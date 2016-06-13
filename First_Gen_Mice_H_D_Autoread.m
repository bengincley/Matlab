% Benjamin Gincley
% 2/8/2016
% Glickfeld Lab
% Original Mice Learning Indicator Analysis - Importing and Proessing Data

clear all; close all; %Clear workspace

% Universal Variables
upperBound = 600;
lowerBound = 150;
trainPeriod = 20;

%%%%%%%%%%%
%  i505  
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
cd(dr);
mouse1 = '505';
allDays = dir([dr 'data-i' mouse1 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i505 = trainPeriod; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i505
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
i505_medianReactTimeCorrect = {};
i505_medianReactTimeEarly = {};
i505_varReactTimeCorrect = {};
i505_varReactTimeEarly = {};
i505_correctRate = {};
i505_earlyRate = {};
i505_missRate = {};
i505_cdf_pUpper = {};
i505_cdf_pLower = {};
i505_cdfDiff = {};
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
    if length(i505_medianReactTimeCorrect) == 0
        i505_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i505_medianReactTimeCorrect);
        i505_medianReactTimeCorrect = {i505_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i505_medianReactTimeEarly) == 0
        i505_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i505_medianReactTimeEarly);
        i505_medianReactTimeEarly = {i505_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i505_varReactTimeCorrect) == 0
        i505_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i505_varReactTimeCorrect);
        i505_varReactTimeCorrect = {i505_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i505_varReactTimeEarly) == 0
        i505_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i505_varReactTimeEarly);
        i505_varReactTimeEarly = {i505_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i505_cdf_pUpper) == 0
        i505_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i505_cdf_pUpper);
        i505_cdf_pUpper = {i505_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i505_cdf_pLower) == 0
        i505_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i505_cdf_pLower);
        i505_cdf_pLower = {i505_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i505_cdfDiff) == 0
        i505_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i505_cdfDiff);
        i505_cdfDiff = {i505_cdfDiff{1,1:current} [dayIx(k).diffIx]};
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
    if length(i505_correctRate) == 0
        i505_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i505_correctRate);
        i505_correctRate = {i505_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i505_earlyRate) == 0
        i505_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i505_earlyRate);
        i505_earlyRate = {i505_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i505_missRate) == 0
        i505_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i505_missRate);
        i505_missRate = {i505_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i505_medianReactTimeCorrect = [i505_medianReactTimeCorrect]';
i505_medianReactTimeEarly = [i505_medianReactTimeEarly]';
i505_varReactTimeCorrect = [i505_varReactTimeCorrect]';
i505_varReactTimeEarly = [i505_varReactTimeEarly]';
i505_correctRate = [i505_correctRate]';
i505_earlyRate = [i505_earlyRate]';
i505_missRate = [i505_missRate]';
i505_cdf_pUpper = [i505_cdf_pUpper]';
i505_cdf_pLower = [i505_cdf_pLower]';
i505_cdfDiff = [i505_cdfDiff]';

%%%%%%%%%%%
%  i506  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';
cd(dr);
mouse2 = '506';
allDays = dir([dr 'data-i' mouse2 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i506 = trainPeriod; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i506
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
i506_medianReactTimeCorrect = {};
i506_medianReactTimeEarly = {};
i506_varReactTimeCorrect = {};
i506_varReactTimeEarly = {};
i506_correctRate = {};
i506_earlyRate = {};
i506_missRate = {};
i506_cdf_pUpper = {};
i506_cdf_pLower = {};
i506_cdfDiff = {};
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
    if length(i506_medianReactTimeCorrect) == 0
        i506_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i506_medianReactTimeCorrect);
        i506_medianReactTimeCorrect = {i506_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i506_medianReactTimeEarly) == 0
        i506_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i506_medianReactTimeEarly);
        i506_medianReactTimeEarly = {i506_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i506_varReactTimeCorrect) == 0
        i506_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i506_varReactTimeCorrect);
        i506_varReactTimeCorrect = {i506_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i506_varReactTimeEarly) == 0
        i506_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i506_varReactTimeEarly);
        i506_varReactTimeEarly = {i506_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i506_cdf_pUpper) == 0
        i506_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i506_cdf_pUpper);
        i506_cdf_pUpper = {i506_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i506_cdf_pLower) == 0
        i506_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i506_cdf_pLower);
        i506_cdf_pLower = {i506_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i506_cdfDiff) == 0
        i506_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i506_cdfDiff);
        i506_cdfDiff = {i506_cdfDiff{1,1:current} [dayIx(k).diffIx]};
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
    if length(i506_correctRate) == 0
        i506_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i506_correctRate);
        i506_correctRate = {i506_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i506_earlyRate) == 0
        i506_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i506_earlyRate);
        i506_earlyRate = {i506_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i506_missRate) == 0
        i506_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i506_missRate);
        i506_missRate = {i506_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i506_medianReactTimeCorrect = [i506_medianReactTimeCorrect]';
i506_medianReactTimeEarly = [i506_medianReactTimeEarly]';
i506_varReactTimeCorrect = [i506_varReactTimeCorrect]';
i506_varReactTimeEarly = [i506_varReactTimeEarly]';
i506_correctRate = [i506_correctRate]';
i506_earlyRate = [i506_earlyRate]';
i506_missRate = [i506_missRate]';
i506_cdf_pUpper = [i506_cdf_pUpper]';
i506_cdf_pLower = [i506_cdf_pLower]';
i506_cdfDiff = [i506_cdfDiff]';

%%%%%%%%%%%
%  i507 
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';
cd(dr);
mouse3 = '507';
allDays = dir([dr 'data-i' mouse3 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i507 = trainPeriod; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i507
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
i507_medianReactTimeCorrect = {};
i507_medianReactTimeEarly = {};
i507_varReactTimeCorrect = {};
i507_varReactTimeEarly = {};
i507_correctRate = {};
i507_earlyRate = {};
i507_missRate = {};
i507_cdf_pUpper = {};
i507_cdf_pLower = {};
i507_cdfDiff = {};
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
    if length(i507_medianReactTimeCorrect) == 0
        i507_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i507_medianReactTimeCorrect);
        i507_medianReactTimeCorrect = {i507_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i507_medianReactTimeEarly) == 0
        i507_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i507_medianReactTimeEarly);
        i507_medianReactTimeEarly = {i507_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end

    reactMat = double(reactMat);

    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i507_varReactTimeCorrect) == 0
        i507_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i507_varReactTimeCorrect);
        i507_varReactTimeCorrect = {i507_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i507_varReactTimeEarly) == 0
        i507_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i507_varReactTimeEarly);
        i507_varReactTimeEarly = {i507_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end

    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i507_cdf_pUpper) == 0
        i507_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i507_cdf_pUpper);
        i507_cdf_pUpper = {i507_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i507_cdf_pLower) == 0
        i507_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i507_cdf_pLower);
        i507_cdf_pLower = {i507_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i507_cdfDiff) == 0
        i507_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i507_cdfDiff);
        i507_cdfDiff = {i507_cdfDiff{1,1:current} [dayIx(k).diffIx]};
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
    if length(i507_correctRate) == 0
        i507_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i507_correctRate);
        i507_correctRate = {i507_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate
    if length(i507_earlyRate) == 0
        i507_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i507_earlyRate);
        i507_earlyRate = {i507_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i507_missRate) == 0
        i507_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i507_missRate);
        i507_missRate = {i507_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i507_medianReactTimeCorrect = [i507_medianReactTimeCorrect]';
i507_medianReactTimeEarly = [i507_medianReactTimeEarly]';
i507_varReactTimeCorrect = [i507_varReactTimeCorrect]';
i507_varReactTimeEarly = [i507_varReactTimeEarly]';
i507_correctRate = [i507_correctRate]';
i507_earlyRate = [i507_earlyRate]';
i507_missRate = [i507_missRate]';
i507_cdf_pUpper = [i507_cdf_pUpper]';
i507_cdf_pLower = [i507_cdf_pLower]';
i507_cdfDiff = [i507_cdfDiff]';


%%%%%%%%%%%
%  i508  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';
cd(dr);
mouse4 = '508';
allDays = dir([dr 'data-i' mouse4 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i508 = trainPeriod; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i508
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
i508_medianReactTimeCorrect = {};
i508_medianReactTimeEarly = {};
i508_varReactTimeCorrect = {};
i508_varReactTimeEarly = {};
i508_correctRate = {};
i508_earlyRate = {};
i508_missRate = {};
i508_cdf_pUpper = {};
i508_cdf_pLower = {};
i508_cdfDiff = {};
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
    if length(i508_medianReactTimeCorrect) == 0
        i508_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i508_medianReactTimeCorrect);
        i508_medianReactTimeCorrect = {i508_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i508_medianReactTimeEarly) == 0
        i508_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i508_medianReactTimeEarly);
        i508_medianReactTimeEarly = {i508_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i508_varReactTimeCorrect) == 0
        i508_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i508_varReactTimeCorrect);
        i508_varReactTimeCorrect = {i508_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i508_varReactTimeEarly) == 0
        i508_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i508_varReactTimeEarly);
        i508_varReactTimeEarly = {i508_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i508_cdf_pUpper) == 0
        i508_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i508_cdf_pUpper);
        i508_cdf_pUpper = {i508_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i508_cdf_pLower) == 0
        i508_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i508_cdf_pLower);
        i508_cdf_pLower = {i508_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i508_cdfDiff) == 0
        i508_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i508_cdfDiff);
        i508_cdfDiff = {i508_cdfDiff{1,1:current} [dayIx(k).diffIx]};
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
    if length(i508_correctRate) == 0
        i508_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i508_correctRate);
        i508_correctRate = {i508_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i508_earlyRate) == 0
        i508_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i508_earlyRate);
        i508_earlyRate = {i508_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i508_missRate) == 0
        i508_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i508_missRate);
        i508_missRate = {i508_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i508_medianReactTimeCorrect = [i508_medianReactTimeCorrect]';
i508_medianReactTimeEarly = [i508_medianReactTimeEarly]';
i508_varReactTimeCorrect = [i508_varReactTimeCorrect]';
i508_varReactTimeEarly = [i508_varReactTimeEarly]';
i508_correctRate = [i508_correctRate]';
i508_earlyRate = [i508_earlyRate]';
i508_missRate = [i508_missRate]';
i508_cdf_pUpper = [i508_cdf_pUpper]';
i508_cdf_pLower = [i508_cdf_pLower]';
i508_cdfDiff = [i508_cdfDiff]';

%%%%%%%%%%%
%  i509  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\HD_First_Days_Data\';
cd(dr);
mouse5 = '509';
allDays = dir([dr 'data-i' mouse5 '-*']);

%Variables for Counting
numAllDays = length(allDays);
daysUsed = {};
n_TrainingPeriod_i509 = trainPeriod; % Sets the period of training observed

% Determines files to pull from
for i = 1:n_TrainingPeriod_i509
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
i509_medianReactTimeCorrect = {};
i509_medianReactTimeEarly = {};
i509_varReactTimeCorrect = {};
i509_varReactTimeEarly = {};
i509_correctRate = {};
i509_earlyRate = {};
i509_missRate = {};
i509_cdf_pUpper = {};
i509_cdf_pLower = {};
i509_cdfDiff = {};
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
    if length(i509_medianReactTimeCorrect) == 0
        i509_medianReactTimeCorrect = {[dayIx(k).medianReactTimeCorrectIx]};
    else
        current = length(i509_medianReactTimeCorrect);
        i509_medianReactTimeCorrect = {i509_medianReactTimeCorrect{1,1:current} [dayIx(k).medianReactTimeCorrectIx]};
    end
    % Median Reaction Time for Early Trials
    dayIx(k).medianReactTimeEarlyIx = median(reactMat(dayIx(k).earlyIx));
    if length(i509_medianReactTimeEarly) == 0
        i509_medianReactTimeEarly = {[dayIx(k).medianReactTimeEarlyIx]};
    else
        current = length(i509_medianReactTimeEarly);
        i509_medianReactTimeEarly = {i509_medianReactTimeEarly{1,1:current} [dayIx(k).medianReactTimeEarlyIx]};
    end
    
    reactMat = double(reactMat);
    
    % Variance of  Reaction Time for Correct Trials
    dayIx(k).varReactTimeCorrectIx = var(reactMat(dayIx(k).correctIx));
    if length(i509_varReactTimeCorrect) == 0
        i509_varReactTimeCorrect = {[dayIx(k).varReactTimeCorrectIx]};
    else
        current = length(i509_varReactTimeCorrect);
        i509_varReactTimeCorrect = {i509_varReactTimeCorrect{1,1:current} [dayIx(k).varReactTimeCorrectIx]};
    end
    % Variance of Reaction Time for Early Trials
    dayIx(k).varReactTimeEarlyIx = var(reactMat(dayIx(k).earlyIx));
    if length(i509_varReactTimeEarly) == 0
        i509_varReactTimeEarly = {[dayIx(k).varReactTimeEarlyIx]};
    else
        current = length(i509_varReactTimeEarly);
        i509_varReactTimeEarly = {i509_varReactTimeEarly{1,1:current} [dayIx(k).varReactTimeEarlyIx]};
    end
    
    % CDF
    upSum = sum(reactMat < upperBound,2);
    lowSum = sum(reactMat < lowerBound,2);
    totalTrials = numel(reactMat);
    
    dayIx(k).pUpperIx = upSum / totalTrials;
    dayIx(k).pLowerIx = lowSum / totalTrials;
    dayIx(k).diffIx = dayIx(k).pUpperIx - dayIx(k).pLowerIx;
    % Upper p value
    if length(i509_cdf_pUpper) == 0
        i509_cdf_pUpper = {[dayIx(k).pUpperIx]};
    else
        current = length(i509_cdf_pUpper);
        i509_cdf_pUpper = {i509_cdf_pUpper{1,1:current} [dayIx(k).pUpperIx]};
    end
    % Lower p value
    if length(i509_cdf_pLower) == 0
        i509_cdf_pLower = {[dayIx(k).pLowerIx]};
    else
        current = length(i509_cdf_pLower);
        i509_cdf_pLower = {i509_cdf_pLower{1,1:current} [dayIx(k).pLowerIx]};
    end
    % Difference
    if length(i509_cdfDiff) == 0
        i509_cdfDiff = {[dayIx(k).diffIx]};
    else
        current = length(i509_cdfDiff);
        i509_cdfDiff = {i509_cdfDiff{1,1:current} [dayIx(k).diffIx]};
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
    if length(i509_correctRate) == 0
        i509_correctRate = {[dayIx(k).correctRateIx]};
    else
        current = length(i509_correctRate);
        i509_correctRate = {i509_correctRate{1,1:current} [dayIx(k).correctRateIx]};
    end
    % Early Rate 
    if length(i509_earlyRate) == 0
        i509_earlyRate = {[dayIx(k).earlyRateIx]};
    else
        current = length(i509_earlyRate);
        i509_earlyRate = {i509_earlyRate{1,1:current} [dayIx(k).earlyRateIx]};
    end
    % Miss Rate
    if length(i509_missRate) == 0
        i509_missRate = {[dayIx(k).missRateIx]};
    else
        current = length(i509_missRate);
        i509_missRate = {i509_missRate{1,1:current} [dayIx(k).missRateIx]};
    end
end

% Reorganizes into columns
i509_medianReactTimeCorrect = [i509_medianReactTimeCorrect]';
i509_medianReactTimeEarly = [i509_medianReactTimeEarly]';
i509_varReactTimeCorrect = [i509_varReactTimeCorrect]';
i509_varReactTimeEarly = [i509_varReactTimeEarly]';
i509_correctRate = [i509_correctRate]';
i509_earlyRate = [i509_earlyRate]';
i509_missRate = [i509_missRate]';
i509_cdf_pUpper = [i509_cdf_pUpper]';
i509_cdf_pLower = [i509_cdf_pLower]';
i509_cdfDiff = [i509_cdfDiff]';

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save Original_Mice_Behavior_Learning_Variables.mat
