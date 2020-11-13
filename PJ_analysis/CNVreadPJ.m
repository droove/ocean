function CNVreadPJ(fpath, fname, append)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by jhpark 2014 Apr 8
%
% %  input variables
% fpath: path of the file
% fname: name of the file
% apend: file name option ; apend='_1' then output variable('var') will be 'var_1'

% if you run this function properly, then all the variables in CNV file
% move into your workspace

% see also CNVreadMPJ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3
    append=''
end
fid=fopen([fpath fname]);
ln=fgetl(fid);
hl=1;hn=1
% for ii=1:30
% ln=fgetl(fid);
% end

while 1
    if strcmp(ln,'*END*'),break,   end
    
    
    %variable header find
    if length(ln)>5 & strcmp(ln(1:6),'# name')
        clid=find(ln==':'); % find conlon index
        elid=find(ln=='='); % find equal sign index
        lns=ln(elid+2:clid-1);
         %find unicode
        bbb=unicode2native(lns); % find unicode id
        unicid=find(ismember(bbb,63));%find unicode id
        if length(unicid)~=0
           bbbn= bbb(unicid+1:end);
           bbb=[bbb(1:unicid-1) 116 104 bbbn];
        end
        lns=native2unicode(bbb);
        delid=find(lns =='-' | lns =='/' | lns =='*' | lns =='=' | lns=='?');% find not acceptable symbol index
        if length( delid ) > 0
            lns(delid)='_';% changing 'not acceptable' symbol index
        end
        header{hn}=lns;
        hn=1+hn;
    end
    
    if length(ln)>6 & strcmp(ln(1:7),'# start')
    stime=ln(6:end);
    end
    ln=fgetl(fid);
    hl=hl+1;
end

fclose(fid)

dd=textread([fpath fname],'','headerlines',hl);

for ii=1:length(header)
    eval([header{ii} '=dd(:,ii);'])
end

%clear excepth selected variables
header{end+1}='stime';
header{end+1}='headers';
header{end+1}='append';
headers=header;
% clearex
a = evalin('base','who');
clearvar = a(~ismember(a,headers));
% assignin('base','ClEaRGsJioU',clearvar);

% evalin('base','clear(ClEaRGsJioU{:},''ClEaRGsJioU'')')

for ii=1:length(headers)-1
eval(['assignin(''base'',[headers{ii} append],' headers{ii} ');' ]);
end

% clear a clearvar headers