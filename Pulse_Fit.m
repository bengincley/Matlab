%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theoretical Non-Adaptive Response Analysis %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
WideField_PairedPulse_DataSets
%% Select Specific Experiments to Run
disp('Loading Session.')
disp('Assign "e=[experiment you would like to run]". Assign "e=0" if you would like to run all experiments.');
disp('Then type "return" to resume program');
keyboard;
if e == 0,
    a = 1; aa = size(expt,2);
else 
    a = e; aa = e;
end

%% Analysis Iterated for Each Experiment Selected
for iexp = a:aa
    date = expt(iexp).date;
    mouse = ['i' expt(iexp).SubNum];
    disp([date ' ' mouse])
    time_mat = expt(iexp).time_mat;
    nrun = expt(iexp).runs;
    g_ind = expt(iexp).g_ind;
    xObj = expt(iexp).obj;
    frame_rate = expt(iexp).frame_rate;
    if expt(iexp).mult_loc == 1 && xObj > 10
        loc1 = expt(iexp).img_loc1;
        loc2 = expt(iexp).img_loc2;
        area_list = char(loc1, loc2);
        areas = sprintf('%s_%s', loc1, loc2);
        order_msg = sprintf('%s, %s', loc1, loc2);
    elseif expt(iexp).mult_loc == 0 && xObj >10
        loc1 = expt(iexp).img_loc1;
        area_list = char(loc1);
        areas = sprintf('%s', loc1);
        order_msg = sprintf('%s', loc1);
    else 
        loc1 = char('V1', 'LM', 'AL', 'RL', 'AM', 'PM');
        area_list = loc1;
        areas = sprintf('HVAs');
        order_msg = sprintf('V1, LM, AL, RL, AM, PM');
    end
    clc
    disp('Expect Analysis For:')
    opening_msg = sprintf('%s | %s | %s | %s | %dx Magnification', mouse, date, expt_name, order_msg, xObj);
    disp(opening_msg)
    disp('Note: Be sure to run the Paired Pulse Analysis for this day before beginning.');
    disp('Type "return" or press [^] if this information is correct and you would like to proceed...');
    keyboard
    col_mat = char('k', 'b');

    fn_base = fullfile(anal_root, [date '_' mouse]);
    fn_output_home = fullfile(output_root, [date '_' mouse '_' areas]);
    fn_output = fullfile(fn_output_home, [date '_' mouse '_' expt_name '_' areas]);
    fn_int = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_interpData.mat']);
    fn_pulse = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_pulseData.mat']);
    fn_res = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_resData.mat']);
    fn_mask = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
    fn_flash = fullfile(fn_base, [date '_' mouse '_FS5_' areas '_exptData.mat']);
%% Check if Proper Directories Exist for Mouse and Experiment
    disp('Checking for previously saved files...')
    if isdir(fn_base)
        disp('Analysis Directory found for this mouse.')
    else
        mkdir(fn_base) 
        disp('New Analysis Directory created for this mouse.')
    end
    if isdir(fn_output_home)
        disp('Output Directory found for this mouse.')
    else 
        mkdir(fn_output_home)
        disp('New Output Directory created for this mouse.')
    end
    if isdir(fn_output)
        disp('Output Directory found for this experiment.')
    else 
        mkdir(fn_output)
        disp('New Output Directory created for this experiment.')
    end
%% Check if ROIs have been selected previously, allow jump straight to figures.
    if exist(fn_res,'file')
        load(fn_res)
        load(fn_mask)
        disp('Previously saved processed data found, skipping to figures.')
    else
        if exist(fn_int,'file')
            disp('Interpolated data found. Loading file...')
            load(fn_int)
            preframes = 15;
            %preframes_b1 = 63;
            %preframes_b2 = 91;
            postframes_b1 = 80;
            postframes_b2 = 115;
            %bdata_pulse_b1 = NaN(sz(1), sz(2), preframes+postframes_b1, ntrials);
            %gdata_pulse_b1 = NaN(sz(1), sz(2), preframes+postframes_b1, ntrials);
            bdata_pulse_b2 = NaN(sz(1), sz(2), preframes+postframes_b2, ntrials);
            gdata_pulse_b2 = NaN(sz(1), sz(2), preframes+postframes_b2, ntrials);
            disp('Sorting trials/frames...')
            for itrial = 1:ntrials
                if holdTimes(itrial) < 10000;
                    if ((stimOff(itrial)==4000) && ((cLeverDown(itrial)+postframes_b2)<=sz(3)))
                        bdata_pulse_b2(:,:,:,itrial) = bdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes_b2-1);
                        gdata_pulse_b2(:,:,:,itrial) = gdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes_b2-1);
                    end
                end
            end 
            bdata_base_F = mean(bdata_pulse_b2(:,:,1:preframes,:),3);
            gdata_base_F = mean(gdata_pulse_b2(:,:,1:preframes,:),3);
            bdata_dFoverF_b2 = dF_Over_F_fun(bdata_base_F, bdata_pulse_b2);            
            gdata_dFoverF_b2 = dF_Over_F_fun(gdata_base_F, gdata_pulse_b2);         
            
            pulse_b2 = bdata_dFoverF_b2-gdata_dFoverF_b2;
            pulse_b1 = pulse_b2(:,:,1:preframes+postframes_b1,:);
            disp('Saving Data...')
            clear bdata_base_F gdata_base_F bdata_dFoverF_b2 gdata_dFoverF_b2 pulse_b1 pulse_b2
            %save(fn_pulse, 'postframes_b1', 'postframes_b2', 'preframes', 'pulse_b1', 'pulse_b2', '-v7.3');
            disp('Interpolated image data saved.')
        else
            disp('Interpolated data not found. Please run Paired Pulse TC Analysis first.')
        end
%% Assess Pulses and Process dF/F for each ROI selected
        if exist(fn_mask,'file')
            load(fn_mask)
            disp('Previously saved processed data found, skipping to figures.')
        else
            disp('Mask not found. Please run Paired Pulse TC Analysis first.')
        end 
        disp('Processing ROIs...')
        pulse_tc_b1 = reshape(stackGetTimeCourses(reshape(pulse_b1,[sz(1) sz(2) (preframes+postframes_b1)*ntrials]),mask_cell), [(preframes+postframes_b1) ntrials size(area_list,1)]);
        pulse_tc_b2 = reshape(stackGetTimeCourses(reshape(pulse_b2,[sz(1) sz(2) (preframes+postframes_b2)*ntrials]),mask_cell), [(preframes+postframes_b2) ntrials size(area_list,1)]);

        ind = find(stimOff == 4000);
        
        mean_tc_b1 = nanmean(pulse_tc_b1,2);
        mean_tc_b2 = nanmean(pulse_tc_b2,2);
        baseline_mean = mean(nanmean(pulse_tc_b1(1:preframes,ind)));
                
        mean_tc_b1 = mean_tc_b1 - baseline_mean;
        mean_tc_b2 = mean_tc_b2 - baseline_mean;
        
        
        b1_shift(95,5) = 0;
        b2_shift(130,5) = 0;
        for n = 1:5
            b1_shift(:,n) = circshift(mean_tc_b1,11*(n-1));
            b2_shift(:,n) = circshift(mean_tc_b2,18*(n-1));
            if n >= 2
                b1_shift(1:(11*(n-1)),n) = 0;
                b2_shift(1:(18*(n-1)),n) = 0;
            end
        end
%% Beta Calculation
        load(fn_flash)
        % Block 1
        ind1 = find(stimOff == 250);
        flash_tc_b1 = tc_sub(:,ind1);
        mean_flash_tc_b1 = nanmean(flash_tc_b1,2);
        mean_flash_tc_shift_b1 = circshift(mean_flash_tc_b1,1);
        mean_flash_tc_shift_b1(1) = 0;
        flash_to_fit_b1 = mean_flash_tc_shift_b1(1:74);
        
        betas_b1 = b1_shift(1:74,:)\flash_to_fit_b1;
        betas_norm_b1 = betas_b1 / betas_b1(1)
        beta_val_b1 = [1.15; .65; .66; .59; .75]; % Guesses: 1.15, 0.65, 0.66, 0.59, 0.75
        
        beta_shift_b1(95,5) = 0;
        no_adapt_b1(95,5) = 0;
            for n=1:5
                no_adapt_b1(:,n) = b1_shift(:,n).*1;
                beta_shift_b1(:,n) = b1_shift(:,n) .* betas_b1(n);
            end
        no_adapt_b1_sum = sum(no_adapt_b1,2);
        pulses_to_fit_b1 = beta_shift_b1(1:74,:);
        sum_pulses_b1 = sum(pulses_to_fit_b1,2);
        
        % Block 2
        ind2 = find(stimOff == 500);
        flash_tc_b2 = tc_sub(:,ind2);
        mean_flash_tc_b2 = nanmean(flash_tc_b2,2);
        mean_flash_tc_shift_b2 = circshift(mean_flash_tc_b2,1);
        mean_flash_tc_shift_b2(1) = 0;
        flash_to_fit_b2 = mean_flash_tc_shift_b2(1:109);
        
        betas_b2 = b2_shift(1:109,:)\flash_to_fit_b2;
        betas_norm_b2 = betas_b2 / betas_b2(1)
        beta_val_b2 = [1.15; .65; .66; .59; .75]; % Guesses: 1.15, 0.65, 0.66, 0.59, 0.75
        
        beta_shift_b2(130,5) = 0;
        no_adapt_b2(130,5) = 0;
            for n=1:5
                no_adapt_b2(:,n) = b2_shift(:,n).*1;
                beta_shift_b2(:,n) = b2_shift(:,n) .* betas_b2(n);
            end
        no_adapt_b2_sum = sum(no_adapt_b2,2);
        pulses_to_fit_b2 = beta_shift_b2(1:109,:);
        sum_pulses_b2 = sum(pulses_to_fit_b2,2);
     end
%    save(fn_tc, 'base_tc_sub', 'test_tc_sub', 'test_tc_sub_off', 'base_tc_sub_off', 'offs', 'stimOff', 'base_win', 'resp_win')
%    disp('Data saved in the proper directory for this mouse.')
%% Plots 
     disp('Plotting Figures...')

     figure;
         hold on; 
         plot(flash_to_fit_b1,'LineWidth',2,'Color','k'); 
         plot(sum_pulses_b1,'LineWidth',2,'Color','b');
         plot(no_adapt_b1_sum(1:74));
         plot(b1_shift(1:74,:),'LineStyle','--')
         xlim([1 74]);
         xlabel('Frames')
         ylabel('dF/F')
         title([mouse ' - ' date ' - Area ' area_list ' - Pulse Fit - Block 1'])
         hold off;
     figure;
         hold on; 
         plot(flash_to_fit_b2,'LineWidth',2,'Color','k'); 
         plot(sum_pulses_b2,'LineWidth',2,'Color','b');
         plot(no_adapt_b2_sum(1:109));
         plot(b2_shift(1:109,:),'LineStyle','--')
         xlim([1 109]);
         xlabel('Frames')
         ylabel('dF/F')
         title([mouse ' - ' date ' - Area ' area_list ' - Pulse Fit - Block 2'])
         hold off;
%     % Establish maximum luminance response to base stimulus
%     base_all = zeros(1,length(offs));
%     for ia = 1:size(area_list,1)
%         for io = 1:length(offs)
%             temp = base_tc_sub_off{io};
%             base_all(io,ia) = squeeze(nanmean(temp(:,:,ia),2)).*1.25;
%         end
%     end
%     base_max = max(base_all,[],1);
%     % Overlay of Base/Test Pulse Responses
%     for ia = 1:size(area_list,1)
%         f = figure; set(f, 'Position', [270 195 1500 1150]);
%         for io = 1:length(offs)
%             ind1 = find(stimOff == offs(io));
%             subplot(2,3,io)
%             shadedErrorBar(1:size(base_tc_sub,1), nanmean(base_tc_sub(:,ind1,ia),2), nanstd(base_tc_sub(:,ind1,ia),[],2)./sqrt(sum(~isnan(squeeze(base_tc_sub(1,ind1,1))),2)),'-k');
%             hold on
%             shadedErrorBar(1:size(test_tc_sub,1), nanmean(test_tc_sub(:,ind1,ia),2)-nanmean(nanmean(test_tc_sub(base_win,ind1,ia),2),1), nanstd(test_tc_sub(:,ind1,1),[],2)./sqrt(sum(~isnan(squeeze(test_tc_sub(1,ind1,1))),2)),'-r');
%             title(num2str(offs(io)))
%             ylim([-0.02 1.75*base_max(:,ia)])
%         end
%         suptitle([mouse ' ' date '- Area ' area_list(ia,:) '- Paired pulse TCs']) 
%         savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_timecourse.fig']));  
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_timecourse.png']), '-dpng');
%     end
%     % Change in Response for Each ISI
%     for ia = 1:size(area_list,1)
%         f = figure; set(f, 'Position', [270 195 1500 1150]);
%         for io = 1:length(offs)
%             norm = bsxfun(@rdivide, test_tc_sub_off{io}, nanmean(base_tc_sub_off{io},2));
%             errorbar(offs(io), nanmean(norm(:,:,ia),2), nanstd(norm(:,:,ia),[],2)./sqrt(size(norm,2)), 'ok')
%             hold on
%         end
%         ylim([0 1.25])
%         xlabel('Time (msec)')
%         ylabel('Normalized amplitude')
%         suptitle([mouse ' ' date '- Area ' area_list(ia,:) '- PP recovery']) 
%         savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_change_resp.fig']));
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_change_resp.png']), '-dpng');
%     end
%     disp('Figures saved in the proper directory for this mouse.')
end