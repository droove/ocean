function [degree]=dm2degPJ(deg,mint);

% convert degree minute to degree position
%written by JHPark 2017 sep 24
% see also deg2dmPJ

degree=deg+mint/60;
end
