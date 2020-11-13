function [mr r0 acovx lags fx w]=spectral_DF_PJ(x);

%% Spectral density function 
%by Jae-Hyoung Park 
%2012/mar/30

%mr: mean(x)
%r0: var(x)
%fx: spectral density function
%w: frequency
%lags: lag of x
%acovx= covariance devided by length(n)

n=length(x);
t=1:n;

[acovx,lags]=xcov(x) ;  %  xcov(x) must be devided by length(x) to have same value with R(0) and (x)
acovx=acovx/n;
r0=nanvar(x);
mr=nanmean(x);
figure('unit','centimeter','position',[3 3 15 19])
subplot(3,2,1:2)
plot(t,x);
title('timeseries of x')
xlabel(['mean=' num2str(mr) ', var=' num2str(r0) ', std' num2str(nanstd(x)) ])
subplot(3,2,3:4)
plot(lags,acovx)
title('auto covariance of X')

% [acrrx,lags]=xcorr(x,'coeff')
% figure(3)
% plot(lags,acrrx)
%
% title('auto correlation of X')

% calculate fx(w)

w=0:1/(n):1;
for k=1:length(w)
    
    for v=(length(lags)+1)/2+1:length(lags);
        
        dd(v)=acovx(v)*cos(2*pi*w(k)*lags(v));
    end
    fx(k)=acovx((length(lags)+1)/2)+2*(sum(dd))/n;
    
end
ag=[-200:1:0];
bc=10.^ag;
cd=bc(near(ag,floor(log10(1/n))));
subplot(3,2,5);
plot(w,fx,'+-') %spectral density function
title('spectral density function')
 xlim([cd 0.5]);
subplot(3,2,6);

 [psdx,psdxc,f]=psd(x,nfft,Fs,hanning(nfft/2),0,0.95,'none');

 
figure; %% ##1 Chl_h_wqm, Chl_h_20m
 loglog(f,psdx,'k-');hold on;
 loglog([0.001 0.001],[Pc_Chl_wqm(138,1)-0.05 Pc_Chl_wqm(138,2)-0.05],'k','linewidth',1.3);  
loglog([0.001],[P_Chl_wqm(138)-0.05],'k.','markersize',15); hold on; 
text(0.0015, P_Chl_wqm(138)-0.13, '95% C.I.','fontname','times','fontsize',15);hold on;

ylabel('Power Sepectrum','fontsize',15);
% semilogx(w,log(fx),'+-') %spectral density function
% % ylim([0 1.5])
%  xlim([cd 0.5])
% title('log spectral density function logx axis')
%  set(gca,'xdir','rev')
 