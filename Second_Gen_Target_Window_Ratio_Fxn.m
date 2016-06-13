% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% Second Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% Correct Window Ratio - Trials in target window / Total Correct Trials

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Second_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i527_cdfDiff = double(cell2mat(i527_cdfDiff));
i529_cdfDiff = double(cell2mat(i529_cdfDiff));
i533_cdfDiff = double(cell2mat(i533_cdfDiff));
i534_cdfDiff = double(cell2mat(i534_cdfDiff));
i535_cdfDiff = double(cell2mat(i535_cdfDiff));
i527_correctRate = double(cell2mat(i527_correctRate));
i529_correctRate = double(cell2mat(i529_correctRate));
i533_correctRate = double(cell2mat(i533_correctRate));
i534_correctRate = double(cell2mat(i534_correctRate));
i535_correctRate = double(cell2mat(i535_correctRate));

% Ratio Calculation - % of all corrects in target window
i527_windowRatio = i527_cdfDiff ./ i527_correctRate;
i529_windowRatio = i529_cdfDiff ./ i529_correctRate;
i533_windowRatio = i533_cdfDiff ./ i533_correctRate;
i534_windowRatio = i534_cdfDiff ./ i534_correctRate;
i535_windowRatio = i535_cdfDiff ./ i535_correctRate;

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1.02]; 
xLimit = [1 30];
d = [7 7];
t = [0 trainPeriod];
trainingDay = 1:trainPeriod;
type = 'HD';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i527
%%%%%%%%%%%%%%%%%%%%
mouse = '527';
i527_smoothC = smooth(i527_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,redD,5,i527_windowRatio,i527_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i529
%%%%%%%%%%%%%%%%%%%%
mouse = '529';
i529_smoothC = smooth(i529_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,orangeD,4,i529_windowRatio,i529_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i533
%%%%%%%%%%%%%%%%%%%%
mouse = '533';
i533_smoothC = smooth(i533_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,yellowD,1,i533_windowRatio,i533_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i534
%%%%%%%%%%%%%%%%%%%%
mouse = '534';
i534_smoothC = smooth(i534_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,greenD,3,i534_windowRatio,i534_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i535
%%%%%%%%%%%%%%%%%%%%
mouse = '535';
i535_trainingDay = 1:trainPeriod535;
i535_smoothC = smooth(i535_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,blueD,6,i535_windowRatio,i535_day,trainPeriod535,upper,lower,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Second Gen Mice Correct within 150-550ms / Total Correct')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Correct in 150-550ms / Total Correct')
ylim([0.3, 1.02]);
xlim(xLimit);
plot(trainingDay, i527_smoothC,'Color', redD, 'LineWidth', 3); % Plots i527 over training days
plot(trainingDay, i529_smoothC,'Color', orangeD,'LineWidth', 3); % Plots i529 over training days
plot(trainingDay, i533_smoothC,'Color', yellowD, 'LineWidth', 3);  % Plots i533 over training days
plot(trainingDay, i534_smoothC, 'Color', greenD, 'LineWidth', 3); % Plots i534 over training days
plot(i535_trainingDay, i535_smoothC,'Color', blueD,'LineWidth', 3); % Plots i535 over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.95 0.95],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Northwest','i527','i529','i533','i534','i535'); %Legend
plot(i527_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i529_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i533_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i534_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i535_day,yLimit,'Color', blueM, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
