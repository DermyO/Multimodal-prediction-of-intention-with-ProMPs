%Test personas
% by Oriane Dermy 24/06/22
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]


close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

% % %init : at the begining we only add click data
inputName = {'clicks'};
s_bar= 40 ;
nbInput = 1 ;
percentData = 48;
%display('load click trajectories')
l_ids = loadIdPerClass('Data/Personas/GHPrimaire_DISTINCTION_id.csv','Data/Personas/GHPrimaire_PASS_id.csv','Data/Personas/GHPrimaire_WITHDRAWN_id.csv','Data/Personas/GHPrimaire_FAIL_id.csv');
t = loadTrajectoryPersonas7('Data/Personas/data_globales.csv', l_ids, 's_bar',240);
t{1}.inputName = inputName;
t{2}.inputName = inputName;
t{3}.inputName = inputName;
t{4}.inputName = inputName;

%To load trajectories faster
listName = ["Data/Bresil/AW.json", "Data/Bresil/JC.json"];
t2{1} = loadTrajectoryBresilian(listName);

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
% drawRecoverData(t{2}, inputName, 'Interval', [1:3], 'Specolor', 'g' ,'namFig', 1);
% drawRecoverData(t{1}, inputName, 'Interval', [1:3], 'Specolor', 'b' ,'namFig', 1);
% drawRecoverData(t{4}, inputName, 'Interval', [1:3]  , 'Specolor', ':r','namFig', 1);
% drawRecoverData(t{3}, inputName, 'Interval', [1:3], 'Specolor', ':k','namFig', 1);

%%init
%take one of the trajectory randomly to do test, the others are stocked in train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);
[train{4},test{4}] = partitionTrajectory(t{4},1,percentData,s_bar);


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
    
end