function [bdata_trials_gsub] = dF_Over_F_fun_TC_Analysis(bdata_trials, gdata_trials, preframes)
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