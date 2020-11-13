function [spd dir]=cur2wind(u,v);

% convert wind data,which consists of currents vector(EW, NS)
% to magnitude, (from) direction(clockwise from the north)

% Wrritten by Jae-Hyoung Park  2012. DEC. 11

%see also : magvari, wind2cur
% u=-3^.5
% v=1

[dirr spd]=cart2pol(-u,-v);

dirs=dirr/pi*180;
id=find(dirr<0);
dirs(id)=dirs(id)+360;
dir=360-dirs+90;
id=find(dir>=360);
dir(id)=dir(id)-360;






