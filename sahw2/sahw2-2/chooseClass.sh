#!/bin/sh
initialClassList() {
  rm -f classList.txt
  for i in 1 2 3 4 5
    do
      for j in "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K"
        do
          echo $i$j >> "classList.txt"
        done
    done
    cp classList.txt tmpClassList.txt
}

buildClassOnOff() {
  rm -f classOnOff.txt
  while read line;
     do
       echo "off" >> classOnOff.txt
     done < cos_information.txt

  paste -d " " cos_information.txt classOnOff.txt | awk '{ print $0 > "classOnOff.txt" }'
  # vim classOnOff.txt
}

showClassMenu() {
  classMenu=""
  i=1
  while read line;
    do
      classMenu=$classMenu"$i $line "
      i=$(($i+1))
    done < classOnOff.txt
  echo $classMenu
  chooseNum=`dialog --stdout --buildlist "Course Regestration System" 100 200 40 $classMenu`
  echo $chooseNum | awk -F " " '{for(i=1; i<=NF; i++) print $i > "chooseNum.txt" }'
}

storeChooseClass() {
  rm -f chooseClassName.txt
  rm -f chooseClassTime.txt
  while read line;
  do
    awk NR==$line cos_ename.txt >> "chooseClassName.txt"
    awk NR==$line cos_time.txt >> "chooseClassTime.txt"
  done < chooseNum.txt
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
    insertClassList
    currentRow=$((currentRow+1))
  done <chooseClassTime.txt
}

insertClassList() {
  createClassBuffer
  mergeBufferToTmpClassList
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

mergeBufferToTmpClassList() {
  sort classBuffer.txt | join -a 1 tmpClassList.txt - | awk '{print $0 > "tmpClassList.txt"}'
}

checkCollision() {
  rm -f collisionList.txt
  rm -f collision.txt
  sort tmpClassList.txt | join -a 1 classList.txt - | awk '{print $0 > "collisionList.txt"}'
  while read listRow;
    do
      echo $listRow | awk -F " " '{if(NF >= 3){print $0 >> "collision.txt"}}'
    done < collisionList.txt
}

insertNewClass() {
  rm -f newClassList.txt
  while read listRow;
    do
      echo $listRow | awk -F " " '{if(NF == 2){print $0 >> "newClassList.txt"}}'
    done < collisionList.txt
  if [ -e newClassList.txt ]
    then
      sort newClassList.txt | join -a 1 classList.txt - | awk '{print $0 > "classList.txt"}'
    fi
}

splitNameClassList() {
  rm -f splitName.txt
  while read classRow;
    do
      echo $classRow |
        awk 'BEGIN {ORS=" "} {
          print substr( $0, 1, 3) >> "splitName.txt"
          for (i=4;i<=length($0);i+=13) {
            print substr( $0, i, 13) >> "splitName.txt"
          }
            printf"\n" >> "splitName.txt"
        }'
    done < classList.txt
}

updateClassOnOff() {
  while read num;
    do
      sed -i.bak "$num s/off/on/g" classOnOff.txt
    done < chooseNum.txt
}

buildClassOnOff
initialClassList
showClassMenu
storeChooseClass
checkClassTime
checkCollision
insertNewClass
rm -f tmpClassList
updateClassOnOff
splitNameClassList

for i in 1 2 3 4 5
  do
#    showClassTable
#    storeChooseClass
#    checkClassTime
#    checkCollision
#    insertNewClass
#    rm -f tmpClassList
 done

