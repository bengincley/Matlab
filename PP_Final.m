%% Final Analysis for Paired Pulse
anal_root = 'S:\Imaging\Analysis Code';
fn_compiled = (fullfile(anal_root, 'Compiled_Data.mat'));
load(fn_compiled)
V1_ind{1}=[1 4 6]; V1_ind{2}=[2 3 5]; V1_ind{3}=[7 8 9]; % AW46; i538; AW56
AL_ind{1}=[1 3 5 8]; AL_ind{2}=[2 4 6]; AL_ind{3}=[7 9 10]; % AW46; i538; AW56
LM_ind{1}=[1 4 6 7]; LM_ind{2}=[2 3]; LM_ind{3}=[5 8 9]; % AW46; i538; AW56
PM_ind{1}=[1 2 3]; %AW46
load(fullfile(anal_root, 'Color_Library.mat'));
l_col = [[0.5 0.5 0.5]; redM; orangeL; cyan];
d_col = [[0 0 0]; redD; orangeD; cyan];
%% Vectorize Data
[v_PP_b_res{1}, v_PP_norm_rec{1}] = vectorize_PP(PP_V1);
[v_PP_b_res{2}, v_PP_norm_rec{2}] = vectorize_PP(PP_AL);
[v_PP_b_res{3}, v_PP_norm_rec{3}] = vectorize_PP(PP_LM);
[v_PP_b_res{4}, v_PP_norm_rec{4}] = vectorize_PP(PP_PM);

for n=1:4
    m_b_res{n} = mean(v_PP_b_res{n}(:,:,:),3);
    m_norm_rec{n} = mean(v_PP_norm_rec{n}(:,:,:),3);
    for a = 1:5
    sem_res{n}(a) = std(v_PP_b_res{n}(:,a,:)) ./sqrt(length(v_PP_b_res{n}));
    sem_norm_rec{n}(a) = std(v_PP_norm_rec{n}(:,a,:)) ./sqrt(length(v_PP_norm_rec{n}));
    end
    for ip=1:5
    [hpp(n,ip,1),ppp(n,ip,1)] = ttest(v_PP_b_res{n}(:,ip,:),1,'Alpha', 0.05); % Tests if recovery/beta values are significantly different from 1
    [hpp(n,ip,2),ppp(n,ip,2)] = ttest(v_PP_b_res{n}(:,ip,:),1,'Alpha', 0.01);
    [hpp(n,ip,3),ppp(n,ip,3)] = ttest(v_PP_b_res{n}(:,ip,:),1,'Alpha', 0.001);
    end
end

%% Baseline 
for n=1:length(PP_Data)
    base_2s(n) = PP_Data(n).h(1,1);
    base_4s(n) = PP_Data(n).h(1,2);
    test_2s(n) = PP_Data(n).h(2,1);
    test_4s(n) = PP_Data(n).h(2,2);
end
for n=1:length(PP_V1)
    base_2s_v1(n) = PP_V1(n).h(1,1);
    base_4s_v1(n) = PP_V1(n).h(1,2);
    test_2s_v1(n) = PP_V1(n).h(2,1);
    test_4s_v1(n) = PP_V1(n).h(2,2);
end
for n=1:length(PP_AL)
    base_2s_al(n) = PP_AL(n).h(1,1);
    base_4s_al(n) = PP_AL(n).h(1,2);
    test_2s_al(n) = PP_AL(n).h(2,1);
    test_4s_al(n) = PP_AL(n).h(2,2);
end
for n=1:length(PP_LM)
    base_2s_lm(n) = PP_LM(n).h(1,1);
    base_4s_lm(n) = PP_LM(n).h(1,2);
    test_2s_lm(n) = PP_LM(n).h(2,1);
    test_4s_lm(n) = PP_LM(n).h(2,2);
end
for n=1:length(PP_PM)
    base_2s_pm(n) = PP_PM(n).h(1,1);
    base_4s_pm(n) = PP_PM(n).h(1,2);
    test_2s_pm(n) = PP_PM(n).h(2,1);
    test_4s_pm(n) = PP_PM(n).h(2,2);
end
    
figure; % All points
    hold on
        plot(base_2s,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None','Linewidth',2)
        plot(base_4s,'ko','Linewidth',2)
        plot(test_2s,'Color',blueL,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s,'Color',blueD,'Marker','o','LineStyle','None','Linewidth',2)
        plot([0 27],[0 0], '--k')
    xlim([0 27])
    xlabel('Experiment')
    ylabel('Magnitude dF/F Baseline')
    [~,~] = legend('Base Pulse, 2s','Base Pulse, 4s','Test Pulse, 2s','Test Pulse, 4s','Location','Southeast');
    hold off
figure; % HVAs
    hold on
        plot(base_2s_v1,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(base_4s_v1,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(test_2s_v1,'Color',[0 0 0],'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_v1,'Color',[0 0 0],'Marker','o','LineStyle','None','Linewidth',2) 
        plot(base_2s_al,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(base_4s_al,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(test_2s_al,'Color',redM,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_al,'Color',redM,'Marker','o','LineStyle','None','Linewidth',2)
        plot(base_2s_lm,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(base_4s_lm,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(test_2s_lm,'Color',orangeD,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_lm,'Color',orangeD,'Marker','o','LineStyle','None','Linewidth',2)
        plot(base_2s_pm,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(base_4s_pm,'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None')
        plot(test_2s_pm,'Color',blueM,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_pm,'Color',blueM,'Marker','o','LineStyle','None','Linewidth',2)
        plot([0 10],[0 0], '--k')
        [~,~] = legend('Base Pulse','','V1','','','','AL','','','','LM','','','','PM','','Location','Southeast');
    xlim([0 10])
    xlabel('Experiment')
    ylabel('Magnitude dF/F Baseline')
    hold off
figure; % Histograms
    hold on
    nbins=16;
    subplot(2,2,1)
    hold on
        hist(base_2s,nbins); hi = findobj(gca,'Type','patch');
        set(hi,'FaceColor',[0.5 0.5 0.5])
        plot([0 0],[0 6],'--g','LineWidth',1.5)
        xlim([-0.03 0.03])
        ylim([0 6])
        title('Base Stimulus Baseline, 2s IPI')
        xlabel('dF/F')
        ylabel('Frequency')
    subplot(2,2,2)
    hold on
        hist(base_4s,nbins); hi = findobj(gca,'Type','patch');
        set(hi,'FaceColor',[0 0 0])
        plot([0 0],[0 6],'--g','LineWidth',1.5)
        xlim([-0.03 0.03])
        ylim([0 6])
        title('Base Stimulus Baseline, 4s IPI')
        xlabel('dF/F')
        ylabel('Frequency')
    subplot(2,2,3)
    hold on
        hist(test_2s,nbins); hi = findobj(gca,'Type','patch');
        set(hi,'FaceColor',blueL)
        plot([0 0],[0 6],'--g','LineWidth',1.5)
        xlim([-0.03 0.03])
        ylim([0 6])
        title('Test Stimulus Baseline, 2s IPI')
        xlabel('dF/F')
        ylabel('Frequency')
    subplot(2,2,4)
    hold on
        hist(test_4s,nbins); hi = findobj(gca,'Type','patch');
        set(hi,'FaceColor',blueD)
        plot([0 0],[0 6],'--g','LineWidth',1.5)
        xlim([-0.03 0.03])
        ylim([0 6])
        title('Test Stimulus Baseline, 4s IPI')
        xlabel('dF/F')
        ylabel('Frequency')
    hold off
% Adaptation vs Baseline dF/F
figure;
v1_adapt(1,:) = reshape(v_PP_b_res{1}(1,4,:),1,9);
v1_adapt(2,:) = reshape(v_PP_b_res{1}(1,5,:),1,9);
al_adapt(1,:) = reshape(v_PP_b_res{2}(1,4,:),1,10);
al_adapt(2,:) = reshape(v_PP_b_res{2}(1,5,:),1,10);
lm_adapt(1,:) = reshape(v_PP_b_res{3}(1,4,:),1,9);
lm_adapt(2,:) = reshape(v_PP_b_res{3}(1,5,:),1,9);
pm_adapt(1,:) = reshape(v_PP_b_res{4}(1,4,:),1,3);
pm_adapt(2,:) = reshape(v_PP_b_res{4}(1,5,:),1,3);
hold on
        plot(test_2s_v1(:),v1_adapt(1,:),'Color',[0.5 0.5 0.5],'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_v1(:),v1_adapt(2,:),'Color',[0 0 0],'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_2s_al(:),al_adapt(1,:),'Color',redL,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_al(:),al_adapt(2,:),'Color',redD,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_2s_lm(:),lm_adapt(1,:),'Color',orangeL,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_lm(:),lm_adapt(2,:),'Color',orangeD,'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_2s_pm(:),pm_adapt(1,:),'Color',[0 1 1],'Marker','o','LineStyle','None','Linewidth',2)
        plot(test_4s_pm(:),pm_adapt(2,:),'Color',cyan,'Marker','o','LineStyle','None','Linewidth',2)
        xlabel('Baseline for Second Pulse')
        xlabel('Baseline for Second Pulse')
        title('Adaptation vs. Baseline dF/F')
        ylabel('Observed Adaptation')
hold off
%% Figures
% Plots individual traces colored by mouse
plot_mice(PP_V1,V1_ind,2,1,1)
plot_mice(PP_AL,AL_ind,2,1,2)
plot_mice(PP_LM,LM_ind,2,1,3)
plot_mice(PP_PM,PM_ind,2,1,4)
col_v = ['k' 'r' 'b'];
% Investigates AL/LM behavior of AW56
% figure;
% for n=1:3
%     hold on
%     al = 100.* horzcat(PP_AL(AL_ind{3}(n)).betas_residual,PP_AL(AL_ind{3}(n)).norm_recov(4:5));
%     plot(PP_Data(1).offs,al,'Color',col_v(n),'LineWidth', 2,'Marker','*')
%     ylim([0 100]);
%     title('AL')
%     hold off
% end
% figure;
% for n=1:3
%     hold on
%     lm = 100.* horzcat(PP_LM(LM_ind{3}(n)).betas_residual,PP_LM(LM_ind{3}(n)).norm_recov(4:5));
%     plot(PP_Data(1).offs,lm,'Color',col_v(n),'LineWidth', 2,'Marker','*')
%     ylim([0 100]);
%     title('LM')
%     hold off
% end
    
% Plots individual regions using residual data for first 3 points
f = figure; set(f, 'Position', [270 195 1800 1150]);
hold on
for n=1:4
    errorbar(PP_Data(1).offs,m_b_res{n},sem_res{n},'LineWidth', 2, 'Color', d_col(n,:),'Marker','*');
    ylim([0 1.05])    
    set(gca,'XTick',[250 500 1000 2000 4000])
    ylabel('Second Pulse Magnitude','FontWeight','Bold','FontSize',14)
    xlabel('Inter-Pulse-Interval (ms)','FontWeight','Bold','FontSize',14)
    title('Paired Pulse Using Residual Subtraction Method','FontWeight','Bold','FontSize',16)
    [~] = legend({'V1   n = 9','AL   n = 10','LM   n = 9','PM   n = 3'},'Location','Southeast');
end
    plot([0 5000],[1 1],'--k','LineWidth',1.5)
    plot([0 5000],[.8 .8; .6 .6; .4 .4; .2 .2],'Color',grayL,'LineStyle','--','LineWidth',1.5)
hold off
% Plots individual regions using Lindsey's Re-zero Method
figure;
hold on
for n=1:4
    errorbar(PP_Data(1).offs,m_norm_rec{n},sem_norm_rec{n},'LineWidth', 2, 'Color', d_col(n,:),'Marker','*');
    ylim([0 1.05])
    ylabel('Second Pulse Magnitude')
    xlabel('Inter-Pulse-Interval (ms)')
    title('Paired Pulse Using Re-Zero Method')
end
