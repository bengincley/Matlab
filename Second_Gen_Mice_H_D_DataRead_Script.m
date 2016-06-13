% Benjamin Gincley
% 2/11/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data
% Second Gen Mice Data Autoread_NoIndex Employing Function 'Autoread_NoIndex'

clear all; close all; %Clear workspace

trainPeriod = 30;

%%%%%%%%%%%
%  i527   %
%%%%%%%%%%%
mouse1 = '527';
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';

outString = sprintf('i%s initializing, launching function...', mouse1);
disp(outString)

% Autoread_NoIndex Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread_NoIndex(mouse1,dr,trainPeriod);

% Decodes shortname variables to logical names
i527_medianReactTimeCorrect = a;
i527_medianReactTimeEarly = b;
i527_scaledVarReactTimeCorrect = c;
i527_scaledVarReactTimeEarly = d;
i527_correctRate = e;
i527_earlyRate = f;
i527_missRate = g;
i527_cdf_pUpper = h;
i527_cdf_pLower = i;
i527_cdfDiff = j;
%i527_normalH = l;
i527_normalP = l;

outString = sprintf('i%s complete', mouse1);
disp(outString)

%%%%%%%%%%%
%  i529   %
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';
mouse2 = '529';

outString = sprintf('i%s initializing, launching function...', mouse2);
disp(outString)

% Autoread_NoIndex Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread_NoIndex(mouse2,dr,trainPeriod);

% Decodes shortname variables to logical names
i529_medianReactTimeCorrect = a;
i529_medianReactTimeEarly = b;
i529_scaledVarReactTimeCorrect = c;
i529_scaledVarReactTimeEarly = d;
i529_correctRate = e;
i529_earlyRate = f;
i529_missRate = g;
i529_cdf_pUpper = h;
i529_cdf_pLower = i;
i529_cdfDiff = j;
%i529_normalH = l;
i529_normalP = l;

outString = sprintf('i%s complete', mouse2);
disp(outString)


%%%%%%%%%%%
%  i533   %
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
mouse3 = '533';

outString = sprintf('i%s initializing, launching function...', mouse3);
disp(outString)

% Autoread_NoIndex Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread_NoIndex(mouse3,dr,trainPeriod);

% Decodes shortname variables to logical names
i533_medianReactTimeCorrect = a;
i533_medianReactTimeEarly = b;
i533_scaledVarReactTimeCorrect = c;
i533_scaledVarReactTimeEarly = d;
i533_correctRate = e;
i533_earlyRate = f;
i533_missRate = g;
i533_cdf_pUpper = h;
i533_cdf_pLower = i;
i533_cdfDiff = j;
%i533_normalH = l;
i533_normalP = l;

outString = sprintf('i%s complete', mouse3);
disp(outString)


%%%%%%%%%%%
%  i534  
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
mouse4 = '534';

outString = sprintf('i%s initializing, launching function...', mouse4);
disp(outString)

% Autoread_NoIndex Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread_NoIndex(mouse4,dr,trainPeriod);

% Decodes shortname variables to logical names
i534_medianReactTimeCorrect = a;
i534_medianReactTimeEarly = b;
i534_scaledVarReactTimeCorrect = c;
i534_scaledVarReactTimeEarly = d;
i534_correctRate = e;
i534_earlyRate = f;
i534_missRate = g;
i534_cdf_pUpper = h;
i534_cdf_pLower = i;
i534_cdfDiff = j;
%i534_normalH = l;
i534_normalP = l;

outString = sprintf('i%s complete', mouse4);
disp(outString)

%%%%%%%%%%%
%  i535 
%%%%%%%%%%%
dr = 'Z:\home\andrew\Behavior\Data\';
mouse5 = '535';
trainPeriod535= 29;
outString = sprintf('i%s initializing, launching function...', mouse5);
disp(outString)

% Autoread_NoIndex Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l] = Autoread_NoIndex(mouse5,dr,trainPeriod535);

% Decodes shortname variables to logical names
i535_medianReactTimeCorrect = a;
i535_medianReactTimeEarly = b;
i535_scaledVarReactTimeCorrect = c;
i535_scaledVarReactTimeEarly = d;
i535_correctRate = e;
i535_earlyRate = f;
i535_missRate = g;
i535_cdf_pUpper = h;
i535_cdf_pLower = i;
i535_cdfDiff = j;
%i535_normalH = l;
i535_normalP = l;

outString = sprintf('i%s complete', mouse5);
disp(outString)

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save Second_Gen_Mice_Variables.mat
out = sprintf('Save complete');
disp(out)
