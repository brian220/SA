#!/bin/sh
rm -f detailTable.txt
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
saturday='Sat'
sunday='Sun'

printFirstLine() {  Firstline=$start$space$space$space$blankWideLittle$monday$boundary$blankWideLittle$tuesday$boundary$blankWideLittle$wednesday$boundary$blankWideLittle$thursday$boundary$blankWideLittle$friday$boundary$blankWideLittle$saturday$boundary$blankWideLittle$sunday$boundary
printf "$Firstline\n" >> detailTable.txt
}

printBlankLine() {
  blankLine=$startPoint$space$space$boundary$startPoint$blankWideAfterStart$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$blankLine\n" >> detailTable.txt
  printf "$blankLine\n" >> detailTable.txt
  printf "$blankLine\n" >> detailTable.txt
  printf "$blankLine\n" >> detailTable.txt
}
printClassTimeLine() {
  classLine=$1$space$space$boundary$startPoint$blankWideAfterStart$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$classLine\n" >> detailTable.txt
}
printDevideLine() {
  devideLine=$singleDivide$space$space$devideBlank$devideBlank$devideBlank$devideBlank$devideBlank$singleDevide$singleDivide$devideBlank$devideBlank
  printf "$devideLine\n" >> detailTable.txt
}

printClass() {
  printClassTimeLine $1
  printBlankLine
  printDevideLine
}

printFirstLine
printDevideLine
printClass "M"
printClass "N"
printClass "A"
printClass "B"
printClass "C"
printClass "D"
printClass "X"
printClass "E"
printClass "F"
printClass "G"
printClass "H"
printClass "Y"
printClass "I"
printClass "J"
printClass "K"
cp detailTable.txt resetDetailTable.txt
