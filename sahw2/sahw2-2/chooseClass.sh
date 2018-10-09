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

buildClassList() {
  rm -f classList.txt
  for i in 1 2 3 4 5
    do
      for j in "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"
        do
          echo $i$j >> "classList.txt"
        done
    done
}

checkClassTime() {
  currentRow=1;
  while read timeRow;
  do
    echo $timeRow |
        awk '{
          split ($0, timeArray, "");
          currentDay = "";
          for (i=1; i <= length($0); i++) {
              if (timeArray[i]~/[0-9]/) {
                currentDay = timeArray[i];
              }
              if (timeArray[i]~/[A-Z]/) {
                currentClass = timeArray[i];
                separateTime = currentDay currentClass;
                printf "%s\n", separateTime > "modifyClassTime.txt"
              }
          }
        }'
    rm -f tmpClass.txt
    awk NR==$currentRow chooseClassName.txt > "tmpClass.txt"
    storeClassFromBuffer
    currentRow=$((currentRow+1))
  done <chooseClassTime.txt
}

storeClassFromBuffer() {
  createClassBuffer
  mergeBufferToClassList
}

createClassBuffer() {
  fillTmpBuffer
  appendTimeToBuffer
}

fillTmpBuffer() {
  rm -f tmpClassBuffer.txt
  while read time;
    do
      awk NR==1 tmpClass.txt >> "tmpClassBuffer.txt"
    done < modifyClassTime.txt
}

appendTimeToBuffer() {
  rm -f classBuffer.txt
  paste -d " "  modifyClassTime.txt tmpClassBuffer.txt > classBuffer.txt
}

mergeBufferToClassList() {
  sort classBuffer.txt | join -a 1 classList.txt - | awk '{print $0 > "classList.txt"}'
}




buildClassList
storeChooseClass
checkClassTime

