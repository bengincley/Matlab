% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% First Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% Correct, Early, Lapse Rate

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% FIGURE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i505_correctRate = double(cell2mat(i505_correctRate));
i505_earlyRate = double(cell2mat(i505_earlyRate));
i505_missRate = double(cell2mat(i505_missRate));
i506_correctRate = double(cell2mat(i506_correctRate));
i506_earlyRate = double(cell2mat(i506_earlyRate));
i506_missRate = double(cell2mat(i506_missRate));
i507_correctRate = double(cell2mat(i507_correctRate));
i507_earlyRate = double(cell2mat(i507_earlyRate));
i507_missRate = double(cell2mat(i507_missRate));
i508_correctRate = double(cell2mat(i508_correctRate));
i508_earlyRate = double(cell2mat(i508_earlyRate));
i508_missRate = double(cell2mat(i508_missRate));
i509_correctRate = double(cell2mat(i509_correctRate));
i509_earlyRate = double(cell2mat(i509_earlyRate));
i509_missRate = double(cell2mat(i509_missRate));

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 
xLimit = [1 20];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% i505
%%%%%%%%%%%%%%%%%%%%
mouse = '505';
i505_smoothC = smooth(i505_correctRate, 3, 'moving');
i505_smoothE = smooth(i505_earlyRate, 3, 'moving');
i505_smoothM = smooth(i505_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,redD,5,i505_correctRate,i505_earlyRate,i505_missRate,i505_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i506
%%%%%%%%%%%%%%%%%%%%
mouse = '506';
i506_smoothC = smooth(i506_correctRate, 3, 'moving');
i506_smoothE = smooth(i506_earlyRate, 3, 'moving');
i506_smoothM = smooth(i506_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,orangeD,4,i506_correctRate,i506_earlyRate,i506_missRate,i506_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i507
%%%%%%%%%%%%%%%%%%%%
mouse = '507';
i507_smoothC = smooth(i507_correctRate, 3, 'moving');
i507_smoothE = smooth(i507_earlyRate, 3, 'moving');
i507_smoothM = smooth(i507_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,yellowD,3,i507_correctRate,i507_earlyRate,i507_missRate,i507_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i508
%%%%%%%%%%%%%%%%%%%%
mouse = '508';
i508_smoothC = smooth(i508_correctRate, 3, 'moving');
i508_smoothE = smooth(i508_earlyRate, 3, 'moving');
i508_smoothM = smooth(i508_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,greenD,1,i508_correctRate,i508_earlyRate,i508_missRate,i508_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i509
%%%%%%%%%%%%%%%%%%%%
mouse = '509';
i509_smoothC = smooth(i509_correctRate, 3, 'moving');
i509_smoothE = smooth(i509_earlyRate, 3, 'moving');
i509_smoothM = smooth(i509_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,blueD,6,i509_correctRate,i509_earlyRate,i509_missRate,i509_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}First Gen Mice Correct Rate over Training')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Percentage')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i505_smoothC,'Color', redD,'LineWidth', 3); % Plots i505 CORRECT rate over training days
plot(trainingDay, i506_smoothC,'Color', orangeD, 'LineWidth', 3);  % Plots i506 CORRECT rate over training days
plot(trainingDay, i507_smoothC, 'Color', yellowD, 'LineWidth', 3); % Plots i507 CORRECT rate over training days
plot(trainingDay, i508_smoothC,'Color', greenD,'LineWidth', 3); % Plots i508 CORRECT rate over training days
plot(trainingDay, i509_smoothC,'Color', blueD, 'LineWidth', 3); % Plots i509 CORRECT rate over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.3 0.3],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Northwest','i505','i506','i507','i508','i509'); %Legend
plot(i505_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i506_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i507_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i508_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i509_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
