function [argtime]=timearrngPJ(pd0,ascii,pd0_time,ascii_time,intv)
%written by PJ 2016May 25
% this function is used when adcp time problem occur compare to the ascii
% time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input variable
% pd0:  velocity from pd0
% ascii: velocity from ascii
% pd0_time: time vector of pd0 data
% ascii_time: time vector of ascii data
% intv: the range in which the same values between pd0 and ascii are detected
%
% output variable
% argtime: re-arranged pd0 time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xp=pd0;
ya=ascii;
x=xp;
y=ya;
h=1;
timear=pd0_time*nan;
xidx=[1:length(xp)]';
while 1
    
    neids=(find (abs(xp(1:min(length(xp),length(ya)))-ya( 1:min (length(xp),length(ya)) )) >10^-7));
    if isempty(neids); break; end
    nanid=find(isnan(ya));
    neidnn=[neids; nanid];
    dn=find(isnan(xp(1:min(length(xp),length(ya))))+isnan(ya(1:min(length(xp),length(ya))))==2);
    neid=min(setxor(neidnn,dn));
    
    %     intv=60;
    eid=neid+intv;
    
    if eid>length(ya)
        eid=length(ya);
    end
    
    yid=find(abs(ya(neid:eid)-xp(neid))<10^-10); %same value index
    ascid=neid+min(yid)-1;
    
    if abs(ya(ascid+1)-xp(neid+1))<10^-10 | isnan(ya(ascid+1))
        xp=[xp(1:neid-1); ya(neid:ascid-1); xp(neid:end)];
        xidx=[xidx(1:neid-1); nan(length(neid:ascid-1),1); xidx(neid:end)];
    else
        xp(neid)=[];
        xidx(neid)=[];
    end
    %     figure
    %     set(gcf,'position',[  169   414   560   420])
    %     plot(xp,'.'); hold on; plot(ya+1,'.r');
    %     legend('pd0','ascii')
    h=h+1
end



idxs=find(~isnan(xidx));

pd0_time(xidx(idxs),:)=ascii_time(idxs,:);
argtime=pd0_time;
% revid=find(timea(:,1)>2020);
% timea(revid,:)=nan;

figure
set(gcf,'position',[  169   414   560   420])
subplot(2,1,1)
 plot(ya+1,'.');hold on; plot(xp+1,'.r');
legend('ascii','pd0+1')
subplot(2,1,2)
plot(datenum(ascii_time),y,'.'); hold on; plot(datenum(pd0_time),x+1,'.r');
legend('ascii','pd0+1')
end