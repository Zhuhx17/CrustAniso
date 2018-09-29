%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    You may have to change:1.matdir                                  %%%
%%%                           2.staindex                                %%%
%%%                           3.phiint                                  %%%
%%%                           4.deltatint                               %%% 
%%%                           5.looptime                                %%%
%%%                           6.n_parpool                               %%%
%%%    This step may be very slow if a lot of stations need to be       %%%
%%%    computed, try parfor instead of for if necessary.                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

matdir='./sta_mat';
[staindex,net]=textread('./stalist.txt','%s %s');
looptime=50; % bootstrap for 50 times
n_parpool=4; % use 4 cores to parallel 
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
ps_time=5;% Ps arrival time close to 5s (0s at P arrival)
ps_win=1;% [-1,1]s of Ps arrival

% stack as each 5 degree back azimuth bin
binsize=5;
    
%matlabpool local n_parpool; % version <= matlab2012a
    parpool('local',n_parpool); % version > matlab2012a
    
for k=1:size(staindex,1)
    load(fullfile(matdir,[staindex{k},'.mat']));
    psint(1)=find(abs(tvec-(ps_time-ps_win))<1e-4);
    psint(2)=find(abs(tvec-(ps_time+ps_win))<1e-4);
    psint=psint(1):psint(2);
    
    for l=1:looptime
        eventnum=length(baz);
        mixtemp=randi([1,eventnum],1,eventnum);
        rmctemp=rmc(:,mixtemp);
        tmctemp=tmc(:,mixtemp);
        baztemp=baz(:,mixtemp);
        [rbintemp,tbintemp,bazbintemp]=rfbin(rmctemp,tmctemp,baztemp,binsize);% stack as back azimuth bin
        
        % define in advance to help matlab identify variable when using parfor
        radmaxsearch=zeros(length(phi),length(deltat));
        radccmaxsearch=zeros(length(phi),length(deltat));
        tranminsearch=zeros(length(phi),length(deltat));
        tic;
        for i=1:length(phi) 
            
            parfor j=1:length(deltat)
     
                radmaxsearch(i,j)=radmax(tvec,rbintemp,bazbintemp,phi(i),deltat(j),psint);
                radccmaxsearch(i,j)=radccmax(tvec,rbintemp,tbintemp,bazbintemp,phi(i),deltat(j),psint);
                tranminsearch(i,j)=tranmin(tvec,rbintemp,tbintemp,bazbintemp,phi(i),deltat(j),psint);
      
            end
            
     
        end
        toc;
        jointmaxsearch=radmaxsearch.*radccmaxsearch./tranminsearch;
        [row,col]=find(jointmaxsearch==max(max(jointmaxsearch)));
        jphi(l)=phi(row(1));
        jdt(l)=deltat(col(1));
        jmax(l)=jointmaxsearch(row(1),col(1));
    end 
    % results: use average of bootstrap results as results, use standard
    % deviation of bootstrap results as errors.
    average_phi=mean(jphi);
    error_phi=std(jphi);
    average_dt=mean(jdt);
    error_dt=std(jdt);
    
        save(fullfile(matdir,[staindex{k},'bootstrap.mat']),'jphi','jdt','jmax','average_phi','average_dt','error_phi','error_dt');
    
end

% end parallel
 % matlabpool close; % version <= matlab2012a
    delete(gcp); % version > matlab2012a










    