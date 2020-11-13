function depths=depthPJ(lonst,latst)

%% written by jhpark 2016 apr 3
% input : longitude, latitude in degree
% output: depth in meter

load('D:\rawdata\bathmetry\EAST_SEA\choi_1min_dep.mat');
 
% d=importdata ('D:\work\exploration\2015_Nov_HY2000\station_loca_plan.txt')
 
latst=latst(:);
lonst=lonst(:);
 
[lonn,latt]=meshgrid(lon,lat);
for ii=1:length(lonst)
    diffs=(latt-latst(ii)).^2+ (lonn-lonst(ii)).^2;
a=min(min(diffs));
[idx,idy]=find(diffs==a);
depth(ii,1)=nanmean(nanmean(depm(idx,idy)));
latss(ii,:)=[nanmean(nanmean(latt(idx,idy))) latst(ii) nanmean(nanmean(latt(idx,idy)))-latst(ii)];
lonss(ii,:)=[nanmean(nanmean(lonn(idx,idy))) lonst(ii) nanmean(nanmean(lonn(idx,idy)))-lonst(ii) ];
end
 
depths=round(depth*10)/10;

end
