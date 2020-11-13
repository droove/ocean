function [tau, LHF, SHF, Cd, Ch, qs, qac] = fluxPJ(wind, SST, Tair, qa, Pair, opt_qa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation of surface momentum and heatflux
% written by J-H Park 2019, Mar, 17
% based on Jaimes et al 2015 @ MWR_ Enthalpy and momentum fluxed during hurricane Earl~~

%input variable all variables should be in the same dimension except opt_qa
% wind: 10 m height wind speed [m/s]
% SST: seasurface temperature [^oC]
% Tair: 10m height air temperature [^oC]
% qa:  10m height atmospheric specific humidity [kg/kg] or relative humidity [%]
% Pair: air pressure [hPa] if Pair is not defined this is regarded as 1014 hPa
% opt_qa: qa option, if opt_qa=1 qa is the specific humidity, opt_qa=0 qa is the relative humidity

%output variable
%tau: wind stress [N m^{-2}]
%LHF: latent heat flux positive upward [W m^{-2}]
%SHF: sensible heat flux positive upward [W m^{-2}]
%Enthalpy flux = LHF+SHF

%Cd: exchange coefficient of momentum 
%Ch:exchange coefficient of sensible (Ch) or latent heat(Cq) (Ch = Cq) 

%qs: saturated specific humidity at the SST 
%(assumed to be at 98% saturation at the SST [Buck 1981 @ J. Appl. Meteor])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See also  convert_humidity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%parameters
rhoa=1.22; %[kg m^{-3}] density of air 
cp= 1004; % [J kg^{-1} K^{-1}] specific heat of air at constant pressure 
Lvap=2.5*10^6; % [J kg^{-1}] latent heat of vaporization
hPa2Pa=100;

wind=wind(:);
SST=SST(:);
Tair=Tair(:);
qa=qa(:);
Pair=Pair(:);

if nargin<5
   opt_qa=1;
   Pair=Tair*0+1014; %hPa
end

if nargin<6
   opt_qa=1;
end


wid1=find(wind<5);
wid2=find(wind>=5 & wind<25);
wid3=find(wind>=25);
widn=find(isnan(wind));
Cd(wid1)=(4-0.6*wind(wid1))*10^(-3);
Cd(wid2)=(0.7375+0.0525*wind(wid2))*10^(-3);
Cd(wid3)=2.05*10^(-3);
Cd(widn)=nan;

hid1=find(wind<2);
hid2=find(wind>=2 & wind<10);
hid3=find(wind>=10);
Ch(hid1)=(1.5-0.25*wind(hid1))*10^(-3);
Ch(hid2)=(0.975+0.0125*wind(hid2))*10^(-3);
Ch(hid3)=1.1*10^(-3);
Ch(widn)=nan;

Cd=reshape(Cd,size(wind));
Ch=reshape(Ch,size(wind));
% humidity conversion
if opt_qa~=1
qac = convert_humidity (Pair*hPa2Pa, SST+273.15,qa,'relative humidity',...
    'specific humidity', 'Murphy&Koop2005',0.0001); % specific humidity in kg/kg
else
qac = qa;
end

qs = convert_humidity (Pair*hPa2Pa, SST+273.15,98+SST*0,'relative humidity',...
    'specific humidity', 'Murphy&Koop2005',0.0001); % specific humidity in kg/kg

    
tau=rhoa*Cd.*(abs(wind).^2);
SHF=rhoa*cp*Ch.*abs(wind).*(SST-Tair);
LHF=rhoa*Lvap*Ch.*abs(wind).*(qs-qac);

end
