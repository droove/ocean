function [yfit amp phdeg]=harmsine_PJ(y,t,tarPeriod,iplot)
% harmonic analysis sine fitting
% parameter linear fits : fits to an arbitrary function with the only
% restriction that this function is linear in the fit parameter
% reference fitting in matlab sine fitting.pdf
% FITTING IN MATLAB.         FIT.TEX KB 20030922
% KLAUS BETZLER1, FACHBEREICH PHYSIK, UNIVERSIT¡§AT OSNABR¡§U CK

% input variable
% y : input data (nan excluded)
% t : time vecto of input data
% tarPeriod: number of data which is the length of the target period for fitting
% 
%
%  output variable
%  yfit: fitted data 
%  amp : amplitude
%  phdeg:phase in degree 
% (if phdeg>0 then sine wave moves to the positive x direction with phase phdeg)  

f1=sin(2*pi/tarPeriod*t)';
f2=cos(2*pi/tarPeriod*t)';

f=[f1 f2];
a=f\y;
yfit=f*a;
amp=norm(a);
ph=atan2(a(2),a(1));
phdeg=ph*180/pi;

%plot 
if nargin>3 & iplot==1 
plot(y);
hold on;
plot(yfit,'r');
title(['AMPLITUDE= ' num2str(amp) ', PHASE= ' num2str(phdeg) '^o'])
end

end