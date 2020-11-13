function [yfit amp phdeg yfitci ampci phci stat]=harmsine(y,tt,tarPeriod,cl,iplot)
% harmonic analysis sine fitting
% parameter linear fits : fits to an arbitrary function with the only
% restriction that this function is linear in the fit parameter
% using 'regress' function

% input variable
% y : input data (nan included data are possible)
% tt : time vector of input data
% tarPeriod: the period (unit is same as that of time vecter) which is the length of the target period for fitting
% cl : confidence level  cl=95 : 95%
% iplot : 1: draw a figure, 0: no figure  

% for example, if y is the data whose time interval is hourly 10 minute 1minute or whatever, 
% the time vector is expressed as julian day (t= [734860.500, 734860.541666667  ... ]) 
% and your target period for fitting is 12hr 
% then you have to input target period should be tarPeriod = 0.5 (day)

%  output variable
%  yfit: fitting result 
%  amp : amplitude, amp(1): mean value, amp(2): wave amplitude
%  phdeg: phase in degree 
%  yfitci : upper and lower confidence interval of time series in 'cl' confidence level
%  ampci : confidence interval of mean: ampci(1,:), confidence interval of amplitude: ampci(2,:)  
%  phci : confidence interval of phase
%  stat= r square, F statistic, p value of the full model, error variance
% (if phdeg>0 then sine wave moves to the positive x direction with phase phdeg)  

t=tt-tt(1);
t=t(:);
[a b]=size(t);

f1=sin(2*pi/tarPeriod*t)';
f2=cos(2*pi/tarPeriod*t)';  
y=y(:);
f=[f1(:)*0+1 f1(:) f2(:)];
p=(1-cl/100);
[a bint r rint stat]=regress(y,f,p);
r=[];rint=[];
amp=[a(1) norm(a(2:3))]';
phdeg=atan2(a(3),a(2))/pi*180;

a1l=bint(1,1);
a1h=bint(1,2);
a2l=norm(bint(2:3,2));
a2h=norm(bint(2:3,1));
ampci=[min(a1l,a1h) max(a1l,a1h); min(a2l,a2h) max(a2l,a2h)];

pll=atan2(bint(3,2),bint(2,2))/pi*180;
pup=atan2(bint(3,1),bint(2,1))/pi*180;
phci=[min(pll,pup) max(pll,pup)];

yfit=f*a;
ylow=(yfit-amp(1))*ampci(2,1)/amp(2)+ampci(1,1);
yup=(yfit-amp(1))*ampci(2,2)/amp(2)+ampci(1,2);
yfitci=[ylow, yup];

%plot 
if nargin>4 & iplot==1 
figure
plot(y,'k')
hold on
plot(yfit,'g')
plot(ylow,'r')
plot(yup,'b')
hold off
a1=ampci(1,:)-amp(1);
a2=ampci(2,:)-amp(2); 
pup-phdeg;
pll-phdeg;
title(['MEAN= ' num2str(amp(1)) ' +/- ' num2str(abs(a1(2))) ', AMP= ' num2str(amp(2)) ' +/- ' num2str(abs(a2(2))) ', PHASE= ' num2str(phdeg) '^o +/- ' num2str(abs(pll-phdeg)) '^o'])
xlim([1 length(y)])
xlabel(['r^2= ' num2str(stat(1))])
end


end