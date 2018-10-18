#!/bin/sh

showClassMenu() {
  classMenu=""
  i=1
  while read line;
    do
      classMenu=$classMenu"$i $line "
      i=$(($i+1))
    done < InitialClassData/classOnOff.txt
  echo $classMenu
  chooseNum=`dialog --stdout --buildlist "Course Regestration System" 100 200 40 $classMenu`
  choose=$?
  echo $chooseNum | awk -F " " '{for(i=1; i<=NF; i++) print $i > "ChooseClassData/chooseNum.txt" }'
  if [ $choose = "0" ]
  then
    classMenuOkButton
  else
    classMenuExitButton
  fi
}

classMenuOkButton() {
  storeChooseClass
  buildTmpClassList
  checkCollision
  if [ -e ChooseClassData/collision.txt ]
  then
    currentState="Collision"
  else
    insertNewClass
    splitNameClassList
    insertClassToTable
    updateClassOnOff
    currentState="ClassTable"
  fi
  cp ClassList/resetClassList.txt ClassList/tmpClassList.txt
}
classMenuExitButton() {
  currentState="ClassTable"
}


storeChooseClass() {
  rm -f ChooseClassData/chooseClassName.txt
  rm -f ChooseClassData/chooseClassTime.txt
  while read line;
  do
    awk NR==$line InitialClassData/cosEName.txt >> "ChooseClassData/chooseClassName.txt"
    awk NR==$line InitialClassData/cosTime.txt >> "ChooseClassData/chooseClassTime.txt"
  done < ChooseClassData/chooseNum.txt
}

buildTmpClassList() {
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
                printf "%s\n", separateTime > "ChooseClassData/modifyClassTime.txt"
              }
          }
        }'
    rm -f ChooseClassData/tmpClass.txt
    awk NR==$currentRow ChooseClassData/chooseClassName.txt > "ChooseClassData/tmpClass.txt"
    insertClassList
    currentRow=$((currentRow+1))
  done < ChooseClassData/chooseClassTime.txt
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
  rm -f ChooseClassData/tmpClassBuffer.txt
  while read time;
    do
      awk NR==1 ChooseClassData/tmpClass.txt >> "ChooseClassData/tmpClassBuffer.txt"
    done < ChooseClassData/modifyClassTime.txt
}

appendTimeToBuffer() {
  rm -f ChooseClassData/classBuffer.txt
  paste -d " "  ChooseClassData/modifyClassTime.txt ChooseClassData/tmpClassBuffer.txt > ChooseClassData/classBuffer.txt
}

mergeBufferToTmpClassList() {
  sort ChooseClassData/classBuffer.txt | join -a 1 ClassList/tmpClassList.txt - | awk '{print $0 > "ClassList/tmpClassList.txt"}'
}

checkCollision() {
  rm -f ChooseClassData/collision.txt
  while read listRow;
    do
      echo $listRow | awk -F " " '{if(NF >= 3){print $0 >> "ChooseClassData/collision.txt"}}'
    done < ClassList/tmpClassList.txt
}

insertNewClass() {
  while read listRow;
    do
      echo $listRow | awk -F " " '{if(NF == 2){print $0 >> "ClassList/classList.txt"}}'
    done < ClassList/tmpClassList.txt
}

splitNameClassList() {
  rm -f SplitName/splitNameClassList.txt
  while read classRow;
    do
      echo $classRow |
        awk 'BEGIN {ORS=" "} {
          print substr( $0, 1, 3) >> "SplitName/splitNameClassList.txt"
          for (i=4;i<=length($0);i+=13) {
            print substr( $0, i, 13) >> "SplitName/splitNameClassList.txt"
          }
            printf"\n" >> "SplitName/splitNameClassList.txt"
        }'
    done < ClassList/classList.txt
}

insertClassToTable() {
  sh insertClassToTable.sh
}

updateClassOnOff() {
  while read num;
    do
      sed -i.bak "$num s/off/on/g" InitialClassData/classOnOff.txt
    done < ChooseClassData/chooseNum.txt
}

showCollision() {
  echo "kk"
  collisionMessage=`cat ChooseClassData/collision.txt`
  echo "$collisionMessage"
  dialog --title "Class Collision, Please Choose Again" --msgbox "$collisionMessage" 100 100
  choose=$?
  if [ $choose = "0" ]
  then
    collisionOkButton
  fi
}

collisionOkButton() {
  currentState="ShowMenu"
}

showClassTable() {
  dialog --backtitle "class table" --ok-label "add class" --extra-button --extra-label "options" --help-button --help-label "exit" --textbox table.txt 100 100
  choose=$?
  if [ $choose = "0" ]
  then
    classTableAddClassButton
  fi
}

classTableAddClassButton() {
    currentState="ShowMenu"
}

currentState="ShowMenu"
while true
do
  if [ $currentState = "ShowMenu" ]
  then
    showClassMenu
  elif [ $currentState = "Collision" ]
  then
    showCollision
  elif [ $currentState = "ClassTable" ]
  then
    showClassTable
  elif [ $currentState = "Exit" ]
  then
    break
  fi
done

