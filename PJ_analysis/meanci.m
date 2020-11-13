function [mu, CI] =meanci(x,CL,DOF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean and its confidence interval%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% calculating arithmatic average and it confidence interval(t-test) at given
% Confidence level and Degree of Freedom
% 
% input variable
% x: time series n X 1 column , nan containing is OK!
% jd: time vector of the time series
% CL: confidence level 0.95 = 95% confidence interval
% DOF: degree of freedom
%
% output variable
% mu: arithmatic average
% CI: confidence interval

%see also meanDT, dofDT
%Written by PJ. 2012. Nov. 27
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%remove nan element
x=x(:);
if nargin < 3;[DOF dcorL]=dofDT(x);end

     p=(1-CL)/2
     
    mu=mean(x);
    stdu=std(x);
     CI=abs(tinv(p,DOF)*stdu/((DOF).^.5));
  


end




