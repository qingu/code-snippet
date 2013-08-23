#-*-coding:utf-8-*-
import numpy as np
from Scientific.IO import NetCDF

#创建NetCDF文件对象
ncfile = NetCDF.NetCDFFile(r'e:\test.nc','w')

#创建变量前，先创建维
ncfile.createDimension('longitude',360)
ncfile.createDimension('latitude',181)
ncfile.createDimension('levelist',37)
ncfile.createDimension('time',24)

#获得NetCDF文件所有维、某一维值
print ncfile.dimensions
print ncfile.dimensions['time']
print ncfile.dimensions.keys()

#创建变量
ncfile.createVariable('ps','d',('longitude','latitude','time',))
ncfile.createVariable('p','d',('longitude','latitude','levelist','time',))

#获得NetCDF变量及其值
print ncfile.variables
print ncfile.variables.keys()
print ncfile.variables['ps']

#创建全局属性
setattr(ncfile, 'Conventions', 'CF-1.0')
setattr(ncfile, 'history', '2013-8-23UTC')

#获得全局属性，及某一全局属性值
print dir(ncfile)
print getattr(ncfile, 'history')

#判断是否存在某一全局属性
if hasattr(ncfile, 'Conventions'):
    print 'Conventions exists in ncfile'

#显示将数据写入文件 
ncfile.sync()

#获得NetCDF变量对象
ps = ncfile.variables['ps']
p = ncfile.variables['p']

#获得变量的类型及shape
print ps.typecode()
print p.shape

#对与NetCDF变量相同shape的临时数组赋值
data1 = np.zeros(ps.shape)
data2 = np.ones(p.shape)

#对NetCDF变量赋值，两种方法
ps[:] = data1
p.assignValue(data2)

#获得NetCDF变量值，两种方法
psValue = ps[:]
pValue = p.getValue()

#创建NetCDF变量的局部属性
setattr(ps, 'long_name', 'pressure of surface')
setattr(p, 'units', 'hPa')

#获得某一变量属性的值
print getattr(ps, 'long_name')
#获得变量的所有属性
print dir(ps)

#关闭NetCDF文件对象
ncfile.close()



