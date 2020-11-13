function [f inertprd]=fPJ(lat);
% calculate coriolis parameter [s^-1] and inertial period [hour] at a target latitude
% lat : latitude in degree
day2sec=86400;
sec2hour=1/day2sec*24;
deg2rad=pi/180;
omega=2*pi/day2sec;
f=2*omega*sin(lat*deg2rad);
inertprd=2*pi./f*sec2hour;
end
