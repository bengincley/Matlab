function [] = fxnReactVariancePlot(mouse,color1,color2,plotLocation,scaledVarReactTimeCorrect,scaledVarReactTimeEarly,learnDay1,learnDay2,trainPeriod,upper,lower,yLimit,xLimit,type)
%Plots various subplots for React Time Variance (Normalized) figure
%[mouse,color1,color2,plotLocation,scaledVarReactTimeCorrect,scaledVarReactTimeEarly,learnDay,trainPeriod,upper,lower,yLimit,xLimit,type]
load Color_Library.mat;

t = [0 trainPeriod];
training_Day = 1:trainPeriod;
d = [7 7];
smoothC = smooth(scaledVarReactTimeCorrect, 3, 'moving');
smoothE = smooth(scaledVarReactTimeEarly, 3, 'moving');

subplot(2,3,plotLocation)  
hold on;
title(['\fontsize{16}i',mouse,': Variance of React Time over Training -- ',type])
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim(yLimit);
xlim(xLimit);
plot(training_Day, smoothC,'Color', color1,'LineWidth', 4); % Plots AVERAGE of CORRECT react time scaledVariance over training days
plot(training_Day, smoothE,'Color', color2,'LineWidth', 4); % Plots AVERAGE of EARLY react time scaledVariance over training days
plot(training_Day, scaledVarReactTimeCorrect,'k*');% Plots ACTUAL react time scaledVariances for CORRECT over training days
plot(training_Day, scaledVarReactTimeEarly,'*', 'Color', grayD);% Plots ACTUAL react time scaledVariances for EARLY over training days
% Reference Lines
plot(t,[1 1],'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,[0.6 0.6],'Color', greenL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[2.5 2.5],'Color',blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[3 3],'Color',purpleL, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Correct','Early','Actual Correct', 'Actual Early'); %Legend
plot(learnDay1,yLimit,'Color', cyan, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(learnDay2,yLimit,'Color', gold, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of PROFICIENCY at task
hold off;