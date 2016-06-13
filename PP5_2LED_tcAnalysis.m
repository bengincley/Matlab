%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paired Pulse 2LED Imaging Response Analysis %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
WideField_PairedPulse_DataSets
%% Select Specific Experiments to Run
disp('Loading Session.')
disp('Assign "e=[experiment you would like to run]". Assign "e=0" if you would like to run all experiments.');
disp('Then type "return" to resume program');
keyboard;
if e == 0,
    a = 5; aa = size(expt,2);
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
        %areas = sprintf('%s', loc1);
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
    disp('Note: Delete the "_exptData.mat" and "_maskData.mat" files for this experiment if you would like to select new ROIs.');
    disp('Type "return" or press [^] if this information is correct and you would like to proceed...');
    if e~=0
        keyboard
    end
    nROI = size(area_list,1);
    col_mat = char('k', 'b');
    fn_base = fullfile(anal_root, [date '_' mouse]);
    fn_output_home = fullfile(output_root, [date '_' mouse '_' areas]);
    fn_output = fullfile(fn_output_home, [date '_' mouse '_' expt_name '_' areas]);
    fn_img = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_imageData.mat']);
    fn_mworks = fullfile('\\CRASH.dhe.duke.edu\data\home\andrew\Behavior\Data', ['data-' mouse '-' date '-' time_mat '.mat']);
    fn_tc = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_exptData.mat']);
    fn_mask = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
    fn_pulse = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_pulseData.mat']);
    fn_img1 = fullfile(data_root, [date '_' mouse], [date '_' mouse '_' expt_name '_' num2str(xObj) '_1']);
    cd(fn_base)
    if exist(fullfile(fn_base, [date '_' mouse '_' expt_name '_' num2str(xObj) '_maskData.mat']),'file')
        movefile([date '_' mouse '_' expt_name '_' num2str(xObj) '_maskData.mat'],[date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
        movefile([date '_' mouse '_' expt_name '_' num2str(xObj) '_exptData.mat'],[date '_' mouse '_' expt_name '_' areas '_exptData.mat']);
    end
    cd(anal_root)
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
    if exist(fn_tc,'file') && exist(fn_mask,'file')
        load(fn_tc)
        load(fn_mask)
        load(fn_mworks)
        disp('Previously saved ROI and experiment data files found, skipping to figures.')
    else
        if exist(fn_img,'file')
            disp('Previously assessed dF/F image data found. Loading file...')
            load(fn_img)
        else
            disp('Initiating new interpolation process.')
            disp('Reading image files...')
            data =[];
            for irun = 1:nrun;  % NOTE: As of 5/13/16, Naming changed from "xObj"-based to "areas"-based. If attempting to load an older file, swap "areas" with "num2str(xObj)"
                if isdir(fn_img1)
                    img_str = [date '_' mouse '_' expt_name '_' num2str(xObj) '_' num2str(irun)];
                    disp('File found with "Obj" naming.')
                else
                    img_str = [date '_' mouse '_' expt_name '_' areas '_' num2str(irun)];
                    disp('File found with "Areas" naming.')
                end
                fn = fullfile(data_root, [date '_' mouse], img_str, [img_str '_MMStack.ome.tif']);
                data_temp = readtiff(fn);
                data = cat(3,data, data_temp);
                clear data_temp
            end
            disp('Assessing dataset...')
            sz = size(data);
            tframes = 1:sz(3);
            gframes = g_ind:g_ind:sz(3);
            bframes = setdiff(tframes, gframes);
            bframes = setdiff(bframes, [7501 15001 16500 22501]);
            bdata = double(data(:,:,bframes));
            gdata = double(data(:,:,gframes));
            disp('Initiating Interpolation. Now Interpolating Blue Frames...')
            bdata= reshape(bdata,[sz(1)*sz(2) length(bframes)]);
            bdata_int = zeros(sz(1)*sz(2), sz(3));
            for i = 1:sz(1)*sz(2)
                bdata_int(i,:) = interp1(bframes,bdata(i,:),tframes,'previous');
            end
            disp('Blue Frame Interpolation Complete. Now Interpolating Green Frames...')
            gdata= reshape(gdata,[sz(1)*sz(2) length(gframes)]);
            gdata_int = zeros(sz(1)*sz(2), sz(3));
            for i = 1:sz(1)*sz(2)
                gdata_int(i,:) = interp1(gframes,gdata(i,:),tframes,'previous');
            end
            bdata_int = reshape(bdata_int, [sz(1) sz(2) sz(3)]);
            gdata_int = reshape(gdata_int, [sz(1) sz(2) sz(3)]);
            disp('Images interpolated. Loading mWorks File...');
            %load mworks .mat file
            load(fn_mworks)
            stimOff  = cell2mat(input.tStimOffTimeMs);
            ntrials = size(stimOff,2);
            cLeverDown = cell2mat(input.cLeverDown);
            cTargetOn = cell2mat(input.cTargetOn);
            holdTimes = cell2mat(input.holdTimesMs);
            disp('Saving Interpolated Data...')
            clear data bdata gdata
            %save(fn_int, 'tframes', 'bframes', 'gframes', 'bdata_int', 'gdata_int', 'input', 'cLeverDown', 'holdTimes', 'cTargetOn', 'sz', 'stimOff', 'ntrials', '-v7.3');
        end
            preframes = 15;
            postframes = 45;           
            postframes_p3 = 65;
            bdata_base = NaN(sz(1), sz(2), preframes+postframes, ntrials);
            gdata_base = NaN(sz(1), sz(2), preframes+postframes, ntrials);
            bdata_test = NaN(sz(1), sz(2), preframes+postframes, ntrials);
            gdata_test = NaN(sz(1), sz(2), preframes+postframes, ntrials);
            bdata_pulse_p3 = NaN(sz(1), sz(2), preframes+postframes_p3, ntrials);
            gdata_pulse_p3 = NaN(sz(1), sz(2), preframes+postframes_p3, ntrials);
            disp('Sorting trials/frames...')
            for itrial = 1:ntrials
                if holdTimes(itrial) < 10000;
                    if ((cLeverDown(itrial)-preframes)>=1) && ((cLeverDown(itrial)+postframes)<=sz(3))
                        bdata_base(:,:,:,itrial) = bdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes-1);
                        gdata_base(:,:,:,itrial) = gdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes-1);
                    end
                    if ((cTargetOn(itrial)-preframes)>=1) && ((cTargetOn(itrial)+postframes)<=sz(3))
                        bdata_test(:,:,:,itrial) = bdata_int(:,:,cTargetOn(itrial)-preframes:cTargetOn(itrial)+postframes-1);
                        gdata_test(:,:,:,itrial) = gdata_int(:,:,cTargetOn(itrial)-preframes:cTargetOn(itrial)+postframes-1);
                    end
%                     if ((stimOff(itrial)==4000) && ((cLeverDown(itrial)+postframes_p3)<=sz(3)))
%                         bdata_pulse_p3(:,:,:,itrial) = bdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes_p3-1);
%                         gdata_pulse_p3(:,:,:,itrial) = gdata_int(:,:,cLeverDown(itrial)-preframes:cLeverDown(itrial)+postframes_p3-1);
%                     end
                end
            end
            disp('Frames sorted. Now assessing fluorescence...')
            bdata_base_F = mean(bdata_base(:,:,1:preframes,:),3);
            gdata_base_F = mean(gdata_base(:,:,1:preframes,:),3);
%             bdata_base_F_p3 = mean(bdata_pulse_p3(:,:,1:preframes,:),3);
%             gdata_base_F_p3 = mean(gdata_pulse_p3(:,:,1:preframes,:),3);
            disp('Base fluorescence assessed. Assessing dF/F...')
            bdata_base_dFoverF = dF_Over_F_fun(bdata_base_F, bdata_base);            
            gdata_base_dFoverF = dF_Over_F_fun(gdata_base_F, gdata_base);
            bdata_test_dFoverF = dF_Over_F_fun(bdata_base_F, bdata_test);            
            gdata_test_dFoverF = dF_Over_F_fun(gdata_base_F, gdata_test);
%             bdata_dFoverF_p3 = dF_Over_F_fun(bdata_base_F_p3, bdata_pulse_p3);            
%             gdata_dFoverF_p3 = dF_Over_F_fun(gdata_base_F_p3, gdata_pulse_p3);  
            disp('dF / F  assessed. Subtracting frames...')
            bdata_base_gsub = bdata_base_dFoverF-gdata_base_dFoverF;
            bdata_test_gsub = bdata_test_dFoverF-gdata_test_dFoverF;
            bdata_trials_gsub = bdata_base_gsub;
%             pulse_p3 = bdata_dFoverF_p3-gdata_dFoverF_p3;
%             pulse_p1 = pulse_p3(:,:,1:preframes+postframes,:);
%             pulse_p2 = pulse_p3(:,:,1:preframes+postframes,:);
            disp('Clearing Excess Data...')            
            clear bdata_int gdata_int bdata_base gdata_base bdata_test gdata_test bdata_pulse_p3 gdata_pulse_p3 
            clear bdata_base_F gdata_base_F bdata_base_F_p3 gdata_base_F_p3 bdata_base_dFoverF gdata_base_dFoverF bdata_test_dFoverF gdata_test_dFoverF bdata_dFoverF_p3 gdata_dFoverF_p3 
            %save(fn_img, 'input', 'sz', 'stimOff', 'ntrials', 'preframes', 'postframes', 'bdata_base_gsub', 'bdata_test_gsub', 'bdata_trials_gsub', '-v7.3');
            %disp('Interpolated image data saved.')
    
%% Load previously selected ROIs, or else select ROIs to process
        if exist(fn_mask, 'file')
            load(fn_mask);
            disp('Loading Previous Mask Data')
        else
            disp('**Select ROIs**')
            disp('The order to select is:')
            disp(order_msg)
            roiPolySelect_ben
            save(fn_mask, 'mask_cell', 'area_list', 'bdata_avg')
        end
%% Assess Base and Test Pulses and Process dF/F for each ROI selected
        disp('Processing ROIs...')
        base_tc_sub = reshape(stackGetTimeCourses(reshape(bdata_base_gsub,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
        test_tc_sub = reshape(stackGetTimeCourses(reshape(bdata_test_gsub,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
%         pulse_tc_p1 = reshape(stackGetTimeCourses(reshape(pulse_p1,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
%         pulse_tc_p2 = reshape(stackGetTimeCourses(reshape(pulse_p2,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
%         pulse_tc_p3 = reshape(stackGetTimeCourses(reshape(pulse_p3,[sz(1) sz(2) (preframes+postframes_p3)*ntrials]),mask_cell), [(preframes+postframes_p3) ntrials size(area_list,1)]);
        clear pulse_p1 pulse_p2 pulse_p3 
    end
    %%
        preframes = 15;
        postframes = 45;
        offs = unique(stimOff);
        test_tc_sub_off = cell(1,length(offs));
        base_tc_sub_off = cell(1,length(offs));
        resp_win = 23:26;
        base_win = 17:20;
        
        pulse_tc_p1 = base_tc_sub(:,stimOff==4000,:);
%         pulse_tc_p2 = ones(60,length(stimOff==4000));
%         pulse_tc_p3 = ones(80,length(stimOff==4000));

        for ia = 1:size(area_list,1)
            for io = 1:length(offs)
                ind1 = find(stimOff == offs(io));
                test_tc_sub_off{io} = nanmean(test_tc_sub(resp_win,ind1,:),1)-nanmean(test_tc_sub(base_win,ind1,:),1);
                base_tc_sub_off{io} = nanmean(base_tc_sub(resp_win,ind1,:),1)-nanmean(base_tc_sub(base_win,ind1,:),1);
            end
        
        % Pulse Fit
        ind = find(stimOff == 4000);
        baseline_mean(ia) = nanmean(nanmean(pulse_tc_p1(1:preframes,:,ia)));
        mean_tc_p1(:,ia) = nanmean(pulse_tc_p1(:,:,ia),2) - baseline_mean(ia);
%         mean_tc_p2 = nanmean(pulse_tc_p2,2) - baseline_mean;
%         mean_tc_p3 = nanmean(pulse_tc_p3,2) - baseline_mean;
        
        shift{1}(60,2) = 0;
%         shift{2}(60,2) = 0;
%         shift{3}(80,2) = 0;
        
        for n = 1:2
            shift{1}(:,n,ia) = circshift(mean_tc_p1(:,ia),11*(n-1));
%             shift{2}(:,n) = circshift(mean_tc_p2,18*(n-1));
%             shift{3}(:,n) = circshift(mean_tc_p3,33*(n-1));
            if n == 2
                shift{1}(1:(11*(n-1)),n,ia) = 0;
%                 shift{2}(1:(18*(n-1)),n) = 0;
%                 shift{3}(1:(33*(n-1)),n) = 0;
            end
        end
        clear offs_m pp_base_tc
        for m = 1:3
            j = (30+(m-1)*10):(30+(m*10));
                offs_m{m}(:,ia) = find(stimOff == 250*(2^(m-1)));
                pp_base_tc{m}(:,:,ia) = base_tc_sub(:,offs_m{m}(:,ia),ia);
                mean_pp_base_tc{m}(:,:,ia) = nanmean(pp_base_tc{m}(:,:,ia),2);
                pp_to_fit{m}(:,:,ia) = mean_pp_base_tc{m}(1:60,:,ia);
                norm_pp_to_fit{m}(:,:,ia) = pp_to_fit{m}(:,:,ia) / max(pp_to_fit{m}(15:30,:,ia));
                norm_shift{m}(:,ia) = shift{1}(:,1,ia) / max(shift{1}(:,1,ia));
%             if m==3
%                 betas{m} = shift{m}(1:60,:)\pp_to_fit{m};
%             else
%                 betas{m} = shift{m}(1:60,:)\pp_to_fit{m};
%             end
                residual{m}(:,ia) = norm_pp_to_fit{m}(:,:,ia) - norm_shift{m}(1:60,ia);
%                 betas_norm{m} = betas{m}(:) ./ betas{m}(1,1);
                betas_residual{m}(:,ia) = max(residual{m}(j,ia));
%             for n=1:2
%                 beta_shift{m}(:,n) = betas{m}(n) * shift{m}(:,n);
%             end
%                 sum_pulses{m} = sum(beta_shift{m},2);
%                 betas_v(m) = betas_norm{m}(2);
                betas_res(m,ia) = betas_residual{m}(:,ia);
        end
        end
    if exist(fn_tc,'file')
        save(fn_tc, 'preframes', 'postframes', '-append')
    else 
        save(fn_tc, 'input', 'preframes', 'postframes', 'base_tc_sub', 'test_tc_sub', 'test_tc_sub_off', 'base_tc_sub_off', 'offs', 'stimOff', 'base_win', 'resp_win')
    end
    if exist(fn_pulse,'file')
        save(fn_pulse, 'shift', 'betas_residual', 'residual', '-append')
    else
        save(fn_pulse, 'pulse_tc_p1', 'shift', 'pp_to_fit', 'betas_residual', 'residual', 'norm_pp_to_fit', 'norm_shift', 'stimOff')
    end
    disp('Data saved in the proper directory for this mouse.')
%% Plots 
    disp('Plotting Figures...')
    % Establish maximum luminance response to base stimulus
    base_all = zeros(1,length(offs));
    for ia = 1:size(area_list,1)
        for io = 1:length(offs)
            temp = base_tc_sub_off{io};
            base_all(io,ia) = squeeze(nanmean(temp(:,:,ia),2)).*1.25;
        end
    end
    base_max = max(base_all,[],1);
    % Overlay of Base/Test Pulse Responses
    for ia = 1:size(area_list,1)
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        for io = 1:length(offs)
            ind1 = find(stimOff == offs(io));
            subplot(2,3,io)
            shadedErrorBar(1:size(base_tc_sub,1), nanmean(base_tc_sub(:,ind1,ia),2), nanstd(base_tc_sub(:,ind1,ia),[],2)./sqrt(sum(~isnan(squeeze(base_tc_sub(1,ind1,1))),2)),'-k');
            hold on
            shadedErrorBar(1:size(test_tc_sub,1), nanmean(test_tc_sub(:,ind1,ia),2)-nanmean(nanmean(test_tc_sub(base_win,ind1,ia),2),1), nanstd(test_tc_sub(:,ind1,1),[],2)./sqrt(sum(~isnan(squeeze(test_tc_sub(1,ind1,1))),2)),'-r');
            title(num2str(offs(io)))
            ylim([-0.02 1.75*base_max(:,ia)])
        end
        suptitle([mouse ' ' date '- Area ' area_list(ia,:) '- Paired pulse TCs']) 
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_timecourse.fig']));  
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_timecourse.png']), '-dpng');
    end
    % Change in Response for Each ISI
    for ia = 1:size(area_list,1)
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        for io = 1:length(offs)
            norm = bsxfun(@rdivide, test_tc_sub_off{io}, nanmean(base_tc_sub_off{io},2));
            errorbar(offs(io), nanmean(norm(:,:,ia),2), nanstd(norm(:,:,ia),[],2)./sqrt(size(norm,2)), 'ok')
            hold on
        end
        ylim([0 1.25])
        xlabel('Time (msec)')
        ylabel('Normalized amplitude')
        suptitle([mouse ' ' date '- Area ' area_list(ia,:) '- PP recovery']) 
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_change_resp.fig']));
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_change_resp.png']), '-dpng');
    end
    % Pulse Fits
%     for ia = 1:size(area_list,1)
%         for m=1:3
%             figure;
%             hold on; 
%             plot(pp_to_fit{m},'LineWidth',2,'Color','k'); 
%             plot(sum_pulses{m},'LineWidth',2,'Color','b');
%             plot(shift{m},'LineStyle','--')
%             if m==3
%                 xlim([1 80]);
%             else
%                 xlim([1 60]);
%             end
%             xlabel('Frames')
%             ylabel('dF/F')
%             title([mouse ' - ' date ' - Area ' areas ' - Pulse Fit'])
%             hold off;
%         savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' areas '_pulse_fit.fig']));  
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' areas '_pulse_fit.png']), '-dpng');
%         end
%     end
    for ia = 1:size(area_list,1)
        for m=1:3
            figure;
            hold on; 
            plot(norm_pp_to_fit{m}(:,:,ia),'LineWidth',2,'Color','k');
            plot(norm_shift{m}(:,ia),'LineStyle','--')
            plot(residual{m}(:,ia),'LineWidth',2,'Color','r');
            xlim([1 60]);
            plot([1 60],[0 0], '--k')
            xlabel('Frames')
            ylabel('Normalized dF/F')
            title([mouse ' - ' date ' - Area ' area_list(ia,:) ' - Pulse Fit']);
            hold off;
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_pulse_norm.fig']));  
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_pulse_norm.png']), '-dpng');
        end
    end
    % Betas for Pulse Fits
    for ia = 1:size(area_list,1)
    figure;
        hold on;
        bar(betas_res(:,ia))
        %bar([betas_v; betas_res]', 'grouped');
        ylim([0 1]);
        set(gca,'XTick',1:6)
        set(gca,'XTickLabel', {'250ms', '500ms', '1000ms'})
        xlabel('Pulse Interval');
        ylabel('Percent Recovery');
        title([mouse ' - ' date ' - Area ' area_list(ia,:) ' - Pulse Recovery Beta Values']);
        hold off
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_betas.fig']));  
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_betas.png']), '-dpng');
    end
    disp('Figures saved in the proper directory for this mouse.')
    
end