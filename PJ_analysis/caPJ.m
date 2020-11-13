function [T21, T12]=caPJ(x1,x2,t);

% Causality analysis 
% reference: Liang_2014@PRE_Unraveling the cause_effect relation between time series

% deals with NaN value

%input variable
% x1 and x2 variables to be analysed
% t : time vector

%output variable
% T21: the rate of information flowing from X2 to X1
% T12: the rate of information flowing from X1 to X2
% T2¡æ1 is significantly (at a 95% level) greater than zero, while
% T1¡æ2 is not significantly different from zero
if nargin <3
    t=1:length(x1);
end

dt=diff(t(1:2));
x1=x1(:);
x2=x2(:);
% dt=diff(t);
% cor=corrPJ(x1,x2)
DOF=length(find(isfinite(nanmean([x1 x2]'))))-1;
DOF1=length(find(isfinite(x1 )))-1;
DOF2=length(find(isfinite(x2 )))-1;
% corp=nansum((x1-nanmean(x1)).*(x2-nanmean(x2)))/DOF/nanstd(x1)/nanstd(x2);
% cor=corp


c11=nansum((x1-nanmean(x1)).*(x1-nanmean(x1)))/DOF1;
c12=nansum((x1-nanmean(x1)).*(x2-nanmean(x2)))/DOF;
c21=nansum((x2-nanmean(x2)).*(x1-nanmean(x1)))/DOF;
c22=nansum((x2-nanmean(x2)).*(x2-nanmean(x2)))/DOF2;

xd1=diff(x1)./dt(1)';
xd2=diff(x2)./dt(1)';

% xd1(end+1)=xd1(end);
% xd2(end+1)=xd2(end);
x1(end)=[];
x2(end)=[];
c1d1=nansum((x1-nanmean(x1)).*(xd1-nanmean(xd1)))/DOF1;
c1d2=nansum((x1-nanmean(x1)).*(xd2-nanmean(xd2)))/DOF;
c2d1=nansum((x2-nanmean(x2)).*(xd1-nanmean(xd1)))/DOF;
c2d2=nansum((x2-nanmean(x2)).*(xd2-nanmean(xd2)))/DOF2;

T21=(c11*c12*c2d1-c12^2*c1d1)/(c11^2*c22-c11*c12^2);
T12=(c22*c21*c1d2-c21^2*c2d2)/(c22^2*c11-c22*c21^2);