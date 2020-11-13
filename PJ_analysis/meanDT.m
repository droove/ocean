function [mu error DOF dcorL] =meanDT(x,jd,dof)
% written by PJ 2013 Feb 4th
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean and its standard error%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% calculating arithmatic average and it standard error at given
% 
% input variable
% x: time series n X 1 column , nan containing is OK!
% jd: time vector of which form is jd=datenum(time)
% output variable
% mu: arithmatic average
% error: standard error ste=std/(dof^0.5) ; 
% DOF: degree of freedom used in error calculation


%Written by PJ. 2013. Feb. 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%remove nan element
%see also meanci, dofDT
[a b]=size(x);

if a~=1 & b~=1, error('input data must be a column vector form');end

x=x(:);
if nargin < 3
  [DOF dcorL]=dofDT(x,jd);
else
    DOF=dof; 
    dcorL=length(x)/DOF*diff(jd(1:2));
end


 mu=nanmean(x);
    stdu=nanstd(x);
    error=abs(stdu./((DOF).^.5));
end
