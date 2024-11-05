% clc
clear
% Create a Satellite Scenario
startTime = datetime(2023,10,15,3,0,0);
stopTime = startTime + hours(12);
% the simulation sample time to 30 second
sampleTime = 1;%?
sc = satelliteScenario(startTime,stopTime,sampleTime);
%the mean orbital parameters of 40 generic satellites in nearly circular
%LEO at an altitude and inclination of approximately 500 km and 55 degrees respectively.
% tleFile = "geo4_twosystems.tle";
tleFile = "geo5_twosystems.tle";
% tleFile = "geo5_ig.tle";
% tleFile = "oneweb_starlink.tle";
% tleFile = "starlink.tle";
% tleFile = "oneweb.tle";%631
sat = satellite(sc,tleFile);
% sat=sat(5:20);
% for i=1:length(sat)
%     sat(i).MarkerColor="#8ECFC9";
%     sat(i).MarkerSize=6;
% end
% for i=1:5
%     sat(i).MarkerColor="#8ECFC9";
%     sat(i).MarkerSize=16;
% end
% for i=6:78
%     sat(i).MarkerColor="#536DFE";
%     sat(i).MarkerSize=8;
% end
% for i=79:length(sat)
%     sat(i).MarkerColor="#00BCD4";
%     sat(i).MarkerSize=8;
% end

names = sat.Name + " Camera";
v = satelliteScenarioViewer(sc,"ShowDetails",false);
cam = conicalSensor(sat,"Name",names,"MaxViewAngle",80);
%% gs
gs_pos=[118,32;114,32;116,28;120,36;120,30;...
    40 75;4 12;109 22;-32 -75;-114 -40];
% num_gs=10;
for i=1:5
    name=sprintf("Groundstation %d",i);
    minElevationAngle = 40; 
    gsta(i)= groundStation(sc,gs_pos(i,2),gs_pos(i,1), ...
        "Name",name);%, "MinElevationAngle",minElevationAngle
    % Properties of access analysis objects
    [a,~]=latency(sat,gsta(i),startTime);
    m=intersect(find(a<0.005),find(a.^2>0));
    access(sat(m),gsta(i));%(1:length(sat))
end
leosat=sat;
% a=latency(sat(1),sat(2),startTime)
% latency(sat,gsta(3),startTime)
% startTime = datetime(2023,10,15,9,0,6);
% a=latency(sat,gsta(1),startTime);
% min(a)
% a=latency(gsta,sat,startTime)
% leosat=sat(6:length(sat));
% sat(4).ShowLabel = true;
% gsta.ShowLabel = true;
% show(sat(4));
save sate_scenerio0902.mat
