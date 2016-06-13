function [a,b,c,d,e,f,g,h,i,j] = Autoread_Flashing(mouse, dr, trainPeriod)
% Reads and creates arrays from data sets

% Variables
upperBound = 550;
lowerBound = 150;
scalar = 100;

% Change Directory to find Raw Data
cd(dr);
allDays = dir([dr 'data-i' mouse '-*']);

%Initialize struct
day(trainPeriod).trialOutcomeCell = 0;
dayIx(trainPeriod).correctIx = 0;
dayIx(trainPeriod).earlyIx = 0;
dayIx(trainPeriod).missIx = 0;
dayIx(trainPeriod).reqHoldTimeIx = 0;
dayIx(trainPeriod).reactWindowIx = 0;
dayIx(trainPeriod).medianReactTimeCorrectIx = 0;
dayIx(trainPeriod).medianReactTimeEarlyIx = 0;
dayIx(trainPeriod).scaledVarReactTimeCorrectIx = 0;
dayIx(trainPeriod).scaledVarReactTimeEarlyIx = 0;
dayIx(trainPeriod).pUpperIx = 0;
dayIx(trainPeriod).pLowerIx = 0;
dayIx(trainPeriod).diffIx = 0;
dayIx(trainPeriod).correctRateIx = 0;
dayIx(trainPeriod).earlyRateIx = 0;
dayIx(trainPeriod).missRateIx = 0;
% Initialize Output Arrays 
dataFiles = {};
medianReactTimeCorrect = {};
medianReactTimeEarly = {};
scaledVarReactTimeCorrect = {};
scaledVarReactTimeEarly = {};
cdf_pUpper = {};
cdf_pLower = {};
cdfDiff = {};
correctRate = {};
earlyRate = {};
missRate = {};

out = sprintf('i%s function is loading data...', mouse);
disp(out)
% Determines files to pull from
for i = 1:trainPeriod
    %i
    load(allDays(i).name);
       if isempty(dataFiles)
        dataFiles = {[allDays(i).name]};
       else
        daysCount = length(dataFiles);
        dataFiles = vertcat(dataFiles(1:daysCount,1), allDays(i).name);
       end
end
out = sprintf('i%s loading complete', mouse);
disp(out)

%Variables for Counting
totalDays = length(dataFiles);

out = sprintf('i%s calculating...', mouse);
disp(out)
% Pulls data from files
for k = 1:totalDays
    %k
    % Load File
    load(char(dataFiles(k)));
    % Overhead Variable Indexing
    day(k).trialOutcomeCell = eval('input.trialOutcomeCell');
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).missIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    dayIx(k).reqHoldTimeIx = (double(input.stimOnTimeMs) + double(input.stimOffTimeMs)) * double(input.maxCyclesOn) + double(input.tooFastTimeMs) - min(double(cell2mat(input.holdTimesMs)));
    dayIx(k).reactWindowIx = (max(double(cell2mat(input.holdTimesMs))) - (double(input.stimOnTimeMs) + double(input.stimOffTimeMs)) * double(input.maxCyclesOn) + double(input.tooFastTimeMs));
    reactMat = double(cell2mat(input.reactTimesMs));
    
    %%%%%%%%%%%%%%%%
    % Calculations %
    %%%%%%%%%%%%%%%%
    
    % Median of React Time
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    % Variance of Reaction Time for Correct Trials
    varianceC = var(reactMat(dayIx(k).correctIx));
    dampingC = scalar * dayIx(k).reactWindowIx;
    dayIx(k).scaledVarReactTimeCorrectIx = varianceC / dampingC;
    % Variance of Reaction Time for Early Trials
    varianceE = var(reactMat(dayIx(k).earlyIx));
    dampingE = scalar * dayIx(k).reqHoldTimeIx;
    dayIx(k).scaledVarReactTimeEarlyIx = varianceE / dampingE;
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Correct, Early, Miss Rate 
    dayIx(k).correctRateIx = sum(dayIx(k).correctIx);
    dayIx(k).earlyRateIx = sum(dayIx(k).earlyIx);
    dayIx(k).missRateIx = sum(dayIx(k).missIx);
    % Number of Trials
    dayIx(k).nTrialsIx = (dayIx(k).correctRateIx + dayIx(k).earlyRateIx + dayIx(k).missRateIx);
    % Conversion to percentage
    dayIx(k).correctRateIx = dayIx(k).correctRateIx / dayIx(k).nTrialsIx;
    dayIx(k).earlyRateIx = dayIx(k).earlyRateIx / dayIx(k).nTrialsIx;
    dayIx(k).missRateIx = dayIx(k).missRateIx / dayIx(k).nTrialsIx;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Concatenation of Variable Arrays %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Median Reaction Time for Correct Trials
    if isempty(medianReactTimeCorrect)
        medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(medianReactTimeCorrect);
        medianReactTimeCorrect = vertcat(medianReactTimeCorrect(1:current,1), dayIx(k).medianReactTimeCorrectIx);
    end
    % Median Reaction Time for Early Trials
    if isempty(medianReactTimeEarly)
        medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(medianReactTimeEarly);
        medianReactTimeEarly = vertcat(medianReactTimeEarly(1:current,1), dayIx(k).medianReactTimeEarlyIx);
    end
    % Scaled Variance for Correct Trials
    if isempty(scaledVarReactTimeCorrect)
        scaledVarReactTimeCorrect = {[dayIx(k).scaledVarReactTimeCorrectIx]};
    else
        current = length(scaledVarReactTimeCorrect);
        scaledVarReactTimeCorrect = vertcat(scaledVarReactTimeCorrect(1:current,1), dayIx(k).scaledVarReactTimeCorrectIx);
    end
    % Scaled Variance for Early Trials
    if isempty(scaledVarReactTimeEarly)
        scaledVarReactTimeEarly = {[dayIx(k).scaledVarReactTimeEarlyIx]};
    else
        current = length(scaledVarReactTimeEarly);
        scaledVarReactTimeEarly = vertcat(scaledVarReactTimeEarly(1:current,1), dayIx(k).scaledVarReactTimeEarlyIx);
    end
    % Upper p Value
    if isempty(cdf_pUpper)
        cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(cdf_pUpper);
        cdf_pUpper = vertcat(cdf_pUpper(1:current,1), dayIx(k).pUpperIx);
    end
    % Lower p Value
    if isempty(cdf_pLower)
        cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(cdf_pLower);
        cdf_pLower = vertcat(cdf_pLower(1:current,1), dayIx(k).pLowerIx);
    end
    % Difference p Value
    if isempty(cdfDiff)
        cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(cdfDiff);
        cdfDiff = vertcat(cdfDiff(1:current,1), dayIx(k).diffIx);
    end
    % Correct Rate
    if isempty(correctRate)
        correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(correctRate);
        correctRate = vertcat(correctRate(1:current,1), dayIx(k).correctRateIx);
    end
    % Early Rate 
    if isempty(earlyRate)
        earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(earlyRate);
        earlyRate = vertcat(earlyRate(1:current,1), dayIx(k).earlyRateIx);
    end
    % Miss Rate
    if isempty(missRate)
        missRate = {[dayIx(k).missRateIx]};
    else
        current = length(missRate);
        missRate = vertcat(missRate(1:current,1), dayIx(k).missRateIx);
    end
end
% Encode outputs to shorter variable names
a = medianReactTimeCorrect;
b = medianReactTimeEarly;
c = scaledVarReactTimeCorrect;
d = scaledVarReactTimeEarly;
e = correctRate;
f = earlyRate;
g = missRate;
h = cdf_pUpper;
i = cdf_pLower;
j = cdfDiff;

% Returns Home
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
end