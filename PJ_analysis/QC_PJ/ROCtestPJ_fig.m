function ROCtestPJ_fig(vars);
% written by PJ, 2016May16
% Drawing Rate of change test figure (QUARTOD) : test value |T_n - T_{n-1}| 

%%input
% vars: input data
% tval: threshold values (can be a vector)
val=abs(vars(2:end-1)-(vars(1:end-2)));

std3=nanstd(val)*3;

p=3;q=1
figure
set(gcf,'position',[ 100    33   832   947])
subplot(p,q,1)
plot(vars,'.')
title('Rate of change test: Original')
subplot(p,q,2)
plot(val,'.')
title('Testvalue |T_n - T_{n-1}| ')
subplot(p,q,3)
hist(val,1000)
title(['Histogram; 3STD of test value: ' num2str(std3)])

tval=input('Type thesholds (tval): ')
l=length(tval);

figure
set(gcf,'position',[ 151    33   832   947])
for ii=1:l
%exceeding index
erid=find(val>tval (ii))+1;
subplot(l,q,ii)
plot(vars,'.')
hold on
plot(erid,vars(erid),'.r')
title(['Rate of change Removed data (' num2str(length(erid)) ') by the thershold: ' num2str(tval(ii)) '; (red)'])
% subplot(l*2,q,2*ii)
% vlid=setxor(1:length(vars), erid);
% plot(jds(vlid),vars(vlid),'.');title('Remove spike')
% % datetick('x','yyyy')
end




end