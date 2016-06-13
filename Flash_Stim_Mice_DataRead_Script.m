% Benjamin Gincley
% 2/17/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data
% Flashing Stim Mice Data Autoread_Flashing Employing Function 'Autoread_Flashing'

clear all; close all; %Clear workspace

trainPeriod = 30;

%%%%%%%%%%%
%  i521   %
%%%%%%%%%%%
mouse1 = '521';
dr = 'S:\Analysis\Learning_Indicator\Flash_Stim_Data\';

outString = sprintf('i%s initializing, launching function...', mouse1);
disp(outString)

% Autoread_Flashing Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j] = Autoread_Flashing(mouse1,dr,trainPeriod);

% Decodes shortname variables to logical names
i521_medianReactTimeCorrect = a;
i521_medianReactTimeEarly = b;
i521_scaledVarReactTimeCorrect = c;
i521_scaledVarReactTimeEarly = d;
i521_correctRate = e;
i521_earlyRate = f;
i521_missRate = g;
i521_cdf_pUpper = h;
i521_cdf_pLower = i;
i521_cdfDiff = j;

outString = sprintf('i%s complete', mouse1);
disp(outString)

%%%%%%%%%%%
%  i522   %
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Flash_Stim_Data\';
mouse2 = '522';

outString = sprintf('i%s initializing, launching function...', mouse2);
disp(outString)

% Autoread_Flashing Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j] = Autoread_Flashing(mouse2,dr,trainPeriod);

% Decodes shortname variables to logical names
i522_medianReactTimeCorrect = a;
i522_medianReactTimeEarly = b;
i522_scaledVarReactTimeCorrect = c;
i522_scaledVarReactTimeEarly = d;
i522_correctRate = e;
i522_earlyRate = f;
i522_missRate = g;
i522_cdf_pUpper = h;
i522_cdf_pLower = i;
i522_cdfDiff = j;

outString = sprintf('i%s complete', mouse2);
disp(outString)


%%%%%%%%%%%
%  i523   %
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Flash_Stim_Data\';
mouse3 = '523';

outString = sprintf('i%s initializing, launching function...', mouse3);
disp(outString)

% Autoread_Flashing Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j] = Autoread_Flashing(mouse3,dr,trainPeriod);

% Decodes shortname variables to logical names
i523_medianReactTimeCorrect = a;
i523_medianReactTimeEarly = b;
i523_scaledVarReactTimeCorrect = c;
i523_scaledVarReactTimeEarly = d;
i523_correctRate = e;
i523_earlyRate = f;
i523_missRate = g;
i523_cdf_pUpper = h;
i523_cdf_pLower = i;
i523_cdfDiff = j;

outString = sprintf('i%s complete', mouse3);
disp(outString)


%%%%%%%%%%%
%  i525  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Flash_Stim_Data\';
mouse4 = '525';

outString = sprintf('i%s initializing, launching function...', mouse4);
disp(outString)

% Autoread_Flashing Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j] = Autoread_Flashing(mouse4,dr,trainPeriod);

% Decodes shortname variables to logical names
i525_medianReactTimeCorrect = a;
i525_medianReactTimeEarly = b;
i525_scaledVarReactTimeCorrect = c;
i525_scaledVarReactTimeEarly = d;
i525_correctRate = e;
i525_earlyRate = f;
i525_missRate = g;
i525_cdf_pUpper = h;
i525_cdf_pLower = i;
i525_cdfDiff = j;

outString = sprintf('i%s complete', mouse4);
disp(outString)

%%%%%%%%%%%
%  i526 
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Flash_Stim_Data\';
mouse5 = '526';

outString = sprintf('i%s initializing, launching function...', mouse5);
disp(outString)

% Autoread_Flashing Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j] = Autoread_Flashing(mouse5,dr,trainPeriod);

% Decodes shortname variables to logical names
i526_medianReactTimeCorrect = a;
i526_medianReactTimeEarly = b;
i526_scaledVarReactTimeCorrect = c;
i526_scaledVarReactTimeEarly = d;
i526_correctRate = e;
i526_earlyRate = f;
i526_missRate = g;
i526_cdf_pUpper = h;
i526_cdf_pLower = i;
i526_cdfDiff = j;

outString = sprintf('i%s complete', mouse5);
disp(outString)

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save Flash_Stim_Mice_Variables.mat
out = sprintf('Save complete');
disp(out)