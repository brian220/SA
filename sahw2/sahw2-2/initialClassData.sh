#!/bin/sh
curlTheClassTable() {
  curl 'https://timetable.nctu.edu.tw/?r=main/get_cos_list' --data 'm_acy=107&m_sem=1&m_degree=3&m_dep_id=17&m_group=**&m_grade=**&m_class=**&m_option=**&m_crs name=**&m_teaname=**&m_cos_id=**&m_cos_code=**&m_crstime=**&m_crsoutline=**&m_costype=**' > InitialClassData/curldownFile.json
}

storeCosInformation() {
  grep -o '"cos_ename": *"[^"]*"' InitialClassData/curldownFile.json | grep -o '"[^"]*"$' | sed -e 's/"//g'| sed -e 's/ /./g'> InitialClassData/cosEName.txt
  grep -o '"cos_time": *"[^"]*"' InitialClassData/curldownFile.json | grep -o '"[^"]*"$' | sed -e 's/"//g' > InitialClassData/cosTimeRoom.txt
  sed -e 's/-[^$,]*//g' InitialClassData/cosTimeRoom.txt > InitialClassData/cosTime.txt
  sed -e 's/[^$,]*-//g' InitialClassData/cosTimeRoom.txt > InitialClassData/cosRoom.txt
  paste -d // InitialClassData/cosEName.txt InitialClassData/cosTimeRoom.txt > InitialClassData/cosInformation.txt
}

initialClassList() {
  rm -f ClassList/classList.txt
  for i in 1 2 3 4 5 6 7
  do
    for j in "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "M" "N" "X" "Y"
    do
      echo $i$j >> "ClassList/classList.txt"
    done
  done
  cp  ClassList/classList.txt  ClassList/tmpClassList.txt
  cp  ClassList/classList.txt  ClassList/resetClassList.txt
}

buildClassOnOff() {
  rm -f InitialClassData/classOnOff.txt
  while read line;
  do
    echo "off" >> InitialClassData/classOnOff.txt
  done < InitialClassData/cosInformation.txt
  paste -d " " InitialClassData/cosInformation.txt InitialClassData/classOnOff.txt | awk '{ print $0 > "InitialClassData/classOnOff.txt"  }'
  cp InitialClassData/classOnOff.txt InitialClassData/resetClassOnOff.txt
}

initialClassData() {
  curlTheClassTable
  storeCosInformation
  initialClassList
  buildClassOnOff
}

initialClassData

