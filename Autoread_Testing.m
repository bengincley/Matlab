% Reads and creates arrays from data sets without using an Index
% [mouse,directory,training period]
mouse = '532';
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';
trainPeriod = 7;
% Variables
upperBound = 550;
lowerBound = 150;
scalar = 100;

% Change Directory to find Raw Data
cd(dr);
allDays = dir([dr 'data-i' mouse '-*']);

% Initialize Output Arrays 
dataFiles = {};
medianReactTimeCorrect = zeros(trainPeriod,1);
medianReactTimeEarly = zeros(trainPeriod,1);
scaledVarReactTimeCorrect = zeros(trainPeriod,1);
scaledVarReactTimeEarly = zeros(trainPeriod,1);
cdf_pUpper = zeros(trainPeriod,1);
cdf_pLower = zeros(trainPeriod,1);
cdfDiff = zeros(trainPeriod,1);
correctRate = zeros(trainPeriod,1);
earlyRate = zeros(trainPeriod,1);
missRate = zeros(trainPeriod,1);
%normalH = zeros(trainPeriod,1);
normalP = zeros(trainPeriod,1);

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
    trialOutcomeCell = eval('input.trialOutcomeCell');
    correctIx = strcmp(trialOutcomeCell, 'success');
    earlyIx = strcmp(trialOutcomeCell, 'failure');
    missIx = strcmp(trialOutcomeCell, 'ignore');
    reqHoldTimeIx = (double(input.fixedReqHoldTimeMs) + double(input.randReqHoldMaxMs) + double(input.tooFastTimeMs)) - min(double(cell2mat(input.holdTimesMs)));
    reactWindowIx = (max(double(cell2mat(input.holdTimesMs))) - (double(input.fixedReqHoldTimeMs) + double(input.randReqHoldMaxMs) + double(input.tooFastTimeMs)));
    reactMat = double(cell2mat(input.reactTimesMs));
    
    %%%%%%%%%%%%%%%%
    % Calculations %
    %%%%%%%%%%%%%%%%
    
    % Median of React Time
    medianReactTimeCorrectIx = median(reactMat(correctIx));
    medianReactTimeEarlyIx = median(reactMat(earlyIx));
    % Variance of Reaction Time for Correct Trials
    varianceC = var(reactMat(correctIx));
    dampingC = scalar * reactWindowIx;
    scaledVarReactTimeCorrectIx = varianceC / dampingC;
    % Variance of Reaction Time for Early Trials
    varianceE = var(reactMat(earlyIx));
    dampingE = scalar * reqHoldTimeIx;
    scaledVarReactTimeEarlyIx = varianceE / dampingE;
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    pUpperIx = upSum / totalTrials;
    pLowerIx = lowSum / totalTrials;
    diffIx = pUpperIx - pLowerIx;
    % Correct, Early, Miss Rate 
    correctRateIx = sum(correctIx);
    earlyRateIx = sum(earlyIx);
    missRateIx = sum(missIx);
    % Number of Trials
    nTrialsIx = (correctRateIx + earlyRateIx + missRateIx);
    % Conversion to percentage
    correctRateIx = correctRateIx / nTrialsIx;
    earlyRateIx = earlyRateIx / nTrialsIx;
    missRateIx = missRateIx / nTrialsIx;
    % Chi Square Goodness-of-Fit Test for Normality
    [~,normalPIx] = chi2gof(reactMat);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Concatenation of Variable Arrays %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Median Reaction Time for Correct Trials
    medianReactTimeCorrect(k,1) = medianReactTimeCorrectIx;
    % Median Reaction Time for Early Trials
    medianReactTimeEarly(k,1) = medianReactTimeEarlyIx;
    % Scaled Variance for Correct Trials
    scaledVarReactTimeCorrect(k,1) = scaledVarReactTimeCorrectIx;
    % Scaled Variance for Early Trials
    scaledVarReactTimeEarly(k,1) = scaledVarReactTimeEarlyIx;
    % Upper p Value
    cdf_pUpper(k,1) = pUpperIx;
    % Lower p Value
    cdf_pLower(k,1) = pLowerIx;
    % Difference p Value
    cdfDiff(k,1) = diffIx;
    % Correct Rate
    correctRate(k,1) = correctRateIx;
    % Early Rate 
    earlyRate(k,1) = earlyRateIx;
    % Miss Rate
    missRate(k,1) = missRateIx;
    %{
    % H value of Normal Chi Square Test
    normalH(k,1) = {normalHIx};
    %}
    % P value of Normal Chi Square Test
    normalP(k,1) = normalPIx;
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
%m = normalH;
l = normalP;

% Returns Home
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
