% Benjamin Gincley
% 3/1/2016
% Glickfeld Lab
% i506 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i506_medianReactTimeCorrect = double(cell2mat(i506_medianReactTimeCorrect));
i506_scaledVarReactTimeCorrect = double(cell2mat(i506_scaledVarReactTimeCorrect));
i506_scaledVarReactTimeEarly = double(cell2mat(i506_scaledVarReactTimeEarly));
i506_correctRate = double(cell2mat(i506_correctRate));
i506_earlyRate = double(cell2mat(i506_earlyRate));
i506_missRate = double(cell2mat(i506_missRate));
i506_cdf_pLower = double(cell2mat(i506_cdf_pLower));
i506_cdf_pUpper = double(cell2mat(i506_cdf_pUpper));
i506_cdfDiff = double(cell2mat(i506_cdfDiff));
i506_windowRatio = i506_cdfDiff ./ i506_correctRate;
i506_normalP = double(cell2mat(i506_normalP));

% Starts new figure
nfig = nfig +1; 
fig = figure(nfig); 
figPos = [5 45 2190 1320];
set(fig, 'Position', figPos); 

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1550]; 
xLimit = [1 trainPeriod];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';
mouse = '506';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,orangeD,1,i506_medianReactTimeCorrect,i506_day1,i506_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,orangeD,orangeL,4,i506_scaledVarReactTimeCorrect,i506_scaledVarReactTimeEarly,i506_day1,i506_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,orangeD,3,i506_correctRate,i506_earlyRate,i506_missRate,i506_day1,i506_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,orangeD,2,i506_cdf_pUpper,i506_cdf_pLower,i506_cdfDiff,i506_day1,i506_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,orangeD,5,i506_windowRatio,i506_day1,i506_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,orangeD,6,i506_normalP,i506_day1,i506_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
