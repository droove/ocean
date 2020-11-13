function xout=movavg2dPJ(xin,int)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by PJ 2016 Jan 12                                              %
% moving average code                                                    %
% xin : in put variable (xin must be an 2-D (NX1 or 1XN) vector)         %
% int : if length(int)==1, NR==NC; else; int= [NR NC]; NR X NC box size for moving averaging                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cc
% xin=ones(10,10);
% int=[2 3];
% int(length(int)+1)=int(1);
% see also movavgPJ


nid=find(isnan(xin));
nr=int(1);
nc=int(2);

[a b]=size(xin);

dd=[];
h=1
for ii=1:nr
    ldds=[nan(ii-1,b); xin; nan(int(1)-ii+1,b)];
    [a1 b1]=size(ldds);
    for jj=1:nc
    lddsc=[nan(a1,jj-1)  ldds nan(a1,int(2)-jj+1)];   
    
    dd(:,:,h)=lddsc;
    h=h+1;
    end
 
end


xouts=squeeze(nanmean(dd,3));
xouts1=xouts;
% number of data
% ddsd=dd*0+1;

if mod(nr,2)==1
    hint=(nr+1)/2;
    xout=xouts(hint:end-hint,:);
else
    hint=(nr)/2;
    xout=xouts(hint:end-hint-1,:);
end

if mod(nc,2)==1
    hint=(nc+1)/2;
    xout=xout(:,hint:end-hint);
else
    hint=(nc)/2;
    xout=xout(:,hint:end-hint-1);
end

xout(nid)=nan;

% end
