%In this demo, you can replay learned movement; then you can begin a movement with the geomagic on iCubGazeboSim. To that, you will use a Cpp program that records your movement as long as you press a Geomagic button. Then, this script retrieve these early observation, and infer the movement end. It replays it on the icubGazeboSim. 


% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
close all;
clearvars;
addpath('used_functions');
warning('off','MATLAB:colon:nonIntegerIndex')

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
inputName = {'x[m]','y[m]','z[m]', 'o_1[°]','o_2[°]','o_3[°]','o_4[°]','n1','n2','a_1[°]','a_2[°]','a_3[°]'};
s_bar=100;
nbInput = 7%[3 4];%9 %number of input used during the inference (here cartesian position)
nbInput = [3 12]; %number of input used during the inference (here cartesian position)10

M(1) = 5; %number of basis functions for the first type of input
%M(2) = 5; %number of basis functions for the second type of input

%variable tuned to achieve the trajectory correctly
expNoise = 0.00001;
percentData = 50; %number of data with what you try to find the correct movement
%%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(1)/M(i); %bandwidth of gaussians
end

connexion = initializeConnectionRealIcub('withFacePos')        
%%
 closeEndOrder = 'left close_hand';
 connexion.grasp.clear();
 connexion.grasp.fromString(closeEndOrder);
 connexion.portGrasp.write(connexion.grasp);
 a = input('Press enter when the robot has closed its hand');
 connexion.portGrasp.close;
% retrieve data 
load('/home/odermy/Bureau/Multimodal-prediction-of-intention-with-ProMPs/MatlabProgram/Data/expIcra/olivier_allWitoutBadOnlyMeanForces.mat')

t{1}.nbInput = nbInput;
t{2}.nbInput = nbInput;

% % %compute PROMPS
%  promp_action{1} = computeDistribution(t{1}, M, s_bar,c,h);
%  promp_action{2} = computeDistribution(t{2}, M, s_bar,c,h);
% % 
% % %Draw PROMPS
%  fig = figure;
%  drawDistribution(promp_action{1}, inputName,s_bar,[10:12],'fig',fig, 'col', 'b','mean');
%  drawDistribution(promp_action{2}, inputName,s_bar,[10:12],'fig',fig, 'col', 'r','mean');
%  fig2 = figure;
%  drawDistribution(promp_action{1}, inputName,s_bar,[4:6],'fig',fig2, 'col', 'b','mean');
%  drawDistribution(promp_action{2}, inputName,s_bar,[4:6],'fig',fig2, 'col', 'r','mean');
% 
%  fig3 = figure;
%  drawDistribution(promp_action{1}, inputName,s_bar,[7:8],'fig',fig3, 'col', 'b','mean');
%  drawDistribution(promp_action{2}, inputName,s_bar,[7:8],'fig',fig3, 'col', 'r','mean');
% 
%  fig4 = figure;
%  drawDistribution(promp_action{1}, inputName,s_bar,[9:11],'fig',fig4, 'col', 'b','mean');
%  drawDistribution(promp_action{2}, inputName,s_bar,[7:11],'fig',fig4, 'col', 'r','mean');



%cont=1;
%while( cont==1)
%%     


[trainAct,testAct] = partitionTrajectory(t{1},1,percentData,s_bar,cpt, 'Interval', [10:12]);

%compute PROMPS
promp_action{1} = computeDistribution(trainAct, M, s_bar,c,h);
promp_action{2} = computeDistribution(t{2}, M, s_bar,c,h);


%    testAct{1} = beginATrajectoryWithRealIcub(connexion);
 %   connexion.portSkin.close;
  %  connexion.portState.close;
    
    %Recognition of the movement
	[alphaTraj,type, x] = inferenceAlphaV2(promp_action,testAct{1},M,s_bar,c,h,testAct{1}.nbData, expNoise,  [10:12], 'ML');                
    recoPromp{1} =promp_action{type}; % we keep only the inferred ProMP
    [infTraj,typeReco] = inference(promp_action, testAct{1}, M, s_bar, c, h, testAct{1}.nbData, expNoise, alphaTraj, connexion);

    %to ask icub to say the label of the recognize trajectory
    %sayType(promp{typeReco}.traj.label, connexion);
    drawInference(promp_action,inputName,infTraj, testAct{1},s_bar)

    continueMovementiCubGui(infTraj,connexion, testAct{1}.nbData,s_bar, promp_action{type}.PHI_norm,inputName);
    %replay the movement into gazebo
    %connexion.portIG.close;
        
    a = input('press "y" if you want to replay on icub or "n" ');
    while(strcmp(a, 'y')==0)
        a = input(' press "y" when ready'); 
        if(strcmp(a, 'n') ==1)
            break;
        end
    end
    
    
    if(strcmp(a,'y') ==1)
        continueMovement(infTraj,connexion, testAct{1}.nbData,s_bar, promp_action{type}.PHI_norm,inputName);
    end
    pause(3);  
     connexion.portGrasp.open('/matlab/grasp:o');
     system('yarp connect /matlab/grasp:o /grasper/rpc:i');
     closeEndOrder = 'left close_hand';
     connexion.grasp.clear();
     connexion.grasp.fromString(closeEndOrder);
     connexion.portGrasp.write(connexion.grasp);
    %cont = input('Do you want to infer again? (yes=1, no=0)');
%end

%close the port and the program replay.
closeConnectionRealIcub(connexion);
