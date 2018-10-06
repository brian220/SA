#!/bin/sh
rm -f table.txt
start='x'
startPoint='.'
boundary='|'
blankWideLittle='               '
blankWide='                  '
devideBlank='==================='
singleDivide='='
monday='Mon'
tuesday='Tue'
wednesday='Wed'
thursday='Thu'
friday='Fri'

printFirstLine() {  Firstline=$start$blankWideLittle$monday$boundary$blankWideLittle$tuesday$boundary$blankWideLittle$wednesday$boundary$blankWideLittle$thursday$boundary$blankWideLittle$friday$boundary
printf "$Firstline\n" >> table.txt
}

printBlankLine() {
  blankLine=$startPoint$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$blankLine\n" >> table.txt
  printf "$blankLine\n" >> table.txt
  printf "$blankLine\n" >> table.txt
  printf "$blankLine\n" >> table.txt
}
printClassTimeLine() {
  classLine=$1$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary$blankWide$boundary
  printf "$classLine\n" >> table.txt
}
printDevideLine() {
  devideLine=$singleDivide$devideBlank$devideBlank$devideBlank$devideBlank$devideBlank
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


