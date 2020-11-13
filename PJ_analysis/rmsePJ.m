function rmse=rmsePJ(x,y);
% 2017 Nov 7 
% written by J.-H. Park

%root mean square error

x=x(:);y=y(:);
nid=find(isnan(x+y));
nnid=find(~isnan(x+y));
x(nid)=nan; y(nid)=nan;

rmse=sqrt(nansum((x-y).^2)/length(nnid));

end