%% Initialize, Load
clearvars; close all;
tic;
% Excel Info
run = '0'; date = '0601';
name = [date '_optical_' run];
metadata = '{300;0;16.64|';
cells = 'CH1048:CH1068';
% Experiment Info
dye = 'cal590';
stimfreq = 3; nstim = 9;
pulseduration = 10;
ncontrolwells = 3; framerate = 60; frameduration = 16.64;
startframe = 60; endframe = 240; totalframes = 300; 
stim_interval=framerate/stimfreq;
if pulseduration<16
    x=1:totalframes-2; interpsize=0.4; 
elseif pulseduration>16 & pulseduration<32
    x=1:totalframes-3; interpsize=0.3;
end
x2=1:totalframes; t=frameduration.*x2;
% Read in Raw API data from Excel
[num,raw] = xlsread(name,cells); % read in values
raw=replace(raw,metadata,''); raw=replace(raw,'}',''); raw=replace(raw,';',' '); % remove problematic symbols
rawAPI=char(raw); rawAPI=str2num(rawAPI); % convert to matrix
nwells=size(rawAPI,1);
figure(1); plot(t,rawAPI)
title('Raw Avg Pixel Intensity, Normalized')
xlabel('Time (ms)'); ylabel('F(t)')
%% Remove Bleedover and Interpolate
for n=0:nstim-1
    anchor=startframe+n*stim_interval; %Set anchor point as initial stim frame
    if pulseduration<16 %Delete frames during stim
        rawAPI(:,[anchor,anchor+1])=[]; 
    elseif pulseduration>16 & pulseduration<32
        rawAPI(:,[anchor,anchor+1,anchor+2])=[];
    end
    for i=1:size(raw,1)
        rawAPI_interp(i,:)=interp1(x,rawAPI(i,:),(anchor-.7:interpsize:anchor-.1),'spline'); %Interp back 2 frames
    end
    rawAPI=[rawAPI(:,1:anchor-1),rawAPI_interp,rawAPI(:,anchor:end)]; %Rewrite
end
%% Subtract Signal Decay via Baseline Interpolation
n_segment=12;
segment_interval=totalframes/n_segment; %Choose segment size to be slightly longer than CTD
base_interp=zeros(nwells,totalframes);
for k=1:nwells
    j=rawAPI(k,:); %Break rawAPI into individual well
    segmented = reshape(j,[segment_interval,n_segment]); %Reshape timecourse to isolate baseline
    [baseline(k,:),index(k,:)]=min(segmented,[],1); %Baseline = minvalue
    base_interp(k,:)=interp1(1:n_segment,baseline(k,:),0:1/segment_interval:11.99,'makima'); %Establish full-length baseline timecourse
    rawAPI(k,:)=rawAPI(k,:)-base_interp(k,:); %Subtract baseline signal from raw timecourse
    minval = min(rawAPI(k,:),[],2); %Find minimum value on timecourse
    rawAPI(k,:)=rawAPI(k,:)-minval; %Normalize minimum value to 0 to maintain proper math later on
end
figure(); plot(x2,rawAPI);
%% Plot Cleaned Raw API
for z=1:nwells
    figure(z+1)
    plot(x2,rawAPI(z,:))
end
%% Analysis for Stimulated Period
stimframes = (startframe:endframe-1); % Frame range during stimulation
peak=zeros(nstim,stim_interval); %Individual peak traces
stim_period1=startframe:endframe-1; spont_period1=1:startframe-1; spont_period2=endframe:totalframes;
if strcmp(dye,'cal590') % determine peak thresholding based on dye
    a=45;b=155;
else
    a=45;b=125;
end
for z=1:nwells
    stimperiod = rawAPI(z,stimframes); % RawAPI trace during stimulated period
    % Break apart individual peak traces per stimulus
    for n=1:nstim
        peak(n,:) = stimperiod(stim_interval*(n-1)+1:stim_interval*n); % Isolates peak traces
        if peak(n,1)>0 % Normalizes peak start values to 0
            peak(n,:)=peak(n,:)-peak(n,1);
        else
            peak(n,:)=peak(n,:)+abs(peak(n,1));
        end
    end
%     figure();plot(1:size(peak,2),peak);
    % Upsample data for greater time resolution
    upsampling_rate = 100;
    upsampled_peak=zeros(nstim,((stim_interval-1)*upsampling_rate)+1);
    for k=1:nstim
        upsampled_peak(k,:)=interp1(1:stim_interval,peak(k,:),1:1/upsampling_rate:stim_interval,'makima');
    end
    
%     figure(); plot(1:size(upsampled_peak,2),upsampled_peak); title(['Peaks ' num2str(z)]); xlabel('Frames');
    
    [peak_height,peak_height_index] = max(upsampled_peak,[],2); % Mark peak value and frame index
    CTD90_val = 0.1.*peak_height; % Define CTD90
    % Calculate frame of CTD90 per peak trace
    CTD90_frame=zeros(1,nstim);
    for n=1:nstim
        I=find(upsampled_peak(n,:)<=CTD90_val(n,1)); % Find values at or below CTD90 value threshold
        j = I>peak_height_index(n); j=I(j); % Find only indexes past max height of peak
        if j>1
            CTD90_frame(n)=min(j); % Identify minimum frame passing CTD90 value threshold
        else
            CTD90_frame(n)=0; % Set values to 0 if issues with data exist (no actual peak, etc.)
        end
    end
    CTD90_time(z,:) = frameduration*CTD90_frame/upsampling_rate;
    peak_height_index=peak_height_index';
    captured_peak(z,:) = (peak_height_index/upsampling_rate>a/frameduration & peak_height_index/upsampling_rate<b/frameduration);
    percent_captured(z,:) = sum(captured_peak(z,:))/nstim;

    % find location of peaks during stim period, calc peak to peak interval
    [stim_peaks,loc] = findpeaks(rawAPI(z,stim_period1),'MinPeakDistance',stim_interval*.75,'MinPeakHeight',0.3*max(peak_height)); 
    npeaks(z,:)=size(stim_peaks,2);
    stim_peak_loc=loc+startframe-1; 
    stim_peaktopeak_interval=diff(stim_peak_loc,[],2);
    avg_peaktopeak_stim=mean(stim_peaktopeak_interval,2);
    % find location of peaks during spontaneous periods
    [peaks1,loc1] = findpeaks(rawAPI(z,spont_period1),'MinPeakDistance',framerate/5,'MinPeakHeight',0.3*max(peak_height)); 
    npeaks1(z,:)=size(peaks1,2);
    [peaks2,loc2] = findpeaks(rawAPI(z,spont_period2),'MinPeakDistance',framerate/5,'MinPeakHeight',0.3*max(peak_height)); 
    npeaks2(z,:)=size(peaks2,2);
    loc2=loc2+endframe-1;
    if isempty(loc2)
        loc2=0;
    end
    peaktopeak_startstim=stim_peak_loc(1)-loc1(end);
    peaktopeak_endstim=loc2(1)-stim_peak_loc(end);
    % Calculate change in beat rate during stim period using peak to peak
    % interval
    tolerance = 0.15 * avg_peaktopeak_stim;
    d1 = abs(peaktopeak_startstim-avg_peaktopeak_stim);
    d2 = abs(peaktopeak_endstim-avg_peaktopeak_stim);
    inTolerance = d1 < tolerance & d2 < tolerance;
    beatrate_changed(z,:) = ~inTolerance;
    well_captured(z,:) = sum(captured_peak(z,:))>=nstim-1-(nstim/6);
    stimpeak_frames(z,1:length(loc)) = loc+startframe-1;
end

% Post-analysis
CTD90_time(CTD90_time<100)=NaN; CTD90_time(CTD90_time>500)=NaN; % Discard outliers below 100ms and above 400ms
CTD90_mean=nanmean(CTD90_time,2); 
CTD90_std=nanstd(CTD90_time,[],2);

stim_rate = npeaks/(length(stim_period1)/framerate);
spont_rate1 = npeaks1/(length(spont_period1)/framerate);
spont_rate2 = npeaks2/(length(spont_period2)/framerate);

percent_plate_captured=sum(well_captured)/(nwells-ncontrolwells);
percent_beatrate_changed=sum(beatrate_changed)/(nwells-ncontrolwells);
%% Export to Excel
% outfile=[date '_analyzed'];
% [null,wellid] = xlsread(name,'B1048:B1068'); clear null; wellid=string(cell2mat(wellid));
% 
% output(:,2) = wellid; output(:,3)=well_captured; output(:,4)=percent_captured; output(:,5)=beatrate_changed;
% output(:,6) = CTD90_mean; output(:,7) = CTD90_std; output(:,8) = spont_rate1; output(:,9) = spont_rate2; 
% output(1,1) = percent_plate_captured; 
% labels = ["% Plate Captured","WellID","WellCaptured","% Captured Peaks","Changed Rate","CTD90 Mean","CTD90 StDev","Pre Spont Rate","Post Spont Rate"];
% 
% xlswrite(outfile,labels,['Sheet' run],'A1');
% xlswrite(outfile,output,['Sheet' run],'A2');
%%
toc