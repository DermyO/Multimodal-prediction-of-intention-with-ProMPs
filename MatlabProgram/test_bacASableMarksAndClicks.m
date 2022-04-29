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


load('Data/Personas/personasClicksAndMarksInit.mat');


%plot recoverData
%   drawRecoverData(t{2}, inputName{1}, 'Specolor','xg','namFig', 1);
%   drawRecoverData(t{1},  inputName{1}, 'Specolor','*b','namFig', 1);
%   drawRecoverData(t{2},  inputName{1}, 'Specolor','xg','namFig', 1);
%   drawRecoverData(t{3},  inputName{1}, 'Specolor','.r','namFig', 1);
%   drawRecoverData(t{4},  inputName{1}, 'Specolor','+k','namFig', 1);
% 
% 


%some variable computation to create basis function, you might have to
%change them
dimRBF = 0;
M = M(1);
nbInput = sum(nbInput);
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end


% 
t{1} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_DISTINCTION_id.csv', t{1}, nbInput);
t{2} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_PASS_id.csv', t{2}, nbInput);
t{3} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_WITHDRAWN_id.csv', t{3}, nbInput);
t{4} = loadTrajectoryPersonas5('Data/Personas/GHPrimaire_FAIL_id.csv', t{4}, nbInput);

t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;

%plot recoverData
%   drawRecoverData(t{2}, inputName, 'Specolor','g','namFig', 2);
%   drawRecoverData(t{2},  inputName, 'Specolor','g','namFig', 2);
%   drawRecoverData(t{3},  inputName, 'Specolor','r','namFig', 2);
%   drawRecoverData(t{4},  inputName, 'Specolor','k','namFig', 2);
%   drawRecoverData(t{1},  inputName, 'Specolor','b','namFig', 2);




%%init
%take one of the trajectory randomly to do test, the others are stocked in train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);
%Compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
promp{4} = computeDistribution(train{4}, M, s_bar,c,h);


expNoise =100;
n=100;

fakeD = fakeData2(promp{1},1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',1);
fakeD = fakeData2(promp{2},2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',2);
fakeD = fakeData2(promp{3},3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',3);
fakeD = fakeData2(promp{4},4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',4);


%fakeD = fakeData(promp,1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',1);
%fakeD = fakeData(promp,2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',2);
%fakeD = fakeData(promp,3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',3);
%fakeD = fakeData(promp,4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig',4);
