%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    You may have to change:1.datadir                                 %%%
%%%                           2.matdir                                  %%%
%%%                           3.eventid                                 %%%
%%%                           4.staindex                                %%%
%%%                           5.timewindow                               %%% 
%%%    This step may be a little slow due to move out correction        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

%datadir='./starf';% your data dir
datadir='/home/nino/ChuanDian/RF/starf';
eventid='Event_*';% directory index in your data directory
%matdir='./sta_mat';
matdir='/home/nino/ChuanDian/RF/rfmat';
%[staindex,net]=textread('./stalist.txt','%s %s');
[net,staindex]=textread('/home/nino/ChuanDian/RF/stalist.txt','%s %s'); 
timewindow=[-5,25];
if ~exist(matdir);
        mkdir(matdir);
end

for k=1:length(staindex)
    eventdir=dir(fullfile(datadir,staindex{k},eventid));
    for i=1:length(eventdir)
    
    eqrname=fullfile(datadir,staindex{k},eventdir(i).name,['*' staindex{k} '_2.5.i.eqr']);
    eqtname=fullfile(datadir,staindex{k},eventdir(i).name,['*' staindex{k} '_2.5.i.eqt']);
    headtempeqr=readsac(eqrname);
    headtempeqt=readsac(eqtname);
    tvec=linspace(headtempeqr.B,headtempeqr.E,headtempeqr.NPTS);
    rfr(:,i)=headtempeqr.DATA1;
    rft(:,i)=headtempeqt.DATA1;
    rayp(i)=headtempeqr.USER1/6371;% as Funclab format, user1 means P ray parameter(sec/rad)
    baz(i)=headtempeqr.BAZ;
    end
    
    indexb=find(abs(tvec-timewindow(1))<1e-5);
    indexe=find(abs(tvec-timewindow(2))<1e-5);
    tvec=tvec(indexb:indexe);
    rfr=rfr(indexb:indexe,:);
    rft=rft(indexb:indexe,:);
    
    % move-out correction
    tic;
    rmc=rfmoveout(rfr,rayp,tvec);
    tmc=rfmoveout(rft,rayp,tvec);
    toc;
    [A0,A1,A2,s,dt,phi]=harmo_decom(baz,rmc);
    save(fullfile(matdir,[staindex{k},'.mat']),'tvec','rfr','rft','rayp','rmc','tmc','baz','A0','A1','A2');
    clear tvec rfr rft rayp rmc tmc baz;
end