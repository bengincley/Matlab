% Benjamin Gincley
% 3/4/2016
% Glickfeld Lab
% i525 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% Enables Datatype Compatibility
i525_medianReactTimeCorrect = double(cell2mat(i525_medianReactTimeCorrect));
i525_scaledVarReactTimeCorrect = double(cell2mat(i525_scaledVarReactTimeCorrect));
i525_scaledVarReactTimeEarly = double(cell2mat(i525_scaledVarReactTimeEarly));
i525_correctRate = double(cell2mat(i525_correctRate));
i525_earlyRate = double(cell2mat(i525_earlyRate));
i525_missRate = double(cell2mat(i525_missRate));
i525_cdf_pLower = double(cell2mat(i525_cdf_pLower));
i525_cdf_pUpper = double(cell2mat(i525_cdf_pUpper));
i525_cdfDiff = double(cell2mat(i525_cdfDiff));
i525_windowRatio = i525_cdfDiff ./ i525_correctRate;
%i525_normalP = double(cell2mat(i525_normalP));

% Starts new figure
nfig = nfig +1; 
fig = figure(nfig); 
figPos = [0 40 2205 1325];
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
type = 'FS';
mouse = '525';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,greenD,1,i525_medianReactTimeCorrect,i525_day1,i525_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,greenD,greenL,4,i525_scaledVarReactTimeCorrect,i525_scaledVarReactTimeEarly,i525_day1,i525_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,greenD,3,i525_correctRate,i525_earlyRate,i525_missRate,i525_day1,i525_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,greenD,2,i525_cdf_pUpper,i525_cdf_pLower,i525_cdfDiff,i525_day1,i525_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,greenD,5,i525_windowRatio,i525_day1,i525_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
%{
% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,greenD,6,i525_normalP,i525_day1,i525_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
%}