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

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme

inputName = {'scores','delays'};

s_bar= 16;% +2 fictif
nbInput(1) = 1;%[1 1];
M(1) = 11; 
%M(2) = 11;
%variable tuned to achieve the trajectory correctly
percentData = 48; %number of data max with what you try to find the correct movement

%%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/(5*M(i)); %bandwidth of gaussians
end

display('load trajectories')
t{1} = loadTrajectoryPersonas('Data/Personas/distinction.csv', 'distinction', 'refNb', s_bar,'nbInput', nbInput, 'withoutDelay');
t{2} = loadTrajectoryPersonas('Data/Personas/Pass.csv', 'pass', 'refNb', s_bar,'nbInput', nbInput, 'withoutDelay');
t{3} = loadTrajectoryPersonas('Data/Personas/withdrawn.csv', 'withdraw', 'refNb', s_bar,'nbInput', nbInput, 'withoutDelay');
t{4} = loadTrajectoryPersonas('Data/Personas/Fail.csv', 'fail', 'refNb', s_bar,'nbInput', nbInput, 'withoutDelay');
t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;

% %plot recoverData
%    drawRecoverData(t{2}, inputName, 'Specolor','xg','namFig', 1);
%    drawRecoverData(t{3}, inputName, 'Specolor','.r','namFig', 1);
%    drawRecoverData(t{4}, inputName, 'Specolor','+k','namFig', 1);
%   drawRecoverData(t{1}, inputName, 'Specolor','*b','namFig', 1);

%take one of the trajectory randomly to do test, the others are stocked in
%train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);

%Compute the distribution for each kind of trajectories.
display('Training t1')
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);
display('Training t2')
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
display('Training t3')
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
display('Training t4')
promp{4} = computeDistribution(train{4}, M, s_bar,c,h);


display('Drawing Distributions ...')
%plot distribution
% drawDistribution(promp{1}, inputName,s_bar,  'shaded','col', 'b', 'xLabelName', 'exams');
% drawDistribution(promp{2}, inputName,s_bar,  'shaded','col', 'g', 'xLabelName', 'exams');
% drawDistribution(promp{3}, inputName,s_bar, 'shaded', 'col', 'r', 'xLabelName', 'exams');
% drawDistribution(promp{4}, inputName,s_bar, 'shaded', 'col', 'k', 'xLabelName', 'exams');

expNoise = 10;
n=100;
fakeD = fakeData2(promp{1},1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 1, 'ymin', [0, -150]);
fakeD = fakeData2(promp{2},2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 2, 'ymin', [0, -150]);
fakeD = fakeData2(promp{3},3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 3, 'ymin', [0, -150]);
fakeD = fakeData2(promp{4},4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 4, 'ymin', [0, -150]);
% 
% fakeD = fakeData(promp,1, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 1, 'ymin', [0, -150]);
% fakeD = fakeData(promp,2, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 2, 'ymin', [0, -150]);
% fakeD = fakeData(promp,3, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 3, 'ymin', [0, -150]);
% fakeD = fakeData(promp,4, n, t, nbInput,M,s_bar,c,h,expNoise,inputName, 'fig', 4, 'ymin', [0, -150]);