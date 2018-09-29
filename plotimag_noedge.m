%Date: Mon, 24 Aug 1998 14:26:41 -0500
%From: xgli@dal.mobil.com (CONT X.  Li [Xin-gong])
%Xingong

function plotimag(a,scal,x,z,amx)
% PLOTIMAG: plot section of traces in wiggle format
% 	1) 'a' is input matrix.
%	2) x direction is as trace number.
%	3) If only 'a' is enter, 'scal,x,z,amn,amx' are decided automatically; 
%	otherwise, 'scal' is a scalar; 'x, z' are vectors for annotation in 
%	offset and time, amx are the amplitude range.
% Author:
% 	Xingong Li, Dec. 1995, UBC
% Changes: 
%	Jun11,1997: add amx
% 	May16,1997: updated for v5 - add 'zeros line' to background color
% 	May17,1996: if scal ==0, plot without scaling
% 	Aug6, 1996: if max(tr)==0, plot a line 

if nargin == 0, nx=10;nz=10; a = rand(nz,nx)-0.5; end;

[nz,nx]=size(a);

trmx= max(abs(a));
if (nargin <= 4); amx=mean(trmx);  end;
if (nargin <= 2); x=[1:nx]; z=[1:nz]; end;
if (nargin <= 1); scal =1; end;

if nx <= 1; disp(' ERR:PlotWig: nx has to be more than 1');return;end;

 % take the average as dx
	dx1 = abs(x(2:nx)-x(1:nx-1));
 	%dx = sum(dx1)/(nx-1);
 	dx = median(dx1);

 dz=z(2)-z(1);
 xmx=max(max(a)); xmn=min(min(a)); 

 if scal == 0; scal=1; end;
 a = a * dx /amx; 
 a = a * scal;

 fprintf(' Plot: data range [%f, %f], plotted max %f \n',xmn,xmx,amx);
 
% set display range 
x1=min(x)-2.0*dx; x2=max(x)+2.0*dx;
z1=min(z)-dz; z2=max(z)+dz;
 
set(gca,'NextPlot','add','Box','on', ...
  'XLim', [x1 x2], ...
  'YDir','reverse', ...
  'YLim',[z1 z2]);
 

%rgray=flipud(gray); colormap(rgray); % Revert the Gray colormap

	% fillcolor = [0.5 .5 .5];
	% linecolor = [0.5 .5 .5];
	fillcolor = [0 0 0];
	linecolor = [0 0 0];
	linewidth = 0.1;

	z=z'; 	% input as row vector
	zstart=z(1);
	zend  =z(nz);

for i=1:nx,
   
  if trmx(i) ~= 0;    % skip the zero traces
	tr=a(:,i); 	% --- one scale for all section
  	s = sign(tr) ;
  	i1= find( s(1:nz-1) ~= s(2:nz) );	% zero crossing points
	npos = length(i1);


	%12/7/97 
	zadd = i1 + tr(i1) ./ (tr(i1) - tr(i1+1));  %locations with 0 amplitudes
    if prod(size(zadd))==0, i, end;
	aadd = zeros(size(zadd));

	[zpos,vpos] = find(tr >0);
	[zz,iz] = sort([zpos; zadd]); 	% indices of zero point plus positives
	aa = [tr(zpos); aadd];
	aa = aa(iz);

	% be careful at the ends
		if tr(1)>0, 	a0=0; z0=1.00;
        elseif prod(size(zadd))==0, a0=0; z0=0;
        else  a0=0; z0=zadd(1);
		end;
		if tr(nz)>0, 	a1=0; z1=nz; 
        elseif prod(size(zadd))==0, a1=0; z1=0;
        else a1=0; z1=max(zadd);
		end;
			
	zz = [z0; zz; z1; z0];
 	aa = [a0; aa; a1; a0];
		

	zzz = zstart + zz*dz -dz;

	patch( aa+x(i) , zzz,  fillcolor,'EdgeColor','w');

%	line( 'Color',[1 1 1],'EraseMode','background',  ...
%	 'LineWidth',[0.8], ...
%         'Xdata', [x(i) x(i)], 'Ydata',[zstart zend]); 
		%% remove zero line
		%%!!! sometimes problem for printing extra lines 
		%%    which are shown on screen. 
		%% Add linewidth to remove unexpected lines, Feb1998

%%'LineWidth',linewidth, ...
%%12/7/97 'Xdata', x(i)+[0 0], 'Ydata',[z0 z1]*dz);	% remove zero line

%	line( 'Color',linecolor,'EraseMode','background',  ...
%	 'LineWidth',linewidth, ...
%	 'Xdata', tr+x(i), 'Ydata',z);	% negatives line

   else % zeros trace
%	line( 'Color',linecolor,'EraseMode','background',  ...
%	 'LineWidth',linewidth, ...
%         'Xdata', [x(i) x(i)], 'Ydata',[zstart zend]);
   end;
end;
