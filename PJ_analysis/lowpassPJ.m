function [xout]=lowpassPJ(data,fc,fs,nperd,order)
% based on the function lp_passed=lowpass(data,fc,fs)
%
% bandpass a time series with a 5th order butterworth filter
%
% data = input time series
% fc = lowpass corner frequency of filter  1/80
% fs = sampling frequency
% nperd = insert nan value near the start/end point of each segment;
% order = order of response fuction
% see also bandpassPJ, highpassPJ
if nargin<5
order=5;      % recommanded by PJ.  % order <= 8 is recommanded, order must be smaller than 10
end
if nargin<4
nperd=fs/fc*2;
end

%linear interpolation
jd=1:length(data);
nnid1=find(~isnan(data));
nid1=find(isnan(data));
nnids=extrchunk(data);
data([1 length(data)])=[data(nnid1(1)) data(nnid1(end))];
nnid2=find(~isnan(data));
nid2=find(isnan(data));
datai=interp1(jd(nnid2),data(nnid2),jd,'linear');
%    
% filter
% fnq=1/(2*delt);  % Nyquist frequency 


wc=(fc.*2.*pi)./(pi.*fs);

[b,a]=butter(order,wc,'low');
dataf=filtfilt(b,a,datai);
dataf=dataf(:);
dataf(nid1)=nan;
%replace nan in the vicinity of data gap after filtering

for kk=1:length(nnids(:,1))
    if nperd~=0
    dataf(nnids(kk,1):nnids(kk,1)+nperd)=nan;
    dataf(nnids(kk,2)-nperd:nnids(kk,2))=nan;
    end
end
xout=dataf;