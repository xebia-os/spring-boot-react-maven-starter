#!/bin/bash
# set -ex

BRANCH=$(echo ${INPUT_NEW_BRANCH} | tr -d 'refs/heads/')

if [[ "${BRANCH}" =~ ([\.0-9]+)([-_])([-a-z]+) ]]; then
  echo "Branch parsed OK"
  BRANCH_VERSION=${BASH_REMATCH[1]}
  BRANCH_SEP=${BASH_REMATCH[2]}
  BRANCH_NAME=${BASH_REMATCH[3]}
  echo "Version is ${BRANCH_VERSION}"
  echo "Separator is ${BRANCH_SEP}"
  echo "Name is ${BRANCH_NAME}"
else
  echo "Unable to extract required portions of branch name from ${BRANCH}"
  exit 1
fi

tmpFile="/tmp/$(basename `pwd`).pomfiles"
find . -name pom.xml > $tmpFile
# fix up the pom.xml files, unless it's gradle
if [ ! -s $tmpFile ]; then
  echo "No pom.xml files found, must be a gradle project"
  exit 0
fi
echo "Fixing up the pom.xml files, please be patient..."
set -x
for pomFile in $(cat $tmpFile); do
#   echo -n $pomFile
  oldVersion=$(grep -m1 '<version>' $pomFile | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
  newVersion=${BRANCH_VERSION}-SNAPSHOT
  if [ ${oldVersion} == ${newVersion} ]; then
    newVersion="${BRANCH_VERSION}.999-SNAPSHOT"
  fi
  sed -i -e "/\<version\>$oldVersion/  s/$oldVersion/$newVersion/" $pomFile
  rm -f $pomFile-e
  git add $pomFile
done
git commit -m "Fixed up pom files in new branch ${BRANCH}"
git push -u origin ${BRANCH}
