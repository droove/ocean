function [lon2, lat2]=lonlatPJ(lon1,lat1,dist,bear)
% lon lat point calculation by using distance (in km) and bearing angle(in degree);
% written by jhpark
% input
% dist=[kilometer]
% bear: bearing angle clock wise from north in degree ex) 0 degree = dew northward, 90 degree=due eastward
% output
% lon lat in deg.
% formula from https://stackoverflow.com/questions/7222382/get-lat-long-given-current-point-distance-and-bearing
% see also distPJ


d=dist;
R=6371; %(km)

deg2rad=pi/180;

lat1=lat1(:)*deg2rad;
lon1=lon1(:)*deg2rad;
dist=dist(:);
bear=bear(:);

bear=bear*deg2rad;
lat2r = asin(sin(lat1).*cos(d/R) + cos(lat1).*sin(d/R).*cos(bear));
lon2r = lon1 + atan2( sin(bear).*sin(d/R).*cos(lat1), cos(d/R)-sin(lat1).*sin(lat2r));
% lon2r = lon1 + atan2( cos(d/R)-sin(lat1)*sin(lat2r), sin(bear)*sin(d/R)*cos(lat1));
lon2=lon2r/deg2rad;
lat2=lat2r/deg2rad;