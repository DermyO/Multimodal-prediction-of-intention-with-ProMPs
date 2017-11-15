%In this demo, you can replay learned movement; then you can begin a movement with the geomagic on iCubGazeboSim. To that, you will use a Cpp program that records your movement as long as you press a Geomagic button. Then, this script retrieve these early observation, and infer the movement end. It replays it on the icubGazeboSim. 


% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
close all;
clearvars;
addpath('../../used_functions');
warning('off','MATLAB:colon:nonIntegerIndex')

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
inputName = {'x[m]','y[m]','z[m]', 'roll[°]','pitch[°]','yaw[°]','n1','n2','a_1[°]','a_2[°]','a_3[°]'};
s_bar=100;
nbInput = 11;%[3 15]; %number of input used during the inference (here cartesian position)10
M(1) = 5; %number of basis functions for the first type of input
%%%%%%%%%%%%%% END VARIABLE CHOICE

for i=1:size(M,2)
c(i) = 1.0 / (M(i));%center of gaussians
h(i) = c(1)/M(i); %bandwidth of gaussians
end

% retrieve data 
load('/home/odermy/Bureau/Multimodal-prediction-of-intention-with-ProMPs/MatlabProgram/Data/expIcra/olivier_allWitoutBadOnlyMeanForces11inputs.mat')

t{1}.nbInput = nbInput;
t{2}.nbInput = nbInput;

%%%%%%%%%%%%%ERROR STAT
 
typeErr = {'ML','MO'};

%%
for allT=2 %1:4
    switch allT
        case 1 
            intUsed = [9:11];
            expNoise = 10;
        case 2
            intUsed = [1:3];
            expNoise = 0.00001;
        case 3
            intUsed = [1:6];
            expNoise = 10;
        case 4
            intUsed = [1:3 9:11];
            expNoise = 10;
    end

    
    cptERR = 0;
    perNB = 20;

    if(perNB == 10)
        lim =10; 
    else
        lim =5;
    end

    errorReco = zeros(2,lim);
    errorRecoType = zeros(2,lim);

    for tt = 1:2
        cptERR = cptERR +1;
        for i =  1:lim
            percentData = 50%perNB*i;
            errorReco(cptERR, i) = 0;
            alphaError(cptERR, i) = 0;
            for cpt=1:t{1}.nbTraj
                clear trainAct testAct

                [trainAct,testAct] = partitionTrajectory(t{1},1,percentData,s_bar,cpt, 'Interval', intUsed);

                %compute PROMPS
                promp_action{1} = computeDistribution(trainAct, M, s_bar,c,h);
                promp_action{2} = computeDistribution(t{2}, M, s_bar,c,h);

                if(tt==2)
                    %compute which ProMP is the correct one and finish movement
                    [w, minData] = computeAlphaV2(testAct{1}.nbData,t, intUsed);
                    promp_action{1}.w_alpha= w{1};
                    promp_action{2}.w_alpha= w{2};
                    %     %Recognition of the movement
                    [alphaTraj,type, x] = inferenceAlphaV2(promp_action,testAct{1},M,s_bar,c,h,minData, expNoise, intUsed, 'MO');
                else
                    [alphaTraj,type, x] = inferenceAlphaV2(promp_action,testAct{1},M,s_bar,c,h,testAct{1}.nbData, expNoise, intUsed, 'ML');
                end
                [infTraj,typeReco] = inference( promp_action, testAct{1}, M, s_bar, c, h, testAct{1}.nbData, expNoise, alphaTraj, 'speInt',intUsed);
             if(type~=1)
                    errorRecoType(cptERR,i) = errorRecoType(cptERR,i) +1;
                end
                if(typeReco ~=1)
                    errorReco(cptERR,i) = errorReco(cptERR,i)+ 1;
                %else
                end
                     minInd = min (testAct{1}.totTime, infTraj.timeInf);
                    infPrior{cptERR,i,cpt} = infTraj.PHI*promp_action{type}.mu_w;
                    infPrior{cptERR,i,cpt} =infPrior{cptERR,i,cpt}([1:minInd , infTraj.timeInf+1: infTraj.timeInf+minInd, infTraj.timeInf*2+1: infTraj.timeInf*2+minInd]) ;

                    infTrajCourb{cptERR,i,cpt} = infTraj.PHI*infTraj.mu_w;
                    infTrajCourb{cptERR,i,cpt} =infTrajCourb{cptERR,i,cpt}([1:minInd , infTraj.timeInf+1: infTraj.timeInf+minInd, infTraj.timeInf*2+1: infTraj.timeInf*2+minInd]); %position only

                    testCourb{cptERR,i,cpt} = testAct{1}.y([1:minInd , testAct{1}.totTime+1:testAct{1}.totTime+minInd,testAct{1}.totTime*2+1:testAct{1}.totTime*2+minInd]);

                    alphaError(cptERR, i) = alphaError(cptERR, i) + abs(infTraj.alpha - testAct{1}.alpha);
                    errorTraj{cptERR}(i,cpt ) = mean(abs(infTrajCourb{cptERR,i,cpt} - testCourb{cptERR,i,cpt}));
                    errorTrajWithoutInf{cptERR}(i,cpt) = mean(abs(infPrior{cptERR,i,cpt} - testCourb{cptERR,i,cpt}));
                    MRMSE{cptERR}(i,cpt) = sqrt(errorTraj{cptERR}(i,cpt)) / mean(abs(infPrior{cptERR,i,cpt}));
                    MRMSE_prior{cptERR}(i,cpt ) = sqrt(errorTrajWithoutInf{cptERR}(i,cpt) ) / mean(abs(infPrior{cptERR,i,cpt}));
                %end

                    %to ask icub to say the label of the recognize trajectory
                    %sayType(promp{typeReco}.traj.label, connexion);
                           drawInference(promp_action,inputName,infTraj, testAct{1},s_bar,'dataReco', intUsed, 'Interval', [1:3 9:11], 'recoData', [1:3 9:11]);
                             a = input('press enter to continue');
                                close all;

            end
            for cpt=1:t{2}.nbTraj

                clear trainAct testAct

                [trainAct,testAct] = partitionTrajectory(t{2},1,percentData,s_bar,cpt, 'Interval', intUsed);

                %compute PROMPS
                promp_action{1} = computeDistribution(t{1}, M, s_bar,c,h);
                promp_action{2} = computeDistribution(trainAct, M, s_bar,c,h);

                if(tt==2)
                    %compute which ProMP is the correct one and finish movement
                    [w, minData] = computeAlphaV2(testAct{1}.nbData,t, intUsed);
                    promp_action{1}.w_alpha= w{1};
                    promp_action{2}.w_alpha= w{2};
                    %     %Recognition of the movement
                    [alphaTraj,type, x] = inferenceAlphaV2(promp_action,testAct{1},M,s_bar,c,h,minData, expNoise, intUsed, 'MO');
                else
                    [alphaTraj,type, x] = inferenceAlphaV2(promp_action,testAct{1},M,s_bar,c,h,testAct{1}.nbData, expNoise, intUsed, 'ML');
                end
                [infTraj,typeReco] = inference(promp_action , testAct{1}, M, s_bar, c, h, testAct{1}.nbData, expNoise, alphaTraj, 'speInt',intUsed);

                if(type~=2)
                    errorRecoType(cptERR,i) = errorRecoType(cptERR,i) +1;
                end
                if(typeReco ~=2)
                    errorReco(cptERR,i) = errorReco(cptERR,i) + 1;
                %  drawInference(promp_action,inputName,infTraj, testAct{1},s_bar, 'dataReco', intUsed, 'Interval', [1:3 9:11; 1:3 9:11], 'recoData', intUsed);
                %else
                end
                    minInd = min (testAct{1}.totTime, infTraj.timeInf);
                    infPrior{cptERR,i,cpt+20} = infTraj.PHI*promp_action{type}.mu_w;
                    infPrior{cptERR,i,cpt+20} =infPrior{cptERR,i,cpt+20}([1:minInd , infTraj.timeInf+1: infTraj.timeInf+minInd, infTraj.timeInf*2+1: infTraj.timeInf*2+minInd]) ;

                    infTrajCourb{cptERR,i,cpt+20} = infTraj.PHI*infTraj.mu_w;
                    infTrajCourb{cptERR,i,cpt+20} =infTrajCourb{cptERR,i,cpt+20}([1:minInd , infTraj.timeInf+1: infTraj.timeInf+minInd, infTraj.timeInf*2+1: infTraj.timeInf*2+minInd]); %position only

                    testCourb{cptERR,i,cpt+20} = testAct{1}.y([1:minInd , testAct{1}.totTime+1:testAct{1}.totTime+minInd,testAct{1}.totTime*2+1:testAct{1}.totTime*2+minInd]);

                    alphaError(cptERR, i) = alphaError(cptERR, i) + abs(infTraj.alpha - testAct{1}.alpha);
                    errorTraj{cptERR}(i,cpt+20 ) = mean(abs(infTrajCourb{cptERR,i,cpt+20} - testCourb{cptERR,i,cpt+20}));
                    errorTrajWithoutInf{cptERR}(i,cpt+20) = mean(abs(infPrior{cptERR,i,cpt+20} - testCourb{cptERR,i,cpt+20}));
                    MRMSE{cptERR}(i,cpt+20) = sqrt(errorTraj{cptERR}(i,cpt+20)) / mean(abs(infPrior{cptERR,i,cpt+20}));
                    MRMSE_prior{cptERR}(i,cpt+20 ) = sqrt(errorTrajWithoutInf{cptERR}(i,cpt+20) ) / mean(abs(infPrior{cptERR,i,cpt+20}));
               % end

            end
            errorReco(cptERR,i) = errorReco(cptERR,i);%/ (t{2}.nbTraj + t{1}.nbTraj))*100;
            alphaError(cptERR, i) = alphaError(cptERR, i) /(t{2}.nbTraj + t{1}.nbTraj);
        end
    end
    display(num2str(allT));
    switch(allT)
        case 1
            save('./dataInf_mat/tmp1.mat');
        case 2
            save('./dataInf_mat/tmp2.mat');
        case 3  
            save('./dataInf_mat/tmp3.mat');
        case 4
            save('./dataInf_mat/tmp4.mat');
    end
    clearvars  -except allT inputName s_bar nbInput M c h t typeErr;
end

nbFig = 0;

visu = load('./dataInf_mat/visu@.mat');
position = load('./dataInf_mat/position@.mat');
pose = load('./dataInf_mat/pose@.mat');
multi = load('./dataInf_mat/multi@.mat');

x11 = visu.MRMSE{1}';
x12 =visu.MRMSE{2}';
x21 = position.MRMSE{1}';
x22 = position.MRMSE{2}';
x31 = pose.MRMSE{1}';
x32 = pose.MRMSE{2}';
x41 = multi.MRMSE{1}';
x42 = multi.MRMSE{2}';

y11 = visu.MRMSE{1}' - visu.MRMSE_prior{1}';
y12 = visu.MRMSE{2}' - visu.MRMSE_prior{2}';
y21 = position.MRMSE{1}'- position.MRMSE_prior{1}';
y22 = position.MRMSE{2}' - position.MRMSE_prior{2}';
y31 = pose.MRMSE{1}' - pose.MRMSE_prior{1}';
y32 = pose.MRMSE{2}' - pose.MRMSE_prior{2}';
y41 = multi.MRMSE{1}' - multi.MRMSE_prior{1}';
y42 = multi.MRMSE{2}' - multi.MRMSE_prior{2}';

nbMax = 5
g1 = [1*ones(size(x11)); 2*ones(size(x21)); 3*ones(size(x41))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);


nbFig = nbFig+1; hh(nbFig) = figure;;
x = [y11;y21; y41]; x = x(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
pause(0.5);
ylabel('MRMSE(posterior) \newline - MRMSE(prior)','FontSize',  18);
xlabel('% of known data','FontSize',  18);
title('MRMSE error with ML')

nbFig = nbFig+1; hh(nbFig) = figure;

x = [y12;y22;y42]; x = x(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
pause(0.5)
ylabel('MRMSE(posterior) \newline - MRMSE(prior)','FontSize',  18);
xlabel('% of known data','FontSize',  18);
title('MRMSE error with Model')

%%%%%%%%%%%%%%%%%%%%%
 intplot = [10:10:100];

nbFig = nbFig+1; hh(nbFig) = figure;hold on
plot(intplot, visu.errorReco(1,:), '-r','linewidth',2);
plot(intplot, position.errorReco(1,:), '+-g','linewidth',2);
plot(intplot, multi.errorReco(1,:), '+-b', 'linewidth',2);
xlabel('% of known data','FontSize',  18);
ylabel('nb error [/38]', 'FontSize',  18);
legend('visual','position','multi');
title('number error with ML')

nbFig = nbFig+1; hh(nbFig) = figure;;hold on
plot(intplot, visu.errorReco(2,:), '+-r','linewidth',2);
plot(intplot, position.errorReco(2,:), '+-g','linewidth',2);
plot(intplot, multi.errorReco(2,:), '+-b','linewidth',2);
xlabel('% of known data','FontSize',  18);
ylabel('nb error [/38]', 'FontSize',  18);
legend('visual','position','multi');
title('number error with Model')


nbFig = nbFig+1; hh(nbFig) = figure;;
set(gca, 'fontsize', 18);


x11 = visu.errorTraj{1}';
x12 =visu.errorTraj{2}';
x21 = position.errorTraj{1}';
x22 = position.errorTraj{2}';
x31 = pose.errorTraj{1}';
x32 = pose.errorTraj{2}';
x41 = multi.errorTraj{1}';
x42 = multi.errorTraj{2}';

nbMax = 5
g1 = [1*ones(size(x12)); 2*ones(size(x22)); 3*ones(size(x42))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);
x = [x12;x22;x42]; x = x(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
pause(1);
ylabel('mean(|y_{real} - y_{inf}|)','FontSize',  18);
xlabel('% of known data','FontSize',  18);
title('mean position error with Model')




nbFig = nbFig+1; hh(nbFig) = figure;;
set(gca, 'fontsize', 18);
g1 = [1*ones(size(x11)); 2*ones(size(x21)); 3*ones(size(x41))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);
x = [x11;x21; x41]; x = x(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
pause(1);
ylabel('mean(|y_{real} - y_{inf}|)','FontSize',  18);
xlabel('% of known data','FontSize',  18);
title('mean position error with ML')




nbFig = nbFig+1; hh(nbFig) = figure;;
set(gca, 'fontsize', 18);
hold on;
plot(intplot, visu.alphaError(1,:), '+-r','linewidth',2);
plot(intplot, position.alphaError(1,:), '+-g','linewidth',2);
plot(intplot, multi.alphaError(1,:), '+-b','linewidth',2);

xlabel('% data', 'FontSize', 18);
ylabel('abs($\alpha^{*} - \alpha_{real}$)','Interpreter','LaTex', 'FontSize', 18);
legend('visual','position','multi');
title('\alpha error with ML')



nbFig = nbFig+1; hh(nbFig) = figure;;
set(gca, 'fontsize', 18);
hold on;
plot(intplot, visu.alphaError(2,:), '+-r','linewidth',2);
plot(intplot, position.alphaError(2,:), '+-g','linewidth',2);
plot(intplot, multi.alphaError(2,:), '+-b','linewidth',2);

xlabel('% data', 'FontSize', 18);
ylabel('abs($\alpha^{*} - \alpha_{real}$)','Interpreter','LaTex', 'FontSize', 18);
legend('visual','position','multi');
title('\alpha error with Model')




figure;
set(gca, 'fontsize', 18);
hold on;
plot(intplot, position.alphaError(1,:), '+-r','linewidth',2);
plot(intplot, position.alphaError(2,:), '+-b','linewidth',2);
xlabel('% data', 'FontSize', 18);
ylabel('abs($\alpha^{*} - \alpha_{real}$)','Interpreter','LaTex', 'FontSize', 18);
legend('maximum likelihood','model');

figure;
set(gca, 'fontsize', 18);
hold on;
plot(intplot, position.errorReco(1,:), '+-r','linewidth',2);
plot(intplot, position.errorReco(2,:), '+-g','linewidth',2);
xlabel('% of known data','FontSize',  18);
ylabel('number for 38 trials','FontSize',  18);
title('Error of type recognition','FontSize',  18);
legend('maximum likelihood','model');

figure;
set(gca, 'fontsize', 18);
x1 = position.errorTraj{1}';
x2 = position.errorTraj{2}';
x = [x1;x2]; x = x(:);
g1 = [1*ones(size(x1)); 2*ones(size(x2))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
ylabel('mean(|y_{real} - y_{inf}|)','FontSize',  18);
xlabel('% of known data','FontSize',  18);


figure;
set(gca, 'fontsize', 18);
x1 = (position.NMRSD{1} - position.NMRSD_prior{1})';
x2 = (position.NMRSD{2} - position.NMRSD_prior{2})';
x = [x1;x2]; x = x(:);
g1 = [1*ones(size(x1)); 2*ones(size(x2))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
pause(0.5)
ylabel('NRMSE(posterior) - NRMSE(prior)','FontSize',  18);
xlabel('% of known data','FontSize',  18);








figure;
set(gca, 'fontsize', 18);
hold on;
plot(intplot, visu.alphaError(1,:), '+-r','linewidth',2);
plot(intplot, visu.alphaError(2,:), '+-b','linewidth',2);
xlabel('% data', 'FontSize', 18);
ylabel('abs($\alpha^{*} - \alpha_{real}$)','Interpreter','LaTex', 'FontSize', 18);
legend('maximum likelihood','model');

figure;
set(gca, 'fontsize', 18);
hold on;
plot(intplot, visu.errorReco(1,:), '+-r','linewidth',2);
plot(intplot, visu.errorReco(2,:), '+-g','linewidth',2);
xlabel('% of known data','FontSize',  18);
ylabel('number for 38 trials','FontSize',  18);
title('Error of type recognition','FontSize',  18);
legend('maximum likelihood','model');

figure;
set(gca, 'fontsize', 18);
x1 = visu.errorTraj{1}';
x2 = visu.errorTraj{2}';
x = [x1;x2]; x = x(:);
g1 = [1*ones(size(x1)); 2*ones(size(x2))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
ylabel('mean(|y_{real} - y_{inf}|)','FontSize',  18);
xlabel('% of known data','FontSize',  18);


figure;
set(gca, 'fontsize', 18);
x1 = (visu.NMRSD{1} - visu.NMRSD_prior{1})';
x2 = (visu.NMRSD{2} - visu.NMRSD_prior{2})';
x = [x1;x2]; x = x(:);
g1 = [1*ones(size(x1)); 2*ones(size(x2))]; g1 = g1(:);
g2 = repmat(1:nbMax,length(g1)/nbMax,1); g2 = g2(:);
boxplot(x, {g2,g1}, 'colorgroup',g1, 'boxstyle','filled', 'factorgap',5, 'factorseparator',1)
pause(0.5)
ylabel('NRMSE(posterior) - NRMSE(prior)','FontSize',  18);
xlabel('% of known data','FontSize',  18);


