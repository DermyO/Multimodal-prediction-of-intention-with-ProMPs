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
s_bar= 17 ;
nbInput(1) = 1 ;
M(1) =17;
percentData = 48;
name = 'DDD_2013B';
flag_14d = 1;
if(strcmp(name,'BBB_2013B')==1)
    M(1) = 8;
    s_bar = 8;
elseif(strcmp(name,'DDD_2013B')==1)
    M(1) = 14;
    s_bar =14;
elseif(strcmp(name,'DDD_2014B')==1)
    M(1) = 7;
    s_bar = 7;
end
if(flag_14d == 1)
    M(1) = 18;
    s_bar =18;
end

display('load click trajectories')

l_ids = loadIdPerClass(strcat('Data/Personas/new_version/',name,'/GHPrimaire_DISTINCTION_id_',name,'.csv'),strcat('Data/Personas/new_version/',name,'/GHPrimaire_PASS_id_',name,'.csv'),strcat('Data/Personas/new_version/',name,'/GHPrimaire_WITHDRAWN_id_',name,'.csv'),strcat('Data/Personas/new_version/',name,'/GHPrimaire_FAIL_id_',name,'.csv'));
t = loadTrajectoryPersonas6(strcat('Data/Personas/new_version/',name,'/total_clicks_per_date_',name,'_14j.csv'), l_ids, 's_bar', s_bar, 'name', '14d');

t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;

%Then we adapt variables to add score and delay data
nbInput(2) = 2 ;
M(2) = 14;

inputName = {'clicks', 'score', 'delai'};
%some variable computation to create basis function, you might have to
%change them
dimRBF = 0;
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/(5*M(i));%bandwidth of gaussians
end

if(strcmp(name,'BBB_2013B')==1 && (flag_14d==0))
    M(2) = 8;
    
    %some variable computation to create basis function, you might have to
    %change them
    dimRBF = 0;
    for i=1:size(M,2)
        dimRBF = dimRBF + M(i)*nbInput(i);
        c(i) = 1.0 / M(i);%center of gaussians
        h(i) = 1/(M(i)*M(i)*M(i));%bandwidth of gaussians
    end
end

t{1} = loadTrajectoryPersonas5(strcat('Data/Personas/new_version/',name,'/GHPrimaire_DISTINCTION_id_',name,'.csv'), t{1}, nbInput, 'name',name);
t{2} = loadTrajectoryPersonas5(strcat('Data/Personas/new_version/',name,'/GHPrimaire_PASS_id_',name,'.csv'), t{2}, nbInput, 'name',name);
t{3} = loadTrajectoryPersonas5(strcat('Data/Personas/new_version/',name,'/GHPrimaire_WITHDRAWN_id_',name,'.csv'), t{3}, nbInput, 'name',name);
t{4} = loadTrajectoryPersonas5(strcat('Data/Personas/new_version/',name,'/GHPrimaire_FAIL_id_',name,'.csv'), t{4}, nbInput, 'name',name);

%plot recoverData
% drawRecoverData(t{1}, inputName,'Interval', [1:3],'Specolor','b','namFig', 1, 'personas_14d');
% drawRecoverData(t{3}, inputName, 'Interval', [1:3],'Specolor','r','namFig', 1, 'personas_14d');
% drawRecoverData(t{4}, inputName, 'Interval', [1:3], 'Specolor',':k','namFig', 1, 'personas_14d');
% drawRecoverData(t{2}, inputName, 'Interval', [1:3],'Specolor',':g','namFig', 1, 'personas_14d');

%%init
%take one of the trajectory randomly to do test, the others are stocked in train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);
%Compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);%, 'Draw');
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);
promp{4} = computeDistribution(train{4}, M, s_bar,c,h);


display('Drawing Distributions ...')
% drawDistribution(promp{1}, inputName,s_bar, 'col', 'b', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{1}.meanTimes,promp{1}.meanTimes,promp{1}.meanTimes], 'shaded', 'without', 'fig',11,'personas_14d');
% drawDistribution(promp{2}, inputName,s_bar, 'col', 'g', 'xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{2}.meanTimes,promp{2}.meanTimes,promp{2}.meanTimes], 'shaded', 'without', 'fig',11,'personas_14d');
% drawDistribution(promp{3}, inputName,s_bar, 'col', 'r' ,'xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{3}.meanTimes,promp{3}.meanTimes,promp{3}.meanTimes], 'shaded', 'without', 'fig',11,'personas_14d');
% drawDistribution(promp{4}, inputName,s_bar, 'col', 'k','xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{4}.meanTimes,promp{4}.meanTimes,promp{4}.meanTimes], 'shaded', 'without', 'fig',11,'personas_14d');

drawDistribution(promp{1}, inputName,s_bar, 'col', 'b', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{1}.meanTimes,promp{1}.meanTimes,promp{1}.meanTimes], 'fig',12,'personas_14d', 'without');
drawDistribution(promp{2}, inputName,s_bar, 'col', 'g', 'xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{2}.meanTimes,promp{2}.meanTimes,promp{2}.meanTimes],   'fig',13,'personas_14d', 'without');
drawDistribution(promp{3}, inputName,s_bar, 'col', 'r' ,'xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{3}.meanTimes,promp{3}.meanTimes,promp{3}.meanTimes],   'fig',14,'personas_14d', 'without');
drawDistribution(promp{4}, inputName,s_bar, 'col', 'k','xLabelName', 'date examens', 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [promp{4}.meanTimes,promp{4}.meanTimes,promp{4}.meanTimes], 'fig',15,'personas_14d', 'without');

% nbTotTraj= 0;
% nbTotError = 0;
% 
% matClusterReco = zeros(4,4);
% expNoise = 100;
% 
% % Testing cluster recognition for all clusters
% for indTraj = 1:1%4
%     nbTraj=0;
%     nbError=0;
%     trial =indTraj;
%     displayOne=1;
%     displayOneOk=1;
%     disp(['testing trajectory type n°',  num2str(trial) ])
%     for indTest=1:1% t{indTraj}.nbTraj
%         nbTotTraj = nbTotTraj+1;
%         nbTraj = nbTraj+1;
%         [train{indTraj},test{indTraj}] = partitionTrajectory(t{indTraj},1,percentData,s_bar, 'Indice', indTest);
%         promp{indTraj} = computeDistribution(train{indTraj}, M, s_bar,c,h);
%         test = test{trial};
%         w = computeAlpha(test{1}.nbData,t, nbInput);
%         for i=1:length(promp)
%             promp{i}.w_alpha= w{i};
%         end
%         
%         % Recognition of the movement
%         [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
%         infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, 3);
%         matClusterReco(trial, infTraj.reco) = matClusterReco(trial, infTraj.reco)+1;
%         if(infTraj.reco ~= trial)
%             % disp('Error of the cluster recognition.');
%             nbTotError= nbTotError+1;
%             nbError=nbError+1;
%             if(displayOne==1)
%                 displayOne=0;
%                 drawInferenceRescaled(promp,inputName ,infTraj, test{1},s_bar,'Interval', [1:3], 'shaded')
%                 drawInference(promp,inputName,infTraj, test{1},s_bar, 'shaded')
%                 drawErrorInference(promp,inputName,infTraj, test{1},s_bar, trial, 'shaded');
%             end
%         elseif(displayOneOk == 1)
%             displayOneOk=0;
%             drawInferenceRescaled(promp,inputName,infTraj, test{1},s_bar,'Interval', [1:3], 'shaded');
%             drawInference(promp,inputName,infTraj, test{1},s_bar, 'shaded')
%             drawErrorInference(promp,inputName,infTraj, test{1},s_bar, trial, 'shaded');
%         end
%     end
%     disp(['Error percentage of cluster n°', num2str(indTraj),' recognition: ',  num2str((nbError/nbTraj)*100), '%.']);
% end
% 
% disp(['Error percentage of clusters recognition: ',  num2str((nbTotError/nbTotTraj)*100), '%.']);
% disp(matClusterReco);


