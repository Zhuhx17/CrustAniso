# RF-CrustAniso MATLAB Package
written by Yang Yan,USTC,2016/06:yy951016@mail.ustc.edu.cn

This is a Brief Manual.
I assume this work is going to be proceeded after Funclab.

main program:
1.
	step1:_copyfile.m
	convert data from Funclab format (based on events) to standard format (based on station).
2.
	step2_savemat.m
	save SAC data to MATLAB .mat for each station, do move out correction. 
3.
	step3_gridsearch.m
	grid search best fitted parameter pair(phi, delta_t).

functions:
	rfmoveout.m - do move out correctiom for RFs, need to call cal1Dtps and prem.par (provided by ZhangPing, but not well-developed)
	correctanis.m - correct anisotropy with assumed anisotropy parameters
	radmax.m/radccmax.m/tranmin.m - compute objective functions (refer to Liu&Niu,2012)
	rfbin.m - stack RFs at back-azimuth bins
	roseplot.m - plot rose diagram for 3IOF+ 1JOF
	plot_rtrf.m - plot radial and transverse Rfs with back azimuth, need plotimag_noedge.m & plotimag_gray.m (provided by ChenLing)

Example directories:
	testdata - original data after Funclab
	starf - after step 1
	sta_mat - after step 2 & 3

Notes: each script is very short therefore easily read. Read and modify following the comments before using. Feel free to contact me if any problem happens.

