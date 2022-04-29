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
%("Page ENT", "Stockage Partage", "Travail Collaboratif", "Notes", "Absences","Services Vie Scolaire", "Gestion Competences", "Gestion Temps", "Cahier Textes","Courrier Electronique", "Actualités", "Reservation Ressources", "Ressources En Ligne", "Documentation CDI", "Orientation", "Parcours Pedagogiques", "Services Collectivites", "Visioconference")
inputName = {'Page ENT', 'Stockage Partage', 'Travail Collaboratif', 'Notes', 'Absences','Services Vie Scolaire', 'Gestion Competences'};%, 'Gestion Temps', 'Cahier Textes','Courrier Electronique', 'Actualités', 'Reservation Ressources', 'Ressources En Ligne', 'Documentation CDI', 'Orientation', 'Parcours Pedagogiques', 'Services Collectivites', 'Visioconference'};
s_bar=365;
nbInput(1) = 4 ; %3; %number of input used during the inference (here cartesian position)
nbInput(2) = 3; %other inputs (here forces and wrenches)

M(1) = 30; %number of basis functions for the first type of input
M(2) = 30; %number of basis functions for the second type of input

%variable tuned to achieve the trajectory correctly
expNoise = 4.0001;
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

% display('load t1')
% t{1} = loadTrajectory('Data/Covid/Per_week/site:[Strasbourg,Toulouse,Val_dOise]_date:2018-09-01:2019-08-30_10users_per_site/_Académie-Toulouse', 'site2019', 'refNb', s_bar, 'nbInput',nbInput, 'Specific','CovidW', 'max', '1737');
% if(~isfield(t{1},'inputName'))
%     t{1}.inputName = inputName
% end
% display('load t2')
% t{2} = loadTrajectory('Data/Covid/Per_week/site:[Strasbourg,Toulouse,Val_dOise]_date:2018-09-01:2019-08-30_10users_per_site/ValOise', 'site2019', 'refNb', s_bar, 'nbInput',nbInput, 'Specific','CovidW', 'max', '1737');
% display('load t3')
 t{1} = loadTrajectory('Data/Covid/Per_week/site:[Strasbourg,Toulouse,Val_dOise]_date:2018-09-01:2019-08-30_10users_per_site/_MBN Strasbourg Lycées', 'site2019', 'refNb', s_bar, 'nbInput',nbInput, 'Specific','CovidM');%, 'max', '1737');
 display('treatment...')
 if(~isfield(t{1},'inputName'))
     t{1}.inputName = inputName
 end

%plot recoverData
drawRecoverData(t{1}, inputName, 'Interval', [1 2 3 4], 'Specolor','b','namFig', 1);
drawRecoverData(t{1}, inputName, 'Interval', [5 6 7], 'Specolor','b','namFig',2);
drawRecoverData(t{2}, inputName, 'Interval', [1 2 3 4], 'Specolor','r','namFig',1);
drawRecoverData(t{2}, inputName, 'Interval', [5 6 7],  'Specolor','r','namFig',2);

%take one of the trajectory randomly to do test, the others are stocked in
%train.
[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);

[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);
[train{3},test{3}] = partitionTrajectory(t{3},1,percentData,s_bar);

%Compute the distribution for each kind of trajectories.
display('Training t1')
promp{1} = computeDistribution(train{1}, M, s_bar,c,h);
display('Training t2')
promp{2} = computeDistribution(train{2}, M, s_bar,c,h);
display('Training t3')
promp{3} = computeDistribution(train{3}, M, s_bar,c,h);

display('Drawing Distributions ...')
%plot distribution
drawDistribution(promp{1}, inputName,s_bar,[1:7], 'col', 'b');
drawDistribution(promp{2}, inputName,s_bar,[1:7], 'col', 'r');
drawDistribution(promp{3}, inputName,s_bar,[1:7], 'col', 'g');
display('Trials')

trial = length(promp)+1;
while (trial > length(promp) || trial < 1)
    trial = input(['Give the trajectory you want to test (between 1 and ', num2str(length(promp)),')']);
end

disp(['We try the number ', num2str(trial)]);
test = test{trial};
w = computeAlpha(test{1}.nbData,t, nbInput);
promp{1}.w_alpha= w{1};
promp{2}.w_alpha= w{2};
promp{3}.w_alpha= w{3};

%Recognition of the movement
[alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, nbInput);

%draw the infered movement
drawInferenceRescaled(promp,inputName ,infTraj, test{1},s_bar)
drawInference(promp,inputName,infTraj, test{1},s_bar)

