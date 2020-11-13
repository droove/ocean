function [integu uda]=trapzPJ(u,z);
%% trapezoidal integration method and depth averaging including nan value
% 
% averaging regadless there are nans or not.
% [integu]=trapzPJ(u,depth);
% % [integu uda]=trapzPJ(u,depth);

% input
% u: profile
% z:  must be in positive upward z coordinate (corresponds to -depth)

% output
% integu: depth integrated u
% uda: depth averaged u
% u must be a column or row vector
%
% Written by PJ. 2013.Mar.20

depth=z;
if diff(depth(1:2))>0, error 'z must be in positive upward z coordinate'; end
id=find(~isfinite(u));
u(id)=[];depth(id)=[];
u=u(:)';
if length (u)<2
    integu=nan; uda=nan;
else
dz=-diff(depth);dz=dz(:)';
integrntu=(u(2:end)+u(1:end-1))/2.*dz;
id=find(isnan(integrntu));dzz=dz;dzz(id)=nan;


integu=nansum(integrntu);

%depth averaged
totdepth=nansum(dzz);
uda=integu/totdepth;
end

end