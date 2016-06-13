function [] = fxnCDFPlot(mouse,color,plotLocation,cdfUpper,cdfLower,cdfDiff,learnDay1,learnDay2,trainPeriod,threshold,yLimit,xLimit,type)
%Plots various subplots for CDF figure
%[mouse,color,plotLocation,cdfUpper,cdfLower,cdfDiff,learnDay,trainPeriod,threshold,yLimit,xLimit,type]
load Color_Library.mat;

training_Day = 1:trainPeriod;
t = [0 trainPeriod];
d = [7 7];
smoothU = smooth(cdfUpper, 3, 'moving');
smoothD = smooth(cdfDiff, 3, 'moving');

subplot(2,3,plotLocation) 
hold on;
title(['\fontsize{16}i',mouse,': % Trials < React Time over Training -- ',type])
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}% Trials')
ylim(yLimit);
xlim(xLimit);
plot(training_Day, smoothU,'Color', blueD,'LineWidth', 4); % Plots UPPER Value [550ms] over training days
plot(training_Day, smoothD,'Color', color,'LineWidth', 4); % Plots LOWER Value [150ms] over training days
plot(training_Day, cdfDiff,'k*','LineStyle', 'none'); % Plots DIFFERENCE over training days
plot(t,[0.55 0.55],'Color', gold, 'LineStyle', ':', 'LineWidth', 2.0)
% Reference Lines
plot(t,threshold,'Color', cyan, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,[0.25 0.25],'Color', cyan, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southeast','<550ms','150-550ms','150-550ms'); %Legend
plot(learnDay1,yLimit,'Color', cyan, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(learnDay2,yLimit,'Color', gold, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of PROFICIENCY at task
hold off;