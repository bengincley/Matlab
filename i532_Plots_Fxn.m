% Benjamin Gincley
% 2/22/2016
% Glickfeld Lab
% i532 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load i532_Variables.mat

% Enables Datatype Compatibility
i532_medianReactTimeCorrect = double(cell2mat(i532_medianReactTimeCorrect));
i532_scaledVarReactTimeCorrect = double(cell2mat(i532_scaledVarReactTimeCorrect));
i532_scaledVarReactTimeEarly = double(cell2mat(i532_scaledVarReactTimeEarly));
i532_correctRate = double(cell2mat(i532_correctRate));
i532_earlyRate = double(cell2mat(i532_earlyRate));
i532_missRate = double(cell2mat(i532_missRate));
i532_cdf_pLower = double(cell2mat(i532_cdf_pLower));
i532_cdf_pUpper = double(cell2mat(i532_cdf_pUpper));
i532_cdfDiff = double(cell2mat(i532_cdfDiff));
i532_windowRatio = i532_cdfDiff ./ i532_correctRate;
i532_normalP = double(cell2mat(i532_normalP));

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

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
mouse = '532';
i532_day1 = [2 2];

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,purpleD,1,i532_medianReactTimeCorrect,i532_day1,i532_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,purpleD,purpleL,4,i532_scaledVarReactTimeCorrect,i532_scaledVarReactTimeEarly,i532_day1,i532_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,purpleD,3,i532_correctRate,i532_earlyRate,i532_missRate,i532_day1,i532_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,purpleD,2,i532_cdf_pUpper,i532_cdf_pLower,i532_cdfDiff,i532_day1,i532_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,purpleD,5,i532_windowRatio,i532_day1,i532_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,purpleD,6,i532_normalP,i532_day1,i532_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
