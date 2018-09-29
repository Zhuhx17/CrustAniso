function rmc=hkmoveout(rf,rayp,tvec,H,k)
% input:
% rf - receiver function, size(rf)=[npts,#rf]
% rayp - ray parameter, length(rayp)=#rf
% tvec - time vector, length(tvec)=npts
% H - crust depth
% k - Vp/Vs
% H in km, vp in km/s
rmc=zeros(size(rf));
if max(rayp)>1
    rayp=rayp/6371;
end
[npts,nrf]=size(rf);
for i=1:nrf
    tpcs(:,i)=pstime(rayp(i),H,k);
end

tpcs0=pstime(0.057,H,k);% epicentre distance is 67 degree

for i=1:nrf
    tpcs_cor=tpcs(:,i)-tpcs0';
    tvec_cor=interp1(tpcs(:,i),tpcs_cor,tvec);
    tvec_cor(isnan(tvec_cor))=0;
    rmc(:,i)=interp1(tvec,rf(:,i),tvec+tvec_cor);
end
rmc(isnan(rmc))=rf(isnan(rmc));
end

function pst=pstime(p,H,k,vp)
% input: pst=pstime(H,k,vp,p) if H in km, vp in km/s
if nargin<4
    vp=6.3;
end
vs=vp/k;
pst(1)=0;
pst(2)=H*(sqrt((vs^-2)-p^2)-sqrt((vp^-2)-p^2));
% beneath Moho, mantle set Vp=8.1,Vs=4.5, depth 200km
Hmt=300;vpmt=8.1;vsmt=4.5;
pst(3)=Hmt*(sqrt((vsmt^-2)-p^2)-sqrt((vpmt^-2)-p^2));
end

