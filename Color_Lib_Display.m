% Benjamin Gincley
% Color Library Display

clear all; close all; nfig = 0; %Cleared workspace and started fig counter

load Color_Library.mat

% Color Test
x = [0 1];
y1 = [1 1];
y2 = [2 2];
y3 = [3 3];
y4 = [4 4];
y5 = [5 5];
y6 = [6 6];
y7 = [7 7];
y8 = [8 8];
y9 = [9 9];
y10 = [10 10];
y11 = [11 11];
y12 = [12 12];
y13 = [13 13];
y14 = [14 14];
y15 = [15 15];
y16 = [16 16];
y17 = [17 17];
y18 = [18 18];
y19 = [19 19];
y20 = [20 20];
y21 = [21 21];
nfig = nfig +1;
figure(nfig)
hold on;
title('\fontsize{16}Color Library')
ylabel('\fontsize{14}Color')
xlim([0 0.95]);
ylim([0.5 21.5]);
plot(x,y18,'Color', redD, 'LineWidth', 32.0)
plot(x,y19,'Color', redM, 'LineWidth', 32.0)
plot(x,y20,'Color', redL, 'LineWidth', 32.0)
plot(x,y16,'Color', orangeD, 'LineWidth', 32.0)
plot(x,y17,'Color', orangeL, 'LineWidth', 32.0)
plot(x,y14,'Color', yellowD, 'LineWidth', 32.0)
plot(x,y15,'Color', yellowL, 'LineWidth', 32.0)
plot(x,y11,'Color', greenD, 'LineWidth', 32.0)
plot(x,y12,'Color', greenM, 'LineWidth', 32.0)
plot(x,y13,'Color', greenL, 'LineWidth', 32.0)
plot(x,y8,'Color', blueD, 'LineWidth', 32.0)
plot(x,y9,'Color', blueM, 'LineWidth', 32.0)
plot(x,y10,'Color', blueL, 'LineWidth', 32.0)
plot(x,y5,'Color', purpleD, 'LineWidth', 32.0)
plot(x,y6,'Color', purpleM, 'LineWidth', 32.0)
plot(x,y7,'Color', purpleL, 'LineWidth', 32.0)
plot(x,y2,'Color', cyan, 'LineWidth', 32.0)
plot(x,y1,'Color', magenta, 'LineWidth', 32.0)
plot(x,y4,'Color', grayL, 'LineWidth', 32.0)
plot(x,y3,'Color', grayD, 'LineWidth', 32.0)
plot(x,y21,'Color', gold, 'LineWidth', 32.0)
hold off;