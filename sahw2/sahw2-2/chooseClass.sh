#!/bin/sh


currentState="ShowMenu"
usedTable="BasicTable"
showFormat="ClassName"
searchWay="Name"

loadStateTag(){
  if [ -e State/stateTag.txt ]
  then
    showFormat=$(awk NR==1 State/stateTag.txt)
    usedTable=$(awk NR==2 State/stateTag.txt)
  fi
}

showClassMenu() {
  echo -n > ChooseClassData/chooseNum.txt
  classMenu=""
  i=1
  while read line;
    do
      classMenu=$classMenu"$i $line "
      i=$(($i+1))
    done < InitialClassData/classOnOff.txt
  chooseNum=`dialog --stdout --buildlist "Course Regestration System" 100 200 40 $classMenu`
  choose=$?
  echo $chooseNum | awk -F " " '{for(i=1; i<=NF; i++) print $i >> "ChooseClassData/chooseNum.txt" }'
  if [ $choose = "0" ]
  then
    classMenuOkButton
  else
    classMenuCancelButton
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

classMenuCancelButton() {
  currentState="ClassTable"
}


storeChooseClass() {
  echo -n > ChooseClassData/chooseClassName.txt
  echo -n > ChooseClassData/chooseClassTime.txt
  while read line;
  do
    if [ $showFormat = "ClassName" ]
    then
      awk NR==$line InitialClassData/cosEName.txt >> "ChooseClassData/chooseClassName.txt"
    elif [ $showFormat = "ClassRoom" ]
    then
      awk NR==$line InitialClassData/cosRoom.txt >> "ChooseClassData/chooseClassName.txt"
    fi
    awk NR==$line InitialClassData/cosTime.txt >> "ChooseClassData/chooseClassTime.txt"
  done < ChooseClassData/chooseNum.txt
}

buildTmpClassList() {
  echo -n > ChooseClassData/modifyClassTime.txt
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
  echo -n > ClassList/classList.txt
  while read listRow;
    do
      echo $listRow | awk -F " " '{if(NF == 2){print $0 >> "ClassList/classList.txt"}}'
    done < ClassList/tmpClassList.txt
}

splitNameClassList() {
  echo -n > SplitName/splitNameClassList.txt
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
  sh insertClassToExtraTable.sh
}

updateClassOnOff() {
  resetClassOnOff
  while read num;
    do
      sed -i.bak "$num s/off/on/g" InitialClassData/classOnOff.txt
    done < ChooseClassData/chooseNum.txt
}

resetClassOnOff() {
  cp InitialClassData/resetClassOnOff.txt InitialClassData/classOnOff.txt
}

showCollision() {
  collisionMessage=`cat ChooseClassData/collision.txt`
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

showTable() {
  if [ $usedTable = "BasicTable" ]
  then
    showBasicTable
  elif [ $usedTable = "ExtraTable" ]
  then
    showExtraTable
  fi
}

showBasicTable() {
  dialog --backtitle "class table" --ok-label "add class" --extra-button --extra-label "options" --help-button --help-label "exit" --textbox Table/table.txt 100 100
  choose=$?
  solveTableChoose $choose
}

showExtraTable() {
  dialog --backtitle "class table" --ok-label "add class" --extra-button --extra-label "options" --help-button --help-label "exit" --textbox Table/extraTable.txt 100 110
  choose=$?
  solveTableChoose $choose
}

solveTableChoose() {
 if [ $1 = "0" ]
  then
    classTableAddClassButton
  elif [ $1 = "3" ]
  then
    classTableOptionsButton
  elif [ $1 = "2" ]
  then
    classTableExitButton
  fi
}

classTableAddClassButton() {
  currentState="ShowMenu"
}

classTableOptionsButton() {
  currentState="Options"
}

classTableExitButton() {
  currentState="Exit"
}

showOptions() {
  option=`dialog --stdout --backtitle "options" --menu "Class Table Kind" 50 50 7\
  1 "Show Class Name" 2 "Show Class Room" 3 "Show Class Name, Extra Column" 4 "Show Class Room, Extra Column" 6 "Search By Name" 7 "Search By Time"`
  choose=$?
  if [ $choose = "0" ]
  then
    optionsOkButton $option
  elif [ $choose = "1" ]
  then
    optionsCancelButton
  fi
}

optionsOkButton() {
  if [ $1 = "1" ]
  then
    showFormat="ClassName"
    usedTable="BasicTable"
    currentState="ClassTable"
    resetClassTableFormat
  elif [ $1 = "2" ]
  then
    showFormat="ClassRoom"
    usedTable="BasicTable"
    currentState="ClassTable"
    resetClassTableFormat
  elif [ $1 = "3" ]
  then
    showFormat="ClassName"
    usedTable="ExtraTable"
    currentState="ClassTable"
    resetClassTableFormat
  elif [ $1 = "4" ]
  then
    showFormat="ClassRoom"
    usedTable="ExtraTable"
    currentState="ClassTable"
    resetClassTableFormat
  elif [ $1 = "6" ]
  then
    searchWay="Name"
    currentState="ClassSearch"
  elif [ $1 = "7" ]
  then
    searchWay="Time"
    currentState="ClassSearch"
  fi
}

resetClassTableFormat() {
  storeChooseClass
  buildTmpClassList
  insertNewClass
  splitNameClassList
  insertClassToTable
  cp ClassList/resetClassList.txt ClassList/tmpClassList.txt
}

optionsCancelButton() {
  currentState="ClassTable"
}

showSearchWindow() {
  if [ $searchWay = "Name" ]
  then
  nameSearch
  elif [ $searchWay = "Time" ]
  then
  timeSearch
  fi
}

nameSearch() {
  target=`dialog --stdout --inputbox "Search By Class Name:" 50 50`
  choose=$?
  grep -E "$target[^$,]*/" InitialClassData/cosInformation.txt > Search/searchName.txt
  if [ $choose = "0" ]
  then
    showNameSearch
  elif [ $choose = "1" ]
  then
    currentState="Options"
  fi
}

showNameSearch() {
  dialog --title "Name Search Result:" --textbox Search/searchName.txt 100 100
  choose=$?
  if [ $choose = "0" ]
  then
    currentState="ClassSearch"
  fi
}

timeSearch() {
  target=`dialog --stdout --inputbox "Search By Class Time:" 50 50`
  choose=$?
  grep -E "/[^$,]*$target" InitialClassData/cosInformation.txt > Search/searchTime.txt
  if [ $choose = "0" ]
  then
    showTimeSearch
  elif [ $choose = "1" ]
  then
    currentState="Options"
  fi
}

showTimeSearch() {
  dialog --title "Time Search Result:" --textbox Search/searchTime.txt 100 100
  choose=$?
  if [ $choose = "0" ]
  then
    currentState="ClassSearch"
  fi
}

saveStateTag() {
  echo $showFormat >> State/tmpStateTag.txt
  echo $usedTable >> State/tmpStateTag.txt
  cp State/tmpStateTag.txt State/stateTag.txt
  rm -f State/tmpStateTag.txt
}

main() {
  loadStateTag
  while true
  do
    if [ $currentState = "ShowMenu" ]
    then
      showClassMenu $currentMenu
    elif [ $currentState = "Collision" ]
    then
      showCollision
    elif [ $currentState = "ClassTable" ]
    then
      showTable
    elif [ $currentState = "Options" ]
    then
      showOptions
    elif [ $currentState = "ClassSearch" ]
    then
      showSearchWindow
    elif [ $currentState = "Exit" ]
    then
      break
    fi
  done
  saveStateTag
}

main
