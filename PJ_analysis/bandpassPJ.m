function [xout]=bandpassPJ(data,flp,fhp,fs,nperd,order)
% based on the function [d]=bandpass(c,flp,fhi,fs)
%
% bandpass a time series with a 2nd order butterworth filter
%
% c = input time series
% flp = lowpass corner frequency of filter  1/80
% fhi = hipass corner frequency  1/40
% fs = sampling frequency
% nperd = insert nan value near the start/end point of each segment;
% see also lowpassPJ, highpassPJ
if nargin<6
order=2;      % recommanded by PJ. 
end
if nargin<5
nperd=fs/fhp*2;
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
%     [d]=bandpass(c,flp,fhi,fs)
% filter
% fnq=1/(2*delt);  % Nyquist frequency 
% fnq=1/(2*delt);  % Nyquist frequency 

fnq=fs/2;  % Nyquist frequency 
Wn=[flp/fnq fhp/fnq];    % butterworth bandpass non-dimensional frequency 
[b,a]=butter(order,Wn); % construct the filter 
dataf=filtfilt(b,a,datai); % zero phase filter the data 
dataf=dataf(:);
dataf(nid1)=nan;
%replace nan in the vicinity of data gap after filtering

for kk=1:length(nnids(:,1))
    dataf(nnids(kk,1):nnids(kk,1)+nperd)=nan;
    dataf(nnids(kk,2)-nperd:nnids(kk,2))=nan;
end
xout=dataf;

end