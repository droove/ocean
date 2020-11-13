cc

% load data
load('d:\work\research\2010.6\mfile\20121208_seasonality\SSH_wind\correl\windcurl_SSH\examp.mat')
% twc, pssh, time

x=twc;y=pssh;jd=datenum(time);
 x=sin(2*pi/365.25*(jd-jd(1)));
yr=222/12
%% check list
% dofDT 
% dofcorr 
% corrPJ  
% xcorrPJ


%% dofDT % checked ; good!
% [DOFS dcorL]=dofDT(x,jd);


[a b]=size(x);
if b~=1, error('input data must be a column vector form');end

x=x(:);x=x-nanmean(x);
xnan=find(isnan(x));
x(xnan)=0;
tlen=length(x)-length(xnan);
if tlen>0
    [cor,lags,bounds]=autocorr(x,length(x)-1 ) ;
    plot(lags,cor)
    %  id=min(find(cor<0));dcorid=id; %first zero crossing
    id=min(find(cor<(1/exp(1))));dcorid=id; %e-folding crossing
    
    if nargin <2
        dcorL=[]
    else
        dcorL=id*diff(jd(1:2));
    end
    % plot(lags,cor)
else
    dcorL=nan;dcorid=nan;
end
DOFS=tlen/dcorid/2; % in Leith (1973) 
% checked ; good! but bretherton 1999 method is recommanded!

%% dofcorr
% Nedf=dofcorr(x,y)

N=min(length(find(~isnan(x))),length(find(~isnan(y))));
for ii=1:10
k=round((N-1)*.1*ii);

[rhoxx lags]=crosscorr(x,x,k);
[rhoyy lags]=crosscorr(y,y,k);
[rhoxy lags]=crosscorr(x,y,k);
[rhoyx lags]=crosscorr(y,x,k);

setcorr=rhoxx.*rhoyy+rhoyx.*rhoxy;
sumcorr=nansum(setcorr);

Nedf=N/sumcorr;
ndof(ii)=Nedf;
end
figure
plot(0.1:.1:1,ndof)
title('DOF by Chelton method')
xlabel('fraction of auto-corr. used in corr. sum; default: 0.8')
ylabel('DOF of WSC and SSH')
set(gcf,'paperpositionmode','auto')
% saveas(gcf,'./figure/AC_frac_DOF_Chelton','pdf')




N=min(length(find(~isnan(x))),length(find(~isnan(y))));

k=round((N-1)*.8);

[rhoxx lags]=crosscorr(x,x,k);
[rhoyy lags]=crosscorr(y,y,k);
[rhoxy lags]=crosscorr(x,y,k);
[rhoyx lags]=crosscorr(y,x,k);

setcorr=rhoxx.*rhoyy+rhoyx.*rhoxy;
sumcorr=nansum(setcorr);

Nedf=N/sumcorr;


[DOFS dcorL]=dofDT(x,jd);
Nedf=dofcorr(x,y)
NDOF=dofBR(x,y)
NDOF1=dofBR(x,x)
NDOF2=dofBR(y,y)
Nedf1=dofcorr(x,x)
%% corrPJ
% checked !
%% xcorrPJ

