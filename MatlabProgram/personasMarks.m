%Test personas
% by Oriane Dermy 14/10/21
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
% in this program, we plot ProMPs corresponding to note and delay other time
% of exams. Each ProMPs correspond to a students' type of final result
% (distinction, pass, fail, withdrawn.)

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme

inputName = {'scores','delays'};

s_bar= 14;
nbInput(1) = 2 ;
M(1) = 11; 

%variable tuned to achieve the trajectory correctly
percentData = 48; %number of data max with what you try to find the correct movement

%%%%%%%%%%%%%% END VARIABLE CHOICE
%some variable computation to create basis function, you might have to change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end

display('load trajectories')
t{1} = loadTrajectoryPersonas('Data/Personas/distinction.csv', 'distinction', 'refNb', s_bar, 'nbInput', nbInput);
t{2} = loadTrajectoryPersonas('Data/Personas/Pass.csv', 'pass', 'refNb', s_bar, 'nbInput', nbInput);
t{3} = loadTrajectoryPersonas('Data/Personas/withdrawn.csv', 'withdraw', 'refNb', s_bar, 'nbInput', nbInput);
t{4} = loadTrajectoryPersonas('Data/Personas/Fail.csv', 'fail', 'refNb', s_bar, 'nbInput', nbInput);
t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;


%plot recoverData
% drawRecoverData(t{2}, inputName, 'Specolor','xg','namFig', 1);
% drawRecoverData(t{2}, inputName, 'Specolor','xg','namFig', 1);
% drawRecoverData(t{3}, inputName, 'Specolor','.r','namFig', 1);
% drawRecoverData(t{4}, inputName, 'Specolor','+k','namFig', 1);
% drawRecoverData(t{1}, inputName, 'Specolor','*b','namFig', 1);


%take one of the trajectory randomly to do test, the others are stocked in
%train.  
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);

%Compute the distribution for each kind of trajectories.
display('Training t1')
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);
%display('Training t2')
%promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
%display('Training t3')
%promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
%display('Training t4')
%promp{4} = computeDistribution(train{4}, M, s_bar,c,h);


display('Drawing Distributions ...')
%plot distribution
drawDistribution(promp{1}, inputName,s_bar, 'col', 'b', 'xLabelName', 'test number','ymin', [0,-21],'ymax', [100,21]);
%drawDistribution(promp{2}, inputName,s_bar,  'shaded','col', 'g', 'xLabelName', 'exams');
%drawDistribution(promp{3}, inputName,s_bar, 'shaded', 'col', 'r', 'xLabelName', 'exams');
%drawDistribution(promp{4}, inputName,s_bar, 'shaded', 'col', 'k', 'xLabelName', 'exams');


expNoise = 12.;
trial=1;
test2 = test;
while(trial <=4)
    display('Trials');
    disp(['We try the number ', num2str(trial)]);
    test = test2{trial};
    w = computeAlpha(test{1}.nbData,t, nbInput);

    for i=1:length(promp)
        promp{i}.w_alpha= w{i};
    end

    %Recognition of the movement
    [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
    infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, nbInput);
    if(infTraj.reco == trial)
        disp('Recognize the good cluster.');
    else
        disp('Error of the cluster recognition.');
    end
    %draw the infered movement
    drawInferenceRescaled(promp,inputName ,infTraj, test{1},s_bar, 'shaded', 'xlim', [0,s_bar], 'yminForInput', [1], 0);
    drawInference(promp,inputName,infTraj, test{1},s_bar, 'shaded', 'yminForInput',[1], 0);
    
    trial = trial +1 ;
end
