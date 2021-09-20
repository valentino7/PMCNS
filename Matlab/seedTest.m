function seedTest()
clc;
%%Apro la cartella seed
dinfo = dir(fullfile('seeds'));
dinfo([dinfo.isdir]) = [];     %get rid of all directories including . and ..
nfiles = length(dinfo);

%inizializzo la matrice di celle
dataset = cell(nfiles,1);
labels = strings(nfiles,1);

%importo i files dei seeds
for j = 1 : nfiles
    filename = fullfile('seeds', dinfo(j).name);
    
    dataset{j,1} = dinfo(j).name; %concatena il nome del file
    dataset{j,2} = importfileSeed(filename); %concatena i valori del file
end
disp(dataset);


%%Il "test del ChiQuadro" è un test parametrico che valuta l'uguaglianza
%di varie categorie ed è implementato come test di ipotesi in crosstab
for h=1:nfiles
    
    name = dataset{h,1};
    figure('Name',name);
    histogram(dataset{h,2});
    [N,edges] = histcounts(dataset{h,2});
    bins = length(N);
    %%TEST ONLINE
    disp("il seme "+ dataset{h,1} + " ha prodotto i seguenti risulati:");
    chi2test ( dataset{h,2}', bins);
end

    fprintf('\n\n');
%%
for h=1:nfiles
    
    [N,edges] = histcounts(dataset{h,2});
    p = length(dataset{h,2})/length(N); 
    chi_test = 0;
    for i = 1:length(N)
        chi_test = chi_test +( ( ( N(i)-p)^2 ) /p);
    end
    x = chi2inv(0.90,length(N)-1);
    string = erase( dataset{h,1}, "Stream");
    string = erase( string, ".csv");
    labels(h,1) = string;
    
    fprintf('seme: %s, chi_test: %f, chi_quadro:%f \n', string, chi_test, x );
    
end

%%
%%Il "Wilcoxon rank sum Test" è un test non parametrico che valuta l'indipendenza di due samples
results_h = zeros(nfiles, nfiles);
results_p = zeros(nfiles, nfiles);


for i=1: nfiles
    for j=1: nfiles
        [p,h,stats] = ranksum(dataset{i,2},dataset{j,2});
        results_h(i,j) = h;
        results_p(i,j) = p;
        
       % if (p==1)
        %    fprintf("I due dataset %s e %s sono identici\n infatti hanno una accuratezza del %f.\n\n",dataset{i,1}, dataset{j,1}, p);
       % else
       %     if(h==0)
       %         fprintf("I due dataset %s e %s sono indipendenti e identicamente distribuiti con uguale media\n con una accuratezza del %f.\n\n",dataset{i,1}, dataset{j,1}, p);
       %     else
       %         fprintf("I due dataset %s e %s NON sono indipendenti e identicamente distribuiti.\n\n", dataset{i,1},dataset{j,1});
       %     end
       % end
    end
end

    temp = cellstr( labels');
    %crea i risultati come tabelle e li stampa su file .xlsx
    T_h = array2table(results_h, 'VariableNames',temp);
    T_h = addvars(T_h, temp','Before', labels(1), 'NewVariableNames', 'Seeds');
  
    T_p = array2table(results_p, 'VariableNames',temp);
    T_p = addvars(T_p, temp','Before', labels(1), 'NewVariableNames', 'Seeds');
   
    disp(T_p);
    disp(T_h);
    filename = 'Seedranksum.xlsx';
    writetable(T_h, filename,'Sheet',1)
    writetable(T_p,filename,'Sheet',2)
    
    
end



%Chi-Square Test =
%                       490
%Critical Value =
%          552.074742731856
% n = 5000
% k = 500
% n/k = 10
%Since 490 < 552, We accept the null hypothesis H_0 and conclude
%that we don't have enough evidence at level alpha = 0.05 to say that
%the observation are not uniform.
function chi2test(data, num_int)
[m,n] = size(data);

E = m/num_int; %binning
interval=zeros(num_int, 1);
for i=1:m
    k = data(i,1);
    interval(fi(num_int,k),1) = interval(fi(num_int,k),1) +1;
end
x = 0;
for j= 1:num_int
    x=x+ (interval(j,1)-E)^2/E;
end
h = chi2inv(0.95,num_int-1);

fprintf('x_value:%f con valore di ChiQuadro:%f\n\n',x,h);
end
function b = fi(i,n)
for j= 0:i
    if n > (1/i)*(i-j)
        b = i-j+1;
        break
    end
end

end

%Import del file
function SeedStream = importfileSeed(filename, startRow, endRow)


% Initialize variables.
delimiter = ';';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

formatSpec = '%f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
end

% Close the text file.
fclose(fileID);

% Create output variable
SeedStream = [dataArray{1:end-1}];
end


