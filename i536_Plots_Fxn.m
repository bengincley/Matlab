% Benjamin Gincley
% 3/8/2016
% Glickfeld Lab
% i536 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load i536_Variables.mat

% Calculation
i536_windowRatio = i536_cdfDiff ./ i536_correctRate;

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Median React Time: Establishes General Parameters
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';
mouse = '536';

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1550]; 
xLimit = [1 trainPeriod];

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,yellowD,1,i536_medianReactTimeCorrect,i536_day1,i536_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% React Time Variance: Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,yellowD,yellowL,4,i536_scaledVarReactTimeCorrect,i536_scaledVarReactTimeEarly,i536_day1,i536_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Outcomes: Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,yellowD,3,i536_correctRate,i536_earlyRate,i536_missRate,i536_day1,i536_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% CDF: Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,yellowD,2,i536_cdf_pUpper,i536_cdf_pLower,i536_cdfDiff,i536_day1,i536_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Target Window Ratio: Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,yellowD,5,i536_windowRatio,i536_day1,i536_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Normality p-Value: Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,yellowD,6,i536_normalP,i536_day1,i536_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
