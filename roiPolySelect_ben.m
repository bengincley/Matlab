bdata_avg = nanmean(mean(bdata_trials_gsub(:,:,preframes+5:preframes+15,:),3),4);
image_fig = figure; H = imagesc(bdata_avg); colormap(summer);
figPos = [200 190 1400 1080]; set(image_fig, 'Position', figPos);
clim([-.005 .03])
print(image_fig, '-dpng', fullfile(fn_output, [date '_' mouse '_' expt_name '_' areas '_image.png']));
%adjust number of ROIs to choose
for i = 1:nROI
    roi(i) = impoly;
end

mask = zeros(sz(1),sz(2),nROI);
for i = 1:nROI
    mask(:,:,i) = createMask(roi(i));
end

roi_cluster = sum(mask,3);
mask_cell = bwlabel(roi_cluster);
mask_fig = figure; set(mask_fig, 'Position', figPos); imagesc(mask_cell);
print(mask_fig, '-dpng', fullfile(fn_output, [date '_' mouse '_' expt_name '_' areas '_ROIs.png']));