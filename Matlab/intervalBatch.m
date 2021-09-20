d=dir("/home/valentino/IdeaProjects/PMCSN/Matlab/Batch");
Alg1 = importBatch("./Batch/"+convertCharsToStrings(d(3).name), 3);
b=size(Alg1);
s=size(d);
means = 1:s(1)-2;
errors = 1:s(1)-2;
j=1:s(1)-2;
j(1)=3;
for i = 4:s(1)

    %genera intervallo di confidenza ci = [x-intervallo; x+intevallo] 
    [~,~,ci,~] = ztest(Alg1.system,mean(Alg1.system),std(Alg1.system),0.05,0);
    
    means(i-3) = mean(Alg1.system);
    errors(i-3) = abs(ci(1)-ci(2));
    if (i==6)
        break;
    end
    j(i-3)=i;
    Alg1 = importBatch("./Batch/"+convertCharsToStrings(d(i).name), 3);
end
%plot degli intervalli di confidenza e della retta == media
figure;
xlim([0 10])
ylim([1.65 1.68])

Rclet = s / 12.25; % serverfarmet
Rc = pq*(mAc+mBc)/2; % cloud
Rtot = Rclet+Rc; %sistema
yline(Rtot,'blue'); %plotting della media teorica
hold on
errorbar(j,means,errors,'ro');  %plotting degli intervalli



function intervalBatchProvaDiletta()
dinfo = dir(fullfile('batch'));
dinfo([dinfo.isdir]) = [];     %get rid of all directories including . and ..
nfiles = length(dinfo);

for x=1: nfiles
    %seleziono i files per il calcolo dell'intervallo di confidenza
    if( strfind(dinfo(x).name,'batchFile') == true )
        filename = fullfile('batch', dinfo(x).name);
        
        Alg1 = importBatch(filename);
             
        b=size(Alg1);
        s=size(d);
        means = 1:s(1)-2;
        errors = 1:s(1)-2;
        j=1:s(1)-2;
        j(1)=3;
        for i = 4:s(1)
            
            %genera intervallo di confidenza ci = [x-intervallo; x+intevallo]
            [~,~,ci,~] = ztest(Alg1.system,mean(Alg1.system),std(Alg1.system),0.05,0);
            
            means(i-3) = mean(Alg1.system);
            errors(i-3) = abs(ci(1)-ci(2));
            if (i==6)
                break;
            end
            j(i-3)=i;
            Alg1 = importBatch("./Batch/"+convertCharsToStrings(d(i).name), 3);
        end
        %plot degli intervalli di confidenza e della retta == media
        figure;
        xlim([0 10])
        ylim([1.65 1.68])
        
        Rclet = s / 12.25; % serverfarmet
        Rc = pq*(mAc+mBc)/2; % cloud
        Rtot = Rclet+Rc; %sistema
        yline(Rtot,'blue'); %plotting della media teorica
        hold on
        errorbar(j,means,errors,'ro');  %plotting degli intervalli
    end
end
end
