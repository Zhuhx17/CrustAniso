
    
%Radial correlation coefficient (cc) maximization
function ircc=radccmax(tvec,r,t,baz,phi,deltat,psint)

%judge the input theta is rad system or angle system

%calculate corrected r,t component
[rc,tc]=correctanis(tvec,r,t,baz,phi,deltat);

    numor=(sum(rc,2)).^2-sum(rc.^2,2);
    denom=(sum(r,2)).^2-sum(r.^2,2);
    
   
    
ircc=(trapz(tvec(psint),numor(psint)))/(trapz(tvec(psint),denom(psint)));

end
