function [m,b,rsq,CI]=lregPJ(x,y,CL,NDOF)
%lregPJ finds linear regression and Confidence interval
% Usage: [m,b,rsq]=linreg(x,y,[iplot]);
% input variable
% x:predictor variable
% y: target variable
% CL: confidence level (CL=0.95 => 95% )
% NDOF: number of degrees of freedom
% m = slope
% b = y intercept
% rsq = r squared correlation coefficient
% regress y on x, add IPLOT=1 for a plotfunction [m,b,rsq]=linreg(x,y)
% Note: If you want a linear regression forced through 0, use LINREG2
%
%y=mx+b
%rsq=regression coefficient squared
%
% Rich Signell rsignell@usgs.gov

denan([x(:),y(:)]);
x=ans(:,1);
y=ans(:,2);
a(1,1)=length(y);
a(2,1)=sum(x);
a(1,2)=a(2,1);
a(2,2)=sum(x.*x);
bb(1)=sum(y);
bb(2)=sum(x.*y);
c=a\bb';
m=c(2);
b=c(1);
bbsq=bb(1)*bb(1)/a(1,1);
rsq=(b*bb(1)+m*bb(2)-bbsq )/(sum(y.*y)-bbsq);
r=sqrt(rsq);
ynew=m*x+b;

%confidence interval


 if nargin < 3 ;Cl=0.95;[DOF dcorL]=dofDT(y,x);
 elseif nargin>=3 & nargin < 4;[DOF dcorL]=dofDT(y,x);
     else
     DOF=NDOF;
 end
p=(1-CL)/2;
 lxx=sum((x-nanmean(x)).^2);
 SE=sum((y-ynew).^2) ;
 S_ep=(SE/(DOF-2)).^.5;

CI=[m-abs(tinv(p,DOF))*S_ep/(lxx).^.5 m+abs(tinv(p,DOF))*S_ep/(lxx).^.5] ;
     
% if exist('iplot')
%     figure
%     plot(x,y,'.k',x,ynew,'r')
%     title(['m=' num2str(m) '  b=' num2str(b) '  r^2=' num2str(rsq)])
% end
