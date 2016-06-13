function [] = fxnOutcomesPlot(mouse,color,plotLocation,correctRate,earlyRate,missRate,learnDay1,learnDay2,trainPeriod,upper,lower,yLimit,xLimit,type)
%Plots various subplots for Outcomes figure
%[mouse,color,plotLocation,correctRate,earlyRate,missRate,learnDay,trainPeriod,upper,lower,yLimit,xLimit,type]
load Color_Library.mat;

training_Day = 1:trainPeriod;
t = [0 trainPeriod];
d = [7 7];
smoothC = smooth(correctRate, 3, 'moving');
smoothE = smooth(earlyRate, 3, 'moving');
smoothM = smooth(missRate, 3, 'moving');

subplot(2,3,plotLocation)  
hold on;
title(['\fontsize{16}i',mouse,': Response Outcomes over Training -- ',type])
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Percentage')
ylim(yLimit);
xlim(xLimit);
plot(training_Day, smoothC,'Color', blueM,'LineWidth', 4); % Plots CORRECT responses over training days
plot(training_Day, smoothE,'Color', greenM,'LineWidth', 4); % Plots EARLY responses over training days
plot(training_Day, smoothM,'Color', redM,'LineWidth', 4); % Plots MISS responses over training days
% Reference Lines
%plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Correct','Early','Miss'); %Legend
plot(learnDay1,yLimit,'Color', cyan, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(learnDay2,yLimit,'Color', gold, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of PROFICIENCY at task
hold off;