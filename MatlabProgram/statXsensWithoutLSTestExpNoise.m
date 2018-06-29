%This demo computes N proMPs given a set of recorded trajectories containing the demonstrations for the N types of movements. 
%It plots the results.

% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.
addpath('used_functions/xSens');
%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
typeTraj = {'bent','bent_strongly', 'kicking','lifting_box','standing','walking','window_open'};
colorTraj = {'b','r', 'g','m','c','k','brown'};
s_bar=70;
cpt_nbInput = 0;
nbInput=69 %Number of input used during the inference
cpt_nbInput = cpt_nbInput + 1
for i=1:nbInput
    inputName{i} = strcat('Dim',num2str(i));
end

M(1) = 10; %number of basis functions for the first type of input

%variable tuned to achieve the trajectory correctly

%%%%%%%%%%%%%% END VARIABLE CHOICE
%some variable computation to create basis function, you might have to
%change them
dimRBF = 0;
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end

nameTest = strcat('Data/Xsens/observations/');
list = {'bent_fw', 'bent_fw_strongly', 'kicking','lifting_box','standing','walking','window_open'};
t{1} = loadTrajectory([nameTest,list{1}], 'bent_fw', 'refNb', s_bar, 'nbInput',nbInput);
t{2} = loadTrajectory([nameTest,list{2}], 'bent_fw_strongly', 'refNb', s_bar, 'nbInput',nbInput);
t{3} = loadTrajectory([nameTest,list{3}], 'kicking', 'refNb', s_bar, 'nbInput',nbInput);
t{4} = loadTrajectory([nameTest,list{4}], 'lifting_box', 'refNb', s_bar, 'nbInput',nbInput);
t{5} = loadTrajectory([nameTest,list{5}], 'standing', 'refNb', s_bar, 'nbInput',nbInput);
t{6} = loadTrajectory([nameTest,list{6}], 'walking', 'refNb', s_bar, 'nbInput',nbInput);
t{7} = loadTrajectory([nameTest,list{7}], 'window_open', 'refNb', s_bar, 'nbInput',nbInput);

for expNoise = [0.1,0.01,0.001,0.0001,0.00001]
        expNoise
        error = zeros(5,70);
        vall= 0;
        for nbPercent =[20:20:100]
            nbDist=1;
            vall= vall+1;
            percentData = nbPercent; %number of data max with what you try to find the correct movement
            for mov = 1:7
                for trial = 1:10
                    for k=1:7
                        if(k==mov)
                            [train{k},test] = partitionTrajectory(t{k},1,percentData,s_bar,trial);
                            promp{k} = computeDistribution(train{k}, M, s_bar,c,h);
                        else
                            promp{k} = computeDistribution(t{k}, M, s_bar,c,h);
                        end
                    end

                    test{1}.type = trial;
                    w = computeAlpha(test{1}.nbData,t, nbInput);
                    promp{1}.w_alpha= w{1};
                    promp{2}.w_alpha= w{2};
                    promp{3}.w_alpha= w{3};
                    promp{4}.w_alpha= w{4};
                    promp{5}.w_alpha= w{5};
                    promp{6}.w_alpha= w{6};
                    promp{7}.w_alpha= w{7};

                    %Recognition of the movement
                    [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'ML');
                    infTraj = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, nbInput);

                    if(type ~= mov)
                        error(vall, (mov-1)*10 + trial) = 1;
                    else
                        posterior = infTraj.PHI*infTraj.mu_w;
                        meanTraj =promp{mov}.PHI_mean*promp{mov}.mu_w;
                        distanceLS(vall, nbDist) = mean(abs(posterior - meanTraj));
                        nbDist = nbDist+1;
                    end

                    clear promp train infTraj posterior alphaTraj type x w test
                end
            end
            meanDistLS(vall) = mean(distanceLS(vall,:));
            covDistLS(vall) = cov(distanceLS(vall,:));
            RMSD(vall) = sqrt(meanDistLS(vall));
            NRMSD(vall) = RMSD(vall) / mean(abs(meanTraj));
        end
    nameSave = ['statXsensWithoutLS2_',num2str(expNoise),'.mat']
    save(nameSave)
end