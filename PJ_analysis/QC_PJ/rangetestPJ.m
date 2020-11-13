function [Xout,flag]=rangetestPJ(vars,Xmax,Xmin);
%written by PJ, 2016May16
% range test : exclude out of range [Xmin Xmax]

% vars: input data
% Xmax: max. value the physical range
% Xmin: min. value the physical range
% Xout: output data (nan valued to out of range data)
% flag: pass 1, fail 4, missing 9 
vars=vars(:);
if nargin<3
badidn=[];
else
    badidn=find(Xmin>vars );
end
badidx=find(Xmax<abs(vars));
nid=find(isnan(vars));
badid=sort([badidx; badidn]);
Xout=vars;

Xout(badid)=nan;
flag=ones(size(vars));
flag(badid)=4;
% flag(nid)=9;
end