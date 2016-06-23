%% Final Analysis for Flashing Stim
anal_root = 'S:\Imaging\Analysis Code';
fn_compiled = (fullfile(anal_root, 'Compiled_Data.mat'));
load(fn_compiled)
V1_ind{1}=[1 4 6]; V1_ind{2}=[2 3 5]; V1_ind{3}=[7 8 9]; % AW46; i538; AW56
AL_ind{1}=[1 3 5 8]; AL_ind{2}=[2 4 6]; AL_ind{3}=[7 9 10]; % AW46; i538; AW56
LM_ind{1}=[1 4 6 7]; LM_ind{2}=[2 3]; LM_ind{3}=[5 8 9]; % AW46; i538; AW56
PM_ind{1}=[1 2 3]; %AW46
load(fullfile(anal_root, 'Color_Library.mat'));
l_col = [[0.5 0.5 0.5]; redM; orangeL; [0 1 1]];
d_col = [[0 0 0]; redD; orangeD; cyan];
%% Vectorize Data
v_FS{1} = vectorize_FS(FS_V1);
v_FS{2} = vectorize_FS(FS_AL);
v_FS{3} = vectorize_FS(FS_LM);
v_FS{4} = vectorize_FS(FS_PM);

for n=1:4
    m_250{n} = mean((v_FS{n}(1,:,:)),3);
    m_500{n} = mean((v_FS{n}(2,:,:)),3);
    for a=1:5
        sem_250{n}(a) = std((v_FS{n}(1,a,:)),0,3) ./sqrt(length(v_FS{n}(1,:,1)));
        sem_500{n}(a) = std((v_FS{n}(2,a,:)),0,3) ./sqrt(length(v_FS{n}(1,:,1)));
    end
    for ip=1:5
    [hfs250(n,ip,1),pfs250(n,ip,1)] = ttest(v_FS{n}(1,ip,:),1,'Alpha', 0.05); % Tests if recovery/beta values are significantly different from 1
    [hfs250(n,ip,2),pfs250(n,ip,2)] = ttest(v_FS{n}(1,ip,:),1,'Alpha', 0.01);
    [hfs250(n,ip,3),pfs250(n,ip,3)] = ttest(v_FS{n}(1,ip,:),1,'Alpha', 0.001);
    [hfs500(n,ip,1),pfs500(n,ip,1)] = ttest(v_FS{n}(2,ip,:),1,'Alpha', 0.05); % Tests if recovery/beta values are significantly different from 1
    [hfs500(n,ip,2),pfs500(n,ip,2)] = ttest(v_FS{n}(2,ip,:),1,'Alpha', 0.01);
    [hfs500(n,ip,3),pfs500(n,ip,3)] = ttest(v_FS{n}(2,ip,:),1,'Alpha', 0.001);
    end
    
end

%% Figures
% Plots individual traces colored by mouse
% 250ms
plot_mice(FS_V1,V1_ind,1,1,1)
plot_mice(FS_AL,AL_ind,1,1,2)
plot_mice(FS_LM,LM_ind,1,1,3)
plot_mice(FS_PM,PM_ind,1,1,4)
% 500ms
plot_mice(FS_V1,V1_ind,1,2,1)
plot_mice(FS_AL,AL_ind,1,2,2)
plot_mice(FS_LM,LM_ind,1,2,3)
plot_mice(FS_PM,PM_ind,1,2,4)

% Plots each region (averaged across mice) for each 
f = figure; set(f, 'Position', [270 195 1800 1150]);
hold on
for n=1:4
    errorbar([0:350:1400],m_250{n},sem_250{n},'LineWidth', 2, 'Color', l_col(n,:),'Marker','*');
    h(n) = errorbar([0:600:2400],m_500{n},sem_500{n},'LineWidth', 2, 'Color', d_col(n,:),'Marker','*');
    xlim([0 2500])
    ylim([0 1.05])
    title('Flashing Stimulus Pulse Responses','FontWeight','Bold','FontSize',16)
    xlabel('Time of Pulse (ms)','FontWeight','Bold','FontSize',14)
    ylabel('Normalized Response Magnitude','FontWeight','Bold','FontSize',14)
end
    [~] = legend([h(1) h(2) h(3) h(4)],{'V1   n = 9','AL   n = 10','LM   n = 9','PM   n = 3'},'Location','Southeast'); 
    plot([0 5000],[1 1],'--k','LineWidth',1.5)
    plot([0 5000],[.8 .8; .6 .6; .4 .4; .2 .2],'Color',grayL,'LineStyle','--','LineWidth',1.5)
hold off
    