% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% First Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% React Time Variance 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i505_scaledVarReactTimeCorrect = double(cell2mat(i505_scaledVarReactTimeCorrect));
i505_scaledVarReactTimeEarly = double(cell2mat(i505_scaledVarReactTimeEarly));
i506_scaledVarReactTimeCorrect = double(cell2mat(i506_scaledVarReactTimeCorrect));
i506_scaledVarReactTimeEarly = double(cell2mat(i506_scaledVarReactTimeEarly));
i507_scaledVarReactTimeCorrect = double(cell2mat(i507_scaledVarReactTimeCorrect));
i507_scaledVarReactTimeEarly = double(cell2mat(i507_scaledVarReactTimeEarly));
i508_scaledVarReactTimeCorrect = double(cell2mat(i508_scaledVarReactTimeCorrect));
i508_scaledVarReactTimeEarly = double(cell2mat(i508_scaledVarReactTimeEarly));
i509_scaledVarReactTimeCorrect = double(cell2mat(i509_scaledVarReactTimeCorrect));
i509_scaledVarReactTimeEarly = double(cell2mat(i509_scaledVarReactTimeEarly));

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0,10]; 
xLimit = [1 20];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i505
%%%%%%%%%%%%%%%%%%%%
mouse = '505';
i505_smoothC = smooth(i505_scaledVarReactTimeCorrect, 3, 'moving');
i505_smoothE = smooth(i505_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,redD,redL,5,i505_scaledVarReactTimeCorrect,i505_scaledVarReactTimeEarly,i505_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i506
%%%%%%%%%%%%%%%%%%%%
mouse = '506';
i506_smoothC = smooth(i506_scaledVarReactTimeCorrect, 3, 'moving');
i506_smoothE = smooth(i506_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,orangeD,orangeL,4,i506_scaledVarReactTimeCorrect,i506_scaledVarReactTimeEarly,i506_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i507
%%%%%%%%%%%%%%%%%%%%
mouse = '507';
i507_smoothC = smooth(i507_scaledVarReactTimeCorrect, 3, 'moving');
i507_smoothE = smooth(i507_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,yellowD,yellowL,3,i507_scaledVarReactTimeCorrect,i507_scaledVarReactTimeEarly,i507_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i508
%%%%%%%%%%%%%%%%%%%%
mouse = '508';
i508_smoothC = smooth(i508_scaledVarReactTimeCorrect, 3, 'moving');
i508_smoothE = smooth(i508_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,greenD,greenL,1,i508_scaledVarReactTimeCorrect,i508_scaledVarReactTimeEarly,i508_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i509
%%%%%%%%%%%%%%%%%%%%
mouse = '509';
i509_smoothC = smooth(i509_scaledVarReactTimeCorrect, 3, 'moving');
i509_smoothE = smooth(i509_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,blueD,blueL,6,i509_scaledVarReactTimeCorrect,i509_scaledVarReactTimeEarly,i509_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}First Gen Mice React Time Variance')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim(yLimit);
xlim(xLimit);
plot(trainingDay, i505_smoothC,'Color', redD,'LineWidth', 3); % Plots i505 react time scaledVariance over training days
plot(trainingDay, i505_smoothE,'Color', redL,'LineWidth', 3); % Plots i505 EARLY react time scaledVariance over training days
plot(trainingDay, i506_smoothC,'Color', orangeD, 'LineWidth', 3);  % Plots i506 react time scaledVariance over training days
plot(trainingDay, i506_smoothE,'Color', orangeL,'LineWidth', 3); % Plots i506 EARLY react time scaledVariance over training days
plot(trainingDay, i507_smoothC, 'Color', yellowD, 'LineWidth', 3); % Plots i507 react time scaledVariance over training days
plot(trainingDay, i507_smoothE,'Color', yellowL,'LineWidth', 3); % Plots i507 EARLY react time scaledVariance over training days
plot(trainingDay, i508_smoothC,'Color', greenD,'LineWidth', 3); % Plots i508 react time scaledVariance over training days
plot(trainingDay, i508_smoothE,'Color', greenL,'LineWidth', 3); % Plots i508 EARLY react time scaledVariance over training days
plot(trainingDay, i509_smoothC,'Color', blueD,'LineWidth', 3); % Plots i509 react time scaledVariance over training days
plot(trainingDay, i509_smoothE,'Color', blueL,'LineWidth', 3); % Plots i509 EARLY react time scaledVariance over training days
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[2.45 2.45],'Color',purpleM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('i505 Correct','i505 Early','i506 Correct','i506 Early','i507 Correct','i507 Early','i508 Correct','i508 Early','i509 Correct','i509 Early'); %Legend
plot(i505_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i506_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i507_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i508_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i509_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
