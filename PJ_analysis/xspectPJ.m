function [freq cohsq pha gain cohsqCL k] = xspectPJ(X,Y,WINDOW,NOVERLAP,NFFT,Fs,CL)
%written by jhpark
%2013 May 6
% CL=0.99 when 99%
% CL=0.95 when 95%
fcw=1.2; %for hanning window

%reference 
% Hartmann, ATM552 lecture note


 [Pxy,freq] = cpsd(X,Y,WINDOW,NOVERLAP,NFFT,Fs);
%  [Pxx,f] = pwelch(x,window,noverlap,nfft,fs)
% X=X-nanmean(X);X(find(isnan(X)))=0;
% Y=Y-nanmean(Y);Y(find(isnan(Y)))=0;
  [Pxx,F] = pwelch(X,WINDOW,NOVERLAP,NFFT,Fs);
  [Pyy,F] = pwelch(Y,WINDOW,NOVERLAP,NFFT,Fs);
% gain
gain=abs(Pxy)./abs(Pyy);  %gain  ratio of x and y (x/y)WRT given frequency   

cohsq=sqrt((abs(Pxy).^2)./(Pxx.*Pyy));
pha=angle(Pxy);  % radian
% pha=atan2(real(Pxy),imag(Pxy));  % radian
% numberof segment
M = length(X);
L = length(WINDOW);
k = (M-NOVERLAP)./(L-NOVERLAP);
k = fix(k)*fcw;
alpha=1-CL;

cohsqCL=1-alpha^(1/(k-1))+cohsq*0;
  