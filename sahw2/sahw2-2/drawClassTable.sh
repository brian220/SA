#!/bin/sh
rm -f table.txt
start='x'
startPoint='.'
space=' '
boundary='|'
blankWideLittle='          '
blankWideAfterStart='            '
blankWide='             '
devideBlank='=============='
singleDivide='='
monday='Mon'
tuesday='Tue'
wednesday='Wed'
thursday='Thu'
friday='Fri'

printFirstLine() {  Firstline=$start$space$space$space$blankWideLittle$monday$boundary$blankWideLittle$tuesday$boundary$blankWideLittle$wednesday$boundary$blankWideLittle$thursday$boundary$blankWideLittle$friday$boundary
printf "$Firstline\n" >> table.txt
}

printBlankLine() {
  blankLine=$startPoint$space$space$boundary$startPoint$blankWideAfterStart$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$blankLine\n" >> table.txt
  printf "$blankLine\n" >> table.txt
  printf "$blankLine\n" >> table.txt
  printf "$blankLine\n" >> table.txt
}
printClassTimeLine() {
  classLine=$1$space$space$boundary$startPoint$blankWideAfterStart$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$classLine\n" >> table.txt
}
printDevideLine() {
  devideLine=$singleDivide$space$space$devideBlank$devideBlank$devideBlank$devideBlank$devideBlank$singleDevide$singleDivide
  printf "$devideLine\n" >> table.txt
}

printClass() {
  printClassTimeLine $1
  printBlankLine
  printDevideLine
}

printFirstLine
printDevideLine
printClass "A"
printClass "B"
printClass "C"
printClass "D"
printClass "E"
printClass "F"
printClass "G"
printClass "H"
printClass "I"
printClass "J"
printClass "K"

buildSplitNameBuffer () {
  rm -f splitNameTimeBuffer.txt
  rm -f splitNameBuffer.txt
  echo $1 |
    awk -F " " '{
      if (NF > 1) {
        print $1 > "splitNameTimeBuffer.txt"
        for(i = 2;i <= NF; i++) {
          print $i >> "splitNameBuffer.txt"
        }
      }
    }'
}

insertSplitNameToTable () {
  if [ -e splitNameTimeBuffer.txt ]
  then
    while read time
      do
        day=$(echo $time | cut -c1)
        class=$(echo $time | cut -c2-2)
        insertClassByDayClass $day $class
      done < splitNameTimeBuffer.txt
  fi
}

insertClassByDayClass () {
  rm -f tmp
  day=$1
  class=$(printf "%d" "'${2}")
  dayCol=$1
  classRow=$(((class-65)*6+3))
  while read splitNameRow;
    do

        awk -v col="$dayCol" -v row=$classRow -v name="$splitNameRow" -F "|" '{OFS=FS}{if(NR==row){
          if(length(name) == 13) {
            $(col+1)=name;
          }
          else if (length(name) > 0){
            $(col+1)=sprintf("%-13s",name);
          }
        }print}' table.txt > tmp && mv tmp table.txt
      classRow=$((classRow+1))
    done < splitNameBuffer.txt
}

insertClassToTable () {
  while read splitNameRow;
    do
      buildSplitNameBuffer "$splitNameRow"
      insertSplitNameToTable
    done < splitName.txt
}
insertClassToTable
