function [S, k, f]=fft2PJ(d1,x,t1);
%written by J.-H. Park
%2019Apr3
%2-d fft
%1 demean
%2 fft2
%3 spectrum
%4 plot

%input variables
%d1:2D data data(x,time)
%x: distance vector
%t1: time vector

%output variables
%S: Energy spectrum
%k: wavenumber (cycle per unit length) 
%f: frequency (cycle per unit time)

%demean
%d1(station,time)

[ns nt]=size(d1)
dm_d=demean(d1')';

d1=dm_d;
d1(isnan(d1))=0;

dk=(ns-1)/(max(x)-min(x)); df=(nt-1)/(max(t1)-min(t1));

if mod(nt,2),f=[-(nt-1)/2:(nt-1)/2]*df/nt;  %in case nt:odd
else,f=[-nt/2:nt/2-1]*df/nt;                %in case nt:even
end

if mod(ns,2),k=[-(ns-1)/2:(ns-1)/2]*dk/ns;  %in case nt:odd
else,k=[-ns/2:ns/2-1]*dk/ns;                %in case nt:even
end

df0=diff(f(1:2));dk0=diff(k(1:2));

fc2=fftshift(fft2(d1))/ns/nt;
S=abs(fc2).^2/df0/dk0;

% figure
% pcolorPJ(k,f,log10(S')); 
% % axis xy;
% colormap(jet)
% colorbar; 
% % caxis([0 7])
% ylabel('Frequency(CP)');xlabel('Wavenumber(m^{-1})');
% hold on;
% 
% %theoretical dispersion relation
% 
% dispr=sqrt(g*abs(k)/2/pi);
% dispr1=sqrt(g*h/2/pi);
% 
% dispr2=sqrt(g*abs(k)/2/pi.*tanh(k*h));
% plot(abs(k),dispr,'w');
% plot(abs(k),dispr1,'w');
% 
% plot(abs(k),dispr2,'w');



