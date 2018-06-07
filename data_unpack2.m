%% Initialize, Load
clearvars;
% Excel Info
name = '0503_optical_5';
metadata = '{300;0;16.64|';
cells = 'CH1048:CH1052';
% Experiment Info
framerate = 60; 
startframe = 60; endframe = 180; totalframes = 300; 
frameduration = 16.64;
stimfreq = 4; stim_interval=framerate/stimfreq;
nstim = 8;
x=[1:totalframes-2]; x2=1:totalframes;
t=frameduration.*x2;
% Read in Raw API data from Excel
[num,raw] = xlsread(name,cells); % read in values
raw=replace(raw,metadata,''); raw=replace(raw,'}',''); raw=replace(raw,';',' '); % remove problematic symbols
rawAPI=char(raw); rawAPI=str2num(rawAPI); % convert to matrix
nwells=size(rawAPI,1);
% figure(7); plot(x2,rawAPI(4,:))
%% Remove Bleedover and Interpolate
    for n=0:nstim-1
        anchor=startframe+n*stim_interval;
        rawAPI(:,[anchor,anchor+1])=[];
        for i=1:size(raw,1)
            rawAPI_interp(i,:)=interp1(x,rawAPI(i,:),(anchor-.7:0.4:anchor-.3),'spline');
        end
        rawAPI=[rawAPI(:,1:anchor-1),rawAPI_interp,rawAPI(:,anchor:end)];
    end
%% Subtract Signal Decay via Baseline Interpolation
segment_interval=25; n_segment=totalframes/segment_interval;
for k=1:nwells
    j=rawAPI(k,:);
    segmented = reshape(j,[segment_interval,n_segment]);
    [baseline(k,:),index(k,:)]=min(segmented,[],1);
    base_interp(k,:)=interp1(1:n_segment,baseline(k,:),[0:1/segment_interval:11.99],'spline');
    rawAPI(k,:)=rawAPI(k,:)-base_interp(k,:);
    figure(); plot(base_interp(k,:))
end
% figure(6); plot(1:12,baseline)
%% Plot Cleaned Raw API
for n=1:nwells
    figure(n)
    plot(x2,rawAPI(n,:))
end
%% Analysis
% Tasks: 
%   Subdivide sessions into Spontaneous/Stimulated/Spontaneous
%   Break traces into individual peaks
%   Upsample number of points within peaks for better resolution
%   Calculate values such as APD10/25/30/50/90, Upstroke Velocity, etc.
%   Output values in table, graph
%   Replace number values with values scalable with framerate (e.g.
%   indstartp1+10
stimframes = (startframe:1:endframe-1); % Frame range during stimulation
for z=1:nwells
    stimperiod = rawAPI(z,stimframes); % RawAPI trace during stimulated period
    % Break apart individual peaks per stimulus
    for n=1:nstim
        peak(n,:) = stimperiod(stim_interval*(n-1)+1:stim_interval*n);
        if peak(n,1)>0
            peak(n,:)=peak(n,:)-peak(n,1);
        else
            peak(n,:)=peak(n,:)+abs(peak(n,1));
        end
    end
    % Upsample data for greater time resolution
    upsampling_rate = 10;
    for k=1:nstim
        upsampled_peak(k,:)=interp1(1:stim_interval,peak(k,:),[1:1/upsampling_rate:stim_interval],'spline');
    end
    figure(); plot(1:size(upsampled_peak,2),upsampled_peak);
    [peak_height,peak_height_index] = max(upsampled_peak,[],2); % Mark peak value and frame index
    APD90_val = 0.1.*peak_height; % Define APD90
    % Calculate frame of APD90 per peak trace
    for n=1:nstim
        I=find(upsampled_peak(n,:)<=APD90_val(n,1)); % Find values at or below APD90 value threshold
        j=find(I>peak_height_index(n)); j=I(j); % Find indexes past peak
        if j>1
            APD90_frame(n)=min(j); % Identify minimum frame passing APD90 value threshold
        else
            APD90_frame(n)=0 % Set values to 0 if issues with data exist (no actual peak, etc.)
        end
    end
    APD90_time(z,:) = frameduration*APD90_frame/upsampling_rate;
end
% Post-analysis
APD90_time(APD90_time<100)=NaN;
APD90_mean=nanmean(APD90_time,2); 
APD90_std=nanstd(APD90_time,[],2)

%% Analysis for Spontaneous Period
% f=1;
% peak_trace=zeros(3,22);
% for n=1:3
%     if n>=3
%         f=n*f;
%     elseif n==2
%         f=peak_length+2;
%     end
%     [startp1,indstartp1] = min(rawAPI(1,f:20+f))
%     [maxp1,indmaxp1] = max(rawAPI(1,indstartp1+f:indstartp1+f+10)); indmaxp1=indmaxp1+indstartp1-1;
%     [endp1,indendp1] = min(rawAPI(1,indmaxp1:indstartp1+f+20)); indendp1=indendp1+indmaxp1-1;
%     APD(n,:)=indendp1-indstartp1;
%     peak_trace1 = rawAPI(1,indstartp1:indendp1); 
%     if size(peak_trace1,2)<size(peak_trace(n,:),2)
%         peak_trace1(end+1:22)=0;
%     end
%     peak_trace(n,:)=peak_trace1;
%     peak_length=indendp1-indstartp1;
%     if peak_trace(n,1)<0
%         peak_trace(n,:)=peak_trace(n,:)+abs(peak_trace(n,1));
%     else
%     end
%     % Try Segmentation like with interpolation instead?
%     % start with peaks after stimuli, then work out spontaneous periods
% end
% figure(); plot(1:max(APD+1),peak_trace)

%% Graveyard
% Attempted to find local minima and maxima, then just went with specific
% frames given the frames of stimulations are known
% localmax=max(rawAPI(:,59:62),[],2)
% localmax1=rawAPI(:,60)
% localmax2=rawAPI(:,61)
% diff1=localmax1-rawAPI(:,59)
% diff2=localmax2-rawAPI(:,62)
% rawAPI(:,60)=localmax1-diff1
% rawAPI(:,61)=localmax2-diff2
% rawAPI(1,60:61)=rawAPI_interp;
% base1=rawAPI(:,[20,35,52]);
% base2=rawAPI(:,[21,36,53]);
% basedrop = base1-base2;
% avedrop = mean(basedrop,2)
% localmax=rawAPI(:,[61:20:240]);
% localmin=rawAPI(:,[62:20:240]);
% diff= localmax - localmin

% Used to remove and interpolate through bleedover frames - original
% hardcode version
% rawAPI(:,[75,76])=[];
% rawAPI_interp=interp1(x,rawAPI(1,:),(74.3:0.4:74.7),'spline');
% rawAPI=[rawAPI(1:74),rawAPI_interp,rawAPI(75:end)];

% Attempted to fit a line to data to subtract decay, found that isolating
% baseline frames and interpolating then subtracting worked better
% for n=1:size(rawAPI,1)
%     [fito,gof,output] = fit(t',rawAPI(n,:)','poly1');
%     fitline=rawAPI(n,:)-output.residuals';
%     offset=min(fitline)-min(rawAPI(n,:)); %fitline=fitline+offset;
%     rawAPI(n,:)=rawAPI(n,:)-fitline+offset;
% end
