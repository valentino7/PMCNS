function [] = intervalloConfidenza()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Alg1 = importIntervalConfidence('./transient/IntervalloConfidenzaAlg2.csv', 2);
stop= [2.0,4.0,6.0,8.0,10.0,20.0,40.0,60.0,80.0,100.0];

means= 1:length(stop);
errors= 1:length(stop);

for i = 1:length(stop)
    %serverfarmt
    AlgFiltered=Alg1(Alg1.stop==stop(i),:);
    SEM = std(AlgFiltered.system)/sqrt(length(AlgFiltered.serverfarmt));               % Standard Error
    ts = tinv([0.025  0.975],length(AlgFiltered.serverfarmt)-1);      % T-Score
    ci = mean(AlgFiltered.serverfarmt) + ts*SEM;                      % Confidence Intervals
   
    means(i)=mean(AlgFiltered.serverfarmt);
    errors(i)=abs(ci(1)-ci(2));
end
xlim([0 110])
ylim([0.5 6.0])
yline(1.138);
hold on
errorbar(stop,means,errors,'rx');


%%

%calcolo manuale
SEM = std(V)/sqrt(length(V));               % Standard Error

ts = norminv([0.025  0.975]);               % Z-Score, passo l'intervallo di probabilità in cui
                                            %l'intervallo di confidenza per
                                            %la media
                                            %deve essere contenuto
                                            
CI = mean(V) + ts*SEM                       % Confidence Intervals

%%

 %%

Alg2 = importIntervalConfidence('IntervalloConfidenza215487963_Alg2.csv', 3);
stop = [100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,900.0,1000.0,1100.0,1200.0,1300.0,1400.0,1500.0,1600.0];

means = 1:length(stop);
errors = 1:length(stop);



for i = 1:length(stop)
    AlgFiltered=Alg2(Alg2.stop==stop(i),:);
    %genera intervallo di confidenza ci = [x-intervallo; x+intevallo] 
    [~,~,ci,~] = ztest(AlgFiltered.system,mean(AlgFiltered.system),std(AlgFiltered.system),0.05,0);
    
    means(i) = mean(AlgFiltered.system);
    errors(i) = abs(ci(1)-ci(2));
    
end

%plot degli intervalli di confidenza e della retta == media
figure;
xlim([0 1800])
ylim([1.45 1.85])
yline(Rtot,'blue'); %plotting della media teorica
hold on
errorbar(stop,means,errors,'ro');  %plotting degli intervalli

%%

%%

Alg1 = importIntervalConfidence('IntervalloConfidenza215487963_Alg1.csv', 3);
stop = [1.0,2.0,3.0,4.0,5.0,10.0,20.0,30.0,40.0,50.0,100.0,200.0,300.0,400.0,500.0];

means = 1:length(stop);
errors = 1:length(stop);



for i = 1:length(stop)
    AlgFiltered=Alg1(Alg1.stop==stop(i),:);
    %genera intervallo di confidenza ci = [x-intervallo; x+intevallo] 
    [~,~,ci,~] = ztest(AlgFiltered.system,mean(AlgFiltered.system),std(AlgFiltered.system),0.05,0);
    
    means(i) = mean(AlgFiltered.system);
    errors(i) = abs(ci(1)-ci(2));
    
end

%plot degli intervalli di confidenza e della retta == media
figure;
xlim([0 1800])
ylim([1.45 1.85])
yline(1.664,'blue'); %plotting della media teorica
hold on
errorbar(stop,means,errors,'ro');  %plotting degli intervalli

%%
d=dir("./batch");
s=size(d);
means = 1:s(1)-2;
errors = 1:s(1)-2;
j=1:s(1)-2;
j(1)=3;
for i = 3:s(1)
    Alg1 = importBatch("./batch/"+convertCharsToStrings(d(i).name), 3);

    %genera intervallo di confidenza ci = [x-intervallo; x+intevallo] 
    [~,~,ci,~] = ztest(Alg1.system,mean(Alg1.system),std(Alg1.system),0.05,0);
    
    means(i-2) = mean(Alg1.system);
    errors(i-2) = abs(ci(1)-ci(2));
  
    j(i-2)=i;
end
%plot degli intervalli di confidenza e della retta == media
figure;
xlim([0 10])
ylim([1.65 1.68])

yline(Rtot,'blue'); %plotting della media teorica
hold on
errorbar(j,means,errors,'ro');  %plotting degli intervalli

end

