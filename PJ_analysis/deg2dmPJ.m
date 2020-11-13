function [degmin]=deg2dmPJ(degree);

% convert degree to degree minute position
%written by JHPark 2017 sep 24
% see also dm2degPJ
degree=degree(:);
pmfactor=degree./abs(degree);
deg=floor(abs(degree));
mint=(degree-(deg.*pmfactor))*60;

degmin=[deg(:).*pmfactor mint(:)];
end
