function [Xout,flag]=ROCtestPJ(vars,tval);
%written by PJ, 2016May16
% Rate of Change test (QUARTOD) : test value |T_n - T_{n-1}| 

%%input
% vars: input data
% tval: threshold



% Xout: output data (nan valued to out of range data)
% badid: index of out of range value
% flag: pass 1, fail 4, missing 9 


val=abs(vars(2:end-1)-(vars(1:end-2)));
nid=find(isnan(vars));
badid=find(val>tval)+1;

Xout=vars;
Xout(badid)=nan;
flag=ones(size(vars));
flag(badid)=4;
% flag(nid)=9;

end