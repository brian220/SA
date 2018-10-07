#!/bin/sh
classMenu=""
i=1
while read line; do
  classMenu=$classMenu"$i $line off "
  i=$(($i+1))
done<cos_information.txt
dialog --buildlist "Course Regestration System" 100 200 40 $classMenu
