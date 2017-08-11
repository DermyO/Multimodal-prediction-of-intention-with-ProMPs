%This demo computes N proMPs given a set of recorded trajectories containing the demonstrations for the N types of movements. 
%It plots the results.

% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

 close all;
clearvars;
 warning('off','MATLAB:colon:nonIntegerIndex')
 addpath('used_functions'); %add some fonctions we use.
% 
%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
inputName = {'x[m]','y[m]','z[m]', 'a1[°]','a2[°]','a3[°]', 'a4[°]'};
s_bar=100;
nbInput = 7; %number of input used during the inference (here cartesian position)

M = 5; %number of basis functions for the first type of input

%variable tuned to achieve the trajectory correctly. It is the co
expNoise = 0.00001;
percentData = 45; %number of observation from with the movement is inferred
%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end

load('Data/icub_frontiersWithMatlab.mat');
for i=1:length(t)
    t{i}.nbInput = nbInput;
end

%Compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(t{1}, M, s_bar,c,h);
promp{2} = computeDistribution(t{2}, M, s_bar,c,h);

connexion = initializeConnection;
command = 'yarp connect /headPos:o /matlab/write';
system(command);
command = 'yarp connect /matlab/write /headPos:o';
system(command);

command = 'yarp connect /grabber /faceIntraface/image:i';
system(command);
command = 'yarp connect /faceIntraface/image:o /view';
system(command);

promp = LearningFacePosition(promp, 20, 50, connexion);

%priorLookLearning
%load('Data/testFace.mat')
%load('tmp_analyse/intrafaceDataIcub.mat')
%drawFacePose(promp);

var_cont=1;
while(var_cont==1)
    [type, test, dist] = recoFacePosition(promp, 'connexion', connexion);
    drawFacePose(promp, 'test2', test);
    var_cont = input('1 to continue or other to stop');
end

%closeConnection(connexion);



% trial = length(promp)+1;
% while (trial > length(promp) || trial < 1)
%     trial = input(['Give the trajectory you want to test (between 1 and ', num2str(length(promp)),')']);
% end
% disp(['We try the number ', num2str(trial)]);
% 
% test = test{trial};
% w = computeAlpha(test{1}.nbData,t, nbInput);
% promp{1}.w_alpha= w{1};
% promp{2}.w_alpha= w{2};
% promp{3}.w_alpha= w{3};
% 
% %Recognition of the movement
% [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
% infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, nbInput);
% 
% %draw the infered movement
% drawInferenceRescaled(promp,inputName ,infTraj, test{1},s_bar)
%drawInference(promp,inputName,promp, test{1},s_bar)

