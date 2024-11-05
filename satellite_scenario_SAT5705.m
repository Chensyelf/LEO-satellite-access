%%

clear;
clc;
%打开STK软件
uiapplication = actxserver('STK9.application');
%打开操作场景
root = uiapplication.Personality2;
%加载场景，选择你路径下的sc文件
root.LoadScenario('C:\Users\admin\Documents\STK 9\Scenario3.sc');
sc = root.CurrentScenario;
%设置卫星编号，假设卫星初始编号为10000
ssc = 10000;
%c创建文件来存储tle数据
fid = fopen('TLEData_Starlink.tle','wt');
%获取所有卫星的路径
satpathcollection = root.ExecuteCommand('ShowNames * Class Satellite');
satpathcollection.Item(0);
%Item(0)中包含了卫星的所有路径，其为字符串类型
%中间用空格隔开，下面语句先将字符串切割，然后去除空格元素
%则satPaths的每个元素只包含一个卫星路径
satPaths = regexp(satpathcollection.Item(0),' ','split');
satPaths(cellfun(@isempty,satPaths)) = [];
%遍历路径，生成两行轨道根数tle数据，输出至文件中。
for i= 1:length(satPaths)
    sattemp = root.GetObjectFromPath(satPaths{i});
    start = sc.StartTime;
    cmd1 = ['GenerateTLE ',satPaths{i},' Point "',start,'" ', sprintf('%05.0f',ssc) , ' 20 0.01 SGP4 ', ' ',sattemp.InstanceName];
    root.ExecuteCommand(cmd1);
    satDP = sattemp.DataProviders.Item('TLE Summary Data').Exec();
    TLEData = satDP.DataSets.GetDataSetByName('TLE').GetValues;
    
    fprintf(fid,'%s\n%s\n',TLEData{1,1},TLEData{2,1});
    ssc= ssc + 1; 
end

%%
% clc
clear
% Create a Satellite Scenario
startTime = datetime(2023,10,15,2,0,0);
stopTime = startTime + hours(500);
sampleTime = 1;%?
sc = satelliteScenario(startTime,stopTime,sampleTime);

semiMajorAxis = 6978.14 * 1000*ones(1,36);
eccentricity = zeros(1,36);
inclination = zeros(1,36);
rightAscensionOfAscendingNode = zeros(1,36);
argumentOfPeriapsis = zeros(1,36);
trueAnomaly = [0:10:350];

sat = satellite(sc,semiMajorAxis,eccentricity,inclination, ...
    rightAscensionOfAscendingNode,argumentOfPeriapsis,trueAnomaly);

% tleFile = "SAT_single.tle";
% sat = satellite(sc,tleFile);
% % 11是+5，12是经度，13=+10，14=-10
% names = sat.Name + " Camera";
% v = satelliteScenarioViewer(sc,"ShowDetails",false);
% cam = conicalSensor(sat,"Name",names,"MaxViewAngle",80);
% gs
gs_pos=[15,0];
% num_gs=10;
name=sprintf("Groundstation %d",1);
minElevationAngle = 40;
gsta= groundStation(sc,gs_pos(1,2),gs_pos(1,1), ...
    "Name",name);%, "MinElevationAngle",minElevationAngle
% Properties of access analysis objects
access(sat,gsta);%(1:length(sat))

save satelliteforverify_36.mat