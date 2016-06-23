% Load each experiment, sort into a structure organized by experiment and
% then mouse and then area
clear all
v1_days = [1 2 7 10 13 15 16 20 25];
al_days = [3 4 8 11 14];
lm_days = [6 9 12 19];
allm_days = [5 17 18 21 26];
pm_days = [22 23 24];
%% Flashing Stim
WideField_FlashStim_DataSets
s = 12;
FS_V1(length(v1_days)).num = [];
FS_AL(length(al_days)).num = [];
FS_LM(length(lm_days)+length(allm_days)).num = [];
FS_PM(length(pm_days)).num = [];

FS_Data(length(s:(size(expt,2)))).num = [];
for iexp = s:(size(expt,2))
    date = expt(iexp).date;
    time = expt(iexp).time_mat;
    mouse = ['i' expt(iexp).SubNum];
    xObj = expt(iexp).obj;
    exp = expt_name;
    if expt(iexp).mult_loc == 1 && xObj > 10
        loc1 = expt(iexp).img_loc1;
        loc2 = expt(iexp).img_loc2;
        area_list = char(loc1, loc2);
        area_str = sprintf('%s_%s', loc1, loc2);
    elseif expt(iexp).mult_loc == 0 && xObj >10
        loc1 = expt(iexp).img_loc1;
        area_list = char(loc1);
        area_str = sprintf('%s', loc1);
    end
    fn_base = fullfile(anal_root,  'FS5');
    fn_final = fullfile(fn_base, [date '_' mouse '_' expt_name '_' area_str '_final.mat']);
    load(fn_final)
    FS_Data(iexp-s+1).num = iexp;
    FS_Data(iexp-s+1).date = date;
    FS_Data(iexp-s+1).time = time;
    FS_Data(iexp-s+1).file = fn_final;
    for ia = 1:size(area_list,1)
        FS_Data(iexp-s+1).area(ia,:) = area_list(ia,:);
        FS_Data(iexp-s+1).mouse = mouse;
        FS_Data(iexp-s+1).offs = offs;
        FS_Data(iexp-s+1).stimOff = stimOff;
        FS_Data(iexp-s+1).resp_v(:,:,ia) = resp_v(:,:,ia);
        FS_Data(iexp-s+1).max_p1(ia) = max_p1(ia);
    end
end
FS_V1 = FS_Data(v1_days);
FS_AL = FS_Data(al_days);
FS_AL2 = FS_Data(allm_days);
FS_LM = FS_Data(lm_days);
FS_LM2 = FS_Data(allm_days);
for n=1:length(allm_days)
    FS_AL2(n).area = [];
    FS_AL2(n).resp_v = [];
    FS_AL2(n).max_p1 = [];
    FS_LM2(n).area = [];
    FS_LM2(n).resp_v = [];
    FS_LM2(n).max_p1 = [];
    FS_AL2(n).area = FS_Data(allm_days(n)).area(1,:);
    FS_AL2(n).resp_v = FS_Data(allm_days(n)).resp_v(:,:,1);
    FS_AL2(n).max_p1 = FS_Data(allm_days(n)).max_p1(1);
    FS_LM2(n).area = FS_Data(allm_days(n)).area(2,:);
    FS_LM2(n).resp_v = FS_Data(allm_days(n)).resp_v(:,:,2);
    FS_LM2(n).max_p1 = FS_Data(allm_days(n)).max_p1(2);
end
FS_AL = [FS_AL, FS_AL2];
FS_LM = [FS_LM, FS_LM2];
[~,index] = sortrows([FS_AL.num].'); FS_AL = FS_AL(index); clear index
[~,index] = sortrows([FS_LM.num].'); FS_LM = FS_LM(index); clear index
FS_PM = FS_Data(pm_days);
disp('Flashing Stim Complete.')
clear expt
%% Paired Pulse 
WideField_PairedPulse_DataSets
s=5;
PP_V1(length(v1_days)).num = [];
PP_AL(length(al_days)).num = [];
PP_LM(length(lm_days)+length(allm_days)).num = [];
PP_PM(length(pm_days)).num = [];

PP_Data(length(s:(size(expt,2)))).num = [];
for iexp = s:(size(expt,2))
    date = expt(iexp).date;
    time = expt(iexp).time_mat;
    mouse = ['i' expt(iexp).SubNum];
    xObj = expt(iexp).obj;
    exp = expt_name;
    if expt(iexp).mult_loc == 1 && xObj > 10
        loc1 = expt(iexp).img_loc1;
        loc2 = expt(iexp).img_loc2;
        area_list = char(loc1, loc2);
        area_str = sprintf('%s_%s', loc1, loc2);
    elseif expt(iexp).mult_loc == 0 && xObj >10
        loc1 = expt(iexp).img_loc1;
        area_list = char(loc1);
        area_str = sprintf('%s', loc1);
    end
    fn_base = fullfile(anal_root,  'PP5');
    fn_final = fullfile(fn_base, [date '_' mouse '_' expt_name '_' area_str '_final.mat']);
    load(fn_final)
    PP_Data(iexp-s+1).num = iexp;
    PP_Data(iexp-s+1).date = date;
    PP_Data(iexp-s+1).time = time;
    PP_Data(iexp-s+1).file = fn_final;
    for ia = 1:size(area_list,1)
        PP_Data(iexp-s+1).area(ia,:) = area_list(ia,:);
        PP_Data(iexp-s+1).mouse = mouse;
        PP_Data(iexp-s+1).offs = offs;
        PP_Data(iexp-s+1).stimOff = stimOff;
        for n = 1:size(betas_residual,2)
            PP_Data(iexp-s+1).betas_residual(ia,n) = betas_residual{n}(ia);
        end
        PP_Data(iexp-s+1).norm_recov(ia,:) = norm_recov(:,ia);
        PP_Data(iexp-s+1).max_p1(ia) = max_p1(ia);
        PP_Data(iexp-s+1).h(:,:,ia) = h(:,:,ia);
    end
end
PP_V1 = PP_Data(v1_days);
PP_AL = PP_Data(al_days);
PP_AL2 = PP_Data(allm_days);
PP_LM = PP_Data(lm_days);
PP_LM2 = PP_Data(allm_days);
for n=1:length(allm_days)
    PP_AL2(n).area = [];
    PP_AL2(n).betas_residual = [];
    PP_AL2(n).norm_recov = [];
    PP_AL2(n).max_p1 = [];
    PP_AL2(n).h = [];
    PP_LM2(n).area = [];
    PP_LM2(n).betas_residual = [];
    PP_LM2(n).norm_recov = [];    
    PP_LM2(n).max_p1 = [];  
    PP_LM2(n).h = [];
    PP_AL2(n).area = PP_Data(allm_days(n)).area(1,:);
    PP_AL2(n).betas_residual = PP_Data(allm_days(n)).betas_residual(1,:);
    PP_AL2(n).norm_recov = PP_Data(allm_days(n)).norm_recov(1,:);    
    PP_AL2(n).max_p1 = PP_Data(allm_days(n)).max_p1(1);
    PP_AL2(n).h = PP_Data(allm_days(n)).h(:,:,1);
    PP_LM2(n).area = PP_Data(allm_days(n)).area(2,:);
    PP_LM2(n).betas_residual = PP_Data(allm_days(n)).betas_residual(2,:);
    PP_LM2(n).norm_recov = PP_Data(allm_days(n)).norm_recov(2,:);
    PP_LM2(n).max_p1 = PP_Data(allm_days(n)).max_p1(2);
    PP_LM2(n).h = PP_Data(allm_days(n)).h(:,:,2);
end
PP_AL = [PP_AL, PP_AL2];
PP_LM = [PP_LM, PP_LM2];
[~,index] = sortrows([PP_AL.num].'); PP_AL = PP_AL(index); clear index
[~,index] = sortrows([PP_LM.num].'); PP_LM = PP_LM(index); clear index
PP_PM = PP_Data(pm_days);
disp('Paired Pulse Complete.')
clear expt
%% Duration
WideField_Duration_DataSets
s=11;
DU_V1(length(v1_days)).num = [];
DU_AL(length(al_days)).num = [];
DU_LM(length(lm_days)+length(allm_days)).num = [];
DU_PM(length(pm_days)).num = [];

DU_Data(length(s:(size(expt,2)))).num = [];
for iexp = s:(size(expt,2))
    date = expt(iexp).date;
    time = expt(iexp).time_mat;
    mouse = ['i' expt(iexp).SubNum];
    xObj = expt(iexp).obj;
    exp = expt_name;
    if expt(iexp).mult_loc == 1 && xObj > 10
        loc1 = expt(iexp).img_loc1;
        loc2 = expt(iexp).img_loc2;
        area_list = char(loc1, loc2);
        area_str = sprintf('%s_%s', loc1, loc2);
    elseif expt(iexp).mult_loc == 0 && xObj >10
        loc1 = expt(iexp).img_loc1;
        area_list = char(loc1);
        area_str = sprintf('%s', loc1);
    end
    fn_base = fullfile(anal_root,  'DU5');
    fn_final = fullfile(fn_base, [date '_' mouse '_' expt_name '_' area_str '_final.mat']);
    load(fn_final)
    DU_Data(iexp-s+1).num = iexp;
    DU_Data(iexp-s+1).date = date;
    DU_Data(iexp-s+1).time = time;
    DU_Data(iexp-s+1).file = fn_final;
    for ia = 1:size(area_list,1)
        DU_Data(iexp-s+1).area(ia,:) = area_list(ia,:);
        DU_Data(iexp-s+1).mouse = mouse;
        DU_Data(iexp-s+1).stimOn = stimOn;
        DU_Data(iexp-s+1).ons = ons;
        for n = 1:size(sust_trans_ratio,1)
            DU_Data(iexp-s+1).sust_trans_ratio(ia,n) = sust_trans_ratio(n,ia);
        end
        DU_Data(iexp-s+1).max_p1(ia) = max_p1(ia);
    end
end
DU_V1 = DU_Data(v1_days);
DU_AL = DU_Data(al_days);
DU_AL2 = DU_Data(allm_days);
DU_LM = DU_Data(lm_days);
DU_LM2 = DU_Data(allm_days);
for n=1:length(allm_days)
    DU_AL2(n).area = [];
    DU_AL2(n).sust_trans_ratio = [];
    DU_AL2(n).max_p1 = [];
    DU_LM2(n).area = [];
    DU_LM2(n).sust_trans_ratio = [];
    DU_LM2(n).max_p1 = [];
    DU_AL2(n).area = DU_Data(allm_days(n)).area(1,:);
    DU_AL2(n).sust_trans_ratio = DU_Data(allm_days(n)).sust_trans_ratio(1,:);
    DU_AL2(n).max_p1 = DU_Data(allm_days(n)).max_p1(1);
    DU_LM2(n).area = DU_Data(allm_days(n)).area(2,:);
    DU_LM2(n).sust_trans_ratio = DU_Data(allm_days(n)).sust_trans_ratio(2,:);
    DU_LM2(n).max_p1 = DU_Data(allm_days(n)).max_p1(2);
end
DU_AL = [DU_AL, DU_AL2];
DU_LM = [DU_LM, DU_LM2];
[~,index] = sortrows([DU_AL.num].'); DU_AL = DU_AL(index); clear index
[~,index] = sortrows([DU_LM.num].'); DU_LM = DU_LM(index); clear index
DU_PM = DU_Data(pm_days);
disp('Duration Complete.')
%% Save
fn_save = (fullfile(anal_root, 'Compiled_Data.mat'));
save(fn_save, 'FS_Data', 'PP_Data', 'DU_Data', 'FS_V1', 'FS_AL', 'FS_LM', 'FS_PM', 'PP_V1', 'PP_AL', 'PP_LM', 'PP_PM',  'DU_V1', 'DU_AL', 'DU_LM', 'DU_PM');
disp('Save Complete.')
% %% Check
% clear all
% anal_root = 'S:\Imaging\Analysis Code';
% fn_save = (fullfile(anal_root, 'Compiled_Data.mat'));
% load(fn_save)