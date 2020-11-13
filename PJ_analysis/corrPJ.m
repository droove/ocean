function  [cor,bounds,confintv,Ndf,p]= corrPJ(y1,y2,conflv,NDOF)
%find correlation coefficient r

% significance region using  t transformation with chelton's Number of degrees of freedom  %95% default

%y1,y2 must be a vector or a colomn
%% input variables
%y1, y2: input time series to be used in correlation estimation
%conflv=0.95  : 95% confidence level
%% output variable
%cor: correlation between y1 and y2
%bounds: lower bound that the correlation is different from 0
%confintv: confidence interval of estimated correlation

%reference ATM 552 Note UW.ch. regression
% t= r*(Ndf-2)^.5/(1-r^2)^.5 , if t > t_{0.025} then H0(rho=0) is rejected 
%see, xcorrPJ

y1=y1(:);y2=y2(:);

nnid=find(~isnan(mean([y1 y2],2)));

x=y1(nnid);y=y2(nnid);
% DOF using Chelton's method
if nargin<4
 Ndf=dofcorr(x,y); %Chelton
%  Ndf=dofBR(y1,y2); %Bretherton
else
    Ndf=NDOF;
end
 
%    numSTD = 2; % Default
 if nargin<3
conflv=0.95; % Default
 end

% The FILTER command could be used to compute the XCF, but FFT-based 
% computation is significantly faster for large data sets.

y1 =x-nanmean(x);
y2 = y-nanmean(y);
L1 = length(y1);
L2 = length(y2);

data=[y1 y2];
 c=nancov(data); s=sqrt(diag(c)); r=c./(s*s');
            cor=r(1,2);

% p-value (two-tailed probability)
if sum(abs(y1)-abs(y2))==0
    p=0;
else
r=-abs(cor);
t= r*(Ndf-2)^.5/(1-r^2)^.5;
p = tcdf(t,Ndf-2)*2;
end

% test if the correlation different from 0!
t_cl=tinv((1-conflv)/2,Ndf-2);
bounds=sqrt(t_cl.^2./(Ndf-2+t_cl.^2));

%Fisher Z-transformation for confidence interval of the correlation 
z_cl=abs(norminv((1-conflv)/2));
zc=1/2*log((1+cor)/(1-cor)); sz=1/sqrt(Ndf-3);
lc=zc-z_cl*sz;
uc=zc+z_cl*sz;
lmu=tanh(lc);
umu=tanh(uc);
confintv=[lmu umu];

% [abs(cor-lmu) abs(cor-umu)]
