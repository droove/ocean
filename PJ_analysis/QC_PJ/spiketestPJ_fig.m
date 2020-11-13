function spiketestPJ_fig(vars,int);
% written by PJ, 2016May16
% Drawing spike test figure (QUARTOD) : test value |T_{n-1}-(T_n+T_{n-2})/2|

%%input
% vars: input data
% tval: threshold values (can be a vector)
% int: moving average box size (default : int=10)


if nargin<2
    int=10
end
mvars=movavgPJ(vars,int);

val=abs(vars(2:end-1)-(vars(3:end)+vars(1:end-2))/2);
mval=abs(vars-mvars);
std3=nanstd(val)*3;
std32=nanstd(mval)*3;
p=5;q=1
figure
set(gcf,'position',[ 50    33   832   947])
subplot(p,q,1)
plot(vars,'.');hold on; plot(mvars,'.r')
lg=legend('Ori','mov. avg.')
set(lg,'position',[ 0.8285    0.9169    0.0829    0.0444])
title('Spike test: Original')
subplot(p,q,2)
plot(val,'.')
title('Testvalue |T_{n-1}-(T_n+T_{n-2})/2|')
subplot(p,q,3)
hist(val,1000)
title(['Histogram; 3STD of test value: ' num2str(std3)])

subplot(p,q,4)
plot(mval,'.')
title('Test2 value |T-T_{ma}|')
subplot(p,q,5)
hist(mval,100)
title(['Histogram; 3STD of test2 value: ' num2str(std32)])

tval=input('Type thesholds (tval1): ')
tval2=input('Type thesholds (tval2): ')
l=length(tval);
l2=length(tval2);


figure
set(gcf,'position',[ 51    33   832   947])
hh=1;
for ii=1:l
    for jj=1:l2
        %exceeding index
        eridw=find(val<=tval(ii))+1;
        erid=setdiff(1:length(val),eridw);
        erid2=find(mval>tval2(jj));
        eridf=intersect(erid,erid2);
        subplot(l*l2,q,hh)
        plot(vars,'.')
        hold on
        plot(mvars,'.k')
        plot(erid,vars(erid),'.g')
        plot(erid2,vars(erid2),'.m')
        plot(eridf,vars(eridf),'.r')
        if hh==1
            hlg=legend('ori','movavg','tval1','tval2','tval12');
             set(hlg,'position', [0.8754    0.8916    0.1202    0.1035]);
        end
        title(['Spike test Removed data (' num2str(length(erid)) ', ' num2str(length(erid2)) ', ' num2str(length(eridf)) ') by the thershold: ' num2str(tval(ii)) ', ' num2str(tval2(jj)) '; (red)'])
        hh=1+hh;
    end
    % subplot(l*2,q,2*ii)
    % vlid=setxor(1:length(vars), erid);
    % plot(jds(vlid),vars(vlid),'.');title('Remove spike')
    % % datetick('x','yyyy')
end




end