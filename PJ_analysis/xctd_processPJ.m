function [tempfn salfn condfn udepth]=xctd_processPJ(xctd);
%% XCTD data  processing   2019 oct 21
% input
% xctd.depth: depth [m]
% xctd.temp: temperature [^oC]
% xctd.cond: conductivity [mS/cm]
% xctd.sal: salinity [ppt]
% xctd.lat: latitude [^oN]
% xctd.lon: longitude [^oE]


% tempfn: 1 m interval processed temperature    [^oC]
% condfn: 1 m interval processed conductivity   [mS/cm]
% salfn: 1 m interval processed salinity        [practical salinity]
% udepth: 1 m interval processed depth          [meter]
% reference: Uchida et al_2011@JAOT_a method for dta processing to obtain high quality xctd data

%see also xctd_readPJ
%% 1) remove stary-up transient change & spikes
% remove 32 scans
rmscan=32;
dep=xctd.depth(rmscan+1:end);
temp=xctd.temp(rmscan+1:end);
cond=xctd.cond(rmscan+1:end);
sal=xctd.sal(rmscan+1:end);
lat=xctd.lat;
% 75 scan boxcar average
mtemp=movavgPJ(temp,75);
mcond=movavgPJ(cond,75);

% figure
% plot(cond,dep)
% 
% figure
% plot(cond,temp)

% interpolation
nids=extrchunk(temp);
ncids=find((nids(2:end,1)-nids(1:end-1,2))<15);
tempi=temp;
for ii=1:length(ncids)
    slid=nids(ncids(ii),2):nids(ncids(ii)+1,1);
    tempi(slid,1)=interp1([slid(1) slid(end)],temp([slid(1) slid(end)]),slid);
end

nids=extrchunk(cond);
ncids=find((nids(2:end,1)-nids(1:end-1,2))<15);
condi=cond;
for ii=1:length(ncids)
    slid=nids(ncids(ii),2):nids(ncids(ii)+1,1);
    condi(slid,1)=interp1([slid(1) slid(end)],cond([slid(1) slid(end)]),slid);
end


%% 2) lowpass filter hamming filter with a window of 19 scans
N=19
wn = ceil(N/2);
w = hamming(2*wn-1); % figure;plot(w)
wt = w/sum(w);
% figure
% plot(wt)
%make data matrix NX19
header={'temp','cond'}
for kk=1:length(header)
    eval(['vars=' header{kk} 'i;'])
    % var=1:length(tempi);
    ll=length(vars);
    data=nan(ll,N);
    for ii=1:N
        if wn-ii+1>0
            data(wn-ii+1:ll,ii)=vars(1:ll-wn+ii);
        else
            data(1:ll-ii+wn,ii)=vars(ii-wn+1:ll);
        end
    end
    % filter
    dataz=data;dataz(isnan(dataz))=0;
    varf=data*wt;
    eval([ header{kk} 'f=varf;'])
end

%% 3) C advancing 1.1 scans
a=0.9;b=0.1
condfa=[condf(1); a*condf(1:end-1)+b*condf(2:end)];

%% 4) salinity calculation
psw = sw_pres(dep,lat);
salt = sw_salt(condfa/sw_c3515,tempf,psw);

%% 5) 1 m interval
nnid=find(~isnan(dep));
zz=ndgrid(dep(nnid));
Ft=griddedInterpolant(zz,tempf(nnid));
Fs=griddedInterpolant(zz,salt(nnid));
Fc=griddedInterpolant(zz,cond(nnid));


udepth=unique(round(dep(nnid)));
tempfn=Ft(udepth);
salfn=Fs(udepth);
condfn=Fc(udepth);



end


