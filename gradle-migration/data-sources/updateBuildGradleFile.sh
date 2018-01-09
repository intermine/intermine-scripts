#!/bin/bash
# this script is only used to update the build.gradle files when they are already created
currentDir=`pwd`
cd $1
for dir in `ls -d */`
do
prj="${dir%%/}"

if [ "$prj" != "gradle" ]
then
cd $prj
  echo ""
  echo "########################################################"
  echo "processing $prj"
  echo "########################################################"
  echo ""
    if [ -d resources ]
    then
      cp -f $currentDir/skeleton-build.gradle.resourcesOnly build.gradle
      echo "Updated build.gradle"
    else
      cp -f $currentDir/skeleton-build.gradle build.gradle
      echo "Updated build.gradle"
    fi
cd ..
fi
done
