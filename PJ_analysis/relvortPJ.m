function relV=relvortPJ(lons,lats,ugs,vgs);

% relative vorticity on earth calculation; function  relV=relvortPJ(lons,lats,ugs,vgs);
% written by jhpark 5/Jun/2020

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % input variables
% lons: longitude [^o] in 1-dimention
% lats: latitude [^o]  in 1-dimention
% ugs=3-dimensional u-component of current; ugs=ugs(lon,lat,time); [m s^{-1}]
% vgs=3-dimensional v-component of current; vgs=vgs(lon,lat,time); [m s^{-1}] 
% % output
% relV: relative vorticity dv/dx-du/dy [s^{-1}]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% see also distPJ


km2m=1000;
for ii=1:length(lats)
xdists(:,ii)=distPJ(lons, lats(ii)+lons*0);
end
for ii=1:length(lons)
ydists(ii,:)=distPJ(lons(ii)+lats*0,lats);
end
xdist=xdists(2:end,2:end-1)*km2m;
ydist=ydists(2:end-1,2:end)*km2m;

relV=nan(size(ugs));
%windstress curl calculation
duy=ugs(:,2:end,:)-ugs(:,1:end-1,:);
dvx=vgs(2:end,:,:)-vgs(1:end-1,:,:);
% dcos=cos((lt(2:end,:)+lt(1:end-1,:))/2*deg2rad);

%averaging 2 points
mdvx1=(dvx(2:end,:,:)+dvx(1:end-1,:,:))/2;
mduy1=(duy(:,2:end,:)+duy(:,1:end-1,:))/2;

mdvx=mdvx1(:,2:end-1,:);
mduy=mduy1(2:end-1,:,:);


dvdx=mdvx./repmat(xdist,[1 1 length(ugs(1, 1, :))]);
dudy=mduy./repmat(ydist,[1 1 length(ugs(1, 1, :))]);

relV(2:end-1,2:end-1,:)=dvdx-dudy;
