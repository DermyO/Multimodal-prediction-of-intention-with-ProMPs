function [trajectory] = loadTrajectoryPersonas(PATH, nameT,varargin)
%LOADTRAJECTORYPERSONAS recovers trajectories of the folder PATH.
%
%INPUTS:
% PATH: path for the trajectory where the "recordX.txt" files are
% nameT: label of the type of trajectory
% varargin: parameters that you can add
% ['refNum', x]: precise the reference number of iteration 'x'.
%OUTPUT:
% trajectory: give an object trajectory
% FILE STRUCTURE
%The file .csv has to be structured as following:

%#score1 #score2 .... #score14 #delay1 #delay2 ... #delay14
%This function records an object "trajectory" where the input variable are (score ; delay).
nbInput(1) = 1;
nbInput(2) = 1;
referenceNumber= -1;
noDelay = 0;
%Treat varargin possibilities
for j=1:2:length(varargin)
    if(strcmp(varargin{j},'refNb')==1)
        referenceNumber = varargin{j+1};
    elseif(strcmp(varargin{j},'nbInput')==1)
        nbInput = varargin{j+1};
    elseif(strcmp(varargin{j},'withoutDelay')==1)
        noDelay = 1;
    end
end

%Retrieve all data in data{j} cells for each trajectory, and put trajectory.realTime{j} cells value, if it readed.
data_tot{1} = importdata(PATH);% load(PATH);
data = data_tot{1}.data;

trajectory.inputName = data_tot{1}.textdata;
trajectory.nbTraj = size(data,1); %total number of trajectory
trajectory.nbInput = nbInput; %scores, delays
trajectory.label = nameT; %label of the trajectory.
scores = [data_tot{1}.data(:,1),data_tot{1}.data(:,1:14),data_tot{1}.data(:,14) ]; %TODO data_tot{1}.data(:,1:14)
delays = [data_tot{1}.data(:,15),data_tot{1}.data(:,15:28),data_tot{1}.data(:,28)]; %TODO data_tot{1}.data(:,15:28)

if(noDelay==0)
    for i=1:trajectory.nbTraj %for each trajectory, fill other variables
        trajectory.y{i} =  [scores(i,:)';delays(i,:)'];
        trajectory.totTime(i) =  size(trajectory.y{i},1)/2;%16; %TODO 14;
        trajectory.yMat{i} = [scores(i,:)',delays(i,:)'];%matrice that contains trajectory input (x= number of sample, y= number of input)
        if(referenceNumber ~= -1)%compute the modulation time of the trajectory
            trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
        end
    end
else
    for i=1:trajectory.nbTraj %for each trajectory, fill other variables
        trajectory.y{i} =  [scores(i,:)'];
        trajectory.totTime(i) =  size(scores(i,:),2);
        trajectory.yMat{i} = [scores(i,:)'];%matrice that contains trajectory input (x= number of sample, y= number of input)
        if(referenceNumber ~= -1)%compute the modulation time of the trajectory
            trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
        end
    end
end
end
