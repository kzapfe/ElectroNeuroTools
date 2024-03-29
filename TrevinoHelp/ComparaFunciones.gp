#!/usr/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 4.6 patchlevel 5 (Gentoo revision r0)    last modified 2014-02-26 
#    	Build System: Linux x86_64
#    
#    	Copyright (C) 1986-1993, 1998, 2004, 2007-2014
#    	Thomas Williams, Colin Kelley and many others
#    
#    	gnuplot home:     http://www.gnuplot.info
#    	faq, bugs, etc:   type "help FAQ"
#    	immediate help:   type "help"  (plot window: hit 'h')
# set terminal wxt 0
# set output
unset clip points
set clip one
unset clip two
set bar 1.000000 front
set border 3 front linetype -1 linewidth 2.000
set timefmt z "%d/%m/%y,%H:%M"
set zdata 
set timefmt y "%d/%m/%y,%H:%M"
set ydata 
set timefmt x "%d/%m/%y,%H:%M"
set xdata 
set timefmt cb "%d/%m/%y,%H:%M"
set timefmt y2 "%d/%m/%y,%H:%M"
set y2data 
set timefmt x2 "%d/%m/%y,%H:%M"
set x2data 
set boxwidth
set style fill  empty border
set style rectangle back fc  lt -3 fillstyle   solid 1.00 border lt -1
set style circle radius graph 0.02, first 0, 0 
set style ellipse size graph 0.05, 0.03, first 0 angle 0 units xy
set dummy x,y
set format x "% g"
set format y "% g"
set format x2 "% g"
set format y2 "% g"
set format z "% g"
set format cb "% g"
set format r "% g"
set angles radians
unset grid
set raxis
set key title ""
set key tmargin center horizontal Right noreverse enhanced autotitles nobox
set key noinvert samplen 4 spacing 1 width 0 height 0 
set key maxcolumns 0 maxrows 0
set key noopaque
unset label
unset arrow
set style increment default
unset style line
unset style arrow
set style histogram clustered gap 2 title  offset character 0, 0, 0
unset logscale
set offsets 0, 0, 0, 0
set pointsize 1
set pointintervalbox 1
set encoding default
unset polar
unset parametric
unset decimalsign
set view map
set samples 400, 400
set isosamples 200, 200
set surface
unset contour
set clabel '%8.3g'
set mapping cartesian
set datafile separator whitespace
unset hidden3d
set cntrparam order 4
set cntrparam linear
set cntrparam levels auto 5
set cntrparam points 5
set size ratio 0.3 1,1
set origin 0,0
set style data points
set style function lines
set xzeroaxis linetype -2 linewidth 1.000
set yzeroaxis linetype -2 linewidth 1.000
set zzeroaxis linetype -2 linewidth 1.000
set x2zeroaxis linetype -2 linewidth 1.000
set y2zeroaxis linetype -2 linewidth 1.000
set ticslevel 0.5
set mxtics default
set mytics default
set mztics default
set mx2tics default
set my2tics default
set mcbtics default
set noxtics
set noytics
set noztics
set nox2tics
set noy2tics
set nocbtics
set nortics
set title "" 
set title  offset character 0, 0, 0 font "" norotate
set timestamp bottom 
set timestamp "" 
set timestamp  offset character 0, 0, 0 font "" norotate
set rrange [ * : * ] noreverse nowriteback
set trange [ * : * ] noreverse nowriteback
set urange [ * : * ] noreverse nowriteback
set vrange [ * : * ] noreverse nowriteback
set xlabel "" 
set xlabel  offset character 0, 0, 0 font "" textcolor lt -1 norotate
set x2label "" 
set x2label  offset character 0, 0, 0 font "" textcolor lt -1 norotate
set xrange [ * : * ] noreverse nowriteback
set x2range [ * : * ] noreverse nowriteback
set ylabel "" 
set ylabel  offset character 0, 0, 0 font "" textcolor lt -1 rotate by -270
set y2label "" 
set y2label  offset character 0, 0, 0 font "" textcolor lt -1 rotate by -270
set yrange [ -15.0000 : 18.0000 ] noreverse nowriteback
set y2range [ * : * ] noreverse nowriteback
set zlabel "" 
set zlabel  offset character 0, 0, 0 font "" textcolor lt -1 norotate
set zrange [ * : * ] noreverse nowriteback
set cblabel "" 
set cblabel  offset character 0, 0, 0 font "" textcolor lt -1 rotate by -270
set cbrange [ * : * ] noreverse nowriteback
set zero 1e-08
set lmargin  -1
set bmargin  -1
set rmargin  -1
set tmargin  -1
set locale "es_ES.utf8"
set pm3d explicit at b
set pm3d scansautomatic
set pm3d interpolate 1,1 flush begin noftriangles nohidden3d corners2color mean
set palette positive nops_allcF maxcolors 0 gamma 1.5 color model RGB 
set palette defined ( 0 0 0 1, 0.5 1 1 1, 1 1 0 0 )
set colorbox default
set colorbox vertical origin screen 0.9, 0.2, 0 size screen 0.05, 0.6, 0 front bdefault
set style boxplot candles range  1.50 outliers pt 7 separation 1 labels auto unsorted
set loadpath 
set fontpath 
set psdir
set fit noerrorvariables
distuno(x,y)=sqrt(x**2+(y-a)**2)
distdos(x,y)=sqrt(x**2+(y+a)**2)
u(x,y)=1.0/distuno(x,y)-1.0/distdos(x,y)
efx(x,y)=x*(1./distuno(x,y)**3-1./distdos(x,y)**3)
efy(x,y)=((y-a)/distuno(x,y)**3-(y+a)/distdos(x,y)**3)
energ(x,y)=efx(x,y)**2+efy(x,y)**2
siglaplau(x,y)=laplau(x,y)*sigmay(y+1)
sigmay(x)=1./(1.+gauss(x))
sigmaprima(x)=x*gauss(x)/((ancho*(1.+gauss(x)))**2)
laplau(x,y)=-1./distuno(x,y)**3+1./distdos(x,y)**3
gauss(x)=exp(-x**2/(2.*ancho**2))/(sqrt(2.*pi)*ancho)
terminoextra(x,y)=efy(x,y)*sigmaprima(y+1)
GNUTERM = "wxt"
a = -1
GPFUN_distuno = "distuno(x,y)=sqrt(x**2+(y-a)**2)"
GPFUN_distdos = "distdos(x,y)=sqrt(x**2+(y+a)**2)"
GPFUN_u = "u(x,y)=1.0/distuno(x,y)-1.0/distdos(x,y)"
GPFUN_efx = "efx(x,y)=x*(1./distuno(x,y)**3-1./distdos(x,y)**3)"
GPFUN_efy = "efy(x,y)=((y-a)/distuno(x,y)**3-(y+a)/distdos(x,y)**3)"
GPFUN_energ = "energ(x,y)=efx(x,y)**2+efy(x,y)**2"
scaling = 0.4
GPFUN_siglaplau = "siglaplau(x,y)=laplau(x,y)*sigmay(y+1)"
GPFUN_sigmay = "sigmay(x)=1./(1.+gauss(x))"
GPFUN_sigmaprima = "sigmaprima(x)=x*gauss(x)/((ancho*(1.+gauss(x)))**2)"
GPFUN_laplau = "laplau(x,y)=-1./distuno(x,y)**3+1./distdos(x,y)**3"
ancho = 0.05
GPFUN_gauss = "gauss(x)=exp(-x**2/(2.*ancho**2))/(sqrt(2.*pi)*ancho)"
GPFUN_terminoextra = "terminoextra(x,y)=efy(x,y)*sigmaprima(y+1)"
plot u(0.2,x)-8 t "Potential", sigmay(x+1)-3 t "Conductivity", efy(0.2,x)*0.5+3 t "Electric Field apical direction", efy(0.2,x)*sigmay(x+1)*0.5+8 t "Current apical direction"
#    EOF
