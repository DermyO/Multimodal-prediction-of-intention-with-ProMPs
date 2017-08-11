%In this demo, you can replay learned movement; then you can begin a movement with the geomagic on iCubGazeboSim. To that, you will use a Cpp program that records your movement as long as you press a Geomagic button. Then, this script retrieve these early observation, and infer the movement end. It replays it on the icubGazeboSim. 


% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
close all;
clearvars;
addpath('used_functions');
warning('off','MATLAB:colon:nonIntegerIndex')

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
inputName = {'x[m]','y[m]','z[m]', 'a1[°]','a2[°]','a3[°]', 'a4[°]'};
s_bar=100;
nbInput = [3 4];%9 %number of input used during the inference (here cartesian position)

M(1) = 5; %number of basis functions for the first type of input
M(2) = 5; %number of basis functions for the second type of input

%variable tuned to achieve the trajectory correctly
expNoise = 0.00001;
percentData = 40; %number of data with what you try to find the correct movement
%%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(1)/M(i); %bandwidth of gaussians
end

connexion = initializeConnectionRealIcub   
%%
t{1} = recordTrajectoryWithRealIcub(connexion, 'left', nbInput, s_bar);
t{2} = recordTrajectoryWithRealIcub(connexion, 'front', nbInput, s_bar);


closeConnectionRealIcub(connexion);