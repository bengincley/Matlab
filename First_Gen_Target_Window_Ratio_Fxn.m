% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% First Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% Correct Window Ratio - Trials in target window / Total Correct Trials

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i505_cdfDiff = double(cell2mat(i505_cdfDiff));
i506_cdfDiff = double(cell2mat(i506_cdfDiff));
i507_cdfDiff = double(cell2mat(i507_cdfDiff));
i508_cdfDiff = double(cell2mat(i508_cdfDiff));
i509_cdfDiff = double(cell2mat(i509_cdfDiff));
i505_correctRate = double(cell2mat(i505_correctRate));
i506_correctRate = double(cell2mat(i506_correctRate));
i507_correctRate = double(cell2mat(i507_correctRate));
i508_correctRate = double(cell2mat(i508_correctRate));
i509_correctRate = double(cell2mat(i509_correctRate));

% Ratio Calculation - % of all corrects in target window
i505_windowRatio = i505_cdfDiff ./ i505_correctRate;
i506_windowRatio = i506_cdfDiff ./ i506_correctRate;
i507_windowRatio = i507_cdfDiff ./ i507_correctRate;
i508_windowRatio = i508_cdfDiff ./ i508_correctRate;
i509_windowRatio = i509_cdfDiff ./ i509_correctRate;

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1.02]; 
xLimit = [1 20];
d = [7 7];
t = [0 trainPeriod];
trainingDay = 1:trainPeriod;
type = 'HD';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i505
%%%%%%%%%%%%%%%%%%%%
mouse = '505';
i505_smoothC = smooth(i505_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,redD,5,i505_windowRatio,i505_day,trainPeriod,upper,lower,yLimit,xLimit,type)
hold off;

% i506
%%%%%%%%%%%%%%%%%%%%
mouse = '506';
i506_smoothC = smooth(i506_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,orangeD,4,i506_windowRatio,i506_day,trainPeriod,upper,lower,yLimit,xLimit,type)
plot([12 12],yLimit,'Color', purpleL, 'LineStyle', '--', 'LineWidth', 2.0); %Plots day reactTime set to 0.55s
hold off;

% i507
%%%%%%%%%%%%%%%%%%%%
mouse = '507';
i507_smoothC = smooth(i507_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,yellowD,3,i507_windowRatio,i507_day,trainPeriod,upper,lower,yLimit,xLimit,type)
plot([25 25],yLimit,'Color', purpleL, 'LineStyle', '--', 'LineWidth', 2.0); %Plots day reactTime set to 0.55s
hold off;

% i508
%%%%%%%%%%%%%%%%%%%%
mouse = '508';
i508_smoothC = smooth(i508_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,greenD,1,i508_windowRatio,i508_day,trainPeriod,upper,lower,yLimit,xLimit,type)
plot([18 18],yLimit,'Color', purpleL, 'LineStyle', '--', 'LineWidth', 2.0); %Plots day reactTime set to 0.55s
hold off;

% i509
%%%%%%%%%%%%%%%%%%%%
mouse = '509';
i509_smoothC = smooth(i509_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,blueD,6,i509_windowRatio,i509_day,trainPeriod,upper,lower,yLimit,xLimit,type)
plot([27 27],yLimit,'Color', purpleL, 'LineStyle', '--', 'LineWidth', 2.0); %Plots day reactTime set to 0.55s
hold off;

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}First Gen Mice Correct within 150-550ms / Total Correct')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Correct in 150-550ms / Total Correct')
ylim([0.3, 1.02]);
xlim(xLimit);
plot(trainingDay, i505_smoothC,'Color', redD, 'LineWidth', 3); % Plots i505 over training days
plot(trainingDay, i506_smoothC,'Color', orangeD,'LineWidth', 3); % Plots i506 over training days
plot(trainingDay, i507_smoothC,'Color', yellowD, 'LineWidth', 3);  % Plots i507 over training days
plot(trainingDay, i508_smoothC, 'Color', greenD, 'LineWidth', 3); % Plots i508 over training days
plot(trainingDay, i509_smoothC,'Color', blueD,'LineWidth', 3); % Plots i509 over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.95 0.95],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southwest','i505','i506','i507','i508','i509'); %Legend
plot(i505_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i506_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i507_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i508_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i509_day,yLimit,'Color', blueM, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
