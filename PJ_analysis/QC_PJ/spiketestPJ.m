function [Xout,flag]=spiketestPJ(vars,tval,tval2,int);
%written by PJ, 2016May16
% spike test (QUARTOD) : test value1 =|T_{n-1}-(T_n+T_{n-2})/2|
%                      : teest value2 = T - T_{moving average}
%%input
% vars: input data
% tval: threshold for test value1
% tval2: threshold for test value 2
% int: moving average box size (default : int=10)

if nargin<4
   int=10; 
end


% Xout: output data (nan valued to out of range data)
% badid: index of out of range value
% flag: pass 1, fail 4, missing 9 

nid=find(isnan(vars));
val=abs(vars(2:end-1)-(vars(3:end)+vars(1:end-2))/2);

mvars=movavgPJ(vars,int);
mval=abs(vars-mvars);

badid1w=find(val<=tval)+1;
badid1=setdiff(1:length(val),badid1w);
badid2=find(mval>tval2);

badid=intersect(badid1,badid2);

Xout=vars;
Xout(badid)=nan;
flag=ones(size(vars));
flag(badid)=4;
% flag(nid)=9;

end