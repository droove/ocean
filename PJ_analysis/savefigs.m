function a=savefigs(fformat,fname,fres)
% fig = gcf;
% fig.PaperPositionMode = 'auto'
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)];
% 
set(gcf,'paperpositionmode','auto');
ppsz=get(gcf,'paperposition');

if strcmp(fformat,'-dpdf')
    set(gcf,'papersize',[ppsz(3)+.03 ppsz(4)],'renderer','painters');
else
set(gcf,'papersize',[ppsz(3)+.03 ppsz(4)],'renderer','opengl');    
end

if nargin>2
    print(fformat,fres,fname);
    
    
else
    print(fformat,fname);
end

end