function [ftot, stot, scw,sccw]=rspectPJ(u,v,t);
% this function should be used in 'T_0=(N-1)*dt' system.(not 'T_0=(N)*dt')
% (T_0: total time length, N: # of total point)
% figure; loglog(ftot,stot);

u=u(:)';v=v(:)';
[ns nt]=size(u);

% NN=nt;
NN=nt-1;

df=(NN)/(max(t)-min(t));

if mod(nt,2)
    f=[-(nt-1)/2:(nt-1)/2]*df/(NN);  %in case nt:odd
else 
    f=[-nt/2:nt/2-1]*df/(NN);                %in case nt:even
end
deltaf=diff(f(1:2));

u=u-nanmean(u);v=v-nanmean(v);
id=isnan(u);u(id)=0;v(id)=0;
d=u+v*i;
fc=fftshift(fft(d))/nt;
s=abs(fc).^2/deltaf;


% length(find(isnan(u)))/length(u) :8%

% 
% figure
% semilogy(f,s,'k')
% xlabel('Frequency (CPD)')
% ylabel('Spectrum (m^2 s^{-2} CPD^{-1})')
% 
% % Parceval's theorem
% sum(s)*deltaf
% nanvar(u)


%%%%%%
% total spectrum

% if mod(nt,2),ii=1:(nt-1)/2;jj=(nt-1)/2+2:nt  %in case nt is odd
% else, ii=1:nt/2;jj=nt/2+2:nt                %in case nt is odd
% end
%excluding frequency=0

% ii=find(f<0);jj=find(f>0);
s=s(:)';
scw=fliplr(s(f<0)); sccw=s(f>0);

if mod(nt,2),stot=scw+sccw;
ftot=f(f>0);
else, stot=scw+[sccw 0];
ftot=[f(f>0) -f(1)];
sccw=[sccw 0];
end


% figure
% semilogy(ftot,stot,'k')
% xlabel('Frequency (CPD)')
% ylabel('Spectrum (m^2 s^{-2} CPD^{-1})')
% 
% df=diff(ftot);
% figure
% semilogy(ftot,sqrt(stot*df(1)),'k')
% xlabel('Frequency (CPD)')
% ylabel('Spectrum convert to sine amplitude (m s^{-1})')

% % Parceval's theorem (energy conservation)
% sum(stot)*deltaf
% nanvar(u)
% 
% figure
% semilogy(ftot,scw,'b');hold on
% semilogy(ftot,sccw,'r')
% h=legend('S_{cw}','S_{ccw}')
% set(h,'linewidth',3)




