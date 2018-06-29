%Statistics about xsens latent space recognition

% by Oriane Dermy 20/04/2018
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

typeTraj = {'bent','bent_strongly', 'kicking','lifting_box','standing','walking','window_open'};
colorTraj = {'b','r', 'g','m','c','k','brown'};
s_bar=70;
nbInput = 2; %number of input used during the inference

for i=1:nbInput
    inputName{i} = strcat('Dim',num2str(i));
end

M(1) = 10; %number of basis functions for the first type of input

%variable tuned to achieve the trajectory correctly
expNoise = 0.00001;

dimRBF = 0; 
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end

%connection = initializeConnection;
%nameTest =strcat('Data/Xsens/l',num2str(nbInput)) ;
nameTest = 'Data/Xsens/position'
list = {'bent_fw', 'bent_strongly', 'kicking','lifting_box','standing','walking','window_open'};
t{1} = loadTrajectory([nameTest,'_0'], 'bent_fw', 'refNb', s_bar, 'nbInput',nbInput);
t{2} = loadTrajectory([nameTest,'_1'], 'bent_strongly', 'refNb', s_bar, 'nbInput',nbInput);
t{3} = loadTrajectory([nameTest,'_2'], 'kicking', 'refNb', s_bar, 'nbInput',nbInput);
t{4} = loadTrajectory([nameTest,'_3'], 'lifting_box', 'refNb', s_bar, 'nbInput',nbInput);
t{5} = loadTrajectory([nameTest,'_4'], 'standing', 'refNb', s_bar, 'nbInput',nbInput);
t{6} = loadTrajectory([nameTest,'_5'], 'walking', 'refNb', s_bar, 'nbInput',nbInput);
t{7} = loadTrajectory([nameTest,'_6'], 'window_open', 'refNb', s_bar, 'nbInput',nbInput);

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
     %       sendLatentSpace(infTraj, connection)

            clear promp train infTraj posterior alphaTraj type x w test
        end
    end
    meanDistLS(vall) = mean(distanceLS(vall,:));
    covDistLS(vall) = cov(distanceLS(vall,:));
    RMSD(vall) = sqrt(meanDistLS(vall));
    NRMSD(vall) = RMSD(vall) / mean(abs(meanTraj));
    
end

% figure;
% title('Error of movement type recognition');
% plot([20:20:100],(sum(val{1}.error')/70)*100,'--+b','linewidth',2);hold on;
% plot([20:20:100],(sum(val{2}.error')/70)*100,'--+r','linewidth',2);
% plot([20:20:100],(sum(val{3}.error')/70)*100,'--+g','linewidth',2);
% plot([20:20:100],(sum(val{4}.error')/70)*100,'--+k','linewidth',2);
% plot([20:20:100],(sum(val{5}.error')/70)*100,'--+m','linewidth',2);
% ylim([0 100]);
% xlabel('Observed data [%]');
% ylabel('Error recognition [%]');
% 
% figure;
% shadedErrorBar([20:20:100],meanDistLS, covDistLS,  {'-r','markerfacecolor',[1,0.2,0.2]});
% xlabel('Observed data [%]');
% ylabel('Average distance between the infered trajectory and the real one [.]');


%sendErrorList(errors, connection)
%closeConnection(connection);
