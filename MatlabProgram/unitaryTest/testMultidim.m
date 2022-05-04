%This function computes the distribution for a simple mouvement : y = x/2
%+5.
%M gaussians spread over time (CF Brouillon test basique)

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex');
addpath('../used_functions');


%%%%%%%%%%%%%%%VARIABLES, please look at the README

inputName = {'x', 'y'};%label of your inputs
s_ref=100; %reference number of samples
nbInput(1) = 1; %number of inputs used during the inference (here Cartesian position)
nbInput(2) = 1;
M(1) = 10; %number of basis functions to represent nbInput(1)
M(2) = 10;
%This variable is the expected data noise, you can tune this parameter to achieve the trajectory correctly
expNoise = 0.1;
percentData = 50; %percent of observed data during the inference type of cost function used to infer the modulation time
%('MO':model/'ML'maximum likelihood/ 'ME' average/'DI' distance).
choice = 'MO' ;
%%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i)-1); %center of gaussians
    %avant :h(1) = c(1)/(M(1)); %bandwidth of the gaussians
    s(i) =c(i)/2; %test ori 28/04/2022 car 95 percentile = c(i) + c(i+1) / 2 = mu + 2s => 2s = ci/2 => s = ci/4
    h(i) = 2*s(i)*s(i);
end

v =  linspace(5,10,100)'; %fonction à modéliser: y = x/2 + 5 de 5 à 10 en 100 points
t{1}.nbTraj =20;
t{1}.y = cell(1, t{1}.nbTraj);
for i=1:t{1}.nbTraj
   t{1}.y{i} = v + 0.4*randn(1, length(v))';
   t{1}.yMat{i} = [t{1}.y{i},sin(t{1}.y{i})*2+6];
   t{1}.y{i} = [t{1}.y{i};sin(t{1}.y{i})*2+6];%2D
   t{1}.totTime(i) = size(t{1}.yMat{i},1);
   t{1}.alpha(i) = t{1}.totTime(i)/s_ref;
   t{1}.realTime{i} = linspace(1,10);%tester aussi sans
end

t{2}.nbTraj =20;
t{2}.y = cell(1, t{1}.nbTraj);
for i=1:t{1}.nbTraj
   t{2}.y{i} = v*0.8 + 0.4*randn(1, length(v))';
   t{2}.yMat{i} = [t{2}.y{i},t{2}.y{i}*3+4];
   t{2}.y{i} = [t{2}.y{i};t{2}.y{i}*3+4];%2D
   t{2}.totTime(i) = size(t{1}.yMat{i},1);
   t{2}.alpha(i) = t{1}.totTime(i)/s_ref;
   t{2}.realTime{i} = linspace(1,10); %tester aussi sans
end


t{1}.nbInput = nbInput;
t{1}.label = 'linear_2D_1';
t{2}.nbInput = nbInput;
t{2}.label = 'linear_2D_2';    
[train{1}, test{1}] =  partitionTrajectory(t{1}, 1, percentData, s_ref);
[train{2}, test{2}] =  partitionTrajectory(t{2}, 1, percentData, s_ref);
test{1} = test{1}{1};
test{2} = test{2}{1};

%plot recoverData
%drawRecoverData(t{1}, inputName, 'Specolor','m','namFig', 1);
%drawRecoverData(t{2}, inputName, 'Specolor','k','namFig', 1);

%compute the distribution for each kind of trajectories.
promp{1} = computeDistribution(train{1}, M, s_ref,c,h);%, 'Draw');
promp{2} = computeDistribution(train{2}, M, s_ref,c,h);%, 'Draw');
%plot distribution
drawDistribution(promp{1}, inputName,s_ref);
drawDistribution(promp{2}, inputName,s_ref);
%plot RBF
%drawBasisFunction(promp{1}.PHI_norm, M);

if (strcmp(choice,'ME')==1)
        expAlpha = promp{1}.mu_alpha;
else
    if(strcmp(choice,'MO')==1)
        %alpha model
        w = computeAlpha(test{1}.nbData,t, nbInput);
        promp{1}.w_alpha = w{1};
        w = computeAlpha(test{2}.nbData,t, nbInput);
        promp{2}.w_alpha = w{1};
    end
        [expAlpha,type, x] = inferenceAlpha(promp,test{1},M,s_ref,c,h,test{1}.nbData, expNoise, choice);
end
display(['expAlpha= ', num2str(expAlpha), ' real alpha= ', num2str(test{1}.alpha)]);

%Recognition of the movement
infTraj = inference(promp, test{1}, M, s_ref, c, h, test{1}.nbData, expNoise, expAlpha);

%draw the infered movement
drawInference(promp,inputName,infTraj, test{1},s_ref, 'Interval', [1,2]);
drawInferenceRescaled(promp,{'y=x/2 + 5', 'y=sin((x/2 + 5))*2 +6'}, infTraj, test{1},s_ref, 'Interval', [1,2])
drawErrorInference(promp,inputName,infTraj, test{1},s_ref, 1, 'shaded', 'Interval', [1,2])