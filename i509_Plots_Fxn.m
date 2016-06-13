% Benjamin Gincley
% 3/4/2016
% Glickfeld Lab
% i509 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i509_medianReactTimeCorrect = double(cell2mat(i509_medianReactTimeCorrect));
i509_scaledVarReactTimeCorrect = double(cell2mat(i509_scaledVarReactTimeCorrect));
i509_scaledVarReactTimeEarly = double(cell2mat(i509_scaledVarReactTimeEarly));
i509_correctRate = double(cell2mat(i509_correctRate));
i509_earlyRate = double(cell2mat(i509_earlyRate));
i509_missRate = double(cell2mat(i509_missRate));
i509_cdf_pLower = double(cell2mat(i509_cdf_pLower));
i509_cdf_pUpper = double(cell2mat(i509_cdf_pUpper));
i509_cdfDiff = double(cell2mat(i509_cdfDiff));
i509_windowRatio = i509_cdfDiff ./ i509_correctRate;
i509_normalP = double(cell2mat(i509_normalP));

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
mouse = '509';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,blueD,1,i509_medianReactTimeCorrect,i509_day1,i509_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,blueD,blueL,4,i509_scaledVarReactTimeCorrect,i509_scaledVarReactTimeEarly,i509_day1,i509_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,blueD,3,i509_correctRate,i509_earlyRate,i509_missRate,i509_day1,i509_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,blueD,2,i509_cdf_pUpper,i509_cdf_pLower,i509_cdfDiff,i509_day1,i509_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,blueD,5,i509_windowRatio,i509_day1,i509_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,blueD,6,i509_normalP,i509_day1,i509_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
