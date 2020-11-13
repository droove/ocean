function [dd header stime]=CNVreadMPJ(fpath, fname, apend)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CNVread Matrix version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by jhpark 2014 Apr 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %  input variables
% fpath: path of the file
% fname: name of the file
% apend: file name option ; apend='_1' then output variable('var') will be 'var_1'

% if you run this function properly, then all the variables in CNV file
% move into your workspace as a matix form

% see also, CNVreadPJ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3
    apend=''
end
fid=fopen([fpath fname]);
ln=fgetl(fid);
hl=1;hn=1
% for ii=1:30
% ln=fgetl(fid);
% end

while 1
    if  strcmp(ln,'*END*'),break,   end
    
    
    %variable header find
    if length(ln)>5 &  strcmp(ln(1:6),'# name')
        clid=find(ln==':'); % find conlon index
        elid=find(ln=='='); % find equal sign index
        lns=ln(elid+2:clid-1);
        delid=find(lns =='-' | lns =='/' | lns =='*' | lns =='=');% find not acceptable symbol index
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



%clear excepth selected variables

