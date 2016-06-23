%% Final Analysis for Duration
anal_root = 'S:\Imaging\Analysis Code';
fn_compiled = (fullfile(anal_root, 'Compiled_Data.mat'));
load(fn_compiled)
V1_ind{1}=[1 4 6]; V1_ind{2}=[2 3 5]; V1_ind{3}=[7 8 9]; % AW46; i538; AW56
AL_ind{1}=[1 3 5 8]; AL_ind{2}=[2 4 6]; AL_ind{3}=[7 9 10]; % AW46; i538; AW56
LM_ind{1}=[1 4 6 7]; LM_ind{2}=[2 3]; LM_ind{3}=[5 8 9]; % AW46; i538; AW56
PM_ind{1}=[1 2 3]; %AW46
load(fullfile(anal_root, 'Color_Library.mat'));
l_col = [[0.5 0.5 0.5]; redM; orangeL; blueL];
d_col = [[0 0 0]; redD; orangeD; cyan];
%% Vectorize Data
v_DU{1} = vectorize_DU(DU_V1);
v_DU{2} = vectorize_DU(DU_AL);
v_DU{3} = vectorize_DU(DU_LM);
v_DU{4} = vectorize_DU(DU_PM);
% for n=1:4
% figure; plot(v_DU{n},'Marker','*')
% xlim([0 3]);
% end
for n=1:4
    m_DU{n} = mean(v_DU{n},2);
    sem{n} = std(v_DU{n},0,2) ./sqrt(length(v_DU{n}));
    for ip=1:2
    [hdu(n,ip,1),pdu(n,ip,1)] = ttest(v_DU{n}(:,ip,:),1,'Alpha', 0.05); % Tests if recovery/beta values are significantly different from 1
    [hdu(n,ip,2),pdu(n,ip,2)] = ttest(v_DU{n}(:,ip,:),1,'Alpha', 0.01);
    [hdu(n,ip,3),pdu(n,ip,3)] = ttest(v_DU{n}(:,ip,:),1,'Alpha', 0.001);
    end
end

%% Figures
% Plots individual traces colored by mouse
plot_mice(DU_V1,V1_ind,3,1,1)
plot_mice(DU_AL,AL_ind,3,1,2)
plot_mice(DU_LM,LM_ind,3,1,3)
plot_mice(DU_PM,PM_ind,3,1,4)

% Summary Figure
f = figure; set(f, 'Position', [270 195 1800 1150]);
hold on
for n=1:4
    errorbar(m_DU{n},sem{n},'LineWidth', 2, 'Color', d_col(n,:),'Marker','*');
    xlim([0.5 2.5])
    ylim([0 1.05]);
    set(gca,'XTick',0:1:3)
    set(gca,'XTickLabel', {'','2000ms','4000ms',''})
    ylabel('Sustained / Transient Response Ratio','FontWeight','Bold','FontSize',14)
    xlabel('Duration of Stimulus (ms)','FontWeight','Bold','FontSize',14)
    title('Sustained/Transient Response for Duration Stimulus','FontWeight','Bold','FontSize',16)
    [~] = legend({'V1   n = 9','AL   n = 10','LM   n = 9','PM   n = 3'},'Location','Southeast');
end
    plot([0 5000],[1 1],'--k','LineWidth',1.5)
    plot([0 5000],[.8 .8; .6 .6; .4 .4; .2 .2],'Color',grayL,'LineStyle','--','LineWidth',1.5)
hold off
