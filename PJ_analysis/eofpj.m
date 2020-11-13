function [EOFs pcs eigvl recs]=eofpj(data,datatype,nmode)

% EOF analysis using spatial covariance matrix not time!
% dimension on PC time series not on eigen vectors

% imput data and parameter
% data type:column index( #of column=length of covariance matrix (=1) or #of row=length of covariance matrix (=2)  );
% nmode: number of mode used in reconstruction   (default: number of station)
%

% output variable
% EOFs: eigen value  (1st column = 1stmode, 2nd column = 2nd mode....)
% pcs : PC time series that has dimension (1st row = 1stmode, 2nd row = 2nd mode....)
% eigvl : eigen value
% recs :reconstruction recs(ii,:,:) = ith mode reconstruction data
%
% see also eof3dPJ

%making type 1 data
if datatype==1
    data=data';
elseif datatype==2
    data=data;
end
c=nancov(data');  % covariance normalized by (N-1)
[ca cb]=size(c);

%number of mode that is needed
if nargin > 2
    nmodes=nmode;
else
    nmodes=ca;
end
[sda sdb]=size(data); %usually sdb>sda

%EOF analysis
[EOF,Evl]=eig(c);  % v: eigen vector, d: eigen value (correspond to variance of each mode)
eigvl= flipud(diag(Evl)); % variance not std
EOFs=fliplr(EOF);
pcs=EOFs'*data;


if datatype==1
    recs=zeros(nmodes,sdb,sda);
    for ii=1:nmodes
        recs(ii,:,:)=[EOFs(:,ii)*pcs(ii,:)]';
    end
else
    recs=zeros(nmodes,sda,sdb);
    for ii=1:nmodes
        recs(ii,:,:)=[EOFs(:,ii)*pcs(ii,:)];
    end
end

