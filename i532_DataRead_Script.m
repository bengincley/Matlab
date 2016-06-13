% Benjamin Gincley
% 2/22/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data
% i532 Data Autoread Employing Function 'Autoread'

clear all; close all; %Clear workspace

trainPeriod = 12;

%%%%%%%%%%%
%  i532   %
%%%%%%%%%%%
mouse1 = '532';
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';

outString = sprintf('i%s initializing, launching function...', mouse1);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread(mouse1,dr,trainPeriod);

% Decodes shortname variables to logical names
i532_medianReactTimeCorrect = a;
i532_medianReactTimeEarly = b;
i532_scaledVarReactTimeCorrect = c;
i532_scaledVarReactTimeEarly = d;
i532_correctRate = e;
i532_earlyRate = f;
i532_missRate = g;
i532_cdf_pUpper = h;
i532_cdf_pLower = i;
i532_cdfDiff = j;
%i532_normalH = l;
i532_normalP = l;

outString = sprintf('i%s complete', mouse1);
disp(outString)

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save i532_Variables.mat
out = sprintf('Save complete');
disp(out)