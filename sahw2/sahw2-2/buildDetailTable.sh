#!/bin/sh
rm -f detailTable.txt
boundary='|'
blankWideLittle='          '
blankWide='             '
saturday="Sat"
sunday="Sun"
devideBlank='=============='
addSatSun() {
  while read tableRow;
    do
      firstChar=$(echo $tableRow | cut -c1)
      if [ $firstChar = "x" ]
      then
        tail=$blankWideLittle$saturday$boundary$blankWideLittle$sunday$boundary
      elif [ $firstChar = "=" ]
      then
        tail=$devideBlank$devideBlank
      else
        tail=$blankWide$boundary$blankWide$bounday$boundary
      fi

      printf "$tableRow$tail\n" >> detailTable.txt
    done < table.txt
}

addX() {
  sed -f addX.src detailTable.txt | awk '{print $0 > "detailTable.txt" }'
  for i in 1 2 3 4
    do
      sed -f addBlank.src detailTable.txt | awk '{print $0 > "detailTable.txt"}'
    done
  }

add() {
  cp table.txt detailTable.txt
  sed -i '8i8 This is Line 8' detailTable.txt
}

addSatSun
add
