function [gU, gV]=ssh_gvelPJ(lat,lon,ssh);
% calculate geostrophic velocity field from AVISO SSH data
% written by jhpark 2017 Feb 1
% 
% input variable
% ssh : ssh=ssh(lat,lon), NXM dynamic topography [meter]
% lat : NX1 latitude vector
% lon : MX1 latitude vector
% output variable
% gU, gV: gvel=gvel(lat,lon), NXM matrix [cm s^-1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xxx=lon;yyy=lat;
[xxx yyy]=meshgrid(lon,lat);
omega=2*pi/86400;% dim:sec^-1
f=2.*omega*sin(yyy*pi()/180);
for ii=1:size(yyy,1)
    Dx(ii,:)=sw_dist(yyy(ii,:), xxx(ii,:),'km')*1000; % dimension 'm'
end
for jj=1:size(xxx,2)
    Dy(:,jj)=sw_dist(yyy(:,jj),xxx(:,jj),'km')*1000;
end

    sshx=(ssh(:,1:end-1)+ssh(:,2:end))/2;
    Tx=(9.8./f(:,2:end-1)).*(sshx(:,2:end)-sshx(:,1:end-1))./Dx(:,1:end-1);
    %-----------u---------------
    sshy=(ssh(1:end-1,:)+ssh(2:end,:))/2;
    Ty=-(9.8./f(2:end-1,:)).*(sshy(2:end,:)-sshy(1:end-1,:))./Dy(1:end-1,:);
    
    %---------------ÀÚ·á cutting (M-2 X N-2)-------------
    vm=Tx(2:end-1,:);
    um=Ty(:,2:end-1);
    
    [a b]=size(ssh);
    
    gU=nan(a,b);
    gV=nan(a,b);

    gU(2:end-1,2:end-1)= um;
    gV(2:end-1,2:end-1)= vm;

end