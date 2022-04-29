%Test personas
% by Oriane Dermy 19/11/21
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
% in this program, we plot ProMPs corresponding to the global click number
% other time.
% Each ProMPs correspond to a students' type of final result
% (distinction, pass, fail, withdrawn.)


close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

%init : at the begining we only add click data
inputName = {'clicks'};
s_bar= 14 ;
nbInput(1) = 1 ;
M(1) =11;
%some variable computation to create basis function, you might have to
%change them
dimRBF = 0;
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/(2*M(i)); %bandwidth of gaussians
end

percentData = 48;
display('load click trajectories')

l_ids = loadIdPerClass('Data/Personas/GHPrimaire_DISTINCTION_id.csv','Data/Personas/GHPrimaire_PASS_id.csv','Data/Personas/GHPrimaire_WITHDRAWN_id.csv','Data/Personas/GHPrimaire_FAIL_id.csv');
t = loadTrajectoryPersonas6('Data/Personas/total_clicks_per_date.csv', l_ids, 's_bar', s_bar);

t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;

%%init
%take one of the trajectory randomly to do test, the others are stocked in train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);
%Compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(train{1}, M, s_bar,c,h, 'Draw');
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
promp{4} = computeDistribution(train{4}, M, s_bar,c,h);

display('Drawing Distributions ...')
% plot distribution
% drawDistribution(promp{1}, inputName,s_bar, 'without', 'shaded','col', 'b');
% drawDistribution(promp{2}, inputName,s_bar, 'without',  'shaded','col', 'g');
% drawDistribution(promp{3}, inputName,s_bar, 'without', 'shaded', 'col', 'r');
% drawDistribution(promp{4}, inputName,s_bar, 'without', 'shaded', 'col', 'k', 'xLabelName', 'date examens', 'ymin', [0,0,-100],'ymax', [3000,100,250]);

%result paper
 drawDistribution(promp{1}, inputName,s_bar, 'col', 'b','without', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [14,14,14], 'shaded');
 drawDistribution(promp{2}, inputName,s_bar, 'col', 'g', 'without', 'xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [14,14,14], 'shaded');
 drawDistribution(promp{3}, inputName,s_bar, 'col', 'r', 'without' ,'xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [14,14,14], 'shaded');
 drawDistribution(promp{4}, inputName,s_bar, 'col', 'k', 'without','xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [14,14,14], 'shaded');


drawDistribution(promp{1}, inputName,s_bar, 'col', 'b', 'interval', [3], 'ymin', [-60],'ymax', [50], 'xmin', [1], 'xmax', [14]);



nbTotTraj= 0;
nbTotError = 0;

matClusterReco = zeros(4,4);
expNoise = 12;

% Testing cluster recognition for all clusters
for indTraj = 1:4
    nbTraj=0;
    nbError=0;
    trial =indTraj;
    displayOne=1;
    displayOneOk=1;
    disp(['testing trajectory type n°',  num2str(trial) ])
    for indTest=1: t{indTraj}.nbTraj
        nbTotTraj = nbTotTraj+1;
        nbTraj = nbTraj+1;
        [train{indTraj},test{indTraj}] = partitionTrajectory(t{indTraj},1,percentData,s_bar, 'Indice', indTest);
        promp{indTraj} = computeDistribution(train{test}, M, s_bar,c,h);
        test = test{trial};
        w = computeAlpha(test{1}.nbData,t, nbInput);
        for i=1:length(promp)
            promp{i}.w_alpha= w{i};
        end
        
        % Recognition of the movement
        [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
        infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, 3);
        matClusterReco(trial, infTraj.reco) = matClusterReco(trial, infTraj.reco)+1;
        if(infTraj.reco ~= trial)
            % disp('Error of the cluster recognition.');
            nbTotError= nbTotError+1;
            nbError=nbError+1;
            if(displayOne==1)
                displayOne=0;
                % drawInferenceRescaled(promp,inputName ,infTraj, test{1},s_bar, 'shaded')
                % drawInference(promp,inputName,infTraj, test{1},s_bar, 'shaded')
                % drawErrorInference(promp,inputName,infTraj, test{1},s_bar, trial, 'shaded');
            end
        elseif(displayOneOk == 1)
            displayOneOk=0;
            drawInference(promp,inputName,infTraj, test{1},s_bar,'Interval', [1:3], 'shaded');
        end
    end
    disp(['Error percentage of cluster n°', num2str(indTraj),' recognition: ',  num2str((nbError/nbTraj)*100), '%.']);
end

disp(['Error percentage of clusters recognition: ',  num2str((nbTotError/nbTotTraj)*100), '%.']);
disp(matClusterReco);


