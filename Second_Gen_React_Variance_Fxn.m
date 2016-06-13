% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% Second Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% React Time Variance 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Second_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i527_scaledVarReactTimeCorrect = double(cell2mat(i527_scaledVarReactTimeCorrect));
i527_scaledVarReactTimeEarly = double(cell2mat(i527_scaledVarReactTimeEarly));
i529_scaledVarReactTimeCorrect = double(cell2mat(i529_scaledVarReactTimeCorrect));
i529_scaledVarReactTimeEarly = double(cell2mat(i529_scaledVarReactTimeEarly));
i533_scaledVarReactTimeCorrect = double(cell2mat(i533_scaledVarReactTimeCorrect));
i533_scaledVarReactTimeEarly = double(cell2mat(i533_scaledVarReactTimeEarly));
i534_scaledVarReactTimeCorrect = double(cell2mat(i534_scaledVarReactTimeCorrect));
i534_scaledVarReactTimeEarly = double(cell2mat(i534_scaledVarReactTimeEarly));
i535_scaledVarReactTimeCorrect = double(cell2mat(i535_scaledVarReactTimeCorrect));
i535_scaledVarReactTimeEarly = double(cell2mat(i535_scaledVarReactTimeEarly));

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0,10]; 
xLimit = [1 30];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i527
%%%%%%%%%%%%%%%%%%%%
mouse = '527';
i527_smoothC = smooth(i527_scaledVarReactTimeCorrect, 3, 'moving');
i527_smoothE = smooth(i527_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,redD,redL,5,i527_scaledVarReactTimeCorrect,i527_scaledVarReactTimeEarly,i527_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i529
%%%%%%%%%%%%%%%%%%%%
mouse = '529';
i529_smoothC = smooth(i529_scaledVarReactTimeCorrect, 3, 'moving');
i529_smoothE = smooth(i529_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,orangeD,orangeL,4,i529_scaledVarReactTimeCorrect,i529_scaledVarReactTimeEarly,i529_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i533
%%%%%%%%%%%%%%%%%%%%
mouse = '533';
i533_smoothC = smooth(i533_scaledVarReactTimeCorrect, 3, 'moving');
i533_smoothE = smooth(i533_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,yellowD,yellowL,1,i533_scaledVarReactTimeCorrect,i533_scaledVarReactTimeEarly,i533_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i534
%%%%%%%%%%%%%%%%%%%%
mouse = '534';
i534_smoothC = smooth(i534_scaledVarReactTimeCorrect, 3, 'moving');
i534_smoothE = smooth(i534_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,greenD,greenL,3,i534_scaledVarReactTimeCorrect,i534_scaledVarReactTimeEarly,i534_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i535
%%%%%%%%%%%%%%%%%%%%
mouse = '535';
i535_trainingDay = 1:trainPeriod535;
i535_smoothC = smooth(i535_scaledVarReactTimeCorrect, 3, 'moving');
i535_smoothE = smooth(i535_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,blueD,blueL,6,i535_scaledVarReactTimeCorrect,i535_scaledVarReactTimeEarly,i535_day,trainPeriod535,upper,lower,yLimit,xLimit,type);

% Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Second Gen Mice React Time Variance')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim(yLimit);
xlim(xLimit);
plot(trainingDay, i527_smoothC,'Color', redD,'LineWidth', 3); % Plots i527 react time scaledVariance over training days
plot(trainingDay, i527_smoothE,'Color', redL,'LineWidth', 3); % Plots i527 EARLY react time scaledVariance over training days
plot(trainingDay, i529_smoothC,'Color', orangeD, 'LineWidth', 3);  % Plots i529 react time scaledVariance over training days
plot(trainingDay, i529_smoothE,'Color', orangeL,'LineWidth', 3); % Plots i529 EARLY react time scaledVariance over training days
plot(trainingDay, i533_smoothC, 'Color', yellowD, 'LineWidth', 3); % Plots i533 react time scaledVariance over training days
plot(trainingDay, i533_smoothE,'Color', yellowL,'LineWidth', 3); % Plots i533 EARLY react time scaledVariance over training days
plot(trainingDay, i534_smoothC,'Color', greenD,'LineWidth', 3); % Plots i534 react time scaledVariance over training days
plot(trainingDay, i534_smoothE,'Color', greenL,'LineWidth', 3); % Plots i534 EARLY react time scaledVariance over training days
plot(i535_trainingDay, i535_smoothC,'Color', blueD,'LineWidth', 3); % Plots i535 react time scaledVariance over training days
plot(i535_trainingDay, i535_smoothE,'Color', blueL,'LineWidth', 3); % Plots i535 EARLY react time scaledVariance over training days
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[2.45 2.45],'Color',purpleM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('i527 Correct','i527 Early','i529 Correct','i529 Early','i533 Correct','i533 Early','i534 Correct','i534 Early','i535 Correct','i535 Early'); %Legend
plot(i527_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i529_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i533_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i534_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i535_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
