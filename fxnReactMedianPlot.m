function [] = fxnReactMedianPlot(mouse,color,plotLocation,medianReactTime,learnDay1,learnDay2,trainPeriod,upper,lower,yLimit,xLimit,type)
%Plots various subplots of figure
%[mouse,color,plotLocation,medianReactTime,learnDay,trainPeriod,upper,lower,yLimit,xLimit,type]
load Color_Library.mat;

t = [0 trainPeriod];
training_Day = 1:trainPeriod;
d = [7 7];
smoothed = smooth(medianReactTime, 3, 'moving');

subplot(2,3,plotLocation);  
hold on;
title(['\fontsize{16}i',mouse,': Median React Time over Training -- ',type])
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim(yLimit);
xlim(xLimit);
plot(training_Day, smoothed,'Color', color,'LineWidth', 4); % Plots AVERAGE of median react time over training days
plot(training_Day, medianReactTime,'k*'); % Plots ACTUAL median react times
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Moving Average','Actual','Threshold'); %Legend
plot(learnDay1,yLimit,'Color', cyan, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(learnDay2,yLimit,'Color', gold, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of PROFICIENCY at task
hold off;