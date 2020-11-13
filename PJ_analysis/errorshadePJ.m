function varargout = errorshadePJ(X,Y,SE,LineColor,varargin)
% modified version of errorshade.m for nan included data plot
% modified by JHPARK.
% date: 2013 Nov 13

%   ERRORSHADE     Shaded error bar plot
%
%    p = errorshade(X,Y,STD,LineColor,{LineWidth},{ShadeColor})
%
%   Plots Y against X in LineColor. A shaded error bar is added
%   between Y-STD and Y+STD.
%  varagin{1}: shadecolor
%  varagin{2}: lind width
%   Optional arguments LineWidth and ShadeColor default to 2 and grey.
%   LineColor defaults to blue, you can use shortend styles as well ('r:').
%   Output returns the handles for the line and the shaded error bar.
%
%   AK 6/2004
X=X(:)';Y=Y(:)';SE=SE(:)'

lw = 2;
ShadeColor = [0.6 0.6 0.6];
 LineColor = 'k';
if nargin > 4
    ShadeColor = varargin{1};
end
if nargin > 5
    lw = varargin{2};
end


if (min(size(SE)) > 1)
    E = SE;
else
    E(1,:) = Y - SE;
    E(2,:) = Y + SE;
end
hold on;


id=find(isnan(Y));
if length(id)==0;
    p1=patch([X X(end:-1:1)],[E(1,:) E(2,end:-1:1)],ShadeColor);
    set(p1,'EdgeColor',ShadeColor,'FaceColor',ShadeColor);
else
    idss=extrchunk(Y);
    for ii=1:length(idss(:,1))
        Xchnk=X(idss(ii,1):idss(ii,2))
        Echnk=E(:,idss(ii,1):idss(ii,2))
        p1=patch([Xchnk Xchnk(end:-1:1)],[Echnk(1,:) Echnk(2,end:-1:1)],ShadeColor);
        set(p1,'EdgeColor',ShadeColor,'FaceColor',ShadeColor);
    end
    
end


if length(LineColor)>1 && ~isnumeric(LineColor)
    p2=plot(X,Y,'Color',LineColor(1),'LineWidth',lw);
    set(p2,'linestyle',LineColor(2:end))
else
    p2=plot(X,Y,'Color',LineColor,'LineWidth',lw);
end

if nargout == 1
    varargout{1} = [p1 p2];
end
