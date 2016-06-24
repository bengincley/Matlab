%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Duration 2LED Imaging Response Analysis    %
% Source by Lindsey Glickfeld                %
% Signif. Modif./Optimization by Ben Gincley %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output Variable Descriptions: 
% tc_sub - Matrix of raw data traces, organized frames;trials;areas
% input - .mat file from that day's experiment
% stimOff - array of stim off times per trial (ex. 250 250 500 250 etc.)
% resp_win - Cell matrix of response window frames, separated by stimOff time
% base_win - Same as above, for baseline window frames
% resp_v - Response ratios used in final analysis, (resp_win-base_win dF/F) / first pulse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
WideField_Duration_DataSets
%% Allow Specific Selection of Experiments to Run
disp('Loading Session...')
disp('Assign "e=[experiment you would like to run]". Assign "e=0" if you would like to run all experiments.');
disp('Then type "return" to resume program...');
keyboard
if e == 0,
    a = 11; aa = size(expt,2);
else 
    a = e; aa = e;
end
%% Analysis Iterated for Each Experiment Selected
% Initializes experiment data from DataSet structure, establishes
% directories, opening dialogue
for iexp = a:aa
    date = expt(iexp).date;
    mouse = ['i' expt(iexp).SubNum];
    %disp([date ' ' mouse])
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
    fn_outbase = fullfile(anal_root, 'DU5');
    fn_output_home = fullfile(output_root, [date '_' mouse '_' areas]);
    fn_output = fullfile(fn_output_home, [date '_' mouse '_' expt_name '_' areas]);
    fn_mworks = fullfile('\\CRASH.dhe.duke.edu\data\home\andrew\Behavior\Data', ['data-' mouse '-' date '-' time_mat '.mat']);
    fn_img = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_imageData.mat']);
    fn_tc = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_exptData.mat']);
    fn_mask = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
    fn_final = fullfile(fn_outbase, [date '_' mouse '_' expt_name '_' areas '_final.mat']);
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
% If mask and expt_data files exist, will skip straight to figures (No post-analysis)   
    load(fn_mworks)
    if exist(fn_tc,'file') && exist(fn_mask,'file')
        load(fn_tc)
        load(fn_mask) 
        disp('Previously saved ROI and experiment data files found, skipping to figures.')
    else
        % Legacy command from era of saving interpolated image data. Use at your own risk (time)
%         if exist(fn_img,'file')
%             disp('Previously assessed dF/F image data found. Loading file...')
%             load(fn_img)
%         else
        % Begins interpolation, loading and processing raw image stacks
        disp('Initiating new interpolation process.')
        disp('Reading image files...')
        data =[];
        for irun = 1:nrun; 
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
        % Establishes blue and green frams, prepares for interpolation
        disp('Assessing dataset...')
        sz = size(data);
        tframes = 1:sz(3);
        gframes = g_ind:g_ind:sz(3);
        bframes = setdiff(tframes, gframes);
        bframes = setdiff(bframes, [7501 15001 16500 22501]);
        bdata = double(data(:,:,bframes));
        gdata = double(data(:,:,gframes));
        % Interpolation of data, first blue then green frames
        disp('Initiating Interpolation. Now Interpolating Blue Frames...')
        bdata = reshape(bdata,[sz(1)*sz(2) length(bframes)]);
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
        disp('Images interpolated. Reading mWorks File...');
        
        % Read mworks .mat file, assign variables from file
        gratingDirectionDeg = cell2mat(input.gratingDirectionDeg);
        dirs = unique(gratingDirectionDeg);
        holdTimes = cell2mat(input.holdTimesMs);
        stimOn  = cell2mat(input.tStimOnTimeMs);
        ntrials = size(stimOn,2);
        cStimOn = cell2mat(input.cFirstStim);
        preframes = 30;
        postframes = 240;
        bdata_trials = NaN(sz(1), sz(2), preframes+postframes, ntrials);
        gdata_trials = NaN(sz(1), sz(2), preframes+postframes, ntrials);
        % Organizes raw image data into trial-cropped arrays, organizes into matrix
        disp('Sorting trials/frames...')
        for itrial = 1:ntrials
            if holdTimes(itrial) < 10000;
                if ((cStimOn(itrial)-preframes)>=1) && ((cStimOn(itrial)+postframes)<=sz(3))
                    bdata_trials(:,:,:,itrial) = bdata_int(:,:,cStimOn(itrial)-preframes:cStimOn(itrial)+postframes-1);
                    gdata_trials(:,:,:,itrial) = gdata_int(:,:,cStimOn(itrial)-preframes:cStimOn(itrial)+postframes-1);
                end
            end
        end
        % Calculates, F, dF, dF/F, and subtracts green from blue (See Function)
        disp('Frames sorted. Now assessing fluorescence...')
        [bdata_trials_gsub] = dF_Over_F_fun_TC_Analysis(bdata_trials, gdata_trials, preframes);
        % Clear large matrices not needed for further analysis
        clear data bdata gdata bdata_int gdata_int bdata_trials gdata_trials         
        %save(fn_img, 'sz', 'stimOn', 'ntrials', 'preframes', 'postframes', 'bdata_trials_gsub', 'gratingDirectionDeg', 'dirs', '-v7.3');
        %disp('Interpolated image data saved.')      
%% Load previously selected ROIs, or else select ROIs to process
% ROI Selection. This section will skip if mask file exists. Delete or run
% "else" section to choose new ROIS
        if exist(fn_mask, 'file')
            disp('Mask Found For This Mouse. Loading Previous Mask Data...')
            load(fn_mask);  
        else
            disp('**Select ROIs**')
            disp('The order to select is:')
            disp(order_msg)
            roiPolySelect_ben
            save(fn_mask, 'mask_cell', 'area_list', 'bdata_avg')
        end
%% Construct intervals and process dF/F for each ROI selected
% Post-processing of image data in ROIs across trials
        disp('Processing ROIs...')
        ons = unique(stimOn);
        tc_sub = reshape(stackGetTimeCourses(reshape(bdata_trials_gsub,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
%         tc_blue = reshape(stackGetTimeCourses(reshape(bdata_trials_dFoverF,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
%         tc_green = reshape(stackGetTimeCourses(reshape(gdata_trials_dFoverF,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);      
        tc_trans_resp = cell(length(ons),size(area_list,1));
        trans_resp = cell(length(ons),size(area_list,1));
        tc_sust_resp = cell(length(ons),size(area_list,1));
%         tc_blue_base = cell(length(ons),size(area_list,1));
%         tc_green_base = cell(length(ons),size(area_list,1));

        % Combine frames for 2s and 4s duration where overlapping
        i1=find(stimOn == 125); i2 = find(stimOn==2000); ib = sort(horzcat(i2,i4));
        for ia=1:size(area_list,1)
            tc_2000 = nanmean(tc_sub(1:93,ib,ia),2);
            tc{1,1} = nanmean(tc_sub(:,i1,ia),2);
            tc_2s(:,:,ia) = vertcat(tc_2000,nanmean(tc_sub(94:end,i2,ia),2));
            tc{1,2} = nanstd(tc_sub(:,i1,ia),[],2)./sqrt(length(i1));
            tc{2,2} = nanstd(tc_sub(:,i2,ia),[],2)./sqrt(length(i2));
        end       
        
        intervals = unique(cell2mat(input.cStimOff)-cell2mat(input.cStimOn));
        % Adjusts for days if more than 3 durations were used
        if length(intervals) > 3
            intervals(2) = intervals(4);
            intervals(3) = intervals(5);
            intervals(4:5) = [];
            ons(2) = ons(4);
            ons(3) = ons(5);
            ons(4:5) = [];
        end
        % Establishes windows for analysis
        for io = 1:length(intervals)
            base_win = 23:28;
            stim_on = 33;
            stim_off(io) = stim_on + intervals(io);
            % take peak for on response transient below
%             trans_resp_win = 37:39;
            sust_resp_win{io} = (30 + intervals(io) - 20):(30 + intervals(io));
            off_resp_win{io} = (35 + intervals(io)):(40 + intervals(io));
        end
        clear sust_trans_ratio
        for ia = 1:size(area_list,1)
            for io = 1:length(ons)
                ind1 = find(stimOn == ons(io));
                if io == 1
                    % Find max avg dF/F for first pulse
                    max_p1(ia) = max(nanmean(tc_sub(35:45,stimOn == ons(io),ia),2));
                elseif io > 1
                    % Establish Transient Response Window
                    mean_tc = nanmean(tc_sub(:,ind1,ia),2);
                    [m, frame] = max(mean_tc(37:47));
                    trans_resp_win = frame+36:frame+38;
                    % Analysis using combined 2s and 4s data for 2s duration
                    if io==2
                    tc_trans_resp{io} = nanmean(tc_2s(trans_resp_win,:,ia),1);
                    tc_sust_resp{io} = nanmean(tc_2s(sust_resp_win{io},:,ia));
                    sust_trans_ratio(io-1,ia) = tc_sust_resp{io}./tc_trans_resp{io};
                    else
                    % Determines Sustained/Transient Ratio
                    tc_trans_resp{io} = nanmean(nanmean(tc_sub(trans_resp_win,ind1,ia),2));%-nanmean(tc_sub(base_win,ind1,ia),1);
                    tc_sust_resp{io} = nanmean(nanmean(tc_sub(sust_resp_win{io},ind1,ia)));
                    sust_trans_ratio(io-1,ia) = tc_sust_resp{io}./tc_trans_resp{io};
                    end
                end
            end
        end
        % Save data. Be advised saving fn_tc is slow (input takes a long
        % time to save, can be removed if necessary)
        % Saves separately for expt data and pulse_fit-related data (can be
        % combined if you want)
        disp('Saving data...')
        if exist(fn_tc,'file')
        else
            save(fn_tc, 'input', 'tc_sub', 'ons', 'stimOn', 'stim_on', 'stim_off', 'sust_resp_win', 'trans_resp_win', 'off_resp_win', 'base_win', 'tc_trans_resp', 'tc_sust_resp', 'sust_trans_ratio')
        end   
        % Data relevant to Ben's final post-analysis 
        save(fn_final, 'max_p1', 'sust_trans_ratio', 'stimOn', 'ons')
        disp('Data saved in the proper directory for this mouse.')
    end    
%     blue_base_F = reshape(stackGetTimeCourses(reshape(bdata_trials_F,[sz(1) sz(2) ntrials]),mask_cell), [ntrials size(area_list,1)]);
%     figure; plot(blue_base_F)
%     title('160524 - i538 - DU5 - V1')
%     xlabel('Trials')
%     ylabel('Fluorescence Value')
%% Plots
    disp('Plotting Figures...')
    % Plot dF/F by Visual Area for Each Stimulus Condition
    [n, n2] = subplotn(size(ons,2));
    for ia = 1:size(area_list,1)  
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        max_lum = 1.5 * max(nanmean(tc_sub(:,:,ia)));
        for io = 1:length(ons)
            ind = find(stimOn == ons(io));
                indn(io) = length(ind);
                subplot(n,n2,io)
                hold on
                yLim = [-0.02 0.06];
                shadedErrorBar(1:size(tc_sub,1), nanmean(tc_sub(:,ind,ia),2), nanstd(tc_sub(:,ind,ia),[],2)./sqrt(length(ind)));
%                plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
                %vline(base_temp(:,1),'--k')
                %vline(base_temp(:,end),'--k')
                plot([0 270],[0 0], '--k')
                plot([stim_on stim_on], yLim, '--k')
                plot([stim_off(io) stim_off(io)], yLim, '--r')
                if io>1
                plot([trans_resp_win(1) trans_resp_win(1)],yLim,'--g')                
                plot([trans_resp_win(end) trans_resp_win(end)],yLim,'--g')
                plot([sust_resp_win{io}(1) sust_resp_win{io}(1)],yLim,'--b')
                plot([sust_resp_win{io}(end) sust_resp_win{io}(end)],yLim,'--b')
                end
                set(gca,'XTick',0:30:270)
                set(gca,'XTickLabel', {'-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
                title([num2str(ons(io)) '  ms on'])
                ylabel('dF/F')
                xlabel('Seconds')
                ylim(yLim)
                xlim([0 270])
                hold off
        end
        suptitle([mouse ' - ' date ' - ' area_list(ia,:)])
        savefig(fullfile(fn_output,[date '_' mouse '_' expt_name '_' area_list(ia,:) '_tc.fig']));
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) 'tc.png']), '-dpng');
    end

    for ia = 1:size(area_list,1)  
        figure;
        hold on
        sust_trans_percent(:,ia) = 100 * sust_trans_ratio(:,ia);
        bar(sust_trans_percent(:,ia))
        ylim([0 100])
        set(gca,'XTick',1:2)
        set(gca,'XTickLabel', {'2000ms', '4000ms'})
        title([mouse ' - ' date ' - ' area_list(ia,:) ' - Sustained Response / Transient'])
        xlabel('Stimulus Duration')
        ylabel('Response Magnitude (%)')
        hold off
        savefig(fullfile(fn_output,[date '_' mouse '_' expt_name '_' area_list(ia,:) '_resp_ratio.fig']));
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) 'resp_ratio.png']), '-dpng');
    end
    
%     % Plot BLUE dF/F by Visual Area for Each Stimulus Condition
%     [n, n2] = subplotn(size(ons,2));
%     for ia = 1:size(area_list,1)  
%         f = figure; set(f, 'Position', [270 195 1500 1150]);
%         start=0;
%         for io = 1:length(ons)
%             ind1 = find(stimOn == ons(io));
%             for id = 1:length(ons)
%                 ind = intersect(ind1, find(stimOn == ons(id)));
%                 indn(id) = length(ind);
%                 base_temp = cell2mat(base_win(id));
%                 resp_temp = cell2mat(stim_win(id));
%                 subplot(n,n2,id)
%                 hold on
%                 shadedErrorBar(1:size(tc_blue,1), nanmean(tc_blue(:,ind,ia),2), nanstd(tc_blue(:,ind,ia),[],2)./sqrt(length(ind)));
%     %             plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
%                 %vline(base_temp(:,1),'--k')
%                 %vline(base_temp(:,end),'--k')
%                 vline(resp_temp(:,1), '--k')
%                 vline(resp_temp(:,end))
%                 set(gca,'XTick',0:30:270)
%                 set(gca,'XTickLabel', {'-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
%                 title([num2str(ons(id)) '  ms on'])
%                 ylim([-0.02 0.08])
%                 xlim([0 270])
%                 hold off
%             end
%             start = start+length(ons);
%         end
%         suptitle([mouse ' ' date ' - Blue dF/F - Area ' area_list(ia,:)])
%         savefig(fullfile(fn_output,[date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_blue.fig']));
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_Blue.png']), '-dpng');
%     end
%     % Plot GREEN dF/F by Visual Area for Each Stimulus Condition
%     [n, n2] = subplotn(size(ons,2));
%     for ia = 1:size(area_list,1)  
%         f = figure; set(f, 'Position', [270 195 1500 1150]);
%         start=0;
%         for io = 1:length(ons)
%             ind1 = find(stimOn == ons(io));
%             for id = 1:length(ons)
%                 ind = intersect(ind1, find(stimOn == ons(id)));
%                 indn(id) = length(ind);
%                 base_temp = cell2mat(base_win(id));
%                 resp_temp = cell2mat(stim_win(id));
%                 subplot(n,n2,id)
%                 hold on
%                 shadedErrorBar(1:size(tc_green,1), nanmean(tc_green(:,ind,ia),2), nanstd(tc_green(:,ind,ia),[],2)./sqrt(length(ind)));
%     %             plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
%                 %vline(base_temp(:,1),'--k')
%                 %vline(base_temp(:,end),'--k')
%                 vline(resp_temp(:,1), '--k')
%                 vline(resp_temp(:,end))
%                 set(gca,'XTick',0:30:270)
%                 set(gca,'XTickLabel', {'-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
%                 title([num2str(ons(id)) '  ms on'])
%                 ylim([-0.02 0.08])
%                 xlim([0 270])
%                 hold off
%             end
%             start = start+length(ons);
%         end
%         suptitle([mouse ' ' date ' - Green dF/F - Area ' area_list(ia,:)])
%         savefig(fullfile(fn_output,[date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_green.fig']));
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_Green.png']), '-dpng');
%     end
    disp('Figures saved in the proper directory for this mouse.')
    end
%%    
% d = [];    
% group_o = [];
% group_d = [];
% ia = 2;
%     for io = 1:2
%         for id = 1:2
%             temp = squeeze(tc_sub_dir{io,id,6});
%             group_o = [group_o;  double(offs(io)).*ones(size(temp,1),1)];
%             group_d = [group_d;  double(dirs(id)).*ones(size(temp,1),1)];
%             d = [d; temp(:,ia)];
%         end
%     end
%     [p, tab, stats] = anovan(d, {group_o,group_d}, 'model', 2, 'varnames', {'Interval', 'Direction'});

            
