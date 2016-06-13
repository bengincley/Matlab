% Benjamin Gincley
% 3/4/2016
% Glickfeld Lab
% i535 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Second_Gen_Mice_Variables.mat

% Calculation
i535_windowRatio = i535_cdfDiff ./ i535_correctRate;

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1550]; 
xLimit = [1 trainPeriod535];
t = [0 trainPeriod535];
d = [7 7];
trainingDay = 1:trainPeriod535;
type = 'HD';
mouse = '535';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,blueD,1,i535_medianReactTimeCorrect,i535_day1,i535_day2,trainPeriod535,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,blueD,blueL,4,i535_scaledVarReactTimeCorrect,i535_scaledVarReactTimeEarly,i535_day1,i535_day2,trainPeriod535,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,blueD,3,i535_correctRate,i535_earlyRate,i535_missRate,i535_day1,i535_day2,trainPeriod535,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,blueD,2,i535_cdf_pUpper,i535_cdf_pLower,i535_cdfDiff,i535_day1,i535_day2,trainPeriod535,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,blueD,5,i535_windowRatio,i535_day1,i535_day2,trainPeriod535,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,blueD,6,i535_normalP,i535_day1,i535_day2,trainPeriod535,upper,lower,yLimit,xLimit,type)
