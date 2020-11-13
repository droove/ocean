function [d_mean m_a]=demean(A,DT);

% demean(DT==1) function and detrend(DT==2)
% Wrritten by J-H Park
%
% A :each column is onepoint timeseries data, each row is one moment space data
% substract time mean of each column of a
%
if nargin<2
    DT=1;
end

[r c]=size(A);

if DT==1
    m_a=nanmean(A);
    
    if r==1 | c==1
        d_mean=A-m_a;
    else
        for ii=1:c;
            d_mean(:,ii)=A(:,ii)-m_a(ii);
        end;
        
    end
else
    
    for ii=1:c
        gd=find(isfinite(A(:,ii)));
        tc=[ones(r,1) [1:r]' ];
        m_a=tc(gd,:)\A(gd,ii);
        d_mean(:,ii)=A(:,ii)-tc*m_a;
    end
    
    
end



