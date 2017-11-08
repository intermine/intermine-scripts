#!/bin/sh
updateProjectStructure()
{
  echo "Converting $1 project to gradle"
  cd $1

  if [ -d src ] && [ `ls -A src` = '.gitignore' ]; then
      rm -r src
    fi

  if [ -d main ]; then
    mkdir -p src
    git mv main/ src/
    git mv src/main/src src/main/java
  fi
  cd ..
}

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
MINE_PATH="${1}"
MINE_NAME=`basename $MINE_PATH`

echo "Converting ${MINE_NAME} to gradle"

cd $MINE_PATH
  if [ -d dbmodel ]; then
    updateProjectStructure dbmodel
  fi

  if [ -d integrate ]; then
    updateProjectStructure integrate
  fi
 
  if [ -d postprocess ]; then
    updateProjectStructure postprocess
  fi

  if [ -d webapp ]; then
    updateProjectStructure webapp
    if [ -d resources/webapp]; then
      git mv resources/webapp/ .
      #mv resources with struts xml file under src/main/resourcces TODO!!!
      #git mv src/main/resources/web.properties src/main/webapp/WEB-INF/
    fi
  fi

echo "Creating settings and build gradle files"
cp "${SCRIPT_PATH}/build.gradle" .
sed -e "s/\${mineInstanceName}/${MINE_NAME}/" "${SCRIPT_PATH}/settings.gradle" > settings.gradle

cp -r "${SCRIPT_PATH}/gradle/" .
cp "${SCRIPT_PATH}/gradlew" .
cp "${SCRIPT_PATH}/gradlew.bat" .

echo "Deleting eclipse configurations files"
find . -name ".project" -type f -delete
find . -name ".classpath" -type f -delete
find . -name ".checkstyle" -type f -delete

echo "Migration completed"
