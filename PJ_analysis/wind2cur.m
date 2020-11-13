function [u, v]=wind2cur(mag,dir,TH);

% convert wind data,which consists  magnitude, (from)direction(clockwise from
% the north degree ),  to currents vector(EW, NS) data and 
%concerning magnetic declination
% Wrritten by Jae-Hyoung Park

% TH=-8.5.*(pi./180); % 8.5 degW 
%  TH  : magnetic declination
%see also : magvari, cur2wind
if nargin<3
   TH=0;
end
dirs=(360-dir-90)*pi/180;
[ur,vr] = pol2cart(dirs,mag);
[u v]=magvari(ur,vr,TH);
