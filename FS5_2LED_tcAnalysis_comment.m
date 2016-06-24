%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flashing Stim 2LED Imaging Response Analysis %
% Source by Lindsey Glickfeld                  %
% Signif. Modif./Optimization by Ben Gincley   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
WideField_FlashStim_DataSets
%% Allow Specific Selection of Experiments to Run
disp('Loading Session...')
disp('Assign "e=[experiment you would like to run]". Assign "e=0" if you would like to run all experiments.');
disp('Then type "return" to resume program...');
keyboard
if e == 0,
    a = 12; aa = size(expt,2);
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
% if xObj == 16
    fn_base = fullfile(anal_root, [date '_' mouse]);
    fn_outbase = fullfile(anal_root, 'FS5');
    fn_output_home = fullfile(output_root, [date '_' mouse '_' areas]);
    fn_output = fullfile(fn_output_home, [date '_' mouse '_' expt_name '_' areas]);
    fn_img = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_imageData.mat']); % Legacy command from era of saving interpolated image data. Use at your own risk (time)
    fn_mworks = fullfile('\\CRASH.dhe.duke.edu\data\home\andrew\Behavior\Data', ['data-' mouse '-' date '-' time_mat '.mat']);
    fn_tc = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_exptData.mat']);
    fn_mask = fullfile(fn_base, [date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
    fn_final = fullfile(fn_outbase, [date '_' mouse '_' expt_name '_' areas '_final.mat']);
    fn_img1 = fullfile(data_root, [date '_' mouse], [date '_' mouse '_' expt_name '_' num2str(xObj) '_1']);
%     cd(fn_base)
%     if exist(fullfile(fn_base, [date '_' mouse '_' expt_name '_' num2str(xObj) '_maskData.mat']),'file')
%         movefile([date '_' mouse '_' expt_name '_' num2str(xObj) '_maskData.mat'],[date '_' mouse '_' expt_name '_' areas '_maskData.mat']);
%         movefile([date '_' mouse '_' expt_name '_' num2str(xObj) '_exptData.mat'],[date '_' mouse '_' expt_name '_' areas '_exptData.mat']);
%     end
%     cd(anal_root)
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
    if exist(fn_tc,'file') && exist(fn_mask,'file')
        load(fn_tc)
        load(fn_mask)
        load(fn_mworks)
        disp('Previously saved ROI and experiment data files found, skipping to figures.')
    else
        % Legacy command from era of saving interpolated image data. Use at your own risk (time)
%         if exist(fn_img,'file')
%             disp('Previously processed image data found. Loading file...')
%             load(fn_img) 
%         else
            % Begins interpolation, loading and processing raw image stacks
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
                data = cat(3,data,data_temp);
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
            disp('Images interpolated. Loading mWorks File...');

            %load mworks .mat file, assign variables from file
            load(fn_mworks)
            gratingDirectionDeg = cell2mat(input.gratingDirectionDeg);
            holdTimes = cell2mat(input.holdTimesMs);
            stimOff  = cell2mat(input.tStimOffTimeMs);
            ntrials = size(gratingDirectionDeg,2);
            cStimOn = cell2mat(input.cFirstStim);
            % Establish pre- and post- stimulus frame numbers
            preframes = 15;
            postframes = 120;
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
            % Clears unnecessary variables, legacy saved important information from this section (massive file size, discontinued.
            disp('Saving Data...')            
            clear data bdata gdata bdata_int gdata_int bdata_trials gdata_trials bdata_trials_F bdata_trials_dF gdata_trials_F gdata_trials_dF         
            %save(fn_img, 'input', 'sz', 'gratingDirectionDeg', 'stimOff', 'ntrials', 'preframes', 'postframes', 'bdata_trials_gsub', '-v7.3');
            disp('Interpolated image data saved.')
%% Load previously selected ROIs, or else select ROIs to process
% ROI Selection. This section will skip if mask file exists. Delete or run
% "else" section to choose new ROIS
        if exist(fn_mask, 'file')
            load(fn_mask);
            disp('Mask Found For This Mouse. Loading Previous Mask Data')
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
        tc_sub = reshape(stackGetTimeCourses(reshape(bdata_trials_gsub,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
    % Place "end" here if you would like to re-run post-processing
    % after already interpolating data (save time without interpolating
    % again. Requires fn_tc file)
        gratingDirectionDeg = cell2mat(input.gratingDirectionDeg);
        dirs = unique(gratingDirectionDeg);
        stimOff  = cell2mat(input.tStimOffTimeMs);
        offs = unique(stimOff);
        tc_sub_dir = cell(length(offs),length(dirs),6,size(area_list,1));
        tc_sub_base = cell(length(offs),5,size(area_list,1));
        resp_win = cell(length(offs));
        base_win = cell(length(offs));
        
%         if strcmp(areas, 'PM') ||  strcmp(areas,'AL') || strcmp(areas,'LM');
%             s = 1;
%         else
%             s = 0;
%         end
        s=0;
        % Establishes Response and Base Windows for later analysis. Values
        % suject to tweaking
        intervals = unique(cell2mat(input.cTargetOn)-cell2mat(input.cStimOn));
        for io = 1:length(intervals)
            resp_win{io} = [(23+s:intervals(io):(intervals(io)*5)+23+s)' (26+s:intervals(io):(intervals(io)*5)+26+s)'];
            base_win{io} = [(19-io:intervals(io):(intervals(io)*5)+19-io)' (22-io:intervals(io):(intervals(io)*5)+22-io)'];
        end
        % For each area, stimOffTime, Direction, find 1. Information for
        % Lindsey's plotting and 2. Response Amplitudes for each pulse for
        % meta analysis
        for ia = 1:size(area_list,1)  
            for io = 1:length(offs)
                ind1 = find(stimOff == offs(io));
                for id = 1:length(dirs)
                    ind = intersect(ind1, find(gratingDirectionDeg == dirs(id)));
                    indn(id) = length(ind);
                    for ip = 1:6
                        tc_sub_dir{io,id,ip,ia} = nanmean(tc_sub(resp_win{io}(ip,1):resp_win{io}(ip,2),ind,:),1)-nanmean(tc_sub(base_win{io}(ip,1):base_win{io}(ip,2),ind,:),1);
                    end
                end
                for ip = 1:5
                    resp_amp{io,ip,ia} = nanmean(nanmean(tc_sub(resp_win{io}(ip,1):resp_win{io}(ip,2),ind1,ia),1) - nanmean(tc_sub(base_win{io}(ip,1):base_win{io}(ip,2),ind1,ia),1),2);
                    resp_amp_norm{io,ip,ia} = resp_amp{io,ip,ia}/resp_amp{io,1,ia};
                    tc_sub_base{io,ip,ia} = nanmean(tc_sub(resp_win{io}(ip,1):resp_win{io}(ip,2),ind1,:),1)-nanmean(tc_sub(base_win{io}(ip,1):base_win{io}(ip,2),ind1,:),1);
                    resp_v(io,ip,ia) = (resp_amp_norm{io,ip,ia});
                end
            end
            % Find max avg dF/F for first pulse
            max_p1(ia) = max(nanmean(tc_sub(20:30,:,ia),2),[],1);
        end 
        % Save data. Be advised saving fn_tc is slow (input takes a long
        % time to save, can be removed if necessary)
        disp('Saving fn_tc...')
        if exist(fn_tc,'file')
        else
            save(fn_tc, 'input', 'tc_sub', 'stimOff', 'resp_win', 'base_win', 'resp_v')
        end
        % Variables of interest to Ben's final post-analysis
        save(fn_final, 'max_p1', 'resp_v', 'offs', 'stimOff')
        disp('Data saved in the proper directory for this mouse.')
    end
%% Plots
    disp('Plotting Figures...')
    % Plot dF/F by Visual Area for Each Stimulus Condition
    [n, n2] = subplotn(size(dirs,2)*size(offs,2));
    for ia = 1:size(area_list,1)  
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        start=0;
        for io = 1:length(offs)
            ind1 = find(stimOff == offs(io));
            for id = 1:length(dirs)
                ind = intersect(ind1, find(gratingDirectionDeg == dirs(id)));
                indn(id) = length(ind);
                subplot(n,n2,id+start)
                hold on
                shadedErrorBar(1:size(tc_sub,1), nanmean(tc_sub(:,ind,ia),2), nanstd(tc_sub(:,ind,ia),[],2)./sqrt(length(ind)));
    %             plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
                vline(base_win{io}(:,1)-1,'--k')
                vline(base_win{io}(:,2)-1,'--k')
                vline(resp_win{io}(:,1)-1)
                vline(resp_win{io}(:,2)-1)
                plot([0 135],[0 0], '--k')
                xlim([0 135]);
                ylim([-0.01 0.03])
                ylabel('dF/F')
                xlabel('Seconds')
                set(gca,'XTick',0:15:150)
                set(gca,'XTickLabel', {'', '0','','1','', '2','', '3','', '4',''})
                title([num2str(dirs(id)) ' deg; ' num2str(offs(io)) ' ms off'])
             end
            start = start+length(dirs);
        end
        suptitle([mouse ' ' date '- Area ' area_list(ia,:)])   
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_dF_Traces.fig']));
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_dF_Traces.png']), '-dpng');
    end
    % Plot Blue/Black Overlay, 250/500ms
    [n, n2] = subplotn(length(offs));
    for ia = 1:size(area_list,1)  
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        for io = 1:length(offs)
            ind1 = find(stimOff == offs(io));
            subplot(n,n2,io)
            for id = 1:length(dirs)
                ind = intersect(ind1, find(gratingDirectionDeg == dirs(id)));
                indn(id,io) = length(ind);
                shadedErrorBar(1:size(tc_sub,1), nanmean(tc_sub(:,ind,ia),2), nanstd(tc_sub(:,ind,ia),[],2)./sqrt(length(ind)), col_mat(id,:));
                hold on;
                plot([0 135],[0 0], '--k')
                xlim([0 135]);
                title([num2str(offs(io)) ' ms off'])
                hold on
            end
        end
        suptitle([mouse ' ' date '- Area ' area_list(ia,:) '; Black: 45 deg; Blue: 90 deg'])
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_overlay.fig']));
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_overlay.png']), '-dpng');
    end
%     % Plot Change in Response for Each Degree Change
%     f = figure; set(f, 'Position', [270 195 1500 1150]);
%     [n,n2] = subplotn(size(area_list,1));
%     for ia = 1:size(area_list,1)
%         subplot(n,n2,ia)
%         for io = 1:length(offs)
%             temp = bsxfun(@rdivide, tc_sub_base{io,5,ia}, nanmean(tc_sub_base{io,1,ia},2));
%             shadedErrorBar(dirs,repmat(nanmean(temp(:,:,ia),2), [1, length(dirs)]),repmat(nanstd(temp(:,:,ia),[],2)./sqrt(size(temp,2)), [1, length(dirs)]), col_mat(io,:));
%             hold on
%             for id = 1:length(dirs)
%                 temp = bsxfun(@rdivide, tc_sub_dir{io,id,6,ia}, nanmean(tc_sub_base{io,1,ia},2));
%                 errorbar(dirs(id),nanmean(temp(:,:,ia),2),nanstd(temp(:,:,ia),[],2)./sqrt(size(temp,2)), ['-o' col_mat(io,:)])
%                 xlim([0 135]);
%                 hold on
%             end
%         end
%         title(['Area ' area_list(ia,:)])
%         ylim([0 2])
%     end
%     suptitle([mouse ' ' date '- Black: 250ms; Blue: 500ms'])
%     savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_net_change.fig']));
%     print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_net_change.png']), '-dpng');
%     
    % Line Plot of Response Magnitude for Each Pulse
    for ia = 1:size(area_list,1)
        figure;
        hold on
        for io = 1:2
            plot(resp_v(io,:,ia), 'LineWidth', 3, 'Color', col_mat(io,:))
        end
        ylim([0 1])
        xlim([0 6])
        title([mouse ' - ' date ' - ' area_list(ia,:) ' - Response Magnitude - Black: 250ms; Blue: 500ms']);
        xlabel('Pulse Number')
        ylabel('Normalized Percent Magnitude')
        hold off
        savefig(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_magnitudes.fig']));
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' area_list(ia,:) '_magnitudes.png']), '-dpng');
    end
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

            
