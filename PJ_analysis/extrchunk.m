function id=extrchunk(Y)
% extract value chunk index (excluding nan) 
 %by JHPARK. 
% date: 2013 Nov 13
%input
% Y: data
%output
% id:N X 2 matrix, extract N-chunk (startid,endid)




% Y=[1 nan 3 nan nan nan 3 5 6 nan nan 10 10]
Y=Y(:)';
yn=[nan Y nan];
% [NaN,1,NaN,3,NaN,NaN,NaN,3,5,6,NaN,NaN,10,10,NaN]
id=find(isnan(Y));
% [2,4,5,6,10,11]
  ids=+~isnan(yn);
% [0,1,0,1,0,0,0,1,1,1,0,0,1,1,0]

dids=  diff(ids);
  sid=find(dids==1)+1;
  eid=find(dids==-1);
 id=[sid(:)-1 eid(:)-1];



