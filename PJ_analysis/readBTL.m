function readBTL(fpath,inputfiles,outputfile)
%% written by PJ.
%date: 2015 May 20
% save many 'btl' files from CTD data into one 'txt' file
%fpath: path of input files
%inputfiles: names of input files in the form of cell array.
%outputfile: output file name ; ex) outputfile='btl_total.txt'.

filename=inputfiles;
fffname=outputfile;
fidf=fopen(fffname,'w+');
for ii=1:length(filename)

fname=[filename{ii}]; ffname=['s' fname]; prid=find(ffname=='.');ffname(prid)='_';
fid=fopen([fpath fname]);
ln=fgetl(fid);
hl=1;hn=1
% for ii=1:30
% ln=fgetl(fid);
% end

while 1
    if strcmp(ln(1),'*')+strcmp(ln(1),'#')==0 ,break,   end
ln=fgetl(fid);
end
lnt=ln;
ln=fgetl(fid);
ln=fgetl(fid);

while 1
datum=strread([ln(1:8) ln(25:end-6)]);datumm=(ln(1:24));
ln=fgetl(fid);
eval([ffname '(hn,:)=datum;']); %read data part
eval([ffname 'date(hn,:)=datumm;']); %read date part
ttinf=ln(15:22);
eval([ffname '_t(hn,:)=ttinf;']); % read time part
hn=hn+1;
ln=fgetl(fid);

if ln==-1 , break, end
end


eval(['data=' ffname]);
format='%10.5f'
number=length(data(1,:));

formatt=[' ' format];
l=length(formatt);

formats=format;
for kk=1:number-1;
   formats(end+1:end+l)=formatt;
end
lnt(12:22)=[];

formats(end+1:end+2)='\n';
fprintf(fidf,'\n\n%s\n',fname) ;
fprintf(fidf,'%s\n',lnt) ;
fprintf(fidf,formats,data') ;


fclose(fid)

end

    fclose(fidf);
