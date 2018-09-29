function rmc=rfmoveout(rf,rayp,tvec)
% input:
% rf - receiver function, size(rf)=[npts,#rf]
% rayp - ray parameter, length(rayp)=#rf
% tvec - time vector, length(tvec)=npts
rf_beforeP=rf(tvec<0,:);
rf=rf(tvec>=0,:);
tvec=tvec(tvec>=0);
if max(rayp)>1
    rayp=rayp/6371;
end
[npts,nrf]=size(rf);
for i=1:nrf
    tpcs(:,i)=cal1Dtps(rayp(i));
end

tpcs0=cal1Dtps(0.057); % epicentre distance is 67 degree

for i=1:nrf
    clear tpcs_cor tpcs_cor_all n_temp
    tpcs_cor=tpcs(:,i)-tpcs0';
    
    % get correction times for all points by interplation
    for j=1:length(tvec)
        if tvec(j)<=tpcs(1,i)
            temp=tpcs_cor(1);
        elseif tvec(j)>=tpcs(end,i)
            temp=tpcs_cor(end);
        else
            temp=interp1(tpcs(:,i),tpcs_cor,tvec(j));
        end
            
        if abs(temp-0.0)<0.1
            temp=0;
        end
        tpcs_cor_all(j)=temp;
    end
    
    % do real moveout by strech or compress
    for j=1:length(tpcs_cor_all)
        t_temp=tvec(j)+tpcs_cor_all(j);
        n_temp(j)=round(t_temp/0.1)+1;    
    end
    
    % judge whether strech or compress
    % 1.compress (larger ray parameters)
    if max(n_temp)>npts
        % get index of the nearest (smaller) integer to the npts
        for ii=1:npts
            if n_temp(ii)<=npts
                ind_npts=ii;
            end
        end
        if n_temp(ind_npts)==npts
            for j=1:ind_npts
                rmc(j,i)=rf(n_temp(j),i);
            end
        elseif n_temp(ind_npts)<npts
            for j=1:ind_npts
                rmc(j,i)=rf(n_temp(j),i);
            end
            rmc(npts,i)=rf(npts,i);
        end
            
        for j=ind_npts+1:npts
            rmc(npts,i)=rf(npts,i);
        end
        % 2. strech (smaller ray parameters)
    else 
        for j=1:npts
            rmc(j,i)=rf(n_temp(j),i);
        end
    end      
end
rmc=[rf_beforeP;rmc];


