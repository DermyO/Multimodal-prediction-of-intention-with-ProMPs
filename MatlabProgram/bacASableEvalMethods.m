%Test personas
% by Oriane Dermy 07/01/21
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
% in this program, we want to create fake data.
% To do so: 
% 1) take two random numbers (i,j) between 1 and promp{1}.nbTraj.
% 2) take 5% of min_{i,j}(promp{1}.traj{min}.totTime).
% 3) infer the continuation of the trajectory.
% 4) Plot this new trajectory 

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

%init : at the begining we only add click data
inputName = {'clicks', 'marks', 'delais'};
s_bar= 14 ;
nbInput = 3 ;
M = 14;
percentData = 48;

%load real data
t{1} = loadFakeData('Data/Personas/real_data_Distinction.csv', 'realDistinction');
t{2} = loadFakeData('Data/Personas/real_data_Pass.csv', 'realPass');
t{3} = loadFakeData('Data/Personas/real_data_Fail.csv', 'realFail');
t{4} = loadFakeData('Data/Personas/real_data_Withdrawn.csv', 'realWithdrawn');

%load fake data from ProMPs
t2{1} = loadFakeData('Data/Personas/fake_data_Periodic_Distinction.csv', 'ProMPDistinction');
t2{2} = loadFakeData('Data/Personas/fake_data_Periodic_Pass.csv', 'ProMPPass');
t2{3} = loadFakeData('Data/Personas/fake_data_Periodic_Fail.csv', 'ProMPFail');
t2{4} = loadFakeData('Data/Personas/fake_data_Periodic_Withdrawn.csv', 'ProMPWithdrawn');

%load fake data from CopulaGan
t3{1} = loadFakeData('Data/Personas/fakeCopulaGAN_data_Distinction.csv', 'CopulaGanDistinction');
t3{2} = loadFakeData('Data/Personas/fakeCopulaGAN_data_Pass.csv', 'CopulaGanPass');
t3{3} = loadFakeData('Data/Personas/fakeCopulaGAN_data_Fail.csv', 'CopulaGanFail');
t3{4} = loadFakeData('Data/Personas/fakeCopulaGAN_data_Withdrawn.csv', 'CopulaGanWithdrawn');


t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;
t2{1}.inputName = inputName;
t2{2}.inputName = inputName;
t2{3}.inputName = inputName;
t2{4}.inputName = inputName;
t3{1}.inputName = inputName;
t3{2}.inputName = inputName;
t3{3}.inputName = inputName;
t3{4}.inputName = inputName;



%plot recoverData
drawRecoverDataSubplot(t{1}, [3;3],[1,4,7], 'Specolor','b','namFig', 1);
drawRecoverDataSubplot(t{1}, [3;3],[1,4,7], 'Specolor','b','namFig', 1);
drawRecoverDataSubplot(t2{1}, [3;3],[2,5,8], 'Specolor','b','namFig', 1);
drawRecoverDataSubplot(t3{1}, [3;3],[3,6,9], 'Specolor','b','namFig', 1);

drawRecoverDataSubplot(t{2}, [3;3],[1,4,7], 'Specolor','g','namFig', 2);
drawRecoverDataSubplot(t{2}, [3;3],[1,4,7], 'Specolor','g','namFig', 2);
drawRecoverDataSubplot(t2{2}, [3;3],[2,5,8], 'Specolor','g','namFig', 2);
drawRecoverDataSubplot(t3{2}, [3;3],[3,6,9], 'Specolor','g','namFig', 2);

drawRecoverDataSubplot(t{3}, [3;3],[1,4,7], 'Specolor','r','namFig', 3);
drawRecoverDataSubplot(t{3}, [3;3],[1,4,7], 'Specolor','r','namFig', 3);
drawRecoverDataSubplot(t2{3}, [3;3],[2,5,8], 'Specolor','r','namFig', 3);
drawRecoverDataSubplot(t3{3}, [3;3],[3,6,9], 'Specolor','r','namFig', 3);

drawRecoverDataSubplot(t{4}, [3;3],[1,4,7], 'Specolor','k','namFig', 4);
drawRecoverDataSubplot(t{4}, [3;3],[1,4,7], 'Specolor','k','namFig', 4);
drawRecoverDataSubplot(t2{4}, [3;3],[2,5,8], 'Specolor','k','namFig', 4);
drawRecoverDataSubplot(t3{4}, [3;3],[3,6,9], 'Specolor','k','namFig', 4);
% 
% %%init
% %take one of the trajectory randomly to do test, the others are stocked in train.
% [train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
% [train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
% [train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
% [train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);
% 
% 
% %Compute the distribution for each kind of trajectories.
% kernel = 'Periodic';
% promp{1} = computeDistribution(train{1}, M, s_bar,c,h, kernel);
% promp{2} = computeDistribution(train{2}, M, s_bar,c,h, kernel);
% promp{3} = computeDistribution(train{3}, M, s_bar,c,h, kernel);
% promp{4} = computeDistribution(train{4}, M, s_bar,c,h, kernel);
% 
% 
% 
% expNoise =0;
% n=100;
% fakeD = fakeData2(promp{1},1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',1, kernel);
% fakeD = fakeData2(promp{2},2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',2, kernel);
% fakeD = fakeData2(promp{3},3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',3, kernel);
% fakeD = fakeData2(promp{4},4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',4, kernel);
