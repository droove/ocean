function [pxid, nxid]=findextrPJ(x);
% written by PJ.
% 2017 Nov 9
% find the indices of extreme values 

%input variables
% x: a vector

%output variables
%pxid: indices of local maxima
%nxid: indices of local minima


% % test
% t=[0:1000];
% xx=sin(2*pi/100*t);
% [pxid, nxid]=findextrPJ(xx);
% figure
% plot(t,xx);
% hold on
% plot(t(pxid),xx(pxid),'*r')
% plot(t(nxid),xx(nxid),'*b')


[a b]=size(x);l=length(x);
if a*b~=l
    error('The input variable must be a vector!')
end
    dxx=diff(x);
exid=find(dxx(2:end).*dxx(1:end-1)<0)+1;
pxid=exid(find((x(exid)-x(exid-1))>0));
nxid=exid(find((x(exid)-x(exid-1))<0));

