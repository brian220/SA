#!/bin/sh
classMenu=""
i=1
while read line;
do
  classMenu=$classMenu"$i $line off "
  i=$(($i+1))
done<cos_information.txt
chooseNum=`dialog --stdout --buildlist "Course Regestration System" 100 200 40 $classMenu`
echo $chooseNum | awk -F " " '{for(i=1; i<=NF; i++) print $i > "chooseNum.txt" }'
rm -f chooseClassName.txt
rm -f chooseClassTime.txt
storeChooseClass() {
  while read line;
  do
    awk NR==$line cos_ename.txt >> "chooseClassName.txt"
    awk NR==$line cos_time.txt >> "chooseClassTime.txt"
  done < chooseNum.txt
}

checkClassTime() {
  while read timeRow;
  do
    echo $timeRow |
        awk '{
          currentTime="";
          split ($0, timeArray, "");
          for (i=1; i < length($0); i++) {
              if (timeArray[i]~/[0-9]/){
                if (timeArray[i+1]~/[A-Z]/ && timeArray[i+2]!~/[A-Z]/) {
                  currentTime = current + TimetimeArray[i] + timeArray[i+1] + ",";
                }
                else if (timeArray[i+1]~/[A-Z]/ && timeArray[i+2]~/[A-Z]/ && timeArray[i+3]!~/[A-Z]/ ) {
                  currentTime = currentTime + timeArray[i] + timeArray[i+1] + "," + timeArray[i] + timeArray[i+2] + ",";
                }
                else if (timeArray[i+1]~/[A-Z]/&& timeArray[i+2]~/[A-Z]/ && timeArray[i+3]~/[A-Z]/ && timeArray[i+3]!~/[A-Z]/) {
                  currentTime = currentTime + timeArray[i] + timeArray[i+1] + "," + timeArray[i] + timeArray[i+2] + "," + timeArray[i] + timeArray[i+3] + ",";
                }
              }
         }
          print currentTime;
       }'
  done < chooseClassTime.txt
}

storeChooseClass
checkClassTime

