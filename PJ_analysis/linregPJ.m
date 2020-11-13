function [m,b,CIy,X,rsq,errm,Ndf]=linregPJ(x,y,CL,iplot,DOF);
%LINREG finds and plots linear regression NOT forced through 0
% Usage: [m,b,CI,rsq,errm]=linregpj(x,y,CL,iplot,iDOF);
% CL=confidence level CL=0.95 => 95% 
% iplot: 1:draw figure, 0=no figure
% m = slope
% b = y intercept
% rsq = r squared(r^2) correlation coefficient
% regress y on x, add IPLOT=1 for a plotfunction [m,b,rsq]=linreg(x,y)
% Note: If you want a linear regression forced through 0, use LINREG2
%
%y=mx+b
%rsq=regression coefficient squared
%
% confidence interval using t distribution
% modified by PJ.    2017 8 7

%reference : ATM552 lecture note
%        

if nargin<3
    CL=0.95;
end
x=x(:);
y=y(:);
nnid=find(~isnan(x+y));
x=x(nnid,1);
y=y(nnid,1);

xx=[ones(1,length(x)) ; x(:)'];
coef=xx'\y;


m=coef(2);
b=coef(1);

rsq=(corrPJ(x,y))^2;
ynew=m*x+b;
alpha=1-CL;

yres=y-ynew;
% %confidence interval by PJ. from WIKIpedia

beta=[b m];
%  Ndf=dofcorr(x,y); %Chelton
%   Ndf=dofBR(x,y);%Bretherton
%  [top_int, bot_int,X] = regression_line_ci(alpha,beta,x,y,Ndf-1);

if nargin<=4
% [DOF dcorL]=dofDT(y,x);
Ndf=dofcorr(x,y);
else
   Ndf=DOF;
end

sige2=1/(Ndf-2)*sum(yres.^2);

sm2=sige2/var(x)/Ndf;
tcl=abs(tinv(alpha,Ndf-2));
mint=[m-tcl*sqrt(sm2) m+tcl*sqrt(sm2)];
errm=tcl*sqrt(sm2);
% prediction interval
x_min = min(x);
x_max = max(x);
X =[ x_min:(x_max-x_min)/100:x_max]';
Y = [ones(size(X))*b + m*X];
up_int=Y+tcl*sqrt(sige2)*sqrt(1/Ndf+(X-nanmean(x)).^2/((Ndf-1)*nanvar(x)));
dn_int=Y-tcl*sqrt(sige2)*sqrt(1/Ndf+(X-nanmean(x)).^2/((Ndf-1)*nanvar(x)));

CIy=[dn_int up_int];

if nargin >=4 & iplot==1
%      figure
    plot(x,y,'.k'); hold on
    plot(x,ynew,'r')
    plot(X,up_int,'b--')
    plot(X,dn_int,'b--')
    title(['m=' num2str(m) '\pm ' num2str(errm) ' b=' num2str(b) '  r^2=' num2str(rsq)])
    hold off
%     title(['m=' num2str(m) ' \pm ' num2str(CIm) ' b=' num2str(b) ' \pm ' num2str(CIb) '  r^2=' num2str(rsq)])
end
