Success = strcmp(input.trialOutcomeCell,('success'));
ReactTime = double(cell2mat(input.reactTimesMs));
Early = strcmp(input.trialOutcomeCell,('failure'));
Miss = strcmp(input.trialOutcomeCell,('ignore'));
HoldTimeMs = double (cell2mat(input.holdTimesMs));
tOrientation = double(cell2mat(input.tGratingDirectionDeg));
CycleNum = double(cell2mat(input.nCyclesOn));
StimOff = double(cell2mat(input.tStimOffTimeMs));
Off = unique(StimOff);
Orien = unique (tOrientation);
Cycle={};
Cycle{1,1} = unique(CycleNum(StimOff==Off(1))); % first is 250ms off second is 500ms off
%Cycle{2,1}= unique(CycleNum(StimOff==Off(2)));
% RT_new = HoldTimeMs - CycleNum *(Off+100);
%
% D= ReactTime - RT_new;
% unique(D)
k=0;
j=0;
RT_success = ReactTime > input.tooFastTimeMs & ReactTime < (input.reactTimeMs - 50);
C = RT_success - Success;
unique(C);
CorrectMarkedEarly = ReactTime (C == 1)
MissMarkedCorrect = ReactTime (C == -1)
errCyc = CycleNum(C == -1)
errStim = StimOff(C == -1);
for c = 1:length(errStim);
    if errStim(c) == 250
    k=k+1;
    elseif errStim(c) == 500
    j=j+1;
    end
end
moreBlock1 = 100*(k-j)./length(errStim)
nErrors = length(errStim)
errOrien = tOrientation(C == -1);