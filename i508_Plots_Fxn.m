% Benjamin Gincley
% 3/4/2016
% Glickfeld Lab
% i508 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i508_medianReactTimeCorrect = double(cell2mat(i508_medianReactTimeCorrect));
i508_scaledVarReactTimeCorrect = double(cell2mat(i508_scaledVarReactTimeCorrect));
i508_scaledVarReactTimeEarly = double(cell2mat(i508_scaledVarReactTimeEarly));
i508_correctRate = double(cell2mat(i508_correctRate));
i508_earlyRate = double(cell2mat(i508_earlyRate));
i508_missRate = double(cell2mat(i508_missRate));
i508_cdf_pLower = double(cell2mat(i508_cdf_pLower));
i508_cdf_pUpper = double(cell2mat(i508_cdf_pUpper));
i508_cdfDiff = double(cell2mat(i508_cdfDiff));
i508_windowRatio = i508_cdfDiff ./ i508_correctRate;
i508_normalP = double(cell2mat(i508_normalP));

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
mouse = '508';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,greenD,1,i508_medianReactTimeCorrect,i508_day1,i508_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,greenD,greenL,4,i508_scaledVarReactTimeCorrect,i508_scaledVarReactTimeEarly,i508_day1,i508_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,greenD,3,i508_correctRate,i508_earlyRate,i508_missRate,i508_day1,i508_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,greenD,2,i508_cdf_pUpper,i508_cdf_pLower,i508_cdfDiff,i508_day1,i508_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,greenD,5,i508_windowRatio,i508_day1,i508_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,greenD,6,i508_normalP,i508_day1,i508_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
