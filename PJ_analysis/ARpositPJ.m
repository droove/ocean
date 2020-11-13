function [ARposit, mfbdist, mdepth]=ARpositPJ(londm,latdm,range,lontg,lattg,depHP,tmooringl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%written by JHPark
%2019May10
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%%input variables
% londm: longitude of ranging points in degree and minute
% latdm: latitude of ranging points in degree and minute
% range: distant of AR measured by AR deckunit on the ship
% lontg: longitude of anchor drop  in degree and minute
% lattg: longitude of anchor drop  in degree and minute
% depHP:depth of hydrophone in meter
% tmooringl: length of mooring in meter for comparing to fall back distance
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%%output variables
% ARposit: latitude and longitude of estimated mean AR position in degree and minute
% mfbdist: mean fall back distance of estimated AR position from anchor drop position in meter;
% mdepth: mean depth of estimated AR position in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Example data
% tmooringl=2695;
% londm=[61 01.1453; 60 59.5673;  60 57.8655; 60 59.5971; 60 59.3950];%degree min
% latdm=[-7 -58.859683; -8 -0.484370;-7.0000  -58.827414; -7 -57.2855; -7 -58.9484];%degree min
% range=[5142 4245 3612 4614 3193]; %m
% lontg=60+58.791206/60;
% lattg=-7-58.88616/60;
% depHP=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cc

nstd=1 % determine outlier. exceeds nstd*STD.
tid=1:length(londm);
b = nchoosek(tid,3); % combinations

%coefficients
km2m=1000;
m2km=1/km2m;
deg2rad=pi/180;
rad2deg=1/deg2rad;


figure
set(gcf,'position',[21   198   878   693])
for kk=1:length(b(:,1))
    sid=b(kk,:);
    %% convert lon, lat to distance coordinate
    lon=dm2degPJ(londm(sid,1),londm(sid,2));
    lat=dm2degPJ(latdm(sid,1),latdm(sid,2));
    lontgg=dm2degPJ(lontg(1),lontg(2));
    lattgg=dm2degPJ(lattg(1),lattg(2));
    R=range(sid);
    
    for ii=1:length(lon)
        [dist bears(ii)]=distPJ([lontgg lon(ii)],[lattgg lat(ii)]);
        dists(ii)=dist*km2m;
    end
    xs=dists.*sin(bears*deg2rad);
    ys=dists.*cos(bears*deg2rad);
    
    A1=xs(2)-xs(1);
    B1=ys(2)-ys(1);
    C1=(R(1)^2-R(2)^2+xs(2)^2-xs(1)^2+ys(2)^2-ys(1)^2)/2;
    
    A2=xs(3)-xs(2);
    B2=ys(3)-ys(2);
    C2=(R(2)^2-R(3)^2+xs(3)^2-xs(2)^2+ys(3)^2-ys(2)^2)/2;
    
    %horizontal position of AR
    xar=(B1*C2-B2*C1)/(B1*A2-B2*A1);
    yar=(C1-A1*(B1*C2-B2*C1)/(B1*A2-B2*A1))/B1;
    
    %horizontal distance from AR and ranging position
    diposit=abs((xs-xar)+1i*(ys-yar));
    th=asin(diposit./R);%*rad2deg
    depthss=R.*cos(th);
    depth=mean(depthss);
    
    %figure
    subplot(2,2,1)
    for ii=1:length(sid)
        [xco, yco]=pol2cart(-pi-.1:.1:pi,R(ii));
        xc=xco+xs(ii);
        yc=yco+ys(ii);
        h1(2)=plot(xc,yc,'k');
        hold on
    end
    
    h1(1)=plot(xs,ys,'+r','linewidth',2);
    % h1(3)=plot(xar,yar,'*b')
    axis equal
    xars(kk)=xar;
    yars(kk)=yar;
    depths(kk)=depth;
end

fbdists=abs(xars+1i*yars);

% remove outlier
stddep=std(demean(depths));
stddist=std(demean(fbdists));
nid1=find(abs(demean(depths))>stddep*nstd);
nid2=find(abs(demean(fbdists))>stddist*nstd);
nid=[nid1(:);nid2(:)];
slid=setxor(1:length(depths), nid)

mxars=nanmean(xars(slid));
myars=nanmean(yars(slid));
mfbdists=nanmean(fbdists(slid));
mdepths=nanmean(depths(slid));
hold on
h1(4)=plot(xars,yars,'*g')%,'color',[1 1 1]*.5);
plot(xars(nid),yars(nid),'*','color',[1 1 1]*.5);
h1(5)=plot(mxars,myars,'*m','markersize',12);
h1(3)=plot(0,0,'*b');
xlabel('zoanal dist. from anchor drop (m)')
ylabel('meridional dist. from anchor drop (m)')
title('Raning points')
lg1=legend(h1,'Ranging point','Range','Anchor drop','ARs','mean ARs');
set(lg1,'position', [0.3872    0.8215    0.1378    0.1241]);

%depths
subplot(2,2,2)
plot(depths,'+r')
hold on
plot(nid,depths(nid),'+','color',[1 1 1]*.5)
plot(1:length(depths),[1:length(depths)]*0+mdepths,'--k')
ylabel('Depth (m)')
xlabel('Combinations')
title(['mean Depth ' num2str(round(mdepths,1)+depHP)])

% zoom in of AR points
subplot(2,2,3)
%convert cart to lon lat coordinate
bearar=90-atan2(myars,mxars)*rad2deg;
[lonmar latmar]=lonlatPJ(lontgg,lattgg,abs(mxars+1i*myars)*m2km,bearar);
londmar=deg2dmPJ(lonmar);
latdmar=deg2dmPJ(latmar);
h(1)=plot(0,0,'*b','markersize',12);
hold on
h(2)=plot(xars,yars,'*g');
plot(xars(nid),yars(nid),'*','color',[1 1 1]*.5);
h(3)=plot(mxars,myars,'*m','markersize',12);


if latdmar(1)<0
    ns='S'
else
    ns='N'
end

if londmar(1)<0
    ew='w'
else
    ew='E'
end

title(['AR position: ' num2str(abs(latdmar(1))) '^o ' num2str(abs(latdmar(2))) '''' ns '; ' num2str(abs(londmar(1))) '^o ' num2str(abs(londmar(2))) '''' ew ';'])
xlabel('zoanal dist. from anchor drop (m)')
ylabel('meridional dist. from anchor drop (m)')
legend(h,'Anchor drop','ARs','mean ARs')
% fall back distance
subplot(2,2,4)
plot(1:length(depths),fbdists,'+r')
hold on
plot(nid,fbdists(nid),'+','color',[1 1 1]*.5)
plot(1:length(depths),[1:length(depths)]*0+mfbdists,'--k')
title(['Fall back distance = ' num2str(round(mfbdists)) 'm out of ' num2str(tmooringl) 'm'])
ylabel('Dist. (m)')
xlabel('Combinations')

% latdmar londmar mfbdists mdepths
ARposit=[latdmar;londmar];
mfbdist=mfbdists;
mdepth=mdepths+depHP;