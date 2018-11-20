#!/bin/sh
cp Table/resetExtraTable.txt Table/extraTable.txt
buildSplitNameBuffer() {
  rm -f SplitName/splitNameTimeBuffer.txt
  rm -f SplitName/splitNameBuffer.txt
  echo $1 |
    awk -F " " '{
      if (NF > 1) {
        print $1 > "SplitName/splitNameTimeBuffer.txt"
        for(i = 2;i <= NF; i++) {
          print $i >> "SplitName/splitNameBuffer.txt"
        }
      }
    }'
}

insertSplitNameToTable() {
  if [ -e SplitName/splitNameTimeBuffer.txt ]
  then
    while read time
      do
        day=$(echo $time | cut -c1)
        class=$(echo $time | cut -c2-2)
        insertClassByDayClass $day $class
      done < SplitName/splitNameTimeBuffer.txt
  fi
}

insertClassByDayClass() {
  rm -f SplitName/tmp
  dayCol=$1
  rowNum=0
  while read classOrder;
  do
    if [ $2 = $classOrder ]
    then
      break
    fi
    rowNum=$((rowNum+1))
  done < SplitName/extraClassOrder.txt

  classRow=$((rowNum*6+3))

  while read splitNameRow;
    do
        awk -v col="$dayCol" -v row=$classRow -v name="$splitNameRow" -F "|" '{OFS=FS}{if(NR==row){
          if(length(name) == 13) {
            $(col+1)=name;
          }
          else if (length(name) > 0){
            $(col+1)=sprintf("%-13s",name);
          }
      }print}' Table/extraTable.txt > SplitName/tmp && mv SplitName/tmp Table/extraTable.txt
      classRow=$((classRow+1))
    done < SplitName/splitNameBuffer.txt
}

insertClassToExtraTable() {
  while read splitNameRow;
    do
      buildSplitNameBuffer "$splitNameRow"
      insertSplitNameToTable
    done < SplitName/splitNameClassList.txt
}
insertClassToExtraTable
