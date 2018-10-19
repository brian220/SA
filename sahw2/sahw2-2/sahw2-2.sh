#!/bin/sh
if [ ! -e InitialClassData/curldownFile.json ]
then
  sh initialClassData.sh
  sh drawClassTable.sh
fi
sh chooseClass.sh
