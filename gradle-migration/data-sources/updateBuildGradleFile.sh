#!/bin/bash
for dir in `ls -d */`
do
prj="${dir%%/}"

cd $prj
  echo ""
  echo "########################################################"
  echo "processing $prj"
  echo "########################################################"
  echo ""
    if [ -d resources ]
    then
      cp -f ../skeleton-build.gradle.resourcesOnly build.gradle
      echo "Created a build.gradle skeleton"
    else
      cp -f ../skeleton-build.gradle build.gradle
      echo "Created a build.gradle skeleton"
    fi
cd ..
done
