function y=normPJ(x);

%normalization of time series x with its STD
% input variable
% x: NX1 or 1XN time series vector
% output variable


[a,b]=size(x);
if a~=1 & b~=1
    error('x should be NX1 or 1XN time series vector');
end

if length(find(~isfinite(x)))==length(x);
    y=nan(a,b);
else
    x=x(:);
    
    y=(x-nanmean(x))./nanstd(x);
end