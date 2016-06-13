function [] = fxnTargWinRatioPlot(mouse,color,plotLocation,windowRatio,learnDay1,learnDay2,trainPeriod,upper,lower,yLimit,xLimit,type)
%Plots various subplots for Target Window Ratio figure
%[mouse,color,plotLocation,windowRatio,learnDay,trainPeriod,upper,lower,yLimit,xLimit,type]
load Color_Library.mat;

training_Day = 1:trainPeriod;
t = [0 trainPeriod];
d = [7 7];
smoothed = smooth(windowRatio, 3, 'moving');

subplot(2,3,plotLocation) 
hold on;
title(['\fontsize{16}i',mouse,': Percent Correct inside Target Window -- ',type])
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Correct in 150-550ms / Total Correct')
ylim(yLimit);
xlim(xLimit);
plot(training_Day, smoothed,'Color', color,'LineWidth', 4); % Plots SMOOTHED ratio each day
plot(training_Day, windowRatio,'k*'); % Plots ACTUAL ratio each day
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southeast','Smoothed Ratio','Actual'); %Legend
plot(learnDay1,yLimit,'Color', cyan, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(learnDay2,yLimit,'Color', gold, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of PROFICIENCY at task
%hold off;