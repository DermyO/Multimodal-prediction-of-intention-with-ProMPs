%In this demo, you can replay learned movement; then you can begin a movement with the geomagic on iCubGazeboSim. To that, you will use a Cpp program that records your movement as long as you press a Geomagic button. Then, this script retrieve these early observation, and infer the movement end. It replays it on the icubGazeboSim. 


% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
close all;
clearvars;
addpath('used_functions');
warning('off','MATLAB:colon:nonIntegerIndex')

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
%inputName = {'x[m]','y[m]','z[m]', 'o_1','o_2','o_3'}%, 'o_4'};
inputName = {'x[m]','y[m]','z[m]', 'o_1','o_2','o_3', 'o_4'};

inputName2 = {'h_1', 'h_2', 'h_3'};
s_bar=100;
nbInput = 7%[3 4];%9 %number of input used during the inference (here cartesian position)

M(1) = 5; %number of basis functions for the first type of input
%M(2) = 5; %number of basis functions for the second type of input

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

connexion = initializeConnectionRealIcub('withFacePos')    
command = 'yarp connect /headPos:o /matlab/HP';
system(command);
command = 'yarp connect /matlab/HP /headPos:o';
system(command);

% Take the object
%  closeEndOrder = 'left close_hand';
%  connexion.grasp.clear();
%  connexion.grasp.fromString(closeEndOrder);
%  connexion.portGrasp.write(connexion.grasp);
%  a = input('Press enter when the robot has closed its hand');
%  connexion.portGrasp.close;

%retrieve trajectories done with the real iCub
load('Data/icub_frontiersWithMatlab.mat');
for i=1:length(t)
    t{i}.nbInput = nbInput;
end

%%%quat2eul
% for i=1:2
%     for j=1:t{i}.nbTraj
%         for k = 1:t{i}.totTime(j)
%             mmata{i,j}(k,1:3) =quat2eul(t{i}.yMat{j}(k,4:7)');
% %SpinCalc('QtoEA321',t{i}.yMat{j}(k,4:7),0,0);
%         end
%     end
% end
% for i=1:2
%     for j=1:t{i}.nbTraj
%         for k = 1:t{i}.totTime(j)
%             t{i}.yMat{j}(k,4:6) = mmata{i,j}(k,:);
%         end
%     end
% end
% for i=1:2
%     for j=1:t{i}.nbTraj
%         t{i}.yMat{j}(:,7) = [];
%     end
% end
% for j=1:t{i}.nbTraj
%     for i=1:2
%         for j=1:t{i}.nbTraj
%             t{i}.y{j} = reshape(t{i}.yMat{j}, [], numel(t{i}.yMat{j}),1)'
%         end
%     end
% end
% t{1}.nbInput = 6;
% t{2}.nbInput = 6;

% 
% namFig = figure;
% drawRecoverData(t{1}, inputName, 'Specolor','b','namFig', 1);
% drawRecoverData(t{2}, inputName, 'Specolor','r','namFig', 1); 



%Compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(t{1}, M, s_bar,c,h);
promp{2} = computeDistribution(t{2}, M, s_bar,c,h);
    
% 
% fig2 = figure;
% drawDistribution(promp{1}, inputName,s_bar,[1:6], 'col', 'b', 'fig', fig2, 'mean');
% drawDistribution(promp{2}, inputName,s_bar,[1:6], 'col', 'r', 'fig', fig2, 'mean');


%% replay trajectories

cont = [];
while(isempty(cont))
cont = input('Do you want to replay trajectories ? Y=1 N=0');
end
while( cont==1)
   %  continueMovementiCubGui(promp{1},connexion, 1,s_bar, promp{1}.PHI_norm,inputName,'isPrior');
  %   drawDistribution(promp{1}, inputName,s_bar,[1:6], 'col', 'b');
     %a = input('inReal');
     continueMovement(promp{1},connexion, 1,s_bar, promp{1}.PHI_norm,inputName,'isPrior', 'isEul');

     a = input('Press enter to see the second movement');
   %  continueMovementiCubGui(promp{2},connexion, 1,s_bar, promp{2}.PHI_norm,inputName,'isPrior');
   %  drawDistribution(promp{2}, inputName,s_bar,[1:6], 'col', 'b');
   %  a = input('inReal');
     continueMovement(promp{2},connexion, 1,s_bar, promp{2}.PHI_norm,inputName,'isPrior', 'isEul');
     cont = [];
    while(isempty(cont))
        cont = input('Do you want to replay trajectories ? Y=1 N=0');
    end
end


load('dataFeteDesSciences.mat');
% Learning the first trajectory
a = [];
while(isempty(a))
    a= input('Do you want to record head trajectories? Y=1 N=0');
end

while (a == 1)
    nbDistrib = nbDistrib +1
    data_action{nbDistrib} = recordFaceTrajectory(promp,s_bar, connexion);
    val= input('Do you want to record the data? Y=1 N=0');
    while(isempty(val))
        val= input('Do you want to record the data? Y=1 N=0');
    end
    if(val ==1)
        display('saving');
        save('dataFeteDesSciences.mat','data_action','-append'); 
        save('dataFeteDesSciences.mat','nbDistrib','-append');
        a =0;
    else
        nbDistrib = nbDistrib -1;
        a = [];
        while(isempty(a))
            a= input('Do you want record head trajectories? Y=1 N=0');
        end
    end

end

wholeData = concatData(data_action);

% namFig = figure;
% drawRecoverData(wholeData{1}, inputName2, 'Specolor','b','namFig', 1);
% drawRecoverData(wholeData{2}, inputName2, 'Specolor','r','namFig', 1); 

%learning huge distribution
promp_action_face{1} = computeDistribution(wholeData{1}, M, s_bar,c,h);
% promp_action_face{2} = computeDistribution(wholeData{2}, M, s_bar,c,h); 
% 
% fig = figure;
% drawDistribution(promp_action_face{1}, inputName2,s_bar,[1:3], 'col', 'b', 'fig', fig, 'mean');
% drawDistribution(promp_action_face{2}, inputName2,s_bar,[1:3], 'col', 'r', 'fig', fig, 'mean');

%%saving data    
cont = [];
while(isempty(cont))
    cont = input('Do you want to infer? (yes=1, no=0)');
end

while( cont==1)
      
    %%Testing the learning   
    test = beginAHeadTrajectory(connexion);

    %Recognition of the movement
    [alphaTraj,type, x] = inferenceAlpha(promp_action_face,test,M,s_bar,c,h,test.nbData, expNoise, 'ML');
    %recoPromp{1} =promp_action_face{type}; % we keep only the inferred ProMP
    %[infTraj,typeReco] = inference(recoPromp, test, M, s_bar, c, h, test.nbData, expNoise, alphaTraj, connexion);
    display(['the recognized type is ',promp{type}.traj.label ])
    %to ask icub to say the label of the recognize trajectory
    
    sayType(promp{type}.traj.label, connexion);
    %drawInference(promp_action_face,inputName2,infTraj, test,s_bar)

    inf = continueMovementiCubGui(promp{type},connexion, test.nbData,s_bar, promp{type}.PHI_norm,inputName, 'isPrior');
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
        continueMovement(inf,connexion, test.nbData,s_bar, promp{type}.PHI_norm,inputName, 'isPrior');
    end
    pause(3);  
     connexion.portGrasp.open('/matlab/grasp:o');
     system('yarp connect /matlab/grasp:o /grasper/rpc:i');
     closeEndOrder = 'left close_hand';
     connexion.grasp.clear();
     connexion.grasp.fromString(closeEndOrder);
     connexion.portGrasp.write(connexion.grasp);
    cont = [];
    while(isempty(cont))
        cont = input('Do you want to infer again? (yes=1, no=0)');
    end
end

%close the port and the program replay.
closeConnectionRealIcub(connexion,'withFacePos');
