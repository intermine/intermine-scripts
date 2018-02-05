#!/bin/sh
updateProjectStructure()
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
    wget "https://raw.githubusercontent.com/intermine/biotestmine/master/$1/build.gradle"
  fi
  cd ..
}

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
MINE_PATH="${1}"
MINE_NAME=`basename $MINE_PATH`

echo "Converting ${MINE_NAME} to gradle"

cd $MINE_PATH

  echo "Deleting eclipse configurations files"
  find . -name ".project" -type f -delete
  find . -name ".classpath" -type f -delete
  find . -name ".checkstyle" -type f -delete
  find . -name "log4j.properties" -type f -delete

  if [ -d dbmodel ]; then
    updateProjectStructure dbmodel
  fi

  if [ -d integrate ]; then
    rm -rf integrate
  fi

  if [ -d webapp ]; then
    updateProjectStructure webapp

    cd webapp

    if [ ! -d src ]; then
      echo "Making /src directory"
      mkdir src
    else 
      if [ -d src/org ]; then
        echo "Moving src/org to src/main/java"
        mkdir src/main
        git mv src/org src/main/java
      fi
    fi

    if [ -d resources/webapp ]; then
      echo "Moving resources/webapp to src/main/resources/webapp"
      git mv resources/webapp src/main/webapp
    fi

    if [ -d resources ]; then
      echo "mv resources to src/main/resources"
      git mv resources src/main/resources
      #mv resources with struts xml file under src/main/resourcces TODO!!!
      #git mv src/main/resources/web.properties src/main/webapp/WEB-INF/
    fi

    cd ..
  fi
  #if [ -d postprocess ]; then
    # TODO
  #fi

echo "Creating settings and build gradle files"
cp "${SCRIPT_PATH}/build.gradle" .
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
