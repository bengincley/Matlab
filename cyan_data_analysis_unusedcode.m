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
% rawAPI_interp=interp1(x,rawAPI(1,:),(74.3:0.4:74.7),'makima');
% rawAPI=[rawAPI(1:74),rawAPI_interp,rawAPI(75:end)];

% Attempted to fit a line to data to subtract decay, found that isolating
% baseline frames and interpolating then subtracting worked better
% for n=1:size(rawAPI,1)
%     [fito,gof,output] = fit(t',rawAPI(n,:)','poly1');
%     fitline=rawAPI(n,:)-output.residuals';
%     offset=min(fitline)-min(rawAPI(n,:)); %fitline=fitline+offset;
%     rawAPI(n,:)=rawAPI(n,:)-fitline+offset;
% end

% Attempted to find spontaneous rate before discovering findpeaks
% upsampling_rate = 10;
%     for k=1:nwells
%         upsampled_rawAPI(k,:)=interp1(1:totalframes,rawAPI(k,:),[1:1/upsampling_rate:totalframes],'makima');
%     end
% figure(); plot(1:length(upsampled_rawAPI),upsampled_rawAPI(1,:));
% %h = 0.001;       % step size
% h=1; 
% %X = -pi:h:pi;    % domain
% %f = sin(X);      % range
% first_deriv = diff(upsampled_rawAPI(1,:))/h;   % first derivative
% second_deriv = diff(first_deriv)/h;   % second derivative
% jj = 1:size(first_deriv,2); kk=(1:size(second_deriv,2));
% figure(); plot(jj,first_deriv,jj,upsampled_rawAPI(1,1:length(jj)))
% figure(); plot(kk,second_deriv,kk,upsampled_rawAPI(1,1:length(kk)))
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
%     CTD(n,:)=indendp1-indstartp1;
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
% figure(); plot(1:max(CTD+1),peak_trace)

% Notes/work for finding spont peaks
% spont1frames=1:startframe-1;
% n=1;
% spont1period=rawAPI(n,spont1frames);
% peakrange=framerate/spontrate;
% [firstpeakval,firstpeakindex]=max(spont1period(1:peakrange),[],2);

% Try upsampling rawAPI, then derivative with step size equal to new
% "frames", then logical for within very close range of 0, like 0.005 or
% something - spontanous beat rate should be half the number of times this
% happens (crosses 0 twice per peak)
