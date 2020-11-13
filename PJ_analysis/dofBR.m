function NDOF=dofBR(x,y)

% ref.: bretherton 1999@ JC and UW ATM552 lecture note chaptor6
% 
[acf1,lags,bounds] = autocorr(x,1);r1=acf1(2);
n1=length(x);
if nargin<2
    
    NDOF=(1-r1)/(1+r1)*n1;
else
    n2=length(y);
%     if n1~=n2
%         warning('x and y must be same size');
%     else
    [acf2,lags,bounds] = autocorr(y,1);r2=acf2(2);
    NDOF=(1-r1*r2)/(1+r1*r2)*length(x);
%     end
end
