#!/bin/sh

curl 'https://timetable.nctu.edu.tw/?r=main/get_cos_list' --data 'm_acy=107&m_sem=1&m_degree=3&m_dep_id=17&m_group=**&m_grade=**&m_class=**&m_option=**&m_crs name=**&m_teaname=**&m_cos_id=**&m_cos_code=**&m_crstime=**&m_crsoutline=**&m_costype=**' > curldownFile.json

grep -o '"cos_ename": *"[^"]*"' curldownFile.json | grep -o '"[^"]*"$' | sed -e 's/"//g'> cos_ename.txt
grep -o '"cos_time": *"[^"]*"' curldownFile.json | grep -o '"[^"]*"$' | sed -e 's/"//g' > cos_time_place.txt

sed -e 's/-[^$,]*//g' cos_time_place.txt >  cos_time.txt


