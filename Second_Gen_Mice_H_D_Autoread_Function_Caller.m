% Benjamin Gincley
% 2/11/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data
% Second Gen Mice Data Autoread

clear all; close all; %Clear workspace

% Universal Variables
upperBound = 600;
lowerBound = 150;
scalar = 100;
trainPeriod = 5;

%%%%%%%%%%%
%  i527  
%%%%%%%%%%%
mouse1 = '527';
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';

outString = sprintf('i%s initializing, launching function...', mouse1);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j] = Autoread(mouse1,dr,trainPeriod);

% Recodes variables to logical names
i527_medianReactTimeCorrect = a;
i527_medianReactTimeEarly = b;
i527_scaledVarReactTimeCorrect = c;
i527_scaledVarReactTimeEarly = d;
i527_correctRate = e;
i527_earlyRate = f;
i527_missRate = g;
i527_cdf_pUpper = h;
i527_cdf_pLower = i;
i527_cdfDiff = j;


outString = sprintf('i%s complete', mouse1);
disp(outString)
%{
%%%%%%%%%%%
%  i529  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';
cd(dr);
mouse2 = '529';
allDays = dir([dr 'data-i' mouse2 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i529 = trainPeriod; % Sets the period of training observed

out = sprintf('%s initial', mouse2);
disp(out)
% Determines files to pull from
for i = 1:n_TrainingPeriod_i529
    %i
    load(allDays(i).name);
       if isempty(daysUsed)
        daysUsed = {[allDays(i).name]};
       else
        daysNow = length(daysUsed);
        daysUsed = {daysUsed{1,1:daysNow} [allDays(i).name]};
       end
end
out = sprintf('%s loading complete', mouse2);
disp(out)

%Variables for Counting
totalDays = length(daysUsed);

% Variables for Analysis
i529_medianReactTimeCorrect = {};
i529_medianReactTimeEarly = {};
i529_varReactTimeCorrect = {};
i529_varReactTimeEarly = {};
i529_scaledVarReactTimeCorrect = {};
i529_scaledVarReactTimeEarly = {};
i529_correctRate = {};
i529_earlyRate = {};
i529_missRate = {};
i529_cdf_pUpper = {};
i529_cdf_pLower = {};
i529_cdfDiff = {};

% Pulls data from files
for k = 1:totalDays
    %k
    load(char(daysUsed(k)));
    day(k).trialOutcomeCell = eval('input.trialOutcomeCell');
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).ignoreIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    dayIx(k).reqHoldTimeIx = double(input.randReqHoldMaxMs) + double(input.fixedReqHoldTimeMs) + double(input.tooFastTimeMs);
    dayIx(k).reactWindowIx = double(input.reactTimeMs);
    reactMat = cell2mat(input.reactTimesMs);
    
    % Median Reaction Time for Correct Trials
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    if isempty(i529_medianReactTimeCorrect)
        i529_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i529_medianReactTimeCorrect);
        i529_medianReactTimeCorrect = {i529_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if isempty(i529_medianReactTimeEarly)
        i529_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i529_medianReactTimeEarly);
        i529_medianReactTimeEarly = {i529_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if isempty(i529_varReactTimeCorrect)
        i529_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i529_varReactTimeCorrect);
        i529_varReactTimeCorrect = {i529_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if isempty(i529_varReactTimeEarly)
        i529_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i529_varReactTimeEarly);
        i529_varReactTimeEarly = {i529_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % Scaled Variance for Correct Trials
    dampingC = scalar * dayIx(k).reactWindowIx;
    
    dayIx(k).scaledVarReactTimeCorrectIx = dayIx(k).varReactTimeCorrectIx / dampingC;
    if isempty(i529_scaledVarReactTimeCorrect)
        i529_scaledVarReactTimeCorrect = {[dayIx(k).scaledVarReactTimeCorrectIx]};
    else
        current = length(i529_scaledVarReactTimeCorrect);
        i529_scaledVarReactTimeCorrect = {i529_scaledVarReactTimeCorrect{1,1:current} [dayIx(k).scaledVarReactTimeCorrectIx]};
    end
    
    % Scaled Variance for Early Trials
    dampingE = scalar * dayIx(k).reqHoldTimeIx;
    
    dayIx(k).scaledVarReactTimeEarlyIx = dayIx(k).varReactTimeEarlyIx / dampingE;
    if isempty(i529_scaledVarReactTimeEarly)
        i529_scaledVarReactTimeEarly = {[dayIx(k).scaledVarReactTimeEarlyIx]};
    else
        current = length(i529_scaledVarReactTimeEarly);
        i529_scaledVarReactTimeEarly = {i529_scaledVarReactTimeEarly{1,1:current} [dayIx(k).scaledVarReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if isempty(i529_cdf_pUpper)
        i529_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i529_cdf_pUpper);
        i529_cdf_pUpper = {i529_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if isempty(i529_cdf_pLower)
        i529_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i529_cdf_pLower);
        i529_cdf_pLower = {i529_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if isempty(i529_cdfDiff)
        i529_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i529_cdfDiff);
        i529_cdfDiff = {i529_cdfDiff{1,1:current} [dayIx(k).diffIx]};
    end
    
    % Correct
    dayIx(k).correctRateIx = sum(dayIx(k).correctIx);
    % Early 
    dayIx(k).earlyRateIx = sum(dayIx(k).earlyIx);
    % Miss
    dayIx(k).missRateIx = sum(dayIx(k).ignoreIx);
    % Number of Trials
    dayIx(k).nTrialsIx = (dayIx(k).correctRateIx + dayIx(k).earlyRateIx + dayIx(k).missRateIx);
    % Conversion to percentage
    dayIx(k).correctRateIx = dayIx(k).correctRateIx / dayIx(k).nTrialsIx;
    dayIx(k).earlyRateIx = dayIx(k).earlyRateIx / dayIx(k).nTrialsIx;
    dayIx(k).missRateIx = dayIx(k).missRateIx / dayIx(k).nTrialsIx;
    
     % Correct Rate
    if isempty(i529_correctRate)
        i529_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i529_correctRate);
        i529_correctRate = {i529_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if isempty(i529_earlyRate)
        i529_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i529_earlyRate);
        i529_earlyRate = {i529_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if isempty(i529_missRate)
        i529_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i529_missRate);
        i529_missRate = {i529_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i529_medianReactTimeCorrect = i529_medianReactTimeCorrect';
i529_medianReactTimeEarly = i529_medianReactTimeEarly';
i529_varReactTimeCorrect = i529_varReactTimeCorrect';
i529_varReactTimeEarly = i529_varReactTimeEarly';
i529_scaledVarReactTimeCorrect = i529_scaledVarReactTimeCorrect';
i529_scaledVarReactTimeEarly = i529_scaledVarReactTimeEarly';
i529_correctRate = i529_correctRate';
i529_earlyRate = i529_earlyRate';
i529_missRate = i529_missRate';
i529_cdf_pUpper = i529_cdf_pUpper';
i529_cdf_pLower = i529_cdf_pLower';
i529_cdfDiff = i529_cdfDiff';
out = sprintf('%s complete', mouse2);
disp(out)

%%%%%%%%%%%
%  i533  
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
cd(dr);
mouse3 = '533';
allDays = dir([dr 'data-i' mouse3 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i533 = trainPeriod; % Sets the period of training observed

out = sprintf('%s initial', mouse3);
disp(out)
% Determines files to pull from
for i = 1:n_TrainingPeriod_i533
    %i
    load(allDays(i).name);
       if isempty(daysUsed)
        daysUsed = {[allDays(i).name]};
       else
        daysNow = length(daysUsed);
        daysUsed = {daysUsed{1,1:daysNow} [allDays(i).name]};
       end
end
out = sprintf('%s loading complete', mouse3);
disp(out)

%Variables for Counting
totalDays = length(daysUsed);

% Variables for Analysis
i533_medianReactTimeCorrect = {};
i533_medianReactTimeEarly = {};
i533_varReactTimeCorrect = {};
i533_varReactTimeEarly = {};
i533_scaledVarReactTimeCorrect = {};
i533_scaledVarReactTimeEarly = {};
i533_correctRate = {};
i533_earlyRate = {};
i533_missRate = {};
i533_cdf_pUpper = {};
i533_cdf_pLower = {};
i533_cdfDiff = {};

% Pulls data from files
for k = 1:totalDays
    %k
    load(char(daysUsed(k)));
    day(k).trialOutcomeCell = eval('input.trialOutcomeCell');
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).ignoreIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    dayIx(k).reqHoldTimeIx = double(input.randReqHoldMaxMs) + double(input.fixedReqHoldTimeMs) + double(input.tooFastTimeMs);
    dayIx(k).reactWindowIx = double(input.reactTimeMs);
    reactMat = cell2mat(input.reactTimesMs);
    
    % Median Reaction Time for Correct Trials
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    if isempty(i533_medianReactTimeCorrect)
        i533_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i533_medianReactTimeCorrect);
        i533_medianReactTimeCorrect = {i533_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if isempty(i533_medianReactTimeEarly)
        i533_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i533_medianReactTimeEarly);
        i533_medianReactTimeEarly = {i533_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if isempty(i533_varReactTimeCorrect)
        i533_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i533_varReactTimeCorrect);
        i533_varReactTimeCorrect = {i533_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if isempty(i533_varReactTimeEarly)
        i533_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i533_varReactTimeEarly);
        i533_varReactTimeEarly = {i533_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % Scaled Variance for Correct Trials
    dampingC = scalar * dayIx(k).reactWindowIx;
    
    dayIx(k).scaledVarReactTimeCorrectIx = dayIx(k).varReactTimeCorrectIx / dampingC;
    if isempty(i533_scaledVarReactTimeCorrect)
        i533_scaledVarReactTimeCorrect = {[dayIx(k).scaledVarReactTimeCorrectIx]};
    else
        current = length(i533_scaledVarReactTimeCorrect);
        i533_scaledVarReactTimeCorrect = {i533_scaledVarReactTimeCorrect{1,1:current} [dayIx(k).scaledVarReactTimeCorrectIx]};
    end
    
    % Scaled Variance for Early Trials
    dampingE = scalar * dayIx(k).reqHoldTimeIx;
    
    dayIx(k).scaledVarReactTimeEarlyIx = dayIx(k).varReactTimeEarlyIx / dampingE;
    if isempty(i533_scaledVarReactTimeEarly)
        i533_scaledVarReactTimeEarly = {[dayIx(k).scaledVarReactTimeEarlyIx]};
    else
        current = length(i533_scaledVarReactTimeEarly);
        i533_scaledVarReactTimeEarly = {i533_scaledVarReactTimeEarly{1,1:current} [dayIx(k).scaledVarReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if isempty(i533_cdf_pUpper)
        i533_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i533_cdf_pUpper);
        i533_cdf_pUpper = {i533_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if isempty(i533_cdf_pLower)
        i533_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i533_cdf_pLower);
        i533_cdf_pLower = {i533_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if isempty(i533_cdfDiff)
        i533_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i533_cdfDiff);
        i533_cdfDiff = {i533_cdfDiff{1,1:current} [dayIx(k).diffIx]};
    end
    
    % Correct
    dayIx(k).correctRateIx = sum(dayIx(k).correctIx);
    % Early 
    dayIx(k).earlyRateIx = sum(dayIx(k).earlyIx);
    % Miss
    dayIx(k).missRateIx = sum(dayIx(k).ignoreIx);
    % Number of Trials
    dayIx(k).nTrialsIx = (dayIx(k).correctRateIx + dayIx(k).earlyRateIx + dayIx(k).missRateIx);
    % Conversion to percentage
    dayIx(k).correctRateIx = dayIx(k).correctRateIx / dayIx(k).nTrialsIx;
    dayIx(k).earlyRateIx = dayIx(k).earlyRateIx / dayIx(k).nTrialsIx;
    dayIx(k).missRateIx = dayIx(k).missRateIx / dayIx(k).nTrialsIx;
    
    % Correct Rate
    if isempty(i533_correctRate)
        i533_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i533_correctRate);
        i533_correctRate = {i533_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if isempty(i533_earlyRate)
        i533_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i533_earlyRate);
        i533_earlyRate = {i533_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if isempty(i533_missRate)
        i533_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i533_missRate);
        i533_missRate = {i533_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i533_medianReactTimeCorrect = i533_medianReactTimeCorrect';
i533_medianReactTimeEarly = i533_medianReactTimeEarly';
i533_varReactTimeCorrect = i533_varReactTimeCorrect';
i533_varReactTimeEarly = i533_varReactTimeEarly';
i533_scaledVarReactTimeCorrect = i533_scaledVarReactTimeCorrect';
i533_scaledVarReactTimeEarly = i533_scaledVarReactTimeEarly';
i533_correctRate = i533_correctRate';
i533_earlyRate = i533_earlyRate';
i533_missRate = i533_missRate';
i533_cdf_pUpper = i533_cdf_pUpper';
i533_cdf_pLower = i533_cdf_pLower';
i533_cdfDiff = i533_cdfDiff';
out = sprintf('%s complete', mouse3);
disp(out)

%%%%%%%%%%%
%  i534  
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
cd(dr);
mouse4 = '534';
allDays = dir([dr 'data-i' mouse4 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i534 = trainPeriod; % Sets the period of training observed

out = sprintf('%s initial', mouse4);
disp(out)
% Determines files to pull from
for i = 1:n_TrainingPeriod_i534
    %i
    load(allDays(i).name);
       if isempty(daysUsed)
        daysUsed = {[allDays(i).name]};
       else
        daysNow = length(daysUsed);
        daysUsed = {daysUsed{1,1:daysNow} [allDays(i).name]};
       end
end
out = sprintf('%s loading complete', mouse4);
disp(out)

%Variables for Counting
totalDays = length(daysUsed);

% Variables for Analysis
i534_medianReactTimeCorrect = {};
i534_medianReactTimeEarly = {};
i534_varReactTimeCorrect = {};
i534_varReactTimeEarly = {};
i534_scaledVarReactTimeCorrect = {};
i534_scaledVarReactTimeEarly = {};
i534_correctRate = {};
i534_earlyRate = {};
i534_missRate = {};
i534_cdf_pUpper = {};
i534_cdf_pLower = {};
i534_cdfDiff = {};

% Pulls data from files
for k = 1:totalDays
    %k
    load(char(daysUsed(k)));
    day(k).trialOutcomeCell = eval('input.trialOutcomeCell');
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).ignoreIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    dayIx(k).reqHoldTimeIx = double(input.randReqHoldMaxMs) + double(input.fixedReqHoldTimeMs) + double(input.tooFastTimeMs);
    dayIx(k).reactWindowIx = double(input.reactTimeMs);
    reactMat = cell2mat(input.reactTimesMs); 
    
    % Median Reaction Time for Correct Trials
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    if isempty(i534_medianReactTimeCorrect)
        i534_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i534_medianReactTimeCorrect);
        i534_medianReactTimeCorrect = {i534_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if isempty(i534_medianReactTimeEarly)
        i534_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i534_medianReactTimeEarly);
        i534_medianReactTimeEarly = {i534_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if isempty(i534_varReactTimeCorrect)
        i534_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i534_varReactTimeCorrect);
        i534_varReactTimeCorrect = {i534_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if isempty(i534_varReactTimeEarly)
        i534_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i534_varReactTimeEarly);
        i534_varReactTimeEarly = {i534_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % Scaled Variance for Correct Trials
    dampingC = scalar * dayIx(k).reactWindowIx;
    
    dayIx(k).scaledVarReactTimeCorrectIx = dayIx(k).varReactTimeCorrectIx / dampingC;
    if isempty(i534_scaledVarReactTimeCorrect)
        i534_scaledVarReactTimeCorrect = {[dayIx(k).scaledVarReactTimeCorrectIx]};
    else
        current = length(i534_scaledVarReactTimeCorrect);
        i534_scaledVarReactTimeCorrect = {i534_scaledVarReactTimeCorrect{1,1:current} [dayIx(k).scaledVarReactTimeCorrectIx]};
    end
    
    % Scaled Variance for Early Trials
    dampingE = scalar * dayIx(k).reqHoldTimeIx;
    
    dayIx(k).scaledVarReactTimeEarlyIx = dayIx(k).varReactTimeEarlyIx / dampingE;
    if isempty(i534_scaledVarReactTimeEarly)
        i534_scaledVarReactTimeEarly = {[dayIx(k).scaledVarReactTimeEarlyIx]};
    else
        current = length(i534_scaledVarReactTimeEarly);
        i534_scaledVarReactTimeEarly = {i534_scaledVarReactTimeEarly{1,1:current} [dayIx(k).scaledVarReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if isempty(i534_cdf_pUpper)
        i534_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i534_cdf_pUpper);
        i534_cdf_pUpper = {i534_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if isempty(i534_cdf_pLower)
        i534_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i534_cdf_pLower);
        i534_cdf_pLower = {i534_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if isempty(i534_cdfDiff)
        i534_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i534_cdfDiff);
        i534_cdfDiff = {i534_cdfDiff{1,1:current} [dayIx(k).diffIx]};
    end
    
    % Correct
    dayIx(k).correctRateIx = sum(dayIx(k).correctIx);
    % Early 
    dayIx(k).earlyRateIx = sum(dayIx(k).earlyIx);
    % Miss
    dayIx(k).missRateIx = sum(dayIx(k).ignoreIx);
    % Number of Trials
    dayIx(k).nTrialsIx = (dayIx(k).correctRateIx + dayIx(k).earlyRateIx + dayIx(k).missRateIx);
    % Conversion to percentage
    dayIx(k).correctRateIx = dayIx(k).correctRateIx / dayIx(k).nTrialsIx;
    dayIx(k).earlyRateIx = dayIx(k).earlyRateIx / dayIx(k).nTrialsIx;
    dayIx(k).missRateIx = dayIx(k).missRateIx / dayIx(k).nTrialsIx;
    
    % Correct Rate
    if isempty(i534_correctRate)
        i534_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i534_correctRate);
        i534_correctRate = {i534_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if isempty(i534_earlyRate)
        i534_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i534_earlyRate);
        i534_earlyRate = {i534_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if isempty(i534_missRate)
        i534_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i534_missRate);
        i534_missRate = {i534_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i534_medianReactTimeCorrect = i534_medianReactTimeCorrect';
i534_medianReactTimeEarly = i534_medianReactTimeEarly';
i534_varReactTimeCorrect = i534_varReactTimeCorrect';
i534_varReactTimeEarly = i534_varReactTimeEarly';
i534_scaledVarReactTimeCorrect = i534_scaledVarReactTimeCorrect';
i534_scaledVarReactTimeEarly = i534_scaledVarReactTimeEarly';
i534_correctRate = i534_correctRate';
i534_earlyRate = i534_earlyRate';
i534_missRate = i534_missRate';
i534_cdf_pUpper = i534_cdf_pUpper';
i534_cdf_pLower = i534_cdf_pLower';
i534_cdfDiff = i534_cdfDiff';
out = sprintf('%s complete', mouse4);
disp(out)

%%%%%%%%%%%
%  i535 
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
cd(dr);
mouse5 = '535';
allDays = dir([dr 'data-i' mouse5 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i535 = numAllDays; % Sets the period of training observed

out = sprintf('%s initial', mouse5);
disp(out)
% Determines files to pull from
for i = 1:n_TrainingPeriod_i535
    %i
    load(allDays(i).name);
       if isempty(daysUsed)
        daysUsed = {[allDays(i).name]};
       else
        daysNow = length(daysUsed);
        daysUsed = {daysUsed{1,1:daysNow} [allDays(i).name]};
       end
end
out = sprintf('%s loading complete', mouse5);
disp(out)

%Variables for Counting
totalDays = length(daysUsed);

% Variables for Analysis
i535_medianReactTimeCorrect = {};
i535_medianReactTimeEarly = {};
i535_varReactTimeCorrect = {};
i535_varReactTimeEarly = {};
i535_scaledVarReactTimeCorrect = {};
i535_scaledVarReactTimeEarly = {};
i535_correctRate = {};
i535_earlyRate = {};
i535_missRate = {};
i535_cdf_pUpper = {};
i535_cdf_pLower = {};
i535_cdfDiff = {};
reactMat = {};

% Pulls data from files
for k = 1:totalDays
    %k
    load(char(daysUsed(k)));
    day(k).trialOutcomeCell = eval('input.trialOutcomeCell');
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).ignoreIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    dayIx(k).reqHoldTimeIx = double(input.randReqHoldMaxMs) + double(input.fixedReqHoldTimeMs) + double(input.tooFastTimeMs);
    dayIx(k).reactWindowIx = double(input.reactTimeMs);
    reactMat = cell2mat(input.reactTimesMs);
    
    % Median Reaction Time for Correct Trials
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    if isempty(i535_medianReactTimeCorrect)
        i535_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i535_medianReactTimeCorrect);
        i535_medianReactTimeCorrect = {i535_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if isempty(i535_medianReactTimeEarly)
        i535_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i535_medianReactTimeEarly);
        i535_medianReactTimeEarly = {i535_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if isempty(i535_varReactTimeCorrect)
        i535_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i535_varReactTimeCorrect);
        i535_varReactTimeCorrect = {i535_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if isempty(i535_varReactTimeEarly)
        i535_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i535_varReactTimeEarly);
        i535_varReactTimeEarly = {i535_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % Scaled Variance for Correct Trials
    dampingC = scalar * dayIx(k).reactWindowIx;
    
    dayIx(k).scaledVarReactTimeCorrectIx = dayIx(k).varReactTimeCorrectIx / dampingC;
    if isempty(i535_scaledVarReactTimeCorrect)
        i535_scaledVarReactTimeCorrect = {[dayIx(k).scaledVarReactTimeCorrectIx]};
    else
        current = length(i535_scaledVarReactTimeCorrect);
        i535_scaledVarReactTimeCorrect = {i535_scaledVarReactTimeCorrect{1,1:current} [dayIx(k).scaledVarReactTimeCorrectIx]};
    end
    
    % Scaled Variance for Early Trials
    dampingE = scalar * dayIx(k).reqHoldTimeIx;
    
    dayIx(k).scaledVarReactTimeEarlyIx = dayIx(k).varReactTimeEarlyIx / dampingE;
    if isempty(i535_scaledVarReactTimeEarly)
        i535_scaledVarReactTimeEarly = {[dayIx(k).scaledVarReactTimeEarlyIx]};
    else
        current = length(i535_scaledVarReactTimeEarly);
        i535_scaledVarReactTimeEarly = {i535_scaledVarReactTimeEarly{1,1:current} [dayIx(k).scaledVarReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if isempty(i535_cdf_pUpper)
        i535_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i535_cdf_pUpper);
        i535_cdf_pUpper = {i535_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if isempty(i535_cdf_pLower)
        i535_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i535_cdf_pLower);
        i535_cdf_pLower = {i535_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if isempty(i535_cdfDiff)
        i535_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i535_cdfDiff);
        i535_cdfDiff = {i535_cdfDiff{1,1:current} [dayIx(k).diffIx]};
    end
    
    % Correct
    dayIx(k).correctRateIx = sum(dayIx(k).correctIx);
    % Early 
    dayIx(k).earlyRateIx = sum(dayIx(k).earlyIx);
    % Miss
    dayIx(k).missRateIx = sum(dayIx(k).ignoreIx);
    % Number of Trials
    dayIx(k).nTrialsIx = (dayIx(k).correctRateIx + dayIx(k).earlyRateIx + dayIx(k).missRateIx);
    % Conversion to percentage
    dayIx(k).correctRateIx = dayIx(k).correctRateIx / dayIx(k).nTrialsIx;
    dayIx(k).earlyRateIx = dayIx(k).earlyRateIx / dayIx(k).nTrialsIx;
    dayIx(k).missRateIx = dayIx(k).missRateIx / dayIx(k).nTrialsIx;
    
    % Correct Rate
    if isempty(i535_correctRate)
        i535_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i535_correctRate);
        i535_correctRate = {i535_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate
    if isempty(i535_earlyRate)
        i535_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i535_earlyRate);
        i535_earlyRate = {i535_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if isempty(i535_missRate)
        i535_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i535_missRate);
        i535_missRate = {i535_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end
out = sprintf('%s complete', mouse5);
disp(out)

% Reorganizes into columns
i535_medianReactTimeCorrect = i535_medianReactTimeCorrect';
i535_medianReactTimeEarly = i535_medianReactTimeEarly';
i535_varReactTimeCorrect = i535_varReactTimeCorrect';
i535_varReactTimeEarly = i535_varReactTimeEarly';
i535_scaledVarReactTimeCorrect = i535_scaledVarReactTimeCorrect';
i535_scaledVarReactTimeEarly = i535_scaledVarReactTimeEarly';
i535_correctRate = i535_correctRate';
i535_earlyRate = i535_earlyRate';
i535_missRate = i535_missRate';
i535_cdf_pUpper = i535_cdf_pUpper';
i535_cdf_pLower = i535_cdf_pLower';
i535_cdfDiff = i535_cdfDiff';

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save Second_Gen_Mice_Variables.mat
out = sprintf('Save complete');
disp(out)
%}