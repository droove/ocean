function xout=movavgPJ(xin,int);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by PJ 2016 Jan 12                                              %
% moving average code                                                    %
% xin : in put variable (xin must be an 1-D (NX1 or 1XN) vector)         %
% int : box size for moving averaging           
% see also movavg2dPJ%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a b]=size(xin);
nid=find(isnan(xin));
colums=0;
if a>b
    colums=1;
end
xin=xin(:)';
dd=[];

for ii=1:int
    dds=[nan(1,ii-1) xin nan(1,int-ii+1)];
    dd=[dd; dds];
end

xouts=nanmean(dd,1);

% number of data
% ddsd=dd*0+1;

if mod(int,2)==1
    hint=(int+1)/2;
    xout=xouts(hint:end-hint);
else
    hint=(int)/2;
    xout=xouts(hint:end-hint-1);
end

xout=xout(:);
xout(nid)=nan;
if colums==0
    xout=xout';
end
end
