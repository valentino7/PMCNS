function generateIntervalPlot()

request = input('1=transiente; 2=batch: ');
if(request == 1)
    mainDir = 'transient';
elseif(request == 2)
    mainDir = 'batch';
end

%apro la cartella principale
dinfo = dir(fullfile(mainDir));
subdir = dinfo([dinfo.isdir]);
subdir(1:2) = [];%get rid of all directories including . and ..

request1 = input("Algoritmo (1/2):  ");
if(request1 == 1)
    %apro la sotto cartella per algoritmo
    newDir = strcat(mainDir ,'/', subdir(1).name);
else
    newDir = strcat(mainDir ,'/', subdir(2).name);
end
estimateDir = dir(fullfile(newDir));
estimateDir(1:2) = [];
numDIR = length(estimateDir);

for b=1:numDIR
    newDir2 = strcat(newDir, '/', estimateDir(b).name);
    localDir = dir(newDir2);
    localDir([localDir.isdir]) = [];
   
    if(~isempty(localDir))
        
        nva = length(localDir); %numero di file attesi
        
        serverfarm = zeros(nva,2);
        serverfarm_task1 = zeros(nva,2);
        serverfarm_task2 = zeros(nva,2);
        
        awsEc2 = zeros(nva,2);
        awsEc2_task1 = zeros(nva,2);
        awsEc2_task2 = zeros(nva,2);
        
        system = zeros(nva,2);
        system_task1 = zeros(nva,2);
        system_task2 = zeros(nva,2);
        
        
        directory = strcat(newDir2,'/');
        if(request1 == 1)
            elaborateFile(localDir,nva,'Alg1',directory,serverfarm,serverfarm_task1,serverfarm_task2,awsEc2,awsEc2_task1,awsEc2_task2,system,system_task1,system_task2)
        elseif(request1 == 2)
            elaborateFile(localDir,nva,'Alg2',directory,serverfarm,serverfarm_task1,serverfarm_task2,awsEc2,awsEc2_task1,awsEc2_task2,system,system_task1,system_task2)
        end
    end
end


end

function elaborateFile(dinfo,nva,type,directory,serverfarm,serverfarm_task1,serverfarm_task2,awsEc2,awsEc2_task1,awsEc2_task2,system,system_task1,system_task2)
labels = strings(nva,1);

j=1;
for i=1:nva
    %seleziono i files per il calcolo dell'intervallo di confidenza
    if( strfind(dinfo(i).name, 'estimate')==1)
        if ( contains(dinfo(i).name,type) )
            filename = fullfile(directory, dinfo(i).name);
            
            temp = importIntervalText(filename);
            labels(j) = dinfo(i).name;
            
            format long
            %serverfarm
            serverfarm(j,1) = str2double(temp.serverfarm);
            serverfarm(j,2) = str2double(temp.VarName2);
            
            serverfarm_task1(j,1) = str2double(temp.serverfarm_task1);
            serverfarm_task1(j,2) = str2double(temp.VarName4);
            
            serverfarm_task2(j,1) = str2double(temp.serverfarm_task2);
            serverfarm_task2(j,2)= str2double(temp.VarName6);
            
            %awsEc2
            awsEc2(j,1) = str2double(temp.awsEc2);
            awsEc2(j,2) = str2double(temp.VarName8);
            
            awsEc2_task1(j,1) = str2double(temp.awsEc2_task1);
            awsEc2_task1(j,2) = str2double(temp.VarName10);
            
            awsEc2_task2(j,1) = str2double(temp.awsEc2_task2);
            awsEc2_task2(j,2) = str2double(temp.VarName12);
            
            %system
            system(j,1) = str2double(temp.system);
            system(j,2) = str2double(temp.VarName14);
            
            system_task1(j,1) = str2double(temp.system_task1);
            system_task1(j,2) = str2double(temp.VarName16);
            
            system_task2(j,1) = str2double(temp.system_task2);
            system_task2(j,2) = str2double(temp.VarName18);
            j=j+1;
        end
    end
end

labels
X=1:nva;
%% PLOT serverfarm
stamp = figure('Name','ServerFarm');
errorbar(X, serverfarm(:,1), serverfarm(:,2), 'blackx');xlim([0,j]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(6.013618, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg1/ServerFarm_time.png';
    elseif ( strcmp( type,'Alg2') )
        yline(5.450564, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg2/ServerFarm_time.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "ServerFarm";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del ServerFarm');
    saveas(stamp,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(9.205360, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg1/ServerFarm_Num.png';
    elseif ( strcmp( type,'Alg2') )
        yline(8.410705, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg2/ServerFarm_Num.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "ServerFarm";
    ylabel('E[N] (pck)');
    title('Numero medio di task del ServerFarm');
    saveas(stamp,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(1.530752, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg1/ServerFarm_Throughput.png';
    elseif ( strcmp( type,'Alg2') )
        yline(1.543089, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/ServerFarm_Throughput.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "ServerFarm";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del ServerFarm');
    saveas(stamp,path);
end

%% PLOT serverfarm_TASK1
stamp1 = figure('Name','ServerFarm_task1');
errorbar(X, serverfarm_task1(:,1), serverfarm_task1(:,2), 'blackx');xlim([0,j]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(5.081503, 'Color', 'red', 'LineStyle','-');
        path = 'figure/Alg1/ServerFarm_time_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(4.996777, 'Color', 'red', 'LineStyle','-');
        path = 'figure/Alg2/ServerFarm_time_task1.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "ServerFarm TASK1";
    ylabel('Tempo medio di risposta (s)');
    title('Tempo medio di risposta del ServerFarm TASK1');
    saveas(stamp1,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(3.556273, 'Color', 'red', 'LineStyle','-');
        path = 'figure/Alg1/ServerFarm_Num_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(5.856180, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg2/ServerFarm_Num_task1.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "ServerFarm TASK1";
    ylabel('E[N] (pck)');
    title('Numero medio di task del ServerFarm TASK1');
    saveas(stamp1,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(0.699847, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg1/ServerFarm_Throughput_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(1.171992, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg2/ServerFarm_Throughput_task1.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "ServerFarm TASK1";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del ServerFarm TASK1');
    saveas(stamp1,path);
end


%% PLOT serverfarm_TASK2
stamp2 = figure('Name','ServerFarm_task2');
errorbar(X, serverfarm_task2(:,1), serverfarm_task2(:,2), 'blackx');xlim([0,j+1]);

if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(6.798710, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg1/ServerFarm_time_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(6.883705, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg2/ServerFarm_time_task2.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "ServerFarm TASK2";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del ServerFarm TASK2');
    saveas(stamp2,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(5.649088, 'Color', 'red', 'LineStyle','-');
        path = 'figure/Alg1/ServerFarm_Num_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(2.554525, 'Color', 'red', 'LineStyle','-');
        path = 'figure/Alg2/ServerFarm_Num_task2.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "ServerFarm TASK2";
    ylabel('E[N] (pck)');
    title('Numero medio di task del ServerFarm TASK2');
    saveas(stamp2,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(0.830906, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg1/ServerFarm_Throughput_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(0.371097, 'Color', 'red', 'LineStyle','-');
        path ='figure/Alg2/ServerFarm_Throughput_task2.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "ServerFarm TASK2";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del ServerFarm TASK2');
    saveas(stamp2,path);
end

%% PLOT awsEc2
stamp3 = figure('Name','AWS EC2');
errorbar(X, awsEc2(:,1), awsEc2(:,2), 'blackx');xlim([0,j+1]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(10.801888, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/AWS_EC2_time.png';
    elseif ( strcmp( type,'Alg2') )
        yline(11.846576, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/AWS_EC2_time.png';
    end
     lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "AWS EC2";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del AWS EC2');
    saveas(stamp3,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(18.856097, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/AWS_EC2_Num.png';
    elseif ( strcmp( type,'Alg2') )
        yline(20.995535, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/AWS_EC2_Num.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "AWS EC2";
    ylabel('E[N] (pck)');
    title('Numero medio di task del AWS EC2');
    saveas(stamp3,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(1.745630, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg1/AWS_EC2_Throughput.png';
    elseif ( strcmp( type,'Alg2') )
        yline(1.772287, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg2/AWS_EC2_Throughput.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "AWS EC2";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del AWS EC2');
    saveas(stamp3,path);
    
end

%% PLOT awsEc2_TASK1

stamp4 =figure('Name','AWS EC2 task1');
errorbar(X, awsEc2_task1(:,1), awsEc2_task1(:,2), 'blackx');xlim([0,j+1]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(8.869746, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/AWS_EC2_time_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(9.147448, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg2/AWS_EC2_time_task1.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "awsEc2 TASK1";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del AWS EC2 TASK1');
    saveas(stamp4,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(7.021626, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg1/AWS_EC2_Num_task1.png' ;
    elseif ( strcmp( type,'Alg2') )
        yline(3.021380, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg2/AWS_EC2_Num_task1.png' ;
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "AWS EC2 TASK1";
    ylabel('E[N] (pck)');
    title('Numero medio di task del AWS EC2 TASK1');
    saveas(stamp4,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(0.791638, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg1/AWS_EC2_Throughput_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(0.330298, 'Color', 'red', 'LineStyle','-'); %media
        path = 'figure/Alg2/AWS_EC2_Throughput_task1.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "AWS EC2 TASK1";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del AWS EC2 TASK1');
    saveas(stamp4,path);
end

%% PLOT awsEc2_TASK2
stamp5 = figure('Name','AWS EC2_task2');
errorbar(X, awsEc2_task2(:,1), awsEc2_task2(:,2), 'blackx');xlim([0,j+1]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(12.405211, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/AWS_EC2_time_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(12.464829, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/AWS_EC2_time_task2.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "AWS EC2 TASK2";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del AWS EC2 TASK2');
    saveas(stamp5,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(11.834471, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/AWS_EC2_Num_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(17.974154, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/AWS_EC2_Num_task2.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "AWS EC2 TASK2";
    ylabel('E[N] (pck)');
    title('Numero medio di task del AWS EC2 TASK2');
    saveas(stamp5,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(0.953992, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/AWS_EC2_Throughput_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(1.441990, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/AWS_EC2_Throughput_task2.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "AWS EC2 TASK2";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del AWS EC2 TASK2');
    saveas(stamp5,path);
    
end

%% PLOT SYSTEM
stamp6 = figure('Name','System');
errorbar(X, system(:,1), system(:,2), 'blackx');xlim([0,j+1]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(8.564847, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_time.png';
    elseif ( strcmp( type,'Alg2') )
        yline(8.869654, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_time.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "SYSTEM";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del SYSTEM');
    saveas(stamp6,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(28.061457, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_Num.png';
    elseif ( strcmp( type,'Alg2') )
        yline(29.406240, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_Num.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "SYSTEM";
    ylabel('E[N] (pck)');
    title('Numero medio di task del SYSTEM');
    saveas(stamp6,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(3.2762824656781624, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_Throughput.png';
    elseif ( strcmp( type,'Alg2') )
        yline(3.3153760773568064, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_Throughput.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "SYSTEM";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del SYSTEM');
    saveas(stamp6,path);
end

%% PLOT SYSTEM_TASK1

stamp7 = figure('Name','System_task1');
errorbar(X, system_task1(:,1), system_task1(:,2), 'blackx');xlim([0,j+1]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(6.458779, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_time_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(5.589530, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_time_task1.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "SYSTEM TASK1";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del SYSTEM TASK1');
    saveas(stamp7,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(10.577899, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_num_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(8.877561, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_num_task1.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "SYSTEM TASK1";
    ylabel('E[N] (pck)');
    title('Numero medio di task del SYSTEM TASK1');
    saveas(stamp7,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(1.4914844127056763, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_Throughput_task1.png';
    elseif ( strcmp( type,'Alg2') )
        yline(1.5022891599846564, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_Throughput_task1.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "SYSTEM TASK1";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del SYSTEM TASK1');
    saveas(stamp7,path);
end

%% PLOT SYSTEM_TASK2
stamp8 = figure('Name','System_task2');
errorbar(X, system_task2(:,1), system_task2(:,2), 'blackx');xlim([0,j+1]);
if(contains(directory,'Tempi') )
    if ( strcmp( type,'Alg1') )
        yline(10.670105, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_time_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(11.935297, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_time_task2.png';
    end
    lgd=legend('tempi medi simulati', 'tempo medio teorico');
    lgd.Title.String = "SYSTEM TASK2";
    ylabel('E[Ts]');
    title('Tempo medio di risposta del SYSTEM TASK2');
    saveas(stamp8,path);
    
elseif(contains(directory,'Task'))
    if ( strcmp( type,'Alg1') )
        yline(17.483558, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_num_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(20.528679, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_num_task2.png';
    end
    lgd=legend('numero di task', 'numero medio teorico');
    lgd.Title.String = "SYSTEM TASK2";
    ylabel('E[N] (pck)');
    title('Numero medio di task del SYSTEM TASK2');
    saveas(stamp8,path);
    
elseif(contains(directory,'Throughput'))
    if ( strcmp( type,'Alg1') )
        yline(1.7848977178179724, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg1/System_Throughput_task2.png';
    elseif ( strcmp( type,'Alg2') )
        yline(1.8130869173721498, 'Color', 'red', 'LineStyle','-'); %media
        path ='figure/Alg2/System_Throughput_task2.png';
    end
    lgd=legend('Throughput medio', 'Throughput teorico');
    lgd.Title.String = "SYSTEM TASK2";
    ylabel('Throughput medio (pck/s)');
    title('Throughput medio del SYSTEM TASK2');
    saveas(stamp8,path);
end



end


%%Import file
function text = importIntervalText(filename, startRow, endRow)
% Initialize variables.
delimiter = ';';
if nargin<=2
    startRow = 2;
    endRow = inf;
end
% Format for each line of text:
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');
% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end
% Close the text file.
fclose(fileID);

% Create output variable
text = table(dataArray{1:end-1}, 'VariableNames', {'serverfarm','VarName2','serverfarm_task1','VarName4','serverfarm_task2','VarName6','awsEc2','VarName8','awsEc2_task1','VarName10','awsEc2_task2','VarName12','system','VarName14','system_task1','VarName16','system_task2','VarName18'});
end

