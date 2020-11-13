function Nedf=dofcorr(x,y)
% with Chelton's Number of effective degrees of freedom

% reference : "Chelton_1983@DSR_Effects of sampling errors in statistical estimation"
xx=nanmean([x(:) y(:)],2);
N=length(find(~isnan(xx)));
k=round((N-1)*0.5); % becomes stable after 10% of total data length


[rhoxx lags]=xcorr(x,x,k,'coeff');
[rhoyy lags]=xcorr(y,y,k,'coeff');
[rhoxy lags]=xcorr(x,y,k,'coeff');
[rhoyx lags]=xcorr(y,x,k,'coeff');

setcorr=rhoxx.*rhoyy+rhoyx.*rhoxy;
sumcorr=nansum(setcorr);

Nedf=N/sumcorr;


end