function [modes,gamm]=normmodePJ(Nsq,p,nmodes,lat,fig)
%%
% %written by jhpark 2014 Jun16
% %based on Kundu 1975 paper. boussinesq 
% % modified from dynmodes.m

% % input var.
% %Nsq: N^2 (square brunt vaisala frequancy)
% %p: pressure (p(1)=0 if possble)
% %nmodes: number of modes to be printed
% %fig: if fig==1 :draw figures, esle no drawing
% 
% % ouput var.
% %modes :normalized vertical structure of horizontal velocity
% %gamm= horizontal length scale

%% data alignment

if nargin<=4
    fig=0;
end
rho0=1028;

%Latitude 
th=37.5; %degree north 
if nargin>=3
th=lat;
end
%    convert to column vector if necessary
[m,n] = size(p);
if n == 1
    p=p';
end
[m,n] = size(Nsq);
if n == 1
    Nsq=Nsq';
    n=m;
end
%                 check for surface value
if p(1) > 0
    %             add surface pressure with top Nsq value
    z(1)=0;
    z(2:n+1)=-p(1:n);
    N2(1)=Nsq(1);
    N2(2:n+1)=Nsq(1:n);
    nz=n+1;
else
    z=-p;
    N2=Nsq;
    nz=n;
end
%          calculate depths and spacing
%        spacing
dz(1:nz-1)=z(1:nz-1)-z(2:nz);
%        midpoint depth
zm(1:nz-1)=z(1:nz-1)-.5*dz(1:nz-1)'';
%        midpoint spacing
dzm=zeros(1,nz);
dzm(2:nz-1)=zm(1:nz-2)-zm(2:nz-1);
dzm(1)=dzm(2);
dzm(nz)=dzm(nz-1);

%% get dynamic modes
% solving eigenvalue problem which satisfies -AV+DV=0 ; V: eigen
% function of A,D: eigen value  of A
%
A = zeros(nz,nz);
B = zeros(nz,nz);
%             create matrices
% A: -d/dz(d/dz)

deg2rad=pi/180;
omega=2*pi/86400;
f=2*omega*sin(th*deg2rad);
g=9.8;
for i=2:nz-1
    A(i,i) = +f^2/N2(i-1)/(dz(i-1)*dzm(i))  + f^2/N2(i)/(dz(i)*dzm(i));
    A(i,i-1) = -f^2/N2(i-1)/(dz(i-1)*dzm(i));
    A(i,i+1) = -f^2/N2(i)/(dz(i)*dzm(i));
end
%             set boundary conditions (no-gradient condition)
A(1,:)=A(2,:);
A(nz,:)=A(nz-1,:);
[wmodes,e] = eig(A); %wmodes : vertical structure of horizontal velosity 
%          extract eigenvalues
e=diag(e);
%
ind=find(imag(e)==0);
e=e(ind);
wmodes=wmodes(:,ind);

% removing error mode.. Barotropic mode is removed in this part
ind=find(e>=1.e-10);
e=e(ind);
wmodes=wmodes(:,ind);
%
[e,ind]=sort(e);
wmodes=wmodes(:,ind);

nm=length(e);
gamm=1./sqrt(e);
gamm=[(g*max(p))^.5/f; gamm]; %include bt scale

%selected mode normalization 
modes=ones(nz,nmodes+1);
for ii=1:nmodes
    modes(:,ii+1)=wmodes(:,ii)/std(wmodes(:,ii));   
end


%% figure
if fig==1
% figure
figure
set(gcf,'position',[218    33   528   691])
subplot(2,2,1)
plot(Nsq,z);
title('Buoyancy Frequency Squared (s^{-2})')
ylabel('z ( m ) ')
ylim([z(end) 0])

subplot(2,2,2)
plot([0:nmodes],gamm(1:nmodes+1)/1000,'r:o');
title(' Horizontal length scale ')
ylabel('( km )')
set(gca,'xtick',0:nmodes,'xticklabel',num2str([0:nmodes]'))
xlabel('mode')
subplot(2,2,3)
plot(modes,z);
lgd=legend('BT', '1^{st} BC', '2^{nd} BC' ,'3^{rd} BC')
set(lgd,'location','southwest')
hold on
plot(z*0,z,'--k')
title('Horizontal Velocity Structure')
ylim([z(end) 0])

subplot(2,2,4)
plot(gamm(2:nmodes+1)/1000,'r:o');
title(' BC''s horizontal length scale (km)')
ylabel('( km )')
set(gca,'xtick',1:nmodes,'xticklabel',num2str([1:nmodes]'))
xlabel('mode')
% set(gcf,'paperpositionmode','auto')
% % print('-dpdf','normalmode_figure')

end