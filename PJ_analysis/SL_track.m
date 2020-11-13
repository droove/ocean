function [Lon Lat t SLA Track Didx]=SL_track(filename);

%This is a Function for reading Aviso alongtrack altimeter data.(dt_ref_global_en_sla_vxxc*.nc) 
% other type of along track data may can be read using this function.
%Lon: Longitude
%Lat: Latitude
%t : time (datenum format in matlab)
%SLA : Sea Level Anomaly
%Track : Track number
%Didx : point index with respect to track

t0=datenum([1950 1 1 0 0 0]);


  dT=ncread([filename],'DeltaT');        %DeltaT([]), shape = [1] "Time gap between two measurements in mean profile" 	DeltaT:units = "s"  DeltaT:scale_factor = 1e-006
    
    
    Trcs=ncread(filename,'Tracks');                %Tracks(Tracks), shape = [155]  "Pass number"
    Pnt=ncread([filename],'NbPoints');         %NbPoints(Tracks), shape = [155] "Number of measurements for each pass"
    Cycles=ncread([filename],'Cycles'); % I think this var. is not necessary    Cycles(Tracks,Cycles), shape = [155 1] "Cycle numbers for each pass"
    Lon=ncread([filename],'Longitudes');      % Longitudes(Data), shape = [235869] "Longitude of each measurement"  	Longitudes:scale_factor = 1e-006
    Lat=ncread([filename],'Latitudes');            % Latitudes(Data), shape = [235869] "Latitude of each measurement"  	Latitudes:scale_factor = 1e-006
    Bdates=ncread([filename],'BeginDates');           %"days since 1950-01-01 00:00:00.000 UTC" BeginDates:C_format = "%17.11f"
    Didx=ncread([filename],'DataIndexes');         % DataIndexes(Data), shape = [235869]  "Data index in theoretical pass"
    SLA=ncread([filename],'SLA');                  %SLA(Data,Cycles), shape = [235869 1] "Sea Level Anomaly"  	SLA:scale_factor = 0.001
  headersss={'Trcs' 'Pnt' 'Cycles' 'Lon' 'Lat' 'Bdates' 'Didx' 'SLA'};
  for kk=1:length(headersss)
      eval([headersss{kk} '=' headersss{kk} '(:);'])
  end
     % index  range at each track
    eid=cumsum(Pnt)';
    sid=[1 eid(1:end-1)+1];
    t=[]; Track=[];%SLA=[];Didx=[]; Tracks=[]; lon=[]; lat=[];
    for jj=1:length(Bdates);
        idx=Didx(sid(jj):eid(jj));
        t_=t0+Bdates(jj)+( idx- idx(1) ) *dT/86400;% dimension : day!
        t=[t; t_];
Track=[Track; ((sid(jj):eid(jj))*0+Trcs(jj))'];
    end
    %SLA=[SLA; SLAd];Didx=[Didx; Dindx]; lon=[lon; Lon]; lat=[lat; Lat];%Tracks=[Tracks; Trcs]
end