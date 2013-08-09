#!/bin/sh


cat a.dat | while read Levs
do 
	echo $Levs
cat > sample.in << EOF
 &userin
 idotitle=1,titlecolor='def.foreground',
 ptimes=0,
 ptimeunits='h',tacc=120,timezone=+8,iusdaylightrule=1,
 iinittime=1,ifcsttime=1,ivalidtime=1,inearesth=0,
 flmin=.09, frmax=.92, fbmin=.10, ftmax=.85,
 ntextq=0,ntextcd=0,fcoffset=0.0,idotser=0,
 idescriptive=1,icgmsplit=0,maxfld=10,itrajcalc=0,imakev5d=0,
 ncarg_type='cgm'
 /
===========================================================================
----------------------    Plot Specification Table    ---------------------
===========================================================================
feld=tmk; ptyp=hc; vcor=p; levs='$Levs'; cint=2; cmth=fill;>
   cosq=-32,light.violet,-24,violet,-16,blue,-8,green,0,yellow,8,red,>
   16,orange,24,brown,32,light.gray
feld=uuu; ptyp=hc
EOF

done
