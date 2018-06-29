val{1} = load('statXsensLS2V2.mat')
val{2} = load('statXsensLS5V2.mat')
val{3} = load('statXsensLS7V2.mat')
val{4} = load('statXsensLS15V2.mat')
val{5} = load('statXsensLS20V2.mat')
val{6} = load('statXsensWithoutLS.mat')
val{6} = load('statXsensWithoutLS2.mat')

% figure;
% title('Error of movement type recognition');
% plot([20:20:100],(sum(val{1}.error')/70)*100,'--+b','linewidth',2);hold on;
% plot([20:20:100],(sum(val{2}.error')/70)*100,'--+r','linewidth',2);
% plot([20:20:100],(sum(val{3}.error')/70)*100,'--+g','linewidth',2);
% plot([20:20:100],(sum(val{4}.error')/70)*100,'--+k','linewidth',2);
% plot([20:20:100],(sum(val{5}.error')/70)*100,'--+m','linewidth',2);
% ylim([0 100]);
% xlabel('Observed data [%]');
% ylabel('Error recognition [%]');
% 
nameL = {'LS=2','LS=5','LS=7','LS=15','LS=20','LS=69'}


figure;
title('Error of movement type recognition');
plot([20:20:100],sum(val{1}.error'),'--+b','linewidth',2);hold on;
plot([20:20:100],sum(val{2}.error'),'--+r','linewidth',2);
plot([20:20:100],sum(val{3}.error'),'--+g','linewidth',2);
plot([20:20:100],sum(val{4}.error'),'-+k','linewidth',2);
plot([20:20:100],sum(val{5}.error'),'--*m','linewidth',2);
plot([20:20:100],sum(val{6}.error'),'--c','linewidth',2);

xlabel('Observed data [%]');
ylabel('nb Error recognition [/70]');
legend(nameL)



fig = figure;
colorr = {'-b','-r','-g','-k','-m','-v'};
hold on;
for i=1:6
    h{i} = shadedErrorBar([20:20:100],val{i}.meanDistLS, val{i}.covDistLS,  {colorr{i},'markerfacecolor',[1,0.2,0.2]})
    h{i}.mainLine.DisplayName = nameL{i};
%    h2 = shadedErrorBar([20:20:100],val{2}.meanDistLS, val{2}.covDistLS,  {'-r','markerfacecolor',[1,0.2,0.2]});
 %   shadedErrorBar([20:20:100],val{3}.meanDistLS, val{3}.covDistLS,  {'-g','markerfacecolor',[1,0.2,0.2]});
  %  shadedErrorBar([20:20:100],val{4}.meanDistLS, val{4}.covDistLS,  {'-k','markerfacecolor',[1,0.2,0.2]});
   % shadedErrorBar([20:20:100],val{5}.meanDistLS, val{5}.covDistLS,  {'-m','markerfacecolor',[1,0.2,0.2]});
end

xlabel('Observed data [%]');
ylabel('Average distance between the infered trajectory and the real one [.]');
legend(findobj(gca, '-regexp', 'DisplayName', '[^'']'));

% 
% 
% fig = figure;
% colorr = {'b','r','g','k','m','v'};
% hold on;
% for i=1:6
%      boxplot(val{i}.distanceLS', 'colors',colorr{i})
% end
% 

%%%%%%%%%%%TEST
% First group of 3 data set with standard deviation 2

figure;
x = zeros(5,68)
for j=1:5 %different timesteps ?
   % for i=6%1:6 % different LS
        x(j,:) = val{6}.distanceLS(j,:)
   % end
end

boxplot(x', 'Label', [20,40,60,80,100])
%%%%%%%%%%%END TEST



% x = [val{1}.distanceLS';val{2}.distanceLS';val{3}.distanceLS';val{4}.distanceLS';val{5}.distanceLS';val{6}.distanceLS'];
% x = x(:);
% g1 = [1*ones(size(val{1}.distanceLS')); 2*ones(size(val{2}.distanceLS'));3*ones(size(val{3}.distanceLS'));4*ones(size(val{4}.distanceLS'));5*ones(size(val{5}.distanceLS'));6*ones(size(val{6}.distanceLS'))]; g1 = g1(:);
% g2 = repmat(1:1520,1); g2 = g2(:);
% boxplot(x, g1, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
% 
% xlabel('Observed data [%]');
% ylabel('Average distance between the infered trajectory and the real one [.]');
% legend(findobj(gca, '-regexp', 'DisplayName', '[^'']'));
% 
% colorr = {'-b','-r','-g','-k','-m','-v'};

figure;
boxplot(val{1}.distanceLS)


load('tmpAccordingToDataDim.mat')


figure;
boxplot(tmpCalcDistr', [2:3:69])
title('Computation of distribution time for movement represented by 70 timestep')
xlabel('Dimension used to represents the movement')
ylabel('Time [s]')


%%
figure;
boxplot(tmpInf', [2:3:69])
title('Time to infert the continuation of a movement represented by 70 timesteps')
xlabel('Dimension used to represents the movement')
ylabel('Time [s]')