function baznum=plot_rtrf(r,t,time,baz,bin,scale,prepst)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot radial and transverse RFs by backazimuth in the same amplitude in one graph
%
% Written by Yang Yan @ USTC, September 7th, 2016
%
% Input:
% r - radial RFs ,size(r)=[sample numbers,traces]
% t - transverse RFs ,size(t)=[sample numbers,traces]
% time  - time axes accordingly
% baz - backazimuth
% bin - 5 degree or others
% scale - scale
% prepst - predicted Ps arriving time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nx=360/bin;

flag=0;
[rb,tb,bazbin,rfnum]=rfbin(r,t,baz,bin);

baznum=length(bazbin);
disp('plotting...');
figure;
set(gcf,'position',[100 100 1600 500]);
subplot('Position',[0.1,0.1,0.3,0.6]);
plotimag_noedge(rb,scale,bazbin,time,1);
plotimag_gray(rb,scale,bazbin,time,1);
xlabel('backazimuth','FontSize',20);
ylabel('time','FontSize',20);
%title('R','FontSize',20);
set(gca,'FontSize',20);
xl=get(gca,'xlim');
hold on;
if nargin == 7
    for i=1:length(prepst)
        plot(bazbin+5,prepst(i),'r.','MarkerSize',16);
    end
end

subplot('Position',[0.1,0.7,0.3,0.2]);
bar(bazbin,rfnum);
set(gca,'FontSize',20);
set(gca,'xtick',[]);
set(gca,'yaxislocation','right');
ylabel('#events','FontSize',20);
xlim(xl);

subplot('Position',[0.55,0.1,0.3,0.6]);
plotimag_noedge(tb,scale,bazbin,time,1);
plotimag_gray(tb,scale,bazbin,time,1);
xlabel('backazimuth','FontSize',20);
ylabel('time','FontSize',20);
%title('T','FontSize',20);
set(gca,'FontSize',20);
hold on;

if nargin ==7
 for i=1:length(prepst)
        plot(bazbin+5,prepst(i),'r.','MarkerSize',16);
    end
end
disp('max(rfnum):')
max(rfnum)
end
