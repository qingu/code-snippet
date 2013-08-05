#! /usr/bin/env python
#-*-coding: utf-8-*-

###########################################################################
#Author: Jiang Qingu
#Date  ：2013/8/5
#
#Purpose: 求每个格点每年的波高和风速联合频率
#     
#Note： 代码写的有点渣啊
###########################################################################


import os.path
import ConfigParser

def get_joint_freq():

	promptStr = u'配置好Config.ini文件后，执行[回车]'
	prompt = raw_input(promptStr.encode('gbk'))
	#使用INI配置文件读取参数设置
	cf = ConfigParser.ConfigParser()
	cf.read("Config.ini")
	#sections[Basic]
	wavePath = cf.get("Basic", "WaveElePath").decode('utf-8')
	windPath = cf.get("Basic", "WindElePath").decode('utf-8')
	gridStart = cf.getint("Basic", "StartGrid")
	gridEnd = cf.getint("Basic", "EndGrid")
	yearStart = cf.getint("Basic", "StartYear")
	yearEnd = cf.getint("Basic", "EndYear")
	#sections[Range]
	wsStart = cf.get("Range", "WindSpeedStart").split(',')
	wsEnd = cf.get("Range", "WindSpeedEnd").split(',')
	whStart= cf.get("Range", "WaveHgtStart").split(',')
	whEnd = cf.get("Range", "WaveHgtEnd").split(',')

	wss = [int(wsStart[i]) for i in range(0,len(wsStart))]
	wse = [int(wsEnd[i]) for i in range(0,len(wsEnd))]
	whs = [float(whStart[i]) for i in range(0,len(whStart))]
	whe = [float(whEnd[i]) for i in range(0,len(whEnd))]
	#print wss
	#print wsStart
	#print wse,whs,whe

	#baseName = os.path.basename(path)


	#对文件循环
	freq_grid = []
	for grid in range(gridStart,gridEnd+1,1):
		print 'start grid',grid
		wavefilename = wavePath.replace('*',str(grid))
		windfilename = windPath.replace('*',str(grid))
		wavefile = open(wavefilename, 'r')
		windfile = open(windfilename, 'r')
		allwavelines = wavefile.readlines()
		allwindlines = windfile.readlines()
		numlines = len(allwavelines)

		wavefile.close()
		windfile.close()
		#年循环
		freq_year = []
		for yr in range(yearStart, yearEnd+1, 1):
			if(isleap(yr)):
				total = 366*8
			else:
				total = 365*8

			#print total
			freq_hgt = []
			for j in range(0,len(whStart)):
				freq_sp = []
				for k in range(0,len(wsStart)):
					count = 0
					for i in range(1,numlines):
						waveline = allwavelines[i].split()
						year = int(waveline[0].split('/')[0])
						hgt = float(waveline[3])
						windspeed = float(allwindlines[i].split()[3])
						if yr == year:
							if hgt>whs[j] and hgt<=whe[j]: 
								if windspeed>wss[k] and windspeed<=wse[k]:
									count = count + 1
					freq_sp.append(int(count*1.0/total*100000)/1000.0)
				freq_hgt.append(freq_sp)
			#print freq_hgt

			freq_year.append(freq_hgt)

		freq_grid.append(freq_year)
				#print eachwaveline,eachwindline

	#print freq_grid
    #输出
	for year in range(yearStart, yearEnd+1, 1):
		outfile = open(str(year)+'.csv', 'w+')
		kk=year-yearStart
		for grid in range(gridStart,gridEnd+1,1):
			i = grid-gridStart
			for j in range(0,len(whStart)):
				whrange=str(whStart[j])+'~'+str(whEnd[j])
				outfile.write(str(grid)+','+whrange+',')
				for k in range(0,len(wsStart)):
					
					outfile.write(str(freq_grid[i][kk][j][k])+',')
				outfile.write('\n')

		outfile.close()
					

def isleap(iyr):
	if (iyr%400)==0:
		return True
	elif (iyr%100)==0:
		return False
	elif (iyr%4)==0:
		return True
	else:
		return False


if __name__ == "__main__":
	get_joint_freq()

