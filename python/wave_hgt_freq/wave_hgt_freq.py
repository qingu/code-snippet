#! /usr/bin/env python
#-*-coding: utf-8-*-

###########################################################################
#Author: Jiang Qingu
#Date  ：2013/7/23
#
#Purpose: 该python脚本功能与wave_height_frequency.sh作用类似，只是每次运行
#         只能生成一个波高范围数据，与Config.ini配合使用。
###########################################################################


import os.path
import ConfigParser

#baseName = u'*-波浪要素2002-2006.txt'
#gridStart = 1
#gridEnd =332
#yearStart = 2002
#yearEnd = 2006
#leftBound = 1.8
#rightBound = 9999

#prompt = u'请输入文件名，格点号用*代替，如*-波浪要素.txt\n'
#path = raw_input(prompt.encode('gbk'))
#dirName = os.path.dirname(path)
#baseName = os.path.basename(path)
#print dirName, baseName
#gridStart = input('Input start grid number: ')
#gridEnd = input('Input end grid number: ')
#yearStart = input('Input start year: ')
#yearEnd = input('Input end year: ')
#leftBound = input("Input wave_height's left bound: ")
#rightBound = input("Input wave_height's right bound: ")

promptStr = u'配置好Config.ini文件后，执行[回车]'
prompt = raw_input(promptStr.encode('gbk'))
#使用INI配置文件读取参数设置
cf = ConfigParser.ConfigParser()
cf.read("Config.ini")
#sections[Basic]
path = cf.get("Basic", "Path").decode('utf-8')
gridStart = cf.getint("Basic", "StartGrid")
gridEnd = cf.getint("Basic", "EndGrid")
yearStart = cf.getint("Basic", "StartYear")
yearEnd = cf.getint("Basic", "EndYear")
#sections[Range]
leftBound = cf.getfloat("Range", "LowerBound")
rightBound = cf.getfloat("Range", "UpperBound")


baseName = os.path.basename(path)

allGrids = []

#对文件循环
for grid in range(gridStart,gridEnd+1,1):
	
	#filename = baseName.replace('*',str(grid))
	#filename = dirName + baseName.replace('*',str(grid))
	filename = path.replace('*',str(grid))
	print filename
	infile = open(filename, 'r')
	#年循环
	for yr in range(yearStart, yearEnd+1, 1):
		gridList = [0,0,0]
		count = 0
		lines = 0
		infile.seek(0)
		for eachLine in infile:
			lines = lines + 1
			#排除第一行说明
			if lines > 2:
				eachList = eachLine.split()
				#print eachList
				year = int(eachList[0].split('/')[0])
				wave_hgt = float(eachList[3])

				if yr == year:
					if wave_hgt <= rightBound and wave_hgt > leftBound:
						count = count + 1
		gridList[0] = grid
		gridList[1] = yr
		gridList[2] = count
		#print gridList
		allGrids.append(gridList)
	infile.close()	

#print allGrids
#写入csv文件
waveRange = str(leftBound)+'-'+str(rightBound)
outfile = open(waveRange+'.csv', 'w+')
outfile.write('grid,year,'+ waveRange + '\n')
for item in allGrids:
	outfile.write(str(item[0])+','+str(item[1])+','+str(item[2])+'\n')

outfile.close()

