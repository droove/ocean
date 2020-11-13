function [uh ur amp phdeg]=harmfits(u,t,s,t0)

% harmonic fitting(cosine fitting) of scalar value with the data including 'nan's

% fitting form
% z(t)=x0+x2*cos(2*pi*fu*t-phase) 

% comment: The reason why I choose cosine fitting is for understanding phase 
% value ituitively. Phase value of cosine curve can be representative of
% location of max/min value

% writen by PJ. with instruction from Prof. S-Y Kim in GeoMath
% 2013 Jan% u: data (possible with missing data with nan)
% t: time vector
% s: target frequency  (dimension :inverse of time dimension) 
% t0: start time (=t(1) default)
 
% output
%uh: harmonic fitting results (cosine curve)
%ur: residual
%amp: mean, amplitude
%phdeg: phase in degree  (phase WRT sine curve) 0<phdeg<360

%see also, harmfitPJ

u=u(:);
if nargin>3
    t=t(:)-t0;
else
t=t(:)-t(1);
end
d2=u;
tt=t;
ii=find(isnan(d2));d2(ii)=[];t(ii)=[];

G=[];Go=[];
for ii=1:length(s)
  g=[t*0+1 cos(2*pi*s(ii)*t) sin(2*pi*s(ii)*t) ];
G=[G g];
 
  go=[tt*0+1 cos(2*pi*s(ii)*tt) sin(2*pi*s(ii)*tt) ];
Go=[Go go];
end

iGG=inv(G'*G);
mhat=iGG*G'*d2;
uh=Go*mhat;
ur=u-Go*mhat;

amp=[mhat(1) norm(mhat(2:3))]';
% %sine
% phdeg=atan2(mhat(2),mhat(3))/pi*180;
% cosine
phdeg=atan2(mhat(3),mhat(2))/pi*180;
if phdeg<0,phdeg=phdeg+360;end
    
end
