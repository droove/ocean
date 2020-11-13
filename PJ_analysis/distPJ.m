function [dist, bear]=distPJ(lon,lat)
% distance calculation; function dist=distPJ(lat,lon);
% written by jhpark
% find angle between 2 vectors using inner product
% A.B=|A||B| cos(theta)=R^2 cos(theta)
% theta=acos( A.B/(R^2) );
% dist=[kilometer]
% output
% dist: distance in km
% bear: bearing angle clock wise from north in degree [-pi pi] ex) 0 degree = dew northward, 90 degree=due eastward
% northward, 90 degree=due eastward
% formula from  https://www.movable-type.co.uk/scripts/latlong.html
% see also lonlatPJ

if abs(lat)>90
    error ('check the order of input variables; dist=distPJ(lon,lat)  ')
end

R=6371; %km
deg2rad=pi/180;

lat=lat(:)*deg2rad;
lon=lon(:)*deg2rad;
lat1=lat(1:end-1);
lat2=lat(2:end);
lon1=lon(1:end-1);
lon2=lon(2:end);

ABR= cos(lat1).*cos(lat2).*cos(lon1-lon2)+sin(lat1).*sin(lat2);
th=acos(  ABR );
dist=abs(R*th);

bear=-atan2(sin(lon1-lon2).*cos(lat2),cos(lat1).*sin(lat2)-sin(lat1).*cos(lat2).*cos(lon1-lon2))/deg2rad;
