function plot_mice(expt_area,area_ind,expt,subexpt,area)
f = figure; set(f, 'Position', [270 195 550 700*.75]);
area_str = ['V1'; 'AL'; 'LM'; 'PM'];
col_v = ['k' 'r' 'b'];
% Flashing Stim %
if expt==1
    if subexpt == 1 
        subexpt_name = '250ms';
        sx = 1;
    elseif subexpt == 2
        subexpt_name = '500ms';
        sx = 2;
    end
    for n=1:size(area_ind,2)
        a(n) = length(area_ind{n});
    end
    for i = 1:size(a,2)
        for j=1:a(i)
            hold on
            h(i) = plot(expt_area(area_ind{i}(j)).resp_v(sx,:),'Color',col_v(i),'LineWidth', 2,'Marker','*');
            title([subexpt_name ' Pulse ISI - ' area_str(area,:)])
            xlabel('Pulse Number')
            ylabel('Normalized % Response Magnitude')
            xlim([0.5 5.5])
            ylim([0 1])
            set(gca,'XTick',1:1:5)
            set(gca,'XTickLabel',{'1' '2' '3' '4' '5'})
        end  
    end
    if area==4
        [~] = legend([h(1)],{'AW46'});
    else
        [~] = legend([h(1) h(2) h(3)],{'AW46','i538','AW56'}); 
    end
    print(fullfile('S:\Imaging\FS', ['FS_' num2str(sx) '_' area_str(area,:) 'ind.png']), '-dpng');
    hold off
% Paired Pulse %
elseif expt==2
    load(fullfile('S:\Imaging\Analysis Code\Compiled_Data.mat'));
    for n=1:size(area_ind,2)
        a(n) = length(area_ind{n});
    end
    for i = 1:size(a,2)
        for j=1:a(i)
            hold on
            all = 100.* horzcat(expt_area(area_ind{i}(j)).betas_residual,expt_area(area_ind{i}(j)).norm_recov(4:5));
            h(i) = plot(PP_Data(1).offs,all,'Color',col_v(i),'LineWidth', 2,'Marker','*');
            title(['Paired Pulse of Varying ISI - ' area_str(area,:)])
            xlabel('2nd Pulse Latency (ms)')
            ylabel('Normalized Response Magnitude (%)')
            xlim([0 4500])
            ylim([0 120])
%             set(gca,'XTick',1:1:5)
%             set(gca,'XTickLabel',{'1' '2' '3' '4' '5'})
        end
    end
    if area==4
        [~] = legend([h(1)],{'AW46'});
    else
        [~] = legend([h(1) h(2) h(3)],{'AW46','i538','AW56'}); 
    end
    print(fullfile('S:\Imaging\PP', ['Individuals_' area_str(area,:) '_ind.png']), '-dpng');
    hold off
% Duration %
elseif expt==3
    for n=1:size(area_ind,2)
        a(n) = length(area_ind{n});
    end
    for i = 1:size(a,2)
        for j=1:a(i)
            hold on
            h(i) = plot(expt_area(area_ind{i}(j)).sust_trans_ratio(1,:),'Color',col_v(i),'LineWidth', 2,'Marker','*');
            title(['Sustained/Transient Ratio by Mouse - ' area_str(area,:)])
            xlabel('Duration of Stimulus')
            ylabel('Sustained / Transient Response Ratio')
            xlim([0.9 2.1])
            ylim([-.40 1.60])
            set(gca,'XTick',1:1:2)
            set(gca,'XTickLabel',{'2000ms','4000ms'})
        end
    end
    if area==4
        [~] = legend([h(1)],{'AW46'});
    else
        [~] = legend([h(1) h(2) h(3)],{'AW46','i538','AW56'}); 
    end
    hold off
    print(fullfile('S:\Imaging\Duration', ['Sust_Trans_Ratio_' area_str(area,:) 'ind.png']), '-dpng');
else 
    disp('Experiment Number Error')
end
