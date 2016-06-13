% Benjamin Gincley
% 1/22/2016
% Glickfeld Lab
% New Mice Learning Indicator Analysis - Importing and Proessing Data

clear all; close all; %Clear workspace

% Universal Variables
upperBound = 600;
lowerBound = 150;
scalar = 100;

%%%%%%%%%%%
%  i534  
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
cd(dr);
mouse1 = '534';
allDays = dir([dr 'data-i' mouse1 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i534 = 10; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i534
    i
    load(allDays(i).name);
       if length(daysUsed) == 0
        daysUsed = {[allDays(i).name]};
       else
        daysNow = length(daysUsed);
        daysUsed = {daysUsed{1,1:daysNow} [allDays(i).name]};
       end
end

%Variables for Counting
totalDays = length(daysUsed);

% Variables for Analysis
i534_medianReactTimeCorrect = {};
i534_medianReactTimeEarly = {};
i534_varReactTimeCorrect = {};
i534_scaledVarReactTimeCorrect = {};
i534_varReactTimeEarly = {};
i534_scaledVarReactTimeEarly = {};
i534_correctRate = {};
i534_earlyRate = {};
i534_missRate = {};
i534_cdf_pUpper = {};
i534_cdf_pLower = {};
i534_cdfDiff = {};
reactMat = {};


% Pulls data from files
for k = 1:totalDays
    k
    load(char(daysUsed(k)));
    day(k).trialOutcomeCell = eval(['input.trialOutcomeCell']);
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).ignoreIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    dayIx(k).reqHoldTimeIx = double(input.randReqHoldMaxMs) + double(input.fixedReqHoldTimeMs) + double(input.tooFastTimeMs);
    dayIx(k).reactWindowIx = double(input.reactTimeMs);
    reactMat = cell2mat(input.reactTimesMs); 
    
    % Median Reaction Time for Correct Trials
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    if length(i534_medianReactTimeCorrect) == 0
        i534_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i534_medianReactTimeCorrect);
        i534_medianReactTimeCorrect = {i534_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i534_medianReactTimeEarly) == 0
        i534_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i534_medianReactTimeEarly);
        i534_medianReactTimeEarly = {i534_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i534_varReactTimeCorrect) == 0
        i534_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i534_varReactTimeCorrect);
        i534_varReactTimeCorrect = {i534_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i534_varReactTimeEarly) == 0
        i534_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i534_varReactTimeEarly);
        i534_varReactTimeEarly = {i534_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % Scaled Variance for Correct Trials
    dampingC = scalar * dayIx(k).reactWindowIx;
    
    dayIx(k).scaledVarReactTimeCorrectIx = dayIx(k).varReactTimeCorrectIx / dampingC;
    if length(i534_scaledVarReactTimeCorrect) == 0
        i534_scaledVarReactTimeCorrect = {[dayIx(k).scaledVarReactTimeCorrectIx]};
    else
        current = length(i534_scaledVarReactTimeCorrect);
        i534_scaledVarReactTimeCorrect = {i534_scaledVarReactTimeCorrect{1,1:current} [dayIx(k).scaledVarReactTimeCorrectIx]};
    end
    
    % Scaled Variance for Early Trials
    dampingE = scalar * dayIx(k).reqHoldTimeIx;
    
    dayIx(k).scaledVarReactTimeEarlyIx = dayIx(k).varReactTimeEarlyIx / dampingE;
    if length(i534_scaledVarReactTimeEarly) == 0
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
    if length(i534_cdf_pUpper) == 0
        i534_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i534_cdf_pUpper);
        i534_cdf_pUpper = {i534_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i534_cdf_pLower) == 0
        i534_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i534_cdf_pLower);
        i534_cdf_pLower = {i534_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i534_cdfDiff) == 0
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
    if length(i534_correctRate) == 0
        i534_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i534_correctRate);
        i534_correctRate = {i534_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i534_earlyRate) == 0
        i534_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i534_earlyRate);
        i534_earlyRate = {i534_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i534_missRate) == 0
        i534_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i534_missRate);
        i534_missRate = {i534_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i534_medianReactTimeCorrect = [i534_medianReactTimeCorrect]';
i534_medianReactTimeEarly = [i534_medianReactTimeEarly]';
i534_varReactTimeCorrect = [i534_varReactTimeCorrect]';
i534_varReactTimeEarly = [i534_varReactTimeEarly]';
i534_correctRate = [i534_correctRate]';
i534_earlyRate = [i534_earlyRate]';
i534_missRate = [i534_missRate]';
i534_cdf_pUpper = [i534_cdf_pUpper]';
i534_cdf_pLower = [i534_cdf_pLower]';
i534_cdfDiff = [i534_cdfDiff]';
%{
%%%%%%%%%%%
%  i535 
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
cd(dr);
mouse2 = '535';
allDays = dir([dr 'data-i' mouse2 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i535 = numAllDays; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i535
    i
    load(allDays(i).name);
       if length(daysUsed) == 0
        daysUsed = {[allDays(i).name]};
       else
        daysNow = length(daysUsed);
        daysUsed = {daysUsed{1,1:daysNow} [allDays(i).name]};
       end
end

%Variables for Counting
totalDays = length(daysUsed);

% Variables for Analysis
i535_medianReactTimeCorrect = {};
i535_medianReactTimeEarly = {};
i535_varReactTimeCorrect = {};
i535_varReactTimeEarly = {};
i535_correctRate = {};
i535_earlyRate = {};
i535_missRate = {};
i535_cdf_pUpper = {};
i535_cdf_pLower = {};
i535_cdfDiff = {};
reactMat = {};

% Pulls data from files
for k = 1:totalDays
    k
    load(char(daysUsed(k)));
    day(k).trialOutcomeCell = eval(['input.trialOutcomeCell']);
    dayIx(k).correctIx = strcmp(day(k).trialOutcomeCell, 'success');
    dayIx(k).earlyIx = strcmp(day(k).trialOutcomeCell, 'failure');
    dayIx(k).ignoreIx = strcmp(day(k).trialOutcomeCell, 'ignore');
    
    reactMat = cell2mat(input.reactTimesMs);
    
    % Median Reaction Time for Correct Trials
    dayIx(k).medianReactTimeCorrectIx = median(reactMat(dayIx(k).correctIx));
    if length(i535_medianReactTimeCorrect) == 0
        i535_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i535_medianReactTimeCorrect);
        i535_medianReactTimeCorrect = {i535_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i535_medianReactTimeEarly) == 0
        i535_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i535_medianReactTimeEarly);
        i535_medianReactTimeEarly = {i535_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i535_varReactTimeCorrect) == 0
        i535_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i535_varReactTimeCorrect);
        i535_varReactTimeCorrect = {i535_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i535_varReactTimeEarly) == 0
        i535_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i535_varReactTimeEarly);
        i535_varReactTimeEarly = {i535_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i535_cdf_pUpper) == 0
        i535_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i535_cdf_pUpper);
        i535_cdf_pUpper = {i535_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i535_cdf_pLower) == 0
        i535_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i535_cdf_pLower);
        i535_cdf_pLower = {i535_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i535_cdfDiff) == 0
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
    if length(i535_correctRate) == 0
        i535_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i535_correctRate);
        i535_correctRate = {i535_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate
    if length(i535_earlyRate) == 0
        i535_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i535_earlyRate);
        i535_earlyRate = {i535_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i535_missRate) == 0
        i535_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i535_missRate);
        i535_missRate = {i535_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i535_medianReactTimeCorrect = [i535_medianReactTimeCorrect]';
i535_medianReactTimeEarly = [i535_medianReactTimeEarly]';
i535_varReactTimeCorrect = [i535_varReactTimeCorrect]';
i535_varReactTimeEarly = [i535_varReactTimeEarly]';
i535_correctRate = [i535_correctRate]';
i535_earlyRate = [i535_earlyRate]';
i535_missRate = [i535_missRate]';
i535_cdf_pUpper = [i535_cdf_pUpper]';
i535_cdf_pLower = [i535_cdf_pLower]';
i535_cdfDiff = [i535_cdfDiff]';
%}
% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save New_Mice_Behavior_Learning_Variables.mat
