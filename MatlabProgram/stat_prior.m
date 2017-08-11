%This demo computes N proMPs given a set of recorded trajectories containing the demonstrations for the N types of movements. 
%It plots the results.

% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

load('etudeData/data/prior.mat');

drawFacePose(promp);

error = 0;

cpt=1;
for nbTest=1:20
    load('etudeData/data/prior.mat');
    trial = ceil(rand(1)*length(promp));
    %while (trial > length(promp) || trial < 1)
     %    trial = input(['Give the trajectory you want to test (between 1 and ', num2str(length(promp)),')']);
    %end
    %disp(['We try the number ', num2str(trial)]);
    [test, promp{trial}.facePose] = partitionPrior(promp{trial}, trial, 1);
%test 
    [type, test, dist] = recoFacePosition(promp, test);
    if(type~=trial)
        error = error+1;
    else 
        distanceWhenCorrect(cpt) = dist;        
        cpt=cpt+1;
    end
    %drawFacePose(promp, 'test2', test);    
end




