%Transverse energy minimization
function it=tranmin(tvec,r,t,baz,phi,deltat,psint)

%judge the input theta is rad system or angle system


%calculate corrected r,t component
[rc,tc]=correctanis(tvec,r,t,baz,phi,deltat);

for j=1:length(baz)
    numor(j)=trapz(tvec(psint),(tc(psint,j)).^2);%%%%%%%%%%%%%
    denom(j)=trapz(tvec(psint),(t(psint,j)).^2);%%%%%%%%%%%%%%%%%%
end
it=(sum(numor))/(sum(denom));

end
