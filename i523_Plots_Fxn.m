% Benjamin Gincley
% 3/4/2016
% Glickfeld Lab
% i523 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% Enables Datatype Compatibility
i523_medianReactTimeCorrect = double(cell2mat(i523_medianReactTimeCorrect));
i523_scaledVarReactTimeCorrect = double(cell2mat(i523_scaledVarReactTimeCorrect));
i523_scaledVarReactTimeEarly = double(cell2mat(i523_scaledVarReactTimeEarly));
i523_correctRate = double(cell2mat(i523_correctRate));
i523_earlyRate = double(cell2mat(i523_earlyRate));
i523_missRate = double(cell2mat(i523_missRate));
i523_cdf_pLower = double(cell2mat(i523_cdf_pLower));
i523_cdf_pUpper = double(cell2mat(i523_cdf_pUpper));
i523_cdfDiff = double(cell2mat(i523_cdfDiff));
i523_windowRatio = i523_cdfDiff ./ i523_correctRate;
%i523_normalP = double(cell2mat(i523_normalP));

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
type = 'FS';
mouse = '523';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,yellowD,1,i523_medianReactTimeCorrect,i523_day1,i523_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,yellowD,yellowL,4,i523_scaledVarReactTimeCorrect,i523_scaledVarReactTimeEarly,i523_day1,i523_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,yellowD,3,i523_correctRate,i523_earlyRate,i523_missRate,i523_day1,i523_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,yellowD,2,i523_cdf_pUpper,i523_cdf_pLower,i523_cdfDiff,i523_day1,i523_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,yellowD,5,i523_windowRatio,i523_day1,i523_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
%{
% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,yellowD,6,i523_normalP,i523_day1,i523_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
%}