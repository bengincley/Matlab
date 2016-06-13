% Load each experiment, sort into a structure organized by experiment and
% then mouse and then area
%% Flashing Stim
WideField_FlashStim_DataSets
data(length(12:(size(expt,2)))).num = [];
for iexp = 12:(size(expt,2))
    date = expt(iexp).date;
    mouse = ['i' expt(iexp).SubNum];
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
    fn_expt = fullfile(fn_base, [date '_' mouse '_' expt_name '_' area_str '_exptData.mat']);
    load(fn_expt)
    data(iexp).num = iexp;
    data(iexp).file = fn_expt;
    for ia = 1:size(area_list,1)
        data(iexp).base_win = base_win;
        data(iexp).resp_win = resp_win;
        data(iexp).input = input;
        data(iexp).resp_amp_norm{:,:,ia} = resp_amp_norm{:,:,ia};
        data(iexp).resp_v(:,:,ia) = resp_v(:,:,ia);
        data(iexp).stimOff = stimOff;
    end
    
    
end
