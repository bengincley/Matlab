function [] = fxnCorrectOverVarPlot(mouse,color,plotLocation,ratio,learnDay,trainPeriod,threshold,yLimit,xLimit,type)
%Plots various subplots for CDF figure
%[mouse,color,plotLocation,cdfUpper,cdfLower,cdfDiff,learnDay,trainPeriod,threshold,yLimit,xLimit,type]
load Color_Library.mat;

training_Day = 1:trainPeriod;
t = [0 trainPeriod];
d = [7 7];
smoothed = smooth(ratio, 3, 'moving');

subplot(2,3,plotLocation) 
hold on;
title(['\fontsize{16}i',mouse,': % Correct in 150-550ms / Early Variance -- ',type])
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}% Trials')
ylim(yLimit);
xlim(xLimit);
plot(training_Day, smoothed,'Color', blueD,'LineWidth', 4); % Plots RATIO over training days
plot(training_Day, ratio,'Color', color, 'Marker', '*','LineStyle', 'none'); % Plots ACTUAL over training days
plot(t,[0.15 0.15],'Color', cyan, 'LineStyle', ':', 'LineWidth', 2.0)
% Reference Lines
plot(t,threshold,'Color', purpleL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southeast','Smoothed','Actual'); %Legend
plot(learnDay,yLimit,'Color', color, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;