% Benjamin Gincley
% 2/11/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Importing and Proessing Data
% First Gen Mice Data Autoread Employing Function 'Autoread'

clear all; close all; %Clear workspace

trainPeriod = 20;

%%%%%%%%%%%
%  i505   %
%%%%%%%%%%%
mouse1 = '505';
dr = 'Z:\home\andrew\Behavior\Data\';

outString = sprintf('i%s initializing, launching function...', mouse1);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l,m] = Autoread(mouse1,dr,trainPeriod);

% Decodes shortname variables to logical names
i505_medianReactTimeCorrect = a;
i505_medianReactTimeEarly = b;
i505_scaledVarReactTimeCorrect = c;
i505_scaledVarReactTimeEarly = d;
i505_correctRate = e;
i505_earlyRate = f;
i505_missRate = g;
i505_cdf_pUpper = h;
i505_cdf_pLower = i;
i505_cdfDiff = j;
i505_normalH = l;
i505_normalP = m;

outString = sprintf('i%s complete', mouse1);
disp(outString)

%%%%%%%%%%%
%  i506   %
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';
mouse2 = '506';

outString = sprintf('i%s initializing, launching function...', mouse2);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l,m] = Autoread(mouse2,dr,trainPeriod);

% Decodes shortname variables to logical names
i506_medianReactTimeCorrect = a;
i506_medianReactTimeEarly = b;
i506_scaledVarReactTimeCorrect = c;
i506_scaledVarReactTimeEarly = d;
i506_correctRate = e;
i506_earlyRate = f;
i506_missRate = g;
i506_cdf_pUpper = h;
i506_cdf_pLower = i;
i506_cdfDiff = j;
i506_normalH = l;
i506_normalP = m;

outString = sprintf('i%s complete', mouse2);
disp(outString)


%%%%%%%%%%%
%  i507   %
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';
mouse3 = '507';

outString = sprintf('i%s initializing, launching function...', mouse3);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l,m] = Autoread(mouse3,dr,trainPeriod);

% Decodes shortname variables to logical names
i507_medianReactTimeCorrect = a;
i507_medianReactTimeEarly = b;
i507_scaledVarReactTimeCorrect = c;
i507_scaledVarReactTimeEarly = d;
i507_correctRate = e;
i507_earlyRate = f;
i507_missRate = g;
i507_cdf_pUpper = h;
i507_cdf_pLower = i;
i507_cdfDiff = j;
i507_normalH = l;
i507_normalP = m;

outString = sprintf('i%s complete', mouse3);
disp(outString)


%%%%%%%%%%%
%  i508  
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';
mouse4 = '508';

outString = sprintf('i%s initializing, launching function...', mouse4);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l,m] = Autoread(mouse4,dr,trainPeriod);

% Decodes shortname variables to logical names
i508_medianReactTimeCorrect = a;
i508_medianReactTimeEarly = b;
i508_scaledVarReactTimeCorrect = c;
i508_scaledVarReactTimeEarly = d;
i508_correctRate = e;
i508_earlyRate = f;
i508_missRate = g;
i508_cdf_pUpper = h;
i508_cdf_pLower = i;
i508_cdfDiff = j;
i508_normalH = l;
i508_normalP = m;

outString = sprintf('i%s complete', mouse4);
disp(outString)

%%%%%%%%%%%
%  i509 
%%%%%%%%%%%
dr = 'S:\Analysis\Learning_Indicator\Data_Files\';
mouse5 = '509';

outString = sprintf('i%s initializing, launching function...', mouse5);
disp(outString)

% Autoread Function: Reads and Computes from Raw Data
[a,b,c,d,e,f,g,h,i,j,l,m] = Autoread(mouse5,dr,trainPeriod);

% Decodes shortname variables to logical names
i509_medianReactTimeCorrect = a;
i509_medianReactTimeEarly = b;
i509_scaledVarReactTimeCorrect = c;
i509_scaledVarReactTimeEarly = d;
i509_correctRate = e;
i509_earlyRate = f;
i509_missRate = g;
i509_cdf_pUpper = h;
i509_cdf_pLower = i;
i509_cdfDiff = j;
i509_normalH = l;
i509_normalP = m;

outString = sprintf('i%s complete', mouse5);
disp(outString)

% Returns to Home Folder
dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
save First_Gen_Mice_Variables.mat
out = sprintf('Save complete');
disp(out)