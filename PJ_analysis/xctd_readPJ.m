function xctd=xctd_readPJ(fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read XCTD data *.edf file   2019 oct 21
% inputfile
% fname: file name *.edf

%output
% xctd.depth: depth [m]
% xctd.temp: temperature [^oC]
% xctd.cond: conductivity [mS/cm]
% xctd.sal: salinity [ppt]
% xctd.den: density [kg m^-3]
% xctd.lat: latitude [^oN] 
% xctd.lon: longitude [^oE]  
% xctd.time: time vec

% see also xctd_processPJ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
header={'depth','temp','cond','sal','den'};
hlines1=15 % for read time information
xid=[ 3 4 5 6 8];
fid=fopen([fname])
%read deploy time
for jj=1:hlines1
    l=fgetl(fid);
end
l=fgetl(fid);
ymd=[str2num(l(27:30)) str2num(l(21:22)) str2num(l(24:25)) ];
l=fgetl(fid);
hms=[str2num(l(21:22)) str2num(l(24:25)) str2num(l(27:28)) ];
timesx=[ymd hms];
l=fgetl(fid); l=fgetl(fid);
latx=[str2num(l(19:22))+ str2num(l(23:31))/60]
l=fgetl(fid);
lonx=[str2num(l(19:23))+ str2num(l(24:31))/60]
fclose(fid);

%load data
filename = [fname];
delimiter = {'\t',' '};
startRow = 50;
formatSpec = '%f%C%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec,...
    'Delimiter', delimiter, 'MultipleDelimsAsOne', true, ...
    'TextType', 'string', 'EmptyValue', NaN,...
    'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

for jj=1:length(header)
    eval(['xctd.' header{jj} '(1:length(dataArray{1,1}),1)=dataArray{1,xid(jj)};'])
end
xctd.lat=latx;xctd.lon=lonx;
xctd.time=datevec(datenum(timesx)+dataArray{1,xid(jj)}/24/60/60);



% remove errorvalue
for jj=1:length(header)
    eval(['xctd.' header{jj} '( xctd.' header{jj} ' == -99 )=nan;'])
end

end