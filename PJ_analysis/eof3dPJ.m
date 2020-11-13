function [EOFs pcs eigvl recs]=eof3dPJ(data,nmode)

% EOF analysis using spatial covariance matrix not time!
% dimension on eigen vectors not on PC time series

% imput data and parameter
% data: data=data(x,y,t); 3D matrix
% nmode: number of mode used in reconstruction   (default: number of station)

%  output variable
% EOFs: eigen value  EOFs=EOFs(x,y,mode); dimensions on EOF!
% pcs :  non-dimensionalized PC(1st row = 1stmode, 2nd row = 2nd mode....); non-dimensionalized PC
% eigvl : eigen value
% recs :reconstruction recs(x,y,t,mode) 
%

nmodes=nmode;
% data=data(x,y,t)

% sorting finite value position
datnan=squeeze(mean(data,3));
[dat2da dat2db]=size(datnan);
nnid=find(~isnan(datnan));
[a b c]=size(data);

for ii=1:c
    dds=squeeze(data(:,:,ii))-datnan; %demean process
    ddss=dds(nnid);
    edata(ii,:)=ddss(:);
end

datas=edata';
c=nancov(datas');  % covariance normalized by (N-1)
[ca cb]=size(c);
[sda sdb]=size(datas); %usually sdb>sda

%EOF analysis
[EOF,Evl]=eig(c);  % v: eigen vector, d: eigen value
eigvl= flipud(diag(Evl));
EOFss=fliplr(EOF);
pcss=EOFss'*datas;

for ii=1:ca
nandat=nan(dat2da, dat2db);
nandat(nnid)=EOFss(:,ii);
pcs(ii,:)=pcss(ii,:)/nanstd(pcss(ii,:));
EOFs(:,:,ii)=nandat*nanstd(pcss(ii,:)); %EOFs=EOF dimensions on EOF!
end



for ii=1:nmodes
    recn1=[EOFss(:,ii)*pcss(ii,:)];
    for jj=1:sdb
       nandat=nan(dat2da, dat2db);
       nandat(nnid)=recn1(:,jj);
    recs(:,:,jj,ii)=nandat;
    end
end
