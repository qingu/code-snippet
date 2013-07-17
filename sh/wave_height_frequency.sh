#!/bin/bash
###########################################################################
#Author: Jiang Qingu
#Date  : 2013/7/17
#
#Input:332个格点文件，每个格点文件名类似于 {1..332}-波浪要素2002-2006.txt 。
#      每个文件中数据格式如下（一天8时次）
#            时间          波向(°)  有效波高(m) 
#       2002/01/01 00:00    264.388   1.282 
#       2002/01/01 03:00    257.198   1.185 
#
#Output:要求统计每个格点在2002-2006每一年波高在以下四个范围出现的次数：
#       0-0.5,0.5-1.2,1.2-1.8,>1.8 。输出文件格式如下
#
#       grid_id  year  0-0.5  0.5-1.2  1.2-1.8  >1.8
#
#Tools: awk, sed, paste
#Notes: 1) awk使用shell传递的变量 awk -v var_awk="$var_shell"
#       2) awk读取/输出字段分隔符 FS/OFS,参数形式 -F分隔符
#       3) awk的BEGIN/END模块
#       4) paste 按列合并文件命令
###########################################################################


#创建四个范围文件
echo 'grid_id,    year,   0-0.5' >0-05.csv
echo '0.5-1.2' >05-12.csv 
echo '1.2-1.8' >12-18.csv 
echo '>1.8' >gt18.csv

cd ./2002-2006/
for ((id=1; id<333; id++));do #格点文件批处理
	for((yr=2002; yr<2007; yr++));do  #2002-2006每一年
		#sed删除第一行提示，然后使用awk提取每一年yr数据，然后提取这一年符合某
		#-范围的波高，最后使用awk中END{}模块统计符合要求的波高数
		sed '1d' $id-*.txt | awk -v year="$yr" -F/ '$1 == year' | awk '$4 <=0.5 && $4 >0'| awk  -v id="$id" -v year="$yr" 'BEGIN{OFS=","} END{print id,year,NR}' >>../0-05.csv
		sed '1d' $id-*.txt | awk -v year="$yr" -F/ '$1 == year' | awk '$4 <=1.2 && $4 >0.5'| awk  -v id="$id" -v year="$yr" 'BEGIN{OFS=","} END{print NR}' >>../05-12.csv
		sed '1d' $id-*.txt | awk -v year="$yr" -F/ '$1 == year' | awk '$4 <=1.8 && $4 >1.2'| awk -v id="$id" -v year="$yr" 'BEGIN{OFS=","} END{print NR}' >>../12-18.csv
		sed '1d' $id-*.txt | awk -v year="$yr" -F/ '$1 == year' | awk '$4 >1.8'| awk -v id="$id" -v year="$yr"  'BEGIN{OFS=","} END{print NR}' >>../gt18.csv
	done
done

cd ../
# paste用于将每个文件中各列数据放到一起
paste -d, 0-05.csv 05-12.csv 12-18.csv gt18.csv > result.csv


