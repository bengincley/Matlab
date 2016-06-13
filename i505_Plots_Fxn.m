% Benjamin Gincley
% 3/4/2016
% Glickfeld Lab
% i505 Behavior Learning Indicator - Analyzing and Outputting
% All Plots in One Figure 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i505_medianReactTimeCorrect = double(cell2mat(i505_medianReactTimeCorrect));
i505_scaledVarReactTimeCorrect = double(cell2mat(i505_scaledVarReactTimeCorrect));
i505_scaledVarReactTimeEarly = double(cell2mat(i505_scaledVarReactTimeEarly));
i505_correctRate = double(cell2mat(i505_correctRate));
i505_earlyRate = double(cell2mat(i505_earlyRate));
i505_missRate = double(cell2mat(i505_missRate));
i505_cdf_pLower = double(cell2mat(i505_cdf_pLower));
i505_cdf_pUpper = double(cell2mat(i505_cdf_pUpper));
i505_cdfDiff = double(cell2mat(i505_cdfDiff));
i505_windowRatio = i505_cdfDiff ./ i505_correctRate;
i505_normalP = double(cell2mat(i505_normalP));

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
mouse = '505';

% Median React Time Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactMedianPlot(mouse,redD,1,i505_medianReactTimeCorrect,i505_day1,i505_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 5]; 

% React Time Variance Plot
%%%%%%%%%%%%%%%%%%%%
fxnReactVariancePlot(mouse,redD,redL,4,i505_scaledVarReactTimeCorrect,i505_scaledVarReactTimeEarly,i505_day1,i505_day2,trainPeriod,upper,lower,yLimit,xLimit,type);

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 

% Outcomes Plot
%%%%%%%%%%%%%%%%%%%%
fxnOutcomesPlot(mouse,redD,3,i505_correctRate,i505_earlyRate,i505_missRate,i505_day1,i505_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
identifierThreshold = 0.30;
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 

% CDF Plot
%%%%%%%%%%%%%%%%%%%%
fxnCDFPlot(mouse,redD,2,i505_cdf_pUpper,i505_cdf_pLower,i505_cdfDiff,i505_day1,i505_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0.4 1.01]; 

% Target Window Ratio Plot
%%%%%%%%%%%%%%%%%%%%
fxnTargWinRatioPlot(mouse,redD,5,i505_windowRatio,i505_day1,i505_day2,trainPeriod,upper,lower,yLimit,xLimit,type)

% Establishes Plot Parameters
lower_threshold = 0.05;
upper_threshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 .20]; 

% Normality p-Value Plot
%%%%%%%%%%%%%%%%%%%%
fxnNormalTestPlot(mouse,redD,6,i505_normalP,i505_day1,i505_day2,trainPeriod,upper,lower,yLimit,xLimit,type)
