function IntervalloConfidenza215487963Alg1 = importIntervalConfidence(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   INTERVALLOCONFIDENZA215487963ALG1 = IMPORTFILE(FILENAME) Reads data
%   from text file FILENAME for the default selection.
%
%   INTERVALLOCONFIDENZA215487963ALG1 = IMPORTFILE(FILENAME, STARTROW,
%   ENDROW) Reads data from rows STARTROW through ENDROW of text file
%   FILENAME.
%
% Example:
%   IntervalloConfidenza215487963Alg1 = importfile('IntervalloConfidenza215487963_Alg1.csv', 2, 101);
%
%    See also TEXTSCAN.


%% Initialize variables.
delimiter = ';';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Replace non-numeric cells with 0.0
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {0.0}; % Replace non-numeric cells

%% Create output variable
IntervalloConfidenza215487963Alg1 = table;
IntervalloConfidenza215487963Alg1.seed = cell2mat(raw(:, 1));
IntervalloConfidenza215487963Alg1.stop = cell2mat(raw(:, 2));
IntervalloConfidenza215487963Alg1.serverfarm = cell2mat(raw(:, 3));
IntervalloConfidenza215487963Alg1.serverfarm_task1 = cell2mat(raw(:, 4));
IntervalloConfidenza215487963Alg1.serverfarm_task2 = cell2mat(raw(:, 5));
IntervalloConfidenza215487963Alg1.awsEc2 = cell2mat(raw(:, 6));
IntervalloConfidenza215487963Alg1.awsEc2_task1 = cell2mat(raw(:, 7));
IntervalloConfidenza215487963Alg1.awsEc2_task2 = cell2mat(raw(:, 8));
IntervalloConfidenza215487963Alg1.system = cell2mat(raw(:, 9));
IntervalloConfidenza215487963Alg1.system_task1 = cell2mat(raw(:, 10));
IntervalloConfidenza215487963Alg1.system_task2 = cell2mat(raw(:, 11));

