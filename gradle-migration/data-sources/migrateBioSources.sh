#!/bin/bash
currentDir=`pwd`
createSettingsFile=false
cd $1
# create the build.gradle in the root project
if [ ! -f build.gradle ]
then   
  cp $currentDir/skeleton-build.gradle.root build.gradle
  echo "Created the build.gradle for the gradle multi-project"
fi
# create the settings.gradle
if [ ! -f settings.gradle ]
then   
  touch settings.gradle
  echo "Created the settings.gradle for the gradle multi-project"
  echo "rootProject.name = 'bio-sources'" >> settings.gradle
  createSettingsFile=true
fi
# copy gradle wrapper
if [ ! -d gradle ]
then
  cp -r $currentDir/gradle-wrapper/* .
  echo "Copied the gradle wrapper"
fi

cp $currentDir/gradle.properties .
echo "Copied the gradle.properties"

# migrate the bio sources located in the directory given in input
for dir in `ls $bioSourcesDir -d */`
do
prj="${dir%%/}"

if [ "$prj" != "gradle" ]
then

  # only create the settings files once
  if [ createSettingsFile ]
  then 
    # update settings file with this data source
    echo "include ':bio-source-$prj'," >> settings.gradle
    echo "project(':bio-source-$prj').projectDir = new File(settingsDir, './$prj')" >> settings.gradle
  fi

cd $prj
  echo ""
  echo "########################################################"
  echo "processing $prj"
  echo "########################################################"
  echo ""

  # converting the project layout to be aligned with the standard gradle layout
  # src
  # ---main
  # -------java
  # -------resources
  # ---test
  # -------java
  # -------resources

  if [ -d main ]
  then
    cd $prj
    echo "Creating src dir"
    mkdir -p src
    echo "Moving main dir under src ..."
    git mv main/ src/
    cd src/main
    git mv src java
    echo "Moved /main/src directory to /src/main/java "
    cd ../..
  fi
  
  if [ -d test ]
  then
    echo "Moving test dir under src ..."
    git mv test/ src/
    cd src/test
    git mv src java
    echo "Moved /test/src directory to /src/test/java "
    cd ../..   
  fi
  
  if [[ -d resources && -d src ]]
  then
    git mv resources/* src/main/resources/
    rm -r resources/
    echo "Moved contents of resources to src/main/resources "
  fi

  if [ -f src/main/resources/.gitignore ]
  then
    git rm -f src/main/resources/.gitignore
    echo "Removed resources/.gitignore "
  fi 

  # remove main build.xml
  if [ -f build.xml ]
  then
    git rm -f build.xml
    echo "Removed build.xml "
  fi
  # remove all build.xml
  for buildFileToRemove in `find . -name "build.xml"`
  do
    git rm -f $buildFileToRemove
  done
  # removed all eclipse files
  if [ -f .classpath ]
  then
    git rm -f .classpath
  fi
  if [ -f .checkstyle ]
  then
    git rm -f .checkstyle
  fi
  if [ -f .project ]
  then
    git rm -f .project
  fi

  # remove project properties files, they are pointless
  # keep main project properties file for now
  if [ -f src/main/project.properties ]
  then
    git rm -f src/main/project.properties
    echo "Removed main/project.properties "
  fi 
  if [ -f src/test/project.properties ]
  then
    git rm -f src/test/project.properties
    echo "Removed test/project.properties "
  fi 
  
  # if the build gradle file is not there, create
  if [ ! -f build.gradle ]
  then
    # there are two different gradle files
    # which one to use is
    # determined by the presence of the /resources directory
    if [ -d resources ]
    then
      cp $currentDir/skeleton-build.gradle.resourcesOnly build.gradle
      echo "Created a build.gradle skeleton"
    elif [ -d src ]
    then
      cp $currentDir/skeleton-build.gradle build.gradle
      echo "Created a build.gradle skeleton"
    else
      echo "$prj is not a bio-source"
      cd ..
      continue
    fi
  fi

  # move additions files (there can be zero, one or many)
  if ls *_additions.xml &> /dev/null
  then
    if [ -d src/main/resources ]
    then
      git mv *_additions.xml src/main/resources
      echo "Moved additions file to src/main/resources"
    fi    
    if [ -d resources ]
    then
      git mv *_additions.xml resources
      echo "Moved additions file to resources"
    fi
  fi

  # move the main project.properties to uniprot.properties
  if [ -f project.properties ]
  then
    git mv project.properties $prj.properties
  fi

cd ..
fi
done
