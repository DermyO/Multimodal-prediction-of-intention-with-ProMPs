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

inputName = {'clicks'};

s_bar= 20;
nbInput(1) = 1 ;
M(1) = 11; 

%variable tuned to achieve the trajectory correctly
expNoise = 20;
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

%load trajectories
t{1} = loadTrajectoryPersonas4('Data/Personas/distinction_global.csv', 'distinction', 'without0','m',15, 's_bar', s_bar);
t{2} = loadTrajectoryPersonas4('Data/Personas/pass_global.csv', 'pass', 'without0','m',15, 's_bar', s_bar);
t{3} = loadTrajectoryPersonas4('Data/Personas/withdrawn_global.csv', 'withdraw', 'without0','m',15, 's_bar', s_bar);
t{4} = loadTrajectoryPersonas4('Data/Personas/fail_global.csv', 'fail', 'without0','m',15, 's_bar', s_bar);
t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;

%init
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
promp{4} = computeDistribution(train{4}, M, s_bar,c,h);

nbTotTraj= 0;
nbTotError = 0;

matClusterReco = zeros(5,4);

%testing cluster recognition for all clusters
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
        promp{indTraj} = computeDistribution(train{indTraj}, M, s_bar,c,h);
        test = test{trial};
        w = computeAlpha(test{1}.nbData,t, nbInput);
        for i=1:length(promp)
            promp{i}.w_alpha= w{i};
        end
        
        %Recognition of the movement
        [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
        infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, nbInput);
        matClusterReco(trial, infTraj.reco) = matClusterReco(trial, infTraj.reco)+1;
        if(infTraj.reco ~= trial)
           % disp('Error of the cluster recognition.');
            nbTotError= nbTotError+1;
            nbError=nbError+1;
        %    if(displayOne==1)
         %       displayOne=0;
          %      drawInferenceRescaled(promp,inputName ,infTraj, test{1},s_bar, 'shaded', 'ymin', 0)
           %     drawInference(promp,inputName,infTraj, test{1},s_bar, 'shaded', 'ymin', 0)
            %    drawErrorInference(promp,inputName,infTraj, test{1},s_bar, trial, 'shaded', 'ymin', 0);
            %end
        elseif(displayOneOk == 1)
            displayOneOk=0;
            drawInference(promp,inputName,infTraj, test{1},s_bar, 'shaded', 'ymin', 0);
        end
    end 
    disp(['Error percentage of cluster n°', num2str(indTraj),' recognition: ',  num2str((nbError/nbTraj)*100), '%.']);   
end

 disp(['Error percentage of clusters recognition: ',  num2str((nbTotError/nbTotTraj)*100), '%.']);
 disp(matClusterReco);

