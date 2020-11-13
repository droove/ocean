function p=pvalueTcorrPJ(cor,Ndf);
% estimate p value for given value and number of degree of freedom with
% t-test

r= -abs(cor);
t= r*(Ndf-2)^.5/(1-r^2)^.5;
p = tcdf(t,Ndf-2);