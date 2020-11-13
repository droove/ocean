function [m,b,CIy,X,rsq,errm,Ndf]=pcaregPJ(x,y,CL,iplot,DOF);

% see also linregPJ 
% y=mX+b
%fake data
if nargin<3
    CL=0.95;
end

if nargin<=4
% [DOF dcorL]=dofDT(y,x);
Ndf=dofcorr(x,y);
else
   Ndf=DOF;
end


x=x(:)';y=y(:)';

data=[x-nanmean(x);y-nanmean(y)];
rsq=(corrPJ(x,y))^2;
nmode=2;
datatype=2;
 alpha=1-CL;
 [EOFs pcs egvl recs]=eofpj(data,datatype,nmode);
 mjr = (egvl(1)) ; mnr = egvl(2) ;%variance
  
 mjth=atan2(EOFs(2,1),EOFs(1,1)); 
 mnth=atan2(EOFs(2,2),EOFs(1,2));
 
 incmj=EOFs(2,1)/EOFs(1,1);incmn=EOFs(2,2)/EOFs(1,2);
degmj=mjth*180/pi;  %degress in cartesian coordinate 
degmn=mnth*180/pi; %degress in cartesian coordinate 

%confidence interval for slope
m=tan(degmj/180*pi);
b=nanmean(y)-m*nanmean(x);
sige2=mnr;
% sm2=sige2/nanvar(x)/Ndf;
sm2=sige2/mjr/Ndf;
tcl=abs(tinv(alpha,Ndf-2));
mint=[m-tcl*sqrt(sm2) m+tcl*sqrt(sm2)];
errm=tcl*sqrt(sm2);

% prediction interval
x_min = min(squeeze(recs(1,1,:)+nanmean(x)));
x_max = max(squeeze(recs(1,1,:)+nanmean(x)));
X =[ x_min:(x_max-x_min)/100:x_max]';
Y = [ones(size(X))*b + m*X];
up_int=Y+tcl*sqrt(sige2)*sqrt(1/Ndf+(X-nanmean(x)).^2/((Ndf-1)*nanvar(x)));
dn_int=Y-tcl*sqrt(sige2)*sqrt(1/Ndf+(X-nanmean(x)).^2/((Ndf-1)*nanvar(x)));

CIy=[dn_int up_int];

if  nargin >=4 &  iplot==1
% figure
plot(x,y,'k.');hold on
plot(squeeze(recs(1,1,:)+nanmean(x)),squeeze(recs(1,2,:)+nanmean(y)),'r')
plot(squeeze(recs(2,1,:)+nanmean(x)),squeeze(recs(2,2,:)+nanmean(y)),'g')
% plot(X,Y,'g')
 plot(X,CIy,'b--')
% axis equal

title(['m=' num2str(round(m,2)) '\pm' num2str(round(errm,2)) '; b=' num2str(round(b,2)) '  r^2=' num2str(round(rsq)) '; mjdeg=' num2str(round(degmj,2)) '; mn/maj=' num2str(round(mnr/mjr,2))])
xlabel('x');ylabel('y')
end