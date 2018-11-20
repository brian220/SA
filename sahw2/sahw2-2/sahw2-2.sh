#!/bin/sh
if [ ! -e InitialClassData/curldownFile.json ]
then
  sh initialClassData.sh
  sh drawClassTable.sh
  sh drawExtraClassTable.sh
fi
sh chooseClass.sh
