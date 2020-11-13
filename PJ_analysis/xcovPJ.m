function [co lag]=xcovPJ(X,Y,numlag,vr)
% calulate cross (auto) covariance matrix
%written by jhpark 2014.Jun.7
%input variable
%X,Y: data
%numlag: number of lags to be printed
%vr: print covariance(vr='cov') or correlation(vr='cor')

%%
if nargin==1
    Y=X; numlag=100; vr='cov'
end
if nargin<3
    numlag=100; vr='cov'
end

if nargin==3
    vr='cov'
end

if vr=='cov'
    outpr=1;
elseif vr=='cor'
    outpr=0;
end
%%

lag=-numlag:numlag;

for ii=1:length(lag)
    if lag(ii)<=0
        xi=  demean(X(-lag(ii)+1:end));
        yi= demean(Y(1:end+lag(ii)));
    else
        xi= demean(X(1:end-lag(ii)));
        yi=  demean(Y(lag(ii)+1:end));
        
    end
    
    cov(ii)=nansum(xi.*yi) / (length(xi)-1); %covariace
    
    corr(ii)=cov(ii)/nanstd(xi)/nanstd(yi);%correlation
end


if outpr==1
    co=cov;
else
    co=corr;
end