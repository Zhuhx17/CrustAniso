function tpcs=cal1Dtps(rayp)
%%
[vp,vs,rho,h]=textread('prem.par','%f %f %f %f','headerlines',1);
nlyr=length(vp);
dep(1)=h(1);
for i=2:nlyr
    dep(i)=dep(i-1)+h(i);
end
for i=1:nlyr
    tpcs0(i)=h(i)*(sqrt(1/vs(i)^2-rayp^2)-sqrt(1/vp(i)^2-rayp^2));
end
tpcs(1)=tpcs0(1);
% ts(1)=ts0(1);
for i=2:nlyr
    tpcs(i)=tpcs(i-1)+tpcs0(i);
end
