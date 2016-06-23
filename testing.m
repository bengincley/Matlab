% x(1,:) = [1 2 1 2 1];
% x(2,:)= [2 1 2 1 2];
% x(3,:) = [0 2 4 1 -2];
% 
% for n=1:3
%     m_x(n) = mean(x(n,:));
%     s_x(n) = std(x(n,:));
% end
% 
% m_s = mean(m_x);
% s_s = std(m_x);
% y = horzcat(x(1,:),x(2,:),x(3,:));
% m_p = mean(y);
% s_p = std(y);
% 
% 
% %% more stuff
% 
% sigma = 4;
% mu = 3;
% Nrow = 10;
% Ncols = 100000;
% 
% x = normrnd(mu, sigma, Nrow, Ncols);
% 
% mu_across_row = sum(x,2);
% 
% sanity_check_2 = [Nrow * mu, mean(mu_across_row), (Nrow.*sigma^2)./(Nrow^2), var(mu_across_row)]
% 
% m_s = mean(m_x);
% s_s = std(m_x);
% y = horzcat(x(1,:),x(2,:),x(3,:));
% m_p = mean(y);
% s_p = std(y);
% 
% 
% a = [6 7 8 9 4 3 2 1];
% [j,k] = max(a(1:3))
for i=1:3
c{1,i} = normrnd(2,1,56,1);
end
 n=1:length(c); 
 a=horzcat(c{n});
 m = mean(a,2);

for i=1:3
j = 1:length(i);
    for n=1:length(c{i})
    m(n) = mean(c{j}(n));
    end
end
