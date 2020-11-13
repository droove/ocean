function [ids,rid]=arr_time_subsample(jdst,jdtg,crtr)

%find indices of "jdtd" corresponding to "jdst"
% written by jhpark 2016 Jul 18

%%input
%jdst: datanum form of evenly spaced (standard) time vector
%jdtg: datanum form of observed time vector
%crtr: allowed maximum difference between "jdst" and "jdtg" whose dimension
%follows input time vector.

%%output
% ids: indices of "jdtd" corresponding to "jdst"
% rid: indices of "jdtd" which is passed the difference criteria "crtr"

%%usage
% datast=data(ids,:);
% datast(rid,:)=nan;
% [jdst' jdtg(ids) datast data(ids)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=1;
for at=1:length(jdst)
    
    id= max(near(jdst(at),jdtg));
    if abs(jdst(at)-jdtg(id))>=crtr;
        rid(h)=at;
        h=h+1;
    end
    ids(at)=id;
%     disp(at);
          disp([num2str(at) '/' num2str(length(jdst))])
end

end

