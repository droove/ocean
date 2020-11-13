function  [a,b, a_up, a_dn]=neutregPJ(x,y);

% neutral regression with confidence limits
% from Garrett and Petrie 1981@JPO
%also see linregPJ, pcaregPJ

[cor,bounds]= corrPJ(x,y,.95);
a=sqrt(nanvar(y)/nanvar(x)); %Y=aX;
b=nanmean(y-a*x);
% a=cor/abs(cor)*nanvar(y)/nanvar(x); %Y=aX;
% confidence limits
% from Garrett and Petrie 1981@JPO

z=demean(x).*demean(y);
nn=length(find(isfinite(z)));
N=round(nn*.5);
[xcf,lags,bounds, Ndf ] = xcorrPJ(z,z,N,.95);%plot(lags,xcf)
lstid=N+2; % index of lag = 1 
sigmas=sum(xcf(lstid:end).*(N:-1:1)');
nstin=1./nn+2./(nn^2)*sigmas;
nst=1/nstin;
 

tpcon=1+2*(1-cor^2)^.5*nst^.5;
tmcon=1-2*(1-cor^2)^.5*nst^.5;

a_up=a*tpcon; 
a_dn=a*tmcon;
