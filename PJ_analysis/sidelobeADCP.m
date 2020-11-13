function [bindepth, SLBA, SLBD]=sidelobeADCP(firstbin,interval,bottombin, binnum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculation side lobe area for ADCP
%written by JHPARK 2016Feb.2

%%input (example)
% firstbin=7.5
% interval=5 % bin interval
% bottombin=25 % bottom bin detected by echo intensity
% binnum=26 % number of total bins

%%output
% bindepth: bin depth of ADCP
% SLBA: side lobe boundary bin
% SLBD: side lobe boundary depth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bindepth=firstbin:interval:firstbin+interval*binnum-1
range=firstbin+interval*(bottombin-1);

deg2rad=pi/180;
stSL=cos(20*deg2rad)*range;% sidelobe contamination start
SLBA=floor(stSL/interval); %boundary area
SLBD=bindepth(SLBA);%boundary depth

end

