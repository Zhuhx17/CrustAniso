%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    You may have to change:1.matdir                                  %%%
%%%                           2.staindex                                %%%
%%%                           3.phiint                                  %%%
%%%                           4.deltatint                               %%%  
%%%    This step may be very slow if a lot of stations need to be       %%%
%%%    computed, try parfor instead of for if necessary.                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

%matdir='./sta_mat';
matdir='/home/nino/ChuanDian/VN_RF/mat';
%[staindex,net]=textread('./stalist.txt','%s %s');
[staindex,~,~]=textread('/home/nino/ChuanDian/VN_RF/staVN.txt','%s %f %f');
%search range of phi
phib=0;
phie=180; % search till 180 rather than 360 since it's 180-period
phiint=2;
phi=phib:phiint:phie;

%search range of deltat
deltatb=0;
deltate=1; % 1s is enough for crustal anisotropy
deltatint=0.02;
deltat=deltatb:deltatint:deltate;

% Ps phase time window
ps_time=3;% Ps arrival time close to 5s (0s at P arrival)
ps_win=1;% [-1,1]s of Ps arrival

% stack as each 5 degree back azimuth bin
binsize=5;
    

for k=1:size(staindex,1)
    load(fullfile(matdir,[staindex{k},'.mat']));
    psint(1)=find(abs(tvec-(ps_time-ps_win))<1e-4);
    psint(2)=find(abs(tvec-(ps_time+ps_win))<1e-4);
    psint=psint(1):psint(2);
    %[rb,tb,bazb,rfnum]=rfbin(rmc,tmc,baz,binsize);% stack as back azimuth bin
    rb=rmc;tb=tmc;bazb=baz;
    radmaxsearch=zeros(length(phi),length(deltat));
    radccmaxsearch=zeros(length(phi),length(deltat));
    tranminsearch=zeros(length(phi),length(deltat));
    for i=1:length(phi) 
        tic;
    parfor j=1:length(deltat)
     
        radmaxsearch(i,j)=radmax(tvec,rb,bazb,phi(i),deltat(j),psint);
       radccmaxsearch(i,j)=radccmax(tvec,rb,tb,bazb,phi(i),deltat(j),psint);
       tranminsearch(i,j)=tranmin(tvec,rb,tb,bazb,phi(i),deltat(j),psint);
      
    end
    toc;
    end
    save(fullfile(matdir,[staindex{k},'search.mat']),'phi','deltat','radmaxsearch','radccmaxsearch','tranminsearch');
end
 










    