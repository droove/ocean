function [xout harmcon]=harmfitPJ(xin,t,s,nlin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% harmonic fitting for multiple target frequency(cosine fitting removing linear trend) with the data including 'nan's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fitting form 
% z(t)=x0+x1*t+x2*cos(2*pi*fu*t-phase) 


% comment: The reason why I choose cosine fitting is for understanding phase 
% value ituitively. Phase value of cosine curve can be representative of
% location of max/min value



% input variables
% xin: data (possible with missing data with nan)
% t: time vector
% s: target frequency [CPD]  (dimension :inverse of time dimension) 
% lin: if nlin= 'nolin' that linear trend of xin is not considered 

% output
%xout: harmonic fitting results (cosine curve)
%harmcon : if xin are real value then harmcon=[mean, amp, emp, pha, epha ] ...
% and if xin are imaginary value then 
% harmcon=[semi-major length, emajor,semi-minor length, eminor, inclination, einc, phase, epha ,rd ]
% rd is rotating direction: rd=1 (counter-clockwise) & rd=-1 (clockwise)
% inclination: 0degree(major axis lies on x-axis)

%%%%%%%  Note  %%%%%
% !!phase starts with first element of time vector!!
%%%%%%%%%%%


% writen by PJ. with instruction from Prof. S-Y Kim in GeoMath and t_tide.m;  2013 Sep 25

% reference
% A description of the theoretical basis of the analysis and some
% implementation details can be found in:
%
% Pawlowicz, R., B. Beardsley, and S. Lentz, "Classical Tidal 
%   "Harmonic Analysis Including Error Estimates in MATLAB 
%    using T_TIDE", Computers and Geosciences, 2002.

%see also harmfit, t_tide, harmfitPJs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lincrit=1;
if nargin>3 
    
      if strcmp(lower(nlin(1:3)),'nol');
 
        lincrit=0;
      else
          error('''nolin'' or nothing');
          
      end
end

t=t(:)-t(1);
xin=xin(:);
fu=s(:);

% xin=u(:,1)+i*v(:,1);
dt=diff(t(1:2));
%% harmonic analysis 
mu=length(fu); % # base frequencies
gd=find(isfinite(xin));

if lincrit==1
tc=[ones(length(t),1) t cos((2*pi)*t*fu') sin((2*pi)*t*fu') ];
%  Ax = B for x   =>   x = A\B
coef=tc(gd,:)\xin(gd);

z0=coef(1);dz0=coef(2);
ap=(coef(3:mu+2)-1i*coef(mu+3:end))/2;  % a+ amplitudes
am=(coef(3:mu+2)+1i*coef(mu+3:end))/2;  % a- amplitudes
else
tc=[ones(length(t),1) cos((2*pi)*t*fu') sin((2*pi)*t*fu') ];
%  Ax = B for x   =>   x = A\B
coef=tc(gd,:)\xin(gd);

z0=coef(1);
ap=(coef(2:mu+1)-1i*coef(mu+2:end))/2;  % a+ amplitudes
am=(coef(2:mu+1)+1i*coef(mu+2:end))/2;  % a- amplitudes
    
end

xout=tc*coef;  % This is the time series synthesized from the analysis
xres=xin-xout; % and the residuals!

%% error analysis 
% Linearly interpolates gaps in a time series %
% Fill in "internal" NaNs with linearly interpolated
% values so we can fft things.

%fixgaps
xr=xres;
bd=isnan(xres);
gd=find(~bd);
bd([1:(min(gd)-1) (max(gd)+1):end])=0; % zero padding 
xr(bd)=interp1(gd,xres(gd),find(bd)); %interpolation

nreal=1;

% linear method
%noise_stats
%residual_spectrum
xxx=xr(isfinite(xr));
fband =[.00010 .00417;
    .03192 .04859;
    .07218 .08884;
    .11243 .12910;
    .15269 .16936;
    .19295 .20961;
    .23320 .25100;
    .26000 .29000;
    .30000 .50000]*24; %cycle per hour

nfband=size(fband,1);
nx=length(xxx);

% Spectral estimate (takes real time series only).
warning('off')
[Pxr,fx]=periodogram(real(xxx),[],nx,1/dt); % Call to SIGNAL PROCESSING TOOLBOX - see note in t_readme. If you have an error here you are probably missing this toolbox
warning('off')
[Pxi,fx]=periodogram(imag(xxx),[],nx,1/dt); % Call to SIGNAL PROCESSING TOOLBOX - see note in t_readme.
warning('off')
[Pxc,fx]=csd(real(xxx),imag(xxx),nx,1/dt); % Call to SIGNAL PROCESSING TOOLBOX - see note in t_readme.
warning('off')



df=fx(3)-fx(2);
Pxr(round(fu./df)+1)=NaN ; % Sets Px=NaN in bins close to analyzed frequencies
Pxi(round(fu./df)+1)=NaN ; % (to prevent leakage problems?).
Pxc(round(fu./df)+1)=NaN ;

Pxrave=zeros(nfband,1);
Pxiave=zeros(nfband,1);
Pxcave=zeros(nfband,1);

for k=nfband:-1:1,
%     iir=[fx>=fband(k,1) & fx<=fband(k,2) & isfinite(Pxr)];
    jband=find(fx>=fband(k,1) & fx<=fband(k,2) & isfinite(Pxr));
    if any(jband),
        Pxrave(k)=mean(Pxr(jband))*2/nx;
        Pxiave(k)=mean(Pxi(jband))*2/nx;
        Pxcave(k)=mean(Pxc(jband))*2/nx;
    elseif k<nfband,
        Pxrave(k)=Pxrave(k+1);   % Low frequency bin might not have any points...
        Pxiave(k)=Pxiave(k+1);
        Pxcave(k)=Pxcave(k+1);
    end;
end



nfband=size(fband,1);
mu=length(fu);

% Get the statistics for each component.
ercx=zeros(mu,1);
eicx=zeros(mu,1);
for k1=1:nfband;
    k=find(fu>=fband(k1,1) & fu<=fband(k1,2));
    ercx(k)=sqrt(Pxrave(k1));
    eicx(k)=sqrt(Pxiave(k1));
end

cxi=ap+am; sxi=i*(ap-am); ercx=ercx;ersx=ercx; ercy=eicx; ersy=eicx;

%errell
r2d=180./pi;
cx=real(cxi(:));sx=real(sxi(:));cy=imag(cxi(:));sy=imag(sxi(:));
ercx=ercx(:);ersx=ersx(:);ercy=ercy(:);ersy=ersy(:);

rp=.5.*sqrt((cx+sy).^2+(cy-sx).^2);
rm=.5.*sqrt((cx-sy).^2+(cy+sx).^2);
ercx2=ercx.^2;ersx2=ersx.^2;
ercy2=ercy.^2;ersy2=ersy.^2;

% major axis error
ex=(cx+sy)./rp;
fx=(cx-sy)./rm;
gx=(sx-cy)./rp;
hx=(sx+cy)./rm;
dcx2=(.25.*(ex+fx)).^2;
dsx2=(.25.*(gx+hx)).^2;
dcy2=(.25.*(hx-gx)).^2;
dsy2=(.25.*(ex-fx)).^2;
emaj=sqrt(dcx2.*ercx2+dsx2.*ersx2+dcy2.*ercy2+dsy2.*ersy2);

% minor axis error
dcx2=(.25.*(ex-fx)).^2;
dsx2=(.25.*(gx-hx)).^2;
dcy2=(.25.*(hx+gx)).^2;
dsy2=(.25.*(ex+fx)).^2;
emin=sqrt(dcx2.*ercx2+dsx2.*ersx2+dcy2.*ercy2+dsy2.*ersy2);

% inclination error
rn=2.*(cx.*cy+sx.*sy);
rd=cx.^2+sx.^2-(cy.^2+sy.^2);
den=rn.^2+rd.^2;
dcx2=((rd.*cy-rn.*cx)./den).^2;
dsx2=((rd.*sy-rn.*sx)./den).^2;
dcy2=((rd.*cx+rn.*cy)./den).^2;
dsy2=((rd.*sx+rn.*sy)./den).^2;
einc=r2d.*sqrt(dcx2.*ercx2+dsx2.*ersx2+dcy2.*ercy2+dsy2.*ersy2);

% phase error
rn=2.*(cx.*sx+cy.*sy);
rd=cx.^2-sx.^2+cy.^2-sy.^2;
den=rn.^2+rd.^2;
dcx2=((rd.*sx-rn.*cx)./den).^2;
dsx2=((rd.*cx+rn.*sx)./den).^2;
dcy2=((rd.*sy-rn.*cy)./den).^2;
dsy2=((rd.*cy+rn.*sy)./den).^2;
epha=r2d.*sqrt(dcx2.*ercx2+dsx2.*ersx2+dcy2.*ercy2+dsy2.*ersy2);




epsp=angle(ap)*180/pi;
epsm=angle(am)*180/pi;
ap=abs(ap);
am=abs(am);

aap=ap;	% Apply nodal corrections and
aam=am;	% compute ellipse parameters.

fmaj=aap+aam;                   % major axis
fmin=abs(aap-aam);                   % minor axis

gp=mod( -epsp ,360); % pos. phase in deg.
gm=mod(+epsm ,360); % neg.  phase in deg.

finc= (epsp+epsm)/2;
finc(:,1)=mod( finc(:,1),180 ); % Ellipse inclination in degrees

pha=mod( gp+finc ,360);
% pha=cluster(pha,360);		% Cluster angles around the 'true' angle
% to avoid 360 degree wraps.

% 95% confidence interval
emaj=1.96*emaj;
emin=1.96*emin;
einc=1.96*einc;
epha=1.96*epha;

% rotating direction
for ii=1:length(fu)
if aap(ii)>aam(ii)
    rd(ii,1)=1 ; %counter-clockwise
else
    rd(ii,1)=-1; %clockwise;
end
end

if isreal(xin),
%     if lincrit==1;
%     harmcon=[z0 dz0 fmaj(:,1),emaj,pha(:,1),epha];
%     else
    harmcon=[z0*ones(mu,1) fmaj(:,1),emaj,pha(:,1),epha];
%     end
else
    harmcon=[ fmaj(:,1),emaj(:,1),fmin(:,1),emin(:,1), finc(:,1),einc,pha(:,1),epha(:,1), rd(:,1)];
end;

