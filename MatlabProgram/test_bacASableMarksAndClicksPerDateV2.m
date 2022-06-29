%Test personas
% by Oriane Dermy 09/06/22
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
% in this program, we want to create fake data.
% To do so:
% 1) take two random numbers (i,j) between 1 and promp{1}.nbTraj.
% 2) take 5% of min_{i,j}(promp{1}.traj{min}.totTime).
% 3) infer the continuation of the trajectory.
% 4) Plot this new trajectory
% specificity: we look at click number each 5 days.

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

% % %init : at the begining we only add click data
% inputName = {'clicks'};
% s_bar= 40 ;
% nbInput = 1 ;
% percentData = 48;
% %display('load click trajectories')
% l_ids = loadIdPerClass('Data/Personas/GHPrimaire_DISTINCTION_id.csv','Data/Personas/GHPrimaire_PASS_id.csv','Data/Personas/GHPrimaire_WITHDRAWN_id.csv','Data/Personas/GHPrimaire_FAIL_id.csv');
% t = loadTrajectoryPersonas7('Data/Personas/data_globales.csv', l_ids, 's_bar',240);
% t{1}.inputName = inputName;
% t{2}.inputName = inputName;
% t{3}.inputName = inputName;
% t{4}.inputName = inputName;

%To load trajectories faster
load('Data/Personas/loadClicksForMarkPerDatePer7days.mat');

s_bar= 40 ;

%Then we adapt variables to add score and delay data
nbInput = 3 ;
inputName = {'clicks', 'score', 'delai'};
%some variable computation to create basis function, you might have to
%change them
t{1} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_DISTINCTION_id.csv', t{1},nbInput);
t{2} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_PASS_id.csv', t{2},nbInput);
t{3} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_WITHDRAWN_id.csv', t{3},nbInput);
t{4} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_FAIL_id.csv', t{4},nbInput);

%createFileFromOulad(t, 'v2');
%plot recoverData
 %drawRecoverData(t{2}, inputName, 'Interval', [1:3], 'Specolor', 'g' ,'namFig', 1);
 %drawRecoverData(t{1}, inputName, 'Interval', [1:3], 'Specolor', 'b' ,'namFig', 1);
 %drawRecoverData(t{4}, inputName, 'Interval', [1:3]  , 'Specolor', ':r','namFig', 1);
 %drawRecoverData(t{3}, inputName, 'Interval', [1:3], 'Specolor', ':*k','namFig', 1);

%%init
%take one of the trajectory randomly to do test, the others are stocked in train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);



%%%Test model non temporel avec GMM

figure;
for i=1:10%size(t{3}.y,2)
    subplot(2,3,1);hold on;
    plot(t{3}.y{i}(1:40), '*');
    subplot(2,3,2);hold on;
    plot(t{3}.y{i}(41:80), '*');
    subplot(2,3,3);hold on;
    plot(t{3}.y{i}(81:120), '*');
    subplot(2,3,4);hold on;
    plot(0,t{3}.y{i}(1:40), '*');
    subplot(2,3,5);hold on;
    plot(0,t{3}.y{i}(41:80), '*');
    subplot(2,3,6);hold on;
    plot(0,t{3}.y{i}(81:120), '*');
end
figure;
for i=1:10%size(t{4}.y,2)
    subplot(2,3,1);hold on;
    plot(t{4}.yMat{i}(:,1), '*');
    subplot(2,3,2);hold on;
    plot(t{4}.yMat{i}(:,2), '*');
    subplot(2,3,3);hold on;
    plot(t{4}.yMat{i}(:,3), '*');
    
    subplot(2,3,4);hold on;
    plot(0,t{4}.yMat{i}(:,1), '*');
    subplot(2,3,5);hold on;
    plot(0,t{4}.yMat{i}(:,2), '*');
    subplot(2,3,6);hold on;
    plot(0,t{4}.yMat{i}(:,3), '*');
end



k=5;





type =2;
if (type==2)
    
    %Compute the distribution for each kind of trajectories.
    kernel = 'Periodic';
    M(1) = 40;%40;
    dimRBF = 0;
    for i=1:size(M,2)
        dimRBF = dimRBF + M(i)*nbInput(i);
        c(i) = 1.0 / (M(i)-1);%center of gaussians
        s(i) = c(i)/4;
        h(i) = s(i);%s(i);%0.0025%s(i);%2*s(i)*s(i);%150;%(M(i)); %bandwidth of gaussians
    end
    expNoise =20;
    
    promp{1} = computeDistribution(train{1}, M, s_bar,c,h, kernel);
    promp{2} = computeDistribution(train{2}, M, s_bar,c,h, kernel);
    promp{3} = computeDistribution(train{3}, M, s_bar,c,h, kernel);
    promp{4} = computeDistribution(train{4}, M, s_bar,c,h, kernel);
    
    n=300;
    fakeD{1} = fakeData2(promp{1},1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',2, kernel, 'save','OULAD',1);
    fakeD{2} = fakeData2(promp{2},2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',3,  kernel, 'save', 'OULAD',1);%'fig',2,
    fakeD{3} = fakeData2(promp{3},3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',4,  kernel, 'save', 'OULAD',1);%'fig',3,
    fakeD{4} = fakeData2(promp{4},4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',5,  kernel, 'save', 'OULAD',1);%'fig',4,
    %
    
elseif (type==1)
    %Compute the distribution for each kind of trajectories.
    kernel = 'gaussian';
    M(1) = 40;
    dimRBF = 0;
    for i=1:size(M,2)
        dimRBF = dimRBF + M(i)*nbInput(i);
        c(i) = 1.0 / (M(i));%center of gaussians
        h(i) = c(i)/150;%75%150%M(i)*2;%150;%(M(i)); %bandwidth of gaussians
    end
    
    promp{1} = computeDistribution(train{1}, M, s_bar,c,h, kernel, 'Draw');
    promp{2} = computeDistribution(train{2}, M, s_bar,c,h, kernel);
    promp{3} = computeDistribution(train{3}, M, s_bar,c,h, kernel);
    promp{4} = computeDistribution(train{4}, M, s_bar,c,h, kernel);
    
    expNoise =20;
    n=300     ;
    fakeD = fakeData2(promp{1},1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',5, kernel,'save', 'OULAD',1);
    fakeD = fakeData2(promp{2},2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',6, kernel,'save', 'OULAD',1);
    fakeD = fakeData2(promp{3},3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',7, kernel,'save', 'OULAD',1);
    fakeD = fakeData2(promp{4},4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',8, kernel,'save', 'OULAD',1);
    
end