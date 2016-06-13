%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paired Pulse Pulse-Fit Analysis %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
WideField_PairedPulse_DataSets
%% Select Specific Experiments to Run
disp('Loading Session.')
disp('Assign "e=[experiment you would like to run]". Assign "e=0" if you would like to run all experiments.');
disp('Then type "return" to pulseume program');
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
    disp('Type "return" or ppulses [^] if this information is correct and you would like to proceed...');
    keyboard
    col_mat = char('k', 'b');

    fn_base = fullfile(anal_root, [date '_' mouse]);
    fn_output_home = fullfile(output_root, [date '_' mouse '_' areas]);
    fn_output = fullfile(fn_output_home, [date '_' mouse '_' expt_name '_' areas]);
    fn_int = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_interpData.mat']);
    fn_pulse = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_pulseData.mat']);
    fn_mask = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
    fn_pp = fullfile(fn_base, [date '_' mouse '_PP5_' areas '_exptData.mat']);
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
%% Check if ROIs have been selected previously, allow jump straight to figupulse.
    if exist(fn_pulse,'file')
        load(fn_pulse)
        load(fn_mask)
        disp('Previously saved processed data found, skipping to figupulse.')
    else
        if exist(fn_int,'file')
            disp('Interpolated data found. Loading file...')
            load(fn_int)
            preframes = 15;
            postframes_p1 = 45;
            postframes_p2 = 45;            
            postframes_p3 = 65;
            %postframes_p4 = 95;
            %postframes_p5 = 145;
            bdata_pulse_p3 = NaN(sz(1), sz(2), preframes+postframes_p3, ntrials);
            gdata_pulse_p3 = NaN(sz(1), sz(2), preframes+postframes_p3, ntrials);
            disp('Sorting trials/frames...')
            for itrial = 1:ntrials
                if holdTimes(itrial) < 10000;
                    if ((stimOff(itrial)==4000) && ((cLeverDown(itrial)+postframes_p3)<=sz(3)))
                        bdata_pulse_p3(:,:,:,itrial) = bdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes_p3-1);
                        gdata_pulse_p3(:,:,:,itrial) = gdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes_p3-1);
                    end
                end
            end 
            bdata_base_F_p3 = mean(bdata_pulse_p3(:,:,1:preframes,:),3);
            gdata_base_F_p3 = mean(gdata_pulse_p3(:,:,1:preframes,:),3);
            bdata_dFoverF_p3 = dF_Over_F_fun(bdata_base_F_p3, bdata_pulse_p3);            
            gdata_dFoverF_p3 = dF_Over_F_fun(gdata_base_F_p3, gdata_pulse_p3);         
            
            pulse_p3 = bdata_dFoverF_p3-gdata_dFoverF_p3;
            pulse_p1 = pulse_p3(:,:,1:preframes+postframes_p1,:);
            pulse_p2 = pulse_p3(:,:,1:preframes+postframes_p2,:);
            %pulse_p5 = pulse_p5(:,:,1:preframes+postframes_p5,:);
            %pulse_p4 = pulse_p5(:,:,1:preframes+postframes_p4,:);
            %disp('Saving Data...')
            clear bdata_base_F gdata_base_F bdata_dFoverF_p3 gdata_dFoverF_p3 
            %save(fn_pulse, 'postframes_b1', 'postframes_p5', 'preframes', 'pulse_b1', 'pulse_p5', '-v7.3');
            %disp('Interpolated image data saved.')
        else
            disp('Interpolated data not found. Please run Paired Pulse TC Analysis first.')
        end
%% Assess Pulses and Process dF/F for each ROI selected
        if exist(fn_mask,'file')
            load(fn_mask)
            disp('Previously saved processed data found.')
        else
            disp('Mask not found. Please run Paired Pulse TC Analysis first.')
        end 
        disp('Processing ROIs...')
        pulse_tc_p1 = reshape(stackGetTimeCourses(reshape(pulse_p1,[sz(1) sz(2) (preframes+postframes_p1)*ntrials]),mask_cell), [(preframes+postframes_p1) ntrials size(area_list,1)]);
        pulse_tc_p2 = reshape(stackGetTimeCourses(reshape(pulse_p2,[sz(1) sz(2) (preframes+postframes_p2)*ntrials]),mask_cell), [(preframes+postframes_p2) ntrials size(area_list,1)]);
        pulse_tc_p3 = reshape(stackGetTimeCourses(resehape(pulse_p3,[sz(1) sz(2) (preframes+postframes_p3)*ntrials]),mask_cell), [(preframes+postframes_p3) ntrials size(area_list,1)]);
%         pulse_tc_p4 = pulsehape(stackGetTimeCourses(pulsehape(pulse_p4,[sz(1) sz(2) (preframes+postframes_p4)*ntrials]),mask_cell), [(preframes+postframes_p4) ntrials size(area_list,1)]);
%         pulse_tc_p5 = pulsehape(stackGetTimeCourses(pulsehape(pulse_p5,[sz(1) sz(2) (preframes+postframes_p5)*ntrials]),mask_cell), [(preframes+postframes_p5) ntrials size(area_list,1)]);
        clear pulse_p1 pulse_p2 pulse_p3 
        ind = find(stimOff == 4000);
        
        baseline_mean = mean(nanmean(pulse_tc_p1(1:preframes,ind)));
        mean_tc_p1 = nanmean(pulse_tc_p1,2) - baseline_mean;
        mean_tc_p2 = nanmean(pulse_tc_p2,2) - baseline_mean;
        mean_tc_p3 = nanmean(pulse_tc_p3,2) - baseline_mean;
%         mean_tc_p4 = nanmean(pulse_tc_p4,2) - baseline_mean;
%         mean_tc_p5 = nanmean(pulse_tc_p5,2) - baseline_mean;
%         mean_tc_p5(121:end,1) = 0;
               
        shift{1}(60,2) = 0;
        shift{2}(60,2) = 0;
        shift{3}(80,2) = 0;
%         p4_shift(110,2) = 0;
%         p5_shift(160,2) = 0;
        for n = 1:2
            shift{1}(:,n) = circshift(mean_tc_p1,11*(n-1));
            shift{2}(:,n) = circshift(mean_tc_p2,(18*(n-1))-1);
            shift{3}(:,n) = circshift(mean_tc_p3,33*(n-1));
%             p4_shift(:,n) = circshift(mean_tc_p4,61*(n-1));
%             p5_shift(:,n) = circshift(mean_tc_p5,121*(n-1));
            if n == 2
                shift{1}(1:(11*(n-1)),n) = 0;
                shift{2}(1:((18*(n-1))-1),n) = 0;
                shift{3}(1:(33*(n-1)),n) = 0;
%                 p4_shift(1:(61*(n-1)),n) = 0;
%                 p5_shift(1:(121*(n-1)),n) = 0;
            end
        end
%% Beta Calculation
        load(fn_pp)
        for m = 1:3
            offs_m{m} = find(stimOff == 250*(2^(m-1)));
            pp_base_tc{m} = base_tc_sub(:,offs_m{m});
            pp_test_tc{m} = test_tc_sub(:,offs_m{m});
            mean_pp_base_tc{m} = nanmean(pp_base_tc{m},2);
            mean_pp_test_tc{m} = nanmean(pp_test_tc{m},2);
            pp_to_fit{m} = mean_pp_base_tc{m}(1:60);
            
            if m==3
                betas{m} = shift{m}(1:80,:)\pp_to_fit{m};
            else
                betas{m} = shift{m}(1:60,:)\pp_to_fit{m};
            end
            
            betas_norm{m} = betas{m}(:) ./ betas{m}(1,1);
            
            for n=1:2
                beta_shift{m}(:,n) = betas{m}(n) * shift{m}(:,n);
            end
            sum_pulses{m} = sum(beta_shift{m},2);
            betas_v(m) = betas_norm{m}(2);
        end
%         mean_pp_tc_shift_p1 = circshift(mean_pp_tc_p1,1);
%         mean_pp_tc_shift_p1(1) = 0;
        %pp_to_fit{4} = mean_pp_test_tc{4}(1:90);
        %pp_to_fit{5} = mean_pp_test_tc{5}(1:160);        
       
        %betas(:,4) = p1_shift(1:90,:)\pp_to_fit_p1;
        %betas(:,5) = p1_shift(1:160,:)\pp_to_fit_p1;
   
%         no_adapt_b1_sum = sum(no_adapt_b1,2);
%         pulses_to_fit_b1 = beta_shift(1:74,:);        
     end
    save(fn_pulse, 'shift', 'offs_m', 'pp_to_fit', 'base_tc_sub', 'base_tc_sub', 'sum_pulses', 'betas_norm', 'beta_shift', 'stimOff')
    disp('Data saved in the proper directory for this mouse.')
%% Plots 
     disp('Plotting Figupulse...')
     for m=1:3
         figure;
             hold on; 
             plot(pp_to_fit{m},'LineWidth',2,'Color','k'); 
             plot(sum_pulses{m},'LineWidth',2,'Color','b');
             plot(shift{m},'LineStyle','--')
             xlim([1 60]);
             xlabel('Frames')
             ylabel('dF/F')
             title([mouse ' - ' date ' - Area ' area_list ' - Pulse Fit'])
             hold off;
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list '_pulse_fit.fig']));  
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list '_pulse_fit.png']), '-dpng');
     end
     figure;
     hold on;
     bar(betas_v);
     ylim([0 1]);
     set(gca,'XTick',1:3)
     set(gca,'XTickLabel', {'250ms', '500ms', '1000ms'})
     xlabel('Pulse Interval');
     ylabel('Percent Recovery');
     title([mouse ' - ' date ' - Area ' area_list ' - Pulse Recovery Beta Values']);
     hold off
     savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list '_betas.fig']));  
     print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list '_betas.png']), '-dpng');
     
%     % Establish maximum luminance pulseponse to base stimulus
%     base_all = zeros(1,length(offs));
%     for ia = 1:size(area_list,1)
%         for io = 1:length(offs)
%             temp = base_tc_sub_off{io};
%             base_all(io,ia) = squeeze(nanmean(temp(:,:,ia),2)).*1.25;
%         end
%     end
%     base_max = max(base_all,[],1);
%     % Overlay of Base/Test Pulse pulseponses
%     for ia = 1:size(area_list,1)
%         f = figure; set(f, 'Position', [270 195 1600 1160]);
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
%     % Change in pulseponse for Each ISI
%     for ia = 1:size(area_list,1)
%         f = figure; set(f, 'Position', [270 195 1600 1160]);
%         for io = 1:length(offs)
%             norm = bsxfun(@rdivide, test_tc_sub_off{io}, nanmean(base_tc_sub_off{io},2));
%             errorbar(offs(io), nanmean(norm(:,:,ia),2), nanstd(norm(:,:,ia),[],2)./sqrt(size(norm,2)), 'ok')
%             hold on
%         end
%         ylim([0 1.25])
%         xlabel('Time (msec)')
%         ylabel('Normalized amplitude')
%         suptitle([mouse ' ' date '- Area ' area_list(ia,:) '- PP recovery']) 
%         savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_change_pulsep.fig']));
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_change_pulsep.png']), '-dpng');
%     end
%     disp('Figupulse saved in the proper directory for this mouse.')
end