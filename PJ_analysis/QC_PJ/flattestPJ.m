function [Xout,flag]=flattestPJ(vars,suspectnum,failnum,iplot);
%written by PJ, 2016May17
% flat data test : exclude flat data
% vars: input data
% suspectnum: minimum number to be suspect data
% failnum: minimum number to be suspect data

% ex)
% suspectnum=6
% failnum=30

% Xout: output data (nan valued for fail data)
% flag: pass 1, fail 4, missing 9

% good data   :  # of same value <  suspectnum
% suspect data:  suspectnum           <= # of same value < failnum
% fail data   :  failnum              <= # of same value

%%%%% see extrchunk.m

if nargin<4
    iplot=0;
end

vars=vars(:);
Xout=vars;
nid=find(isnan(vars));
val=[diff(vars); nan];
flid=find(val~=0);
val(flid)=nan;

id=extrchunk(val);

susid=[];
falid=[];


ii=5
for ii=1:length(id)
    if id(ii,1)+suspectnum-2<=id(ii,2) & id(ii,2)<id(ii,1)+failnum-2
        susid=[susid id(ii,1): id(ii,2)+1];
    elseif id(ii,1)+failnum-2 <=id(ii,2)
        falid=[falid id(ii,1): id(ii,2)+1];
    end
end

flag=ones(size(vars));
flag(susid)=3;
flag(falid)=4;
% flag(nid)=9;
Xout(falid)=nan;

if iplot==1
    figure
    set(gcf,'position',[  200  400 1208 420])
    plot(vars,'.');hold on
    plot(susid,vars(susid),'.g')
    plot(falid,vars(falid),'.r')
    title(['Flat test. suspect num.= ' num2str(suspectnum) '; fail num.= ' num2str(failnum)])
end


end