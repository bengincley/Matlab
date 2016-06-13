% Benjamin Gincley
% 3/8/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data
% i536 Data Autoread Employing Function 'Autoread'

clear all; close all; %Clear workspace

trainPeriod = 11;

%%%%%%%%%%%
%  i536   %
%%%%%%%%%%%
mouse1 = '536';
dr = 'Z:\home\andrew\Behavior\Data\';
outString = sprintf('i%s initializing, launching function...', mouse1);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread_NoIndex(mouse1,dr,trainPeriod);

% Decodes shortname variables to logical names
i536_medianReactTimeCorrect = a;
i536_medianReactTimeEarly = b;
i536_scaledVarReactTimeCorrect = c;
i536_scaledVarReactTimeEarly = d;
i536_correctRate = e;
i536_earlyRate = f;
i536_missRate = g;
i536_cdf_pUpper = h;
i536_cdf_pLower = i;
i536_cdfDiff = j;
%i536_normalH = l;
i536_normalP = l;

outString = sprintf('i%s complete', mouse1);
disp(outString)

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save i536_Variables.mat
out = sprintf('Save complete');
disp(out)