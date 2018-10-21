#!/bin/sh
rm -f Table/table.txt
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
printf "$Firstline\n" >> Table/table.txt
}

printBlankLine() {
  blankLine=$startPoint$space$space$boundary$startPoint$blankWideAfterStart$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$blankLine\n" >> Table/table.txt
  printf "$blankLine\n" >> Table/table.txt
  printf "$blankLine\n" >> Table/table.txt
  printf "$blankLine\n" >> Table/table.txt
}
printClassTimeLine() {
  classLine=$1$space$space$boundary$startPoint$blankWideAfterStart$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$classLine\n" >> Table/table.txt
}
printDevideLine() {
  devideLine=$singleDivide$space$space$devideBlank$devideBlank$devideBlank$devideBlank$devideBlank$singleDevide$singleDivide
  printf "$devideLine\n" >> Table/table.txt
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
cp Table/table.txt Table/resetTable.txt
