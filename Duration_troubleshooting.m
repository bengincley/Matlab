%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Duration 2LED Imaging Response Analysis %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
WideField_Duration_DataSets
%% Allow Specific Selection of Experiments to Run
%{
f = figure;
set(f, 'Position', [800 800 300 150]);

title('Select Which Experiments You Would Like to Run', 'fontsize', 14);
axis off
% Button group
chkBtn1 = uicontrol(     'Style', 'checkbox',...
                         'Position', [100 400 200 30],...
                         'String','1',...
                         'Tag', '1');
chkBtn2 = uicontrol(     'Style', 'checkbox',...
                         'Position', [100 300 200 30],...
                         'String','2',...
                         'Tag', '2');
chkBtn3 = uicontrol(     'Style', 'checkbox',...
                         'Position', [100 200 200 30],...
                         'String','All',...
                         'Tag', 'all');
rButtons.SelectedObject = chkBtn1; % Set the Radio Button #2 as default ('1')

continueBtn = uicontrol('Position',[50 50 200 60],'String','Click to Continue', 'Callback','uiresume(gcbf)');
disp('Are you sure you want to begin?');
uiwait(gcf); 
close(f);
%}
disp('Loading Session...')
disp('Assign "e=[experiment you would like to run]". Assign "e=0" if you would like to run all experiments.');
disp('Then type "return" to resume program...');
keyboard
if e == 0,
    a = 1; aa = size(expt,2);
else 
    a = e; aa = e;
end

%% Analysis Iterated for Each Experiment Selected
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
        order_msg = sprintf('%s, %s', loc1, loc2);
    elseif expt(iexp).mult_loc == 0 && xObj >10
        loc1 = expt(iexp).img_loc1;
        area_list = char(loc1);
        order_msg = sprintf('%s', loc1);
    else 
        loc1 = char('V1', 'LM', 'AL', 'RL', 'AM', 'PM');
        area_list = loc1;
        order_msg = sprintf('V1, LM, AL, RL, AM, PM');
    end
    clc
    disp('Expect Analysis For:')
    opening_msg = sprintf('%s | %s | %s | %s | %dx Magnification', mouse, date, expt_name, order_msg, xObj);
    disp(opening_msg)
    disp('Note: Delete the "_exptData.mat" and "_maskData.mat" files for this experiment if you would like to select new ROIs.');
    disp('Type "return" or press [^] if this information is correct and you would like to proceed...');
    keyboard
    nROI = size(area_list,1);
    col_mat = char('k', 'b');

    fn_base = fullfile(anal_root, [date '_' mouse]);
    fn_output_home = fullfile(output_root, [date '_' mouse]);
    fn_output = fullfile(fn_output_home, [date '_' mouse '_' expt_name '_' num2str(xObj)]);
    fn_img = fullfile(fn_base, [date '_' mouse '_' expt_name '_' num2str(xObj) '_imageData.mat']);
    fn_tc = fullfile(fn_base, [date '_' mouse '_' expt_name '_' num2str(xObj) '_exptData.mat']);
    fn_mask = fullfile(fn_base, [date '_' mouse '_' expt_name '_' num2str(xObj) '_maskData.mat']);
    fn_mworks = fullfile('\\CRASH.dhe.duke.edu\data\home\andrew\Behavior\Data', ['data-' mouse '-' date '-' time_mat '.mat']);
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
    load(fn_mworks)
    if exist(fn_tc,'file') && exist(fn_mask,'file')
        load(fn_tc)
        load(fn_mask) 
        disp('Previously saved ROI and experiment data files found, skipping to figures.')
    else
        if exist(fn_img,'file')
            disp('Previously interpolated image data found. Loading file...')
            load(fn_img)
        else
            disp('Initiating new interpolation process.')
            disp('Reading image files...')
            data =[];
            for irun = 1:nrun;
                fn = fullfile(data_root, [date '_' mouse], [date '_' mouse '_' expt_name '_' num2str(xObj) '_' num2str(irun)], [date '_' mouse '_' expt_name '_' num2str(xObj) '_' num2str(irun) '_MMStack.ome.tif']);
                data_temp = readtiff(fn);
                data = cat(3,data, data_temp);
                clear data_temp
            end
            disp('Assessing dataset...')
            sz = size(data);
            tframes = 1:sz(3);
            gframes = g_ind:g_ind:sz(3);
            bframes = setdiff(tframes, gframes);
            bdata = double(data(:,:,bframes));
            gdata = double(data(:,:,gframes));
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
            disp('Sorting trials/frames...')
            for itrial = 1:ntrials
                if holdTimes(itrial) < 10000;
                    if ((cStimOn(itrial)-preframes)>=1) && ((cStimOn(itrial)+postframes)<=sz(3))
                        bdata_trials(:,:,:,itrial) = bdata_int(:,:,cStimOn(itrial)-preframes:cStimOn(itrial)+postframes-1);
                        gdata_trials(:,:,:,itrial) = gdata_int(:,:,cStimOn(itrial)-preframes:cStimOn(itrial)+postframes-1);
                    end
                end
            end
            disp('Frames sorted. Now assessing fluorescence...')
            disp('Assessing Blue Frames...')
            bdata_trials_F = mean(bdata_trials(:,:,1:preframes,:),3);
            bdata_trials_dF = bsxfun(@minus, bdata_trials, bdata_trials_F);
            bdata_trials_dFoverF = bsxfun(@rdivide, bdata_trials_dF, bdata_trials_F);
            disp('Assessing Green Frames...')
            gdata_trials_F = mean(gdata_trials(:,:,1:preframes,:),3);
            gdata_trials_dF = bsxfun(@minus, gdata_trials, gdata_trials_F);
            gdata_trials_dFoverF = bsxfun(@rdivide, gdata_trials_dF, gdata_trials_F);
            disp('Subtracting Green from Blue...')
            bdata_trials_gsub = bdata_trials_dFoverF-gdata_trials_dFoverF;
            k=1; j=(g_ind - 1);
            for i = 1:length(cStimOn)
                blue_on(:,i) = bdata_trials_dFoverF(k:j);
                interp_win(:,i) = bdata_trials_dFoverF((j-1):(j+1));
                k=k+g_ind; j=j+g_ind;
            end
            %disp('Saving Data...')
            %clear data bdata gdata bdata_int gdata_int bdata_trials gdata_trials bdata_trials_F bdata_trials_dF gdata_trials_F gdata_trials_dF         
            %save(fn_img, 'sz', 'stimOn', 'ntrials', 'preframes', 'postframes', 'bdata_trials_gsub', 'bdata_trials_dFoverF', 'gdata_trials_dFoverF',  'gratingDirectionDeg', 'dirs', '-v7.3');
            %disp('Interpolated image data saved.')
        end
        %     writetiff(squeeze(mean(bdata_trials_gsub,4)), 'C:\Users\lindsey\Desktop\160308_all.tif')
    end  
        figure;
        plot(blue_on);
        figure;
        plot(interp_win);
%{
%% Load previously selected ROIs, or else select ROIs to process
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
        disp('Processing ROIs...')
        ons = unique(stimOn);
        tc_sub = reshape(stackGetTimeCourses(reshape(bdata_trials_gsub,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
        tc_blue = reshape(stackGetTimeCourses(reshape(bdata_trials_dFoverF,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);
        tc_green = reshape(stackGetTimeCourses(reshape(gdata_trials_dFoverF,[sz(1) sz(2) (preframes+postframes)*ntrials]),mask_cell), [(preframes+postframes) ntrials size(area_list,1)]);      
        tc_sub_base = cell(length(ons),size(area_list,1));
        tc_blue_base = cell(length(ons),size(area_list,1));
        tc_green_base = cell(length(ons),size(area_list,1));
        
        intervals = unique(cell2mat(input.cStimOff)-cell2mat(input.cStimOn));
        
        for io = 1:length(intervals)
            stim_win{io} = 33:intervals(io)+33;
            base_win{io} = 23:28;
        end
        for ia = 1:size(area_list,1)
            for io = 1:length(ons)
                ind1 = find(stimOn == ons(io));
                tc_sub_base{io} = nanmean(tc_sub(stim_win{io},ind1,:),1)-nanmean(tc_sub(base_win{io},ind1,:),1);
                tc_blue_base{io} = nanmean(tc_blue(stim_win{io},ind1,:),1)-nanmean(tc_blue(base_win{io},ind1,:),1);
                tc_green_base{io} = nanmean(tc_green(stim_win{io},ind1,:),1)-nanmean(tc_green(base_win{io},ind1,:),1);
            end
        end     
        save(fn_tc, 'tc_sub', 'tc_blue', 'tc_green', 'tc_sub_base', 'tc_blue_base', 'tc_green_base', 'ons', 'stimOn', 'stim_win', 'base_win')
        disp('Data saved in the proper directory for this mouse.')
    end
%% Plots
    disp('Plotting Figures...')
    % Plot dF/F by Visual Area for Each Stimulus Condition
    [n, n2] = subplotn(size(ons,2));
    for ia = 1:size(area_list,1)  
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        start=0;
        for io = 1:length(ons)
            ind1 = find(stimOn == ons(io));
            for id = 1:length(ons)
                ind = intersect(ind1, find(stimOn == ons(id)));
                indn(id) = length(ind);
                base_temp = cell2mat(base_win(id));
                resp_temp = cell2mat(stim_win(id));
                subplot(n,n2,id)
                hold on
                shadedErrorBar(1:size(tc_sub,1), nanmean(tc_sub(:,ind,ia),2), nanstd(tc_sub(:,ind,ia),[],2)./sqrt(length(ind)));
    %             plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
                %vline(base_temp(:,1),'--k')
                %vline(base_temp(:,end),'--k')
                vline(resp_temp(:,1), '--k')
                vline(resp_temp(:,end))
                set(gca,'XTick',0:30:270)
                set(gca,'XTickLabel', {'-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
                title([num2str(ons(id)) '  ms on'])
                ylim([-0.02 0.08])
                xlim([0 270])
                hold off
            end
            start = start+length(ons);
        end
        suptitle([mouse ' ' date '- Area ' area_list(ia,:)])   
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '.png']), '-dpng');
    end
    % Plot BLUE dF/F by Visual Area for Each Stimulus Condition
    [n, n2] = subplotn(size(ons,2));
    for ia = 1:size(area_list,1)  
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        start=0;
        for io = 1:length(ons)
            ind1 = find(stimOn == ons(io));
            for id = 1:length(ons)
                ind = intersect(ind1, find(stimOn == ons(id)));
                indn(id) = length(ind);
                base_temp = cell2mat(base_win(id));
                resp_temp = cell2mat(stim_win(id));
                subplot(n,n2,id)
                hold on
                shadedErrorBar(1:size(tc_blue,1), nanmean(tc_blue(:,ind,ia),2), nanstd(tc_blue(:,ind,ia),[],2)./sqrt(length(ind)));
    %             plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
                %vline(base_temp(:,1),'--k')
                %vline(base_temp(:,end),'--k')
                vline(resp_temp(:,1), '--k')
                vline(resp_temp(:,end))
                set(gca,'XTick',0:30:270)
                set(gca,'XTickLabel', {'-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
                title([num2str(ons(id)) '  ms on'])
                ylim([-0.02 0.08])
                xlim([0 270])
                hold off
            end
            start = start+length(ons);
        end
        suptitle([mouse ' ' date ' - Blue dF/F - Area ' area_list(ia,:)])   
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_Blue.png']), '-dpng');
    end
    % Plot GREEN dF/F by Visual Area for Each Stimulus Condition
    [n, n2] = subplotn(size(ons,2));
    for ia = 1:size(area_list,1)  
        f = figure; set(f, 'Position', [270 195 1500 1150]);
        start=0;
        for io = 1:length(ons)
            ind1 = find(stimOn == ons(io));
            for id = 1:length(ons)
                ind = intersect(ind1, find(stimOn == ons(id)));
                indn(id) = length(ind);
                base_temp = cell2mat(base_win(id));
                resp_temp = cell2mat(stim_win(id));
                subplot(n,n2,id)
                hold on
                shadedErrorBar(1:size(tc_green,1), nanmean(tc_green(:,ind,ia),2), nanstd(tc_green(:,ind,ia),[],2)./sqrt(length(ind)));
    %             plot(1:size(tc_sub,1), mean(tc_sub(:,ind,1),2), col_mat(id,:));
                %vline(base_temp(:,1),'--k')
                %vline(base_temp(:,end),'--k')
                vline(resp_temp(:,1), '--k')
                vline(resp_temp(:,end))
                set(gca,'XTick',0:30:270)
                set(gca,'XTickLabel', {'-1', '0', '1', '2', '3', '4', '5', '6', '7', '8'})
                title([num2str(ons(id)) '  ms on'])
                ylim([-0.02 0.005])
                xlim([0 270])
                hold off
            end
            start = start+length(ons);
        end
        suptitle([mouse ' ' date ' - Green dF/F - Area ' area_list(ia,:)])   
        print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_Green.png']), '-dpng');
    end
    %}
%     % Plot Blue/Black Overlay, 250/500ms
%     [n, n2] = subplotn(length(ons));
%     for ia = 1:size(area_list,1)  
%         f = figure; set(f, 'Position', [270 195 1500 1150]);
%         for io = 1:length(ons)
%             ind1 = find(stimOn == ons(io));
%             base_temp = base_win{io};
%             resp_temp = resp_win{io};
%             subplot(n,n2,io)
%             for id = 1:length(ons)
%                 ind = intersect(ind1, find(stimOn == ons(id)));
%                 indn(id,io) = length(ind);
%                 shadedErrorBar(1:size(tc_sub,1), nanmean(tc_sub(:,ind,ia),2), nanstd(tc_sub(:,ind,ia),[],2)./sqrt(length(ind)), col_mat(id,:));
%                 hold on;
%                 title([num2str(ons(io)) ' ms off'])
%                 hold on
%             end
%         end
%         suptitle([mouse ' ' date '- Area ' area_list(ia,:) '; Black: 45 deg; Blue: 90 deg'])   
%         print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_' area_list(ia,:) '_overlay.png']), '-dpng');
%     end
%     % Plot Change in Response for Each Degree Change
%     f = figure; set(f, 'Position', [270 195 1500 1150]);
%     [n,n2] = subplotn(size(area_list,1));
%     for ia = 1:size(area_list,1)
%         subplot(n,n2,ia)
%         for io = 1:length(ons)
%             temp = bsxfun(@rdivide, tc_sub_base{io,5,ia}, nanmean(tc_sub_base{io,1,ia},2));
%             shadedErrorBar(dirs,repmat(nanmean(temp(:,:,ia),2), [1, length(dirs)]),repmat(nanstd(temp(:,:,ia),[],2)./sqrt(size(temp,2)), [1, length(dirs)]), col_mat(io,:));
%             hold on
%             for id = 1:length(dirs)
%                 temp = bsxfun(@rdivide, tc_sub_dir{io,id,6,ia}, nanmean(tc_sub_base{io,1,ia},2));
%                 errorbar(dirs(id),nanmean(temp(:,:,ia),2),nanstd(temp(:,:,ia),[],2)./sqrt(size(temp,2)), ['-o' col_mat(io,:)])
%                 hold on
%             end
%         end
%         title(['Area ' area_list(ia,:)])
%         ylim([0 2])
%     end
%     suptitle([mouse ' ' date '- Black: 250ms; Blue: 500ms'])
%     print(fullfile(fn_output, [date '_' mouse '_' expt_name '_' num2str(xObj) '_change_resp.png']), '-dpng');
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

            
