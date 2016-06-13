% Benjamin Gincley
% 1/20/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data

clear all; close all; %Clear workspace

% Universal Variables
upperBound = 600;
lowerBound = 150;
trainPeriod = 30;

%%%%%%%%%%%
%  i527  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';
cd(dr);
mouse1 = '527';
allDays = dir([dr 'data-i' mouse1 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i527 = trainPeriod; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i527
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
i527_medianReactTimeCorrect = {};
i527_medianReactTimeEarly = {};
i527_varReactTimeCorrect = {};
i527_varReactTimeEarly = {};
i527_correctRate = {};
i527_earlyRate = {};
i527_missRate = {};
i527_cdf_pUpper = {};
i527_cdf_pLower = {};
i527_cdfDiff = {};
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
    if length(i527_medianReactTimeCorrect) == 0
        i527_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i527_medianReactTimeCorrect);
        i527_medianReactTimeCorrect = {i527_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i527_medianReactTimeEarly) == 0
        i527_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i527_medianReactTimeEarly);
        i527_medianReactTimeEarly = {i527_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i527_varReactTimeCorrect) == 0
        i527_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i527_varReactTimeCorrect);
        i527_varReactTimeCorrect = {i527_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i527_varReactTimeEarly) == 0
        i527_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i527_varReactTimeEarly);
        i527_varReactTimeEarly = {i527_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i527_cdf_pUpper) == 0
        i527_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i527_cdf_pUpper);
        i527_cdf_pUpper = {i527_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i527_cdf_pLower) == 0
        i527_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i527_cdf_pLower);
        i527_cdf_pLower = {i527_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i527_cdfDiff) == 0
        i527_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i527_cdfDiff);
        i527_cdfDiff = {i527_cdfDiff{1,1:current} [dayIx(k).diffIx]};
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
    if length(i527_correctRate) == 0
        i527_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i527_correctRate);
        i527_correctRate = {i527_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i527_earlyRate) == 0
        i527_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i527_earlyRate);
        i527_earlyRate = {i527_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i527_missRate) == 0
        i527_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i527_missRate);
        i527_missRate = {i527_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i527_medianReactTimeCorrect = [i527_medianReactTimeCorrect]';
i527_medianReactTimeEarly = [i527_medianReactTimeEarly]';
i527_varReactTimeCorrect = [i527_varReactTimeCorrect]';
i527_varReactTimeEarly = [i527_varReactTimeEarly]';
i527_correctRate = [i527_correctRate]';
i527_earlyRate = [i527_earlyRate]';
i527_missRate = [i527_missRate]';
i527_cdf_pUpper = [i527_cdf_pUpper]';
i527_cdf_pLower = [i527_cdf_pLower]';
i527_cdfDiff = [i527_cdfDiff]';


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

% Determines files to pull from
for i = 1:n_TrainingPeriod_i529
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
i529_medianReactTimeCorrect = {};
i529_medianReactTimeEarly = {};
i529_varReactTimeCorrect = {};
i529_varReactTimeEarly = {};
i529_correctRate = {};
i529_earlyRate = {};
i529_missRate = {};
i529_cdf_pUpper = {};
i529_cdf_pLower = {};
i529_cdfDiff = {};
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
    if length(i529_medianReactTimeCorrect) == 0
        i529_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i529_medianReactTimeCorrect);
        i529_medianReactTimeCorrect = {i529_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i529_medianReactTimeEarly) == 0
        i529_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i529_medianReactTimeEarly);
        i529_medianReactTimeEarly = {i529_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i529_varReactTimeCorrect) == 0
        i529_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i529_varReactTimeCorrect);
        i529_varReactTimeCorrect = {i529_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i529_varReactTimeEarly) == 0
        i529_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i529_varReactTimeEarly);
        i529_varReactTimeEarly = {i529_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i529_cdf_pUpper) == 0
        i529_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i529_cdf_pUpper);
        i529_cdf_pUpper = {i529_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i529_cdf_pLower) == 0
        i529_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i529_cdf_pLower);
        i529_cdf_pLower = {i529_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i529_cdfDiff) == 0
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
    if length(i529_correctRate) == 0
        i529_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i529_correctRate);
        i529_correctRate = {i529_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i529_earlyRate) == 0
        i529_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i529_earlyRate);
        i529_earlyRate = {i529_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i529_missRate) == 0
        i529_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i529_missRate);
        i529_missRate = {i529_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i529_medianReactTimeCorrect = [i529_medianReactTimeCorrect]';
i529_medianReactTimeEarly = [i529_medianReactTimeEarly]';
i529_varReactTimeCorrect = [i529_varReactTimeCorrect]';
i529_varReactTimeEarly = [i529_varReactTimeEarly]';
i529_correctRate = [i529_correctRate]';
i529_earlyRate = [i529_earlyRate]';
i529_missRate = [i529_missRate]';
i529_cdf_pUpper = [i529_cdf_pUpper]';
i529_cdf_pLower = [i529_cdf_pLower]';
i529_cdfDiff = [i529_cdfDiff]';

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

% Determines files to pull from
for i = 1:n_TrainingPeriod_i533
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
i533_medianReactTimeCorrect = {};
i533_medianReactTimeEarly = {};
i533_varReactTimeCorrect = {};
i533_varReactTimeEarly = {};
i533_correctRate = {};
i533_earlyRate = {};
i533_missRate = {};
i533_cdf_pUpper = {};
i533_cdf_pLower = {};
i533_cdfDiff = {};
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
    if length(i533_medianReactTimeCorrect) == 0
        i533_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i533_medianReactTimeCorrect);
        i533_medianReactTimeCorrect = {i533_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i533_medianReactTimeEarly) == 0
        i533_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i533_medianReactTimeEarly);
        i533_medianReactTimeEarly = {i533_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i533_varReactTimeCorrect) == 0
        i533_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i533_varReactTimeCorrect);
        i533_varReactTimeCorrect = {i533_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i533_varReactTimeEarly) == 0
        i533_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i533_varReactTimeEarly);
        i533_varReactTimeEarly = {i533_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i533_cdf_pUpper) == 0
        i533_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i533_cdf_pUpper);
        i533_cdf_pUpper = {i533_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i533_cdf_pLower) == 0
        i533_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i533_cdf_pLower);
        i533_cdf_pLower = {i533_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i533_cdfDiff) == 0
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
    if length(i533_correctRate) == 0
        i533_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i533_correctRate);
        i533_correctRate = {i533_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i533_earlyRate) == 0
        i533_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i533_earlyRate);
        i533_earlyRate = {i533_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i533_missRate) == 0
        i533_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i533_missRate);
        i533_missRate = {i533_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i533_medianReactTimeCorrect = [i533_medianReactTimeCorrect]';
i533_medianReactTimeEarly = [i533_medianReactTimeEarly]';
i533_varReactTimeCorrect = [i533_varReactTimeCorrect]';
i533_varReactTimeEarly = [i533_varReactTimeEarly]';
i533_correctRate = [i533_correctRate]';
i533_earlyRate = [i533_earlyRate]';
i533_missRate = [i533_missRate]';
i533_cdf_pUpper = [i533_cdf_pUpper]';
i533_cdf_pLower = [i533_cdf_pLower]';
i533_cdfDiff = [i533_cdfDiff]';

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save Behavior_Learning_Variables.mat
