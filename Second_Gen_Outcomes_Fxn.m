% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% Second Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% Correct, Early, Lapse Rate

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Second_Gen_Mice_Variables.mat

% FIGURE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i527_correctRate = double(cell2mat(i527_correctRate));
i527_earlyRate = double(cell2mat(i527_earlyRate));
i527_missRate = double(cell2mat(i527_missRate));
i529_correctRate = double(cell2mat(i529_correctRate));
i529_earlyRate = double(cell2mat(i529_earlyRate));
i529_missRate = double(cell2mat(i529_missRate));
i533_correctRate = double(cell2mat(i533_correctRate));
i533_earlyRate = double(cell2mat(i533_earlyRate));
i533_missRate = double(cell2mat(i533_missRate));
i534_correctRate = double(cell2mat(i534_correctRate));
i534_earlyRate = double(cell2mat(i534_earlyRate));
i534_missRate = double(cell2mat(i534_missRate));
i535_correctRate = double(cell2mat(i535_correctRate));
i535_earlyRate = double(cell2mat(i535_earlyRate));
i535_missRate = double(cell2mat(i535_missRate));

% Establishes Plot Parameters
lower_threshold = 0.25;
upper_threshold = 0.35;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 
xLimit = [1 30];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% i527
%%%%%%%%%%%%%%%%%%%%
mouse = '527';
i527_smoothC = smooth(i527_correctRate, 3, 'moving');
i527_smoothE = smooth(i527_earlyRate, 3, 'moving');
i527_smoothM = smooth(i527_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,redD,5,i527_correctRate,i527_earlyRate,i527_missRate,i527_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i529
%%%%%%%%%%%%%%%%%%%%
mouse = '529';
i529_smoothC = smooth(i529_correctRate, 3, 'moving');
i529_smoothE = smooth(i529_earlyRate, 3, 'moving');
i529_smoothM = smooth(i529_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,orangeD,4,i529_correctRate,i529_earlyRate,i529_missRate,i529_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i533
%%%%%%%%%%%%%%%%%%%%
mouse = '533';
i533_smoothC = smooth(i533_correctRate, 3, 'moving');
i533_smoothE = smooth(i533_earlyRate, 3, 'moving');
i533_smoothM = smooth(i533_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,yellowD,1,i533_correctRate,i533_earlyRate,i533_missRate,i533_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i534
%%%%%%%%%%%%%%%%%%%%
mouse = '534';
i534_smoothC = smooth(i534_correctRate, 3, 'moving');
i534_smoothE = smooth(i534_earlyRate, 3, 'moving');
i534_smoothM = smooth(i534_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,greenD,3,i534_correctRate,i534_earlyRate,i534_missRate,i534_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i535
%%%%%%%%%%%%%%%%%%%%
mouse = '535';
i535_trainingDay = 1:trainPeriod535;
i535_smoothC = smooth(i535_correctRate, 3, 'moving');
i535_smoothE = smooth(i535_earlyRate, 3, 'moving');
i535_smoothM = smooth(i535_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,blueD,6,i535_correctRate,i535_earlyRate,i535_missRate,i535_day,trainPeriod535,upper,lower,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Second Gen Mice Correct Rate over Training')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Percentage')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i527_smoothC,'Color', redD,'LineWidth', 3); % Plots i527 CORRECT rate over training days
plot(trainingDay, i529_smoothC,'Color', orangeD, 'LineWidth', 3);  % Plots i529 CORRECT rate over training days
plot(trainingDay, i533_smoothC, 'Color', yellowD, 'LineWidth', 3); % Plots i533 CORRECT rate over training days
plot(trainingDay, i534_smoothC,'Color', greenD,'LineWidth', 3); % Plots i534 CORRECT rate over training days
plot(i535_trainingDay, i535_smoothC,'Color', blueD, 'LineWidth', 3); % Plots i535 CORRECT rate over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.3 0.3],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Northwest','i527','i529','i533','i534','i535'); %Legend
plot(i527_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i529_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i533_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i534_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i535_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
