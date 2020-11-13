function [Xval,Yval,ids]=expertrvPJ(XX,YY)
%written by PJ, 2016May17, GUI part is modified from KJLee's code
% Expert's review!
% input
% XX: input data x
% YY: input data y
% output
% Xval: selected x variable
% yval: selected y variable
% ids : selected index

%see also 
if nargin<2
    YY=XX(:);
   XX=1:length(XX); 
end

xx=XX(:);
vars=YY(:);
proc=1;
procd=1;
ii=1
xs=[];
ys=[];
ids=[];
%  rect = getrect(varargin)
while proc==1
    procd=1;
    
    while procd==1
        pause()
        grct=getrectPJ;
%         grct = getrect2
        x=grct(1);
        y=grct(2);
        dx=grct(3);
        dy=grct(4);
        
        if dx==0 & dy==0
            %find nearest data point (magnetic)
            XScale=diff(get(gca,'XLim'));
            YScale=diff(get(gca,'YLim'));
            r=sqrt(((xx-x)./XScale).^2+((vars-y)./YScale).^2);
            
            [temp,i]=min(r);
            xs(ii)=xx(i);
            ys(ii)=vars(i);
            ids(ii)=i;
            hold on; h1=plot(xs(ii),ys(ii),'ro');
            ii=ii+1;
            choiced=questdlg('Another point?','Expert review');
            
            
            switch choiced
                case 'Yes'
                    procd=1;
                    zoom
                case 'No'
                    procd=0;
                    zoom out
                case 'Cancel'
                    procd=1;
                    delete(h1)
                    xs(end)=[];
                    ys(end)=[];
                    ii=ii-1
                    zoom
            end
            
        else
            
            xids=find(xx>=x & xx<=x+dx);
            yids=find(vars>=y & vars<=y+dy);
            cids=intersect(xids,yids);
            ids=[ids cids(:)'];
            xs=[xs xx(cids(:)')'];
            ys=[ys vars(cids(:)')'];
            llc=length(cids);
            ii=ii+llc;
            hold on; h1=plot(xs(end-llc+1:end),ys(end-llc+1:end),'ro');
            
            
            
            choiced=questdlg('Another point?','Expert review');
            
            
            switch choiced
                case 'Yes'
                    procd=1;
                    zoom
                case 'No'
                    procd=0;
                    zoom out
                case 'Cancel'
                    procd=1;
                    delete(h1)
                    xs(end-llc+1:end)=[];
                    ys(end-llc+1:end)=[];
                    ii=ii-llc
                    zoom
            end
        end
        
        
    end
    
    choice=questdlg('Another period?','Finding bad data','Yes','No','No');
    
    switch choice
        case 'Yes'
            proc=1;
            zoom out;
            
        case 'No'
            proc=0;
            zoom out;
            
    end
end
Xval=xs;
Yval=ys;

end