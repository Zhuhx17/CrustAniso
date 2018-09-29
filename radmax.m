%Radial energy maximization with cosine moveout correction
function ircos=radmax(tvec,r,baz,phi,deltat,psint)
%judge the input theta is rad system or angle system
theta=baz/180*pi;
phi=phi/180*pi;

for j=1:length(theta)
            rj(:,j)=interp1(tvec,r(:,j),tvec-deltat/2*cos(2*(phi-theta(j))),'linear');
end 
            rj(isnan(rj))=0;
        

    
        numer=(sum(rj,2)).^2;
        denom=(sum(r,2)).^2;
        

ircos=(max(numer(psint)))/(max(denom(psint)));

end

















