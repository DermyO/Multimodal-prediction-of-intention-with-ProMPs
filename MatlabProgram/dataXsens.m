%This demo computes N proMPs given a set of recorded trajectories containing the demonstrations for the N types of movements. 
%It plots the results.

% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
typeTraj = {'bent','bent_strongly', 'kicking','lifting_box','standing','walking','window_open'};
colorTraj = {'b','r', 'g','m','c','k','brown'};
s_bar=70;
nbInput = 69; %number of input used during the inference


for i=1:nbInput
    inputName{i} = strcat('Dim',num2str(i));
end

M(1) = 10; %number of basis functions for the first type of input

%variable tuned to achieve the trajectory correctly
expNoise = 0.00001;
percentData = 48; %number of data max with what you try to find the correct movement

%%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end


nameTest = strcat('Data/Xsens/l',num2str(nbInput));
list = {'bent_fw', 'bent_strongly', 'kicking','lifting_box','standing','walking','window_open'};
t{1} = loadTrajectory([nameTest,'_0'], 'bent_fw', 'refNb', s_bar, 'nbInput',nbInput);
t{2} = loadTrajectory([nameTest,'_1'], 'bent_strongly', 'refNb', s_bar, 'nbInput',nbInput);
t{3} = loadTrajectory([nameTest,'_2'], 'kicking', 'refNb', s_bar, 'nbInput',nbInput);
t{4} = loadTrajectory([nameTest,'_3'], 'lifting_box', 'refNb', s_bar, 'nbInput',nbInput);
t{5} = loadTrajectory([nameTest,'_4'], 'standing', 'refNb', s_bar, 'nbInput',nbInput);
t{6} = loadTrajectory([nameTest,'_5'], 'walking', 'refNb', s_bar, 'nbInput',nbInput);
t{7} = loadTrajectory([nameTest,'_6'], 'window_open', 'refNb', s_bar, 'nbInput',nbInput);

% %plot recoverData
drawRecoverData(t{1}, inputName, 'Specolor','b','namFig', 1,'Interval',[1:6]);
drawRecoverData(t{2}, inputName, 'Specolor','r','namFig',1,'Interval',[1:6]);
drawRecoverData(t{3}, inputName, 'Specolor','g','namFig',1,'Interval',[1:6]);
drawRecoverData(t{4}, inputName, 'Specolor','m','namFig',1,'Interval',[1:6]);
drawRecoverData(t{5}, inputName, 'Specolor','c','namFig',1,'Interval',[1:6]);
drawRecoverData(t{6}, inputName, 'Specolor','k','namFig',1,'Interval',[1:6]);
drawRecoverData(t{7}, inputName, 'Specolor','y','namFig',1,'Interval',[1:6]);
% print('originalData_l5','-dsvg')
%close all;

%take one of the trajectory randomly to do test, the others are stocked in
%train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar,9);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar,9);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar,9);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar,9);
[train{5},test{5}] = partitionTrajectory(t{5},1,percentData,s_bar,9);
[train{6},test{6}] = partitionTrajectory(t{6},1,percentData,s_bar,9);
[train{7},test{7}] = partitionTrajectory(t{7},1,percentData,s_bar,9);

%Compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
promp{4} = computeDistribution(train{4}, M, s_bar,c,h);
promp{5} = computeDistribution(train{5}, M, s_bar,c,h);
promp{6} = computeDistribution(train{6}, M, s_bar,c,h);
promp{7} = computeDistribution(train{7}, M, s_bar,c,h);

fig= figure(2)
%plot distribution
drawDistribution(promp{1}, inputName,s_bar,[1:3], 'col', 'b','fig', fig);
drawDistribution(promp{2}, inputName,s_bar,[1:3], 'col', 'r','fig', fig);
drawDistribution(promp{3}, inputName,s_bar,[1:3], 'col', 'g','fig', fig);
drawDistribution(promp{4}, inputName,s_bar,[1:3], 'col', 'm','fig', fig);
drawDistribution(promp{5}, inputName,s_bar,[1:3], 'col', 'c','fig', fig);
drawDistribution(promp{6}, inputName,s_bar,[1:3], 'col', 'k','fig', fig);
drawDistribution(promp{7}, inputName,s_bar,[1:3], 'col', 'y','fig', fig);
% %print('distributions_l5','-dsvg')
%close all;

% drawDistribution(promp{1}, inputName,s_bar,[1:3], 'col', 'b');
% print([typeTraj{1},'_pos'],'-dsvg')
% drawDistribution(promp{2}, inputName,s_bar,[1:3], 'col', 'r');
% print([typeTraj{2},'_pos'],'-dsvg')
% drawDistribution(promp{3}, inputName,s_bar,[1:3], 'col', 'g');
% print([typeTraj{3},'_pos'],'-dsvg')
% drawDistribution(promp{4}, inputName,s_bar,[1:3], 'col', 'm');
% print([typeTraj{4},'_pos'],'-dsvg')
% drawDistribution(promp{5}, inputName,s_bar,[1:3], 'col', 'c');
% print([typeTraj{5},'_pos'],'-dsvg')
% drawDistribution(promp{6}, inputName,s_bar,[1:3], 'col', 'k');
% print([typeTraj{6},'_pos'],'-dsvg')
% drawDistribution(promp{7}, inputName,s_bar,[1:3], 'col', 'y');
% print([typeTraj{7},'_pos'],'-dsvg')
% close all;

% trial = length(promp)+1;
% while (trial > length(promp) || trial < 1)
%     trial = input(['Give the trajectory you want to test (between 1 and ', num2str(length(promp)),')']);
% end


for trial =1:7
    disp(['We try the number ', num2str(trial), ' : ',list{trial} ]);
    teste = test{trial};
    teste{1}.type = trial;
    w = computeAlpha(teste{1}.nbData,t, nbInput);
    promp{1}.w_alpha= w{1};
    promp{2}.w_alpha= w{2};
    promp{3}.w_alpha= w{3};
    promp{4}.w_alpha= w{4};
    promp{5}.w_alpha= w{5};
    promp{6}.w_alpha= w{6};
    promp{7}.w_alpha= w{7};

    %Recognition of the movement
    [alphaTraj,type, x] = inferenceAlpha(promp,teste{1},M,s_bar,c,h,teste{1}.nbData, expNoise, 'MO');
    infTraj = inference(promp, teste{1}, M, s_bar, c, h, teste{1}.nbData, expNoise, alphaTraj, nbInput);

    %draw the infered movement
    drawInference(promp,inputName,infTraj, teste{1},s_bar);
    %nameFigure = ['inference_l5_', typeTraj{trial}]
    %print(nameFigure,'-dsvg')
    listInfTraj{trial} = infTraj 
    
    clear infTraj alphaTraj type x w teste
end

%connexion with python
connection = initializeConnection;
for trial=1:7
    sendLatentSpace(listInfTraj{trial}, nbInput, connection)
end
closeConnection(connection);

