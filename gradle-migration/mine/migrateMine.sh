#!/bin/sh

 usage()  
 {  
  echo "Usage: $0 /path/to/mine"  
  exit 1  
 } 

cleanProjectStructure()
{
  echo "Converting $1 project to gradle"
  echo "cd $1"
  cd $1

  if [ -f build.xml ]; then
    # leaving project.properties where it is because people might need it for reference. Or not?
    echo "Deleting ant build file"
    git rm build.xml
  fi

  # if the src directory is empty, delete!
  if [ -d src ] && [ `ls -A src` = '.gitignore' ]; then
      rm -r src
  fi

  if [ ! -f build.gradle ]; then
    echo "Copying gradle build file"
    cp "${SCRIPT_PATH}/${1}/build.gradle" "build.gradle"
  fi
  cd ..
}

if [ $# -ne 1 ] ; then
    usage
fi

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
MINE_PATH="${1}"
MINE_NAME=`basename $MINE_PATH`

echo "Converting ${MINE_NAME} to gradle"

cd $MINE_PATH

  echo "Deleting eclipse configurations files"
  find . -name ".project" -type f -delete
  find . -name ".classpath" -type f -delete
  find . -name ".checkstyle" -type f -delete
  echo "Deleting project properties files"
  find . -name "project.properties" -type f -delete

  if [ -d dbmodel ]; then
    cleanProjectStructure dbmodel
  fi

  if [ -d integrate ]; then
    rm -rf integrate
  fi

  if [ -d webapp ]; then
    cleanProjectStructure webapp

    cd webapp

    if [ ! -d src ]; then
      echo "Making /src directory"
      mkdir src
    else
      if [ -d src/org ]; then
        echo "Moving src/org to src/main/java"
        mkdir -p src/main/java
        git mv src/org src/main/java
      fi
    fi

    if [ -d resources/webapp ]; then
      if [ ! -d src/main ]; then
        echo "Making src/main directory"
        mkdir -p src/main
      fi
      echo "Moving resources/webapp to src/main/resources/webapp"
      git mv resources/webapp src/main
    fi

    if [ -d resources ]; then
      echo "mv resources to src/main/resources"

      git mv resources src/main
      git mv src/main/resources/web.properties src/main/webapp/WEB-INF/
    fi

    cd ..
  fi
  if [ -d postprocess ]; then
    cd postprocess
    if [ -d resources ] && [ `ls -A resources` != '.gitignore' ]; then
      echo "Moving postprocess resources to dbmodel/resources"
      git mv resources/* ../dbmodel/resources
    fi
    cd ..
    # rm -rf postprocess
  fi

echo "Deleting log4j.properties file"
find . -name "log4j.properties" -type f -delete
echo "Creating settings and build gradle files"
sed -e "s/\${mineInstanceName}/${MINE_NAME}/" "${SCRIPT_PATH}/build.gradle" > build.gradle
sed -e "s/\${mineInstanceName}/${MINE_NAME}/" "${SCRIPT_PATH}/settings.gradle" > settings.gradle

cp -r "${SCRIPT_PATH}/gradle/" .
cp "${SCRIPT_PATH}/gradlew" .
cp "${SCRIPT_PATH}/gradlew.bat" .

echo "Deleting default.intermine.*.properties"
if [ -f default.intermine.integrate.properties ]; then
  git rm default.intermine.integrate.properties
fi
if [ -f default.intermine.webapp.properties ]; then
  git rm default.intermine.webapp.properties
fi

echo "Migration completed"

