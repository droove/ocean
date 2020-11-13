function h=pcolorPJ(x,y,z);
%written by J.-H. Park
%2017 Nov 7
% imagesc like pcolor
% x & y  is a vector not matrix grid
xl=length(x);yl=length(y);

xmp=(x(2:xl)+x(1:xl-1))/2;
xp(1)=x(1)-(x(2)-x(1))/2;
xp(2:xl)=xmp; 
xp(xl+1)=x(xl)+(x(xl)-x(xl-1))/2;
ymp=(y(2:yl)+y(1:yl-1))/2;
yp(1)=y(1)-(y(2)-y(1))/2;
yp(2:yl)=ymp; 
yp(yl+1)=y(yl)+(y(yl)-y(yl-1))/2;

zp=z; zp(yl+1,:)=z(yl,:); zp(:,xl+1)=zp(:,xl);
h=pcolor(xp,yp,zp); shading flat

end
% % test
% x=[1 2 3];
% y=[1 2 ]
% z=[5 6 7; 8 9 10];
% figure
% pcolor(x,y,z);
% figure
% pcolorPJ(x,y,z);