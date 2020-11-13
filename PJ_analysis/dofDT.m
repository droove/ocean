function [DOFS dcorL]=dofDT(x,jd);
% written by PJ 2013 Feb 4th
% finding Degree of Freedom and decorrelation time scale(first e-folding time scale)
%
% the demension of decorrelation time scale follows  that of input time series
%
%   The mean is removed from a column before calculating the
%   result  and zero pedding on NaN value.

% in Leith (1973), # of DOF of Rednoise is estimated analytically. DOF=(N*dt)/(2*T); 
% T: e-folding time scale of autocorrelation 
% % 
% see also
[a b]=size(x);
x=x(:);
jd=jd(:);
if b~=1 & a~=1, error('input data must be a column vector form');end
x=x-nanmean(x);
xnan=find(isnan(x));
x(xnan)=0;
tlen=length(x)-length(xnan);
if tlen>0
% [cor,lags,bounds]=autocorr(x,length(x)-1 ) ;
[cor,lags,bounds]=xcorrPJ(x,x,length(x)-1 ) ;
cor=cor(lags>=0);
lags=lags(lags>=0);
%  id=min(find(cor<0));dcorid=id; %first zero crossing
 id=min(find(cor<(1/exp(1))));dcorid=id; %e-folding crossing
 
 if nargin <2
     dcorL=[];
 else
dcorL=id*diff(jd(1:2));
 end
% plot(lags,cor)
else
    dcorL=nan;dcorid=nan;
end
DOFS=tlen/dcorid/2; % in Leith (1973)

%     % checked ; good! but bretherton 1999 method is recommanded!
% check file D:\mat_tool\assortment\PJ_analysis\function_check.m

end