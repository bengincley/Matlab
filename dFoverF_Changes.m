%% Final Analysis dF/F Changes
anal_root = 'S:\Imaging\Analysis Code';
fn_compiled = (fullfile(anal_root, 'Compiled_Data.mat'));
load(fn_compiled)
mkey = ['AW46';'i538';'AW56'];
akey = ['V1','AL','LM','PM'];
V1_ind{1}=[1 4 6]; V1_ind{2}=[2 3 5]; V1_ind{3}=[7 8 9]; % AW46; i538; AW56
AL_ind{1}=[1 3 5 8]; AL_ind{2}=[2 4 6]; AL_ind{3}=[7 9 10]; % AW46; i538; AW56
LM_ind{1}=[1 4 6 7]; LM_ind{2}=[2 3]; LM_ind{3}=[5 8 9]; % AW46; i538; AW56
PM_ind{1}=[1 2 3]; %AW46

col_v = ['k' 'r' 'b'];
%% Vectorize Data
v_FS{1} = vectorize_dF(FS_V1);
v_FS{2} = vectorize_dF(FS_AL);
v_FS{3} = vectorize_dF(FS_LM);
v_FS{4} = vectorize_dF(FS_PM);

v_PP{1} = vectorize_dF(PP_V1);
v_PP{2} = vectorize_dF(PP_AL);
v_PP{3} = vectorize_dF(PP_LM);
v_PP{4} = vectorize_dF(PP_PM);

v_DU{1} = vectorize_dF(DU_V1);
v_DU{2} = vectorize_dF(DU_AL);
v_DU{3} = vectorize_dF(DU_LM);
v_DU{4} = vectorize_dF(DU_PM);

%% Figures
%     for n=1:size(area_ind,2)
%         a(n) = length(area_ind{n});
%     end
%     for i = 1:size(a,2)
%         for j=1:a(i)
for im=1:3
        for d=1:3
            ewd_v1{im}(d,:) = [v_FS{1}(V1_ind{im}(d)); v_PP{1}(V1_ind{im}(d)); v_DU{1}(V1_ind{im}(d))]; %Experiments within day
            ewd_al{im}(d,:) = [v_FS{2}(AL_ind{im}(d)); v_PP{2}(AL_ind{im}(d)); v_DU{2}(AL_ind{im}(d))];
        end
        for d=1:2
            ewd_lm{im}(d,:) = [v_FS{3}(LM_ind{im}(d)); v_PP{3}(LM_ind{im}(d)); v_DU{3}(LM_ind{im}(d))];
        end
end

%             ewd_pm{im}(d,:) = [v_FS{1}(PM_ind{im}(d)); v_PP{1}(PM_ind{im}(d)); v_DU{1}(PM_ind{im}(d))];
ewd_v1{1,1}(2,:) = circshift(ewd_v1{1,1}(2,:),[1,1]);
ewd_lm{1,2}(2,:) = circshift(ewd_lm{1,2}(2,:),[1,1]);
ewd_lm{1,1}(2,:) = circshift(ewd_lm{1,1}(2,:),[1,1]);
for im=1:3
figure;
for n=1:length(ewd_v1{im}(2,:))
    hold on
    plot(ewd_v1{im}(n,:),'Color',col_v(n),'LineWidth', 2,'Marker','*')
    xlim([0 4])    
    ylim([0.0 0.1])
    set(gca,'XTick',0:1:4)
    set(gca,'XTickLabel', {'','1st','2nd','3rd',''})
    title([mkey(im,:) ' -  V1'])
    ylabel('Max dF/F Observed')
    xlabel('Daily Experiment')
    [~,~] = legend('1st Session','2nd Session','3rd Session');
    hold off
end
end
for im=1:3
figure;
for n=1:length(ewd_al{im}(:,1))
    hold on
    plot(ewd_al{im}(n,:),'Color',col_v(n),'LineWidth', 2,'Marker','*')
    xlim([0 4])    
    ylim([0.0 0.1])
    set(gca,'XTick',0:1:4)
    set(gca,'XTickLabel', {'','1st','2nd','3rd',''})
    title([mkey(im,:) ' -  AL'])
    ylabel('Max dF/F Observed')
    xlabel('Daily Experiment')
    [~,~] = legend('1st Session','2nd Session','3rd Session');
    hold off
end
end
for im=1:3
figure;
for n=1:length(ewd_lm{im}(:,1))
    hold on
    plot(ewd_lm{im}(n,:),'Color',col_v(n),'LineWidth', 2,'Marker','*')
    xlim([0 4])    
    ylim([0.0 0.1])
    set(gca,'XTick',0:1:4)
    set(gca,'XTickLabel', {'','1st','2nd','3rd',''})
    title([mkey(im,:) ' -  LM'])
    ylabel('Max dF/F Observed')
    xlabel('Daily Experiment')
    [~,~] = legend('1st Session','2nd Session','3rd Session');
    hold off
end
end