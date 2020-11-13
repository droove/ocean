function h_steric=stericPJ(T,S,z,lat);
% written by jhpark 2017 Mar. 3
% calculating steric height following Sieigismund et al., 2007 @JGR

%inputvariable
%T: temperature [^oC], column vector
%T: salinity, column vector
%z: depth [m] (positive downward), column vector
%lat: latitude at the point

%outputvariable
% h_steric: steric height. [m]

% lat=37;
% T=[15 10 7 5 4 3]';
% S=[34 34.4 34 33.9 33.8 33.8 ]';
% z=[0 10 20 50 75 100 ]';

% %convert z to p
p = sw_pres(z,lat);
% p=z;

rhop=sw_dens(S,T,p);
rho0p=sw_dens(p*0+35,p*0,p);

mrhop=(rhop(2:end)+rhop(1:end-1))/2;
mrho0p=(rho0p(2:end)+rho0p(1:end-1))/2;

intgv=mrho0p./mrhop-1;
dz=diff(z);

intgvzs=intgv.*dz;
if length(find(isnan(intgv)))==length(dz)
    h_steric=nan;
else
    h_steric=nansum([intgv(1)*z(1); intgvzs]);
end
end
%  gpanc=sw_gpan(S,T,z)/9.8