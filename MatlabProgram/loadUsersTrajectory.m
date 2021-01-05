 function [trajectory] = loadUsersTrajectory(PATH, nameT,varargin)
%LOADUSERSTRAJECTORY recovers trajectories of the folder PATH.
%
%INPUTS:
% PATH: path for the trajectory where the "visitorID.txt" files are 
% nameT: label of the type of trajectory
% varargin: parameters that you can add
% ['refNum', x]: precise the reference number of iteration 'x'.
% ['nbInput', x]: precise the number of inputs: 
%                 if x=[a,b] then only the first 'a' inputs will be used to
%                 recognize the trajectory during inference
% ['Specific', x]: precise information about the data structure.
% If x='Time': the first data column corresponds to the time
%OUTPUT:
% trajectory: give an object trajectory 
% FILE STRUCTURE
%The file .txt has to be structured as following:

referenceNumber= -1;
nbInput=-1;
%Treat varargin possibilities
for j=1:2:length(varargin)
    if(strcmp(varargin{j},'refNb')==1)
            referenceNumber = varargin{j+1};
    end
end

%Retrieve all data in data{j} cells for each trajectory, and put
%"trajectory.realTime{j} cells value, if it readed.
listtmp = dir(PATH);

j=1;    
for k=1:size(listtmp,1)
   
    if(strcmp(listtmp(k).name,'.')==1 ||strcmp(listtmp(k).name,'..')==1)
        continue;
    end
   
    nameF = strcat("./",PATH,"/",listtmp(k).name);
    
    data_tot{j} = importdata(nameF);
      
    %retrieve only some columns
 %   data{j} = [data_tot{j}.data(:,3:4),data_tot{j}.data(:,6),data_tot{j}.data(:,8),data_tot{j}.data(:,16:17)];
    data{j} = data_tot{j}.data(:,2:size(data_tot{j}.data,2));
    trajectory.realTime{j} = data_tot{j}.textdata(1:13,1); %Time information   
    j=j+1;
end
%trajectory.inputName = [data_tot{1}.textdata(1,4:5),data_tot{1}.textdata(1,7),data_tot{1}.textdata(1,9),data_tot{1}.textdata(1,17:18)];%  colheaders;
trajectory.inputName = data_tot{1}.textdata(1,2:size(data_tot{1}.data,2));

if(nbInput ==-1) %if the number of input parameters is not given in input, it computes it
    trajectory.nbInput = size(data{1},2);
else
    trajectory.nbInput = nbInput;
end
trajectory.nbTraj = size(data,2);
for(i=1:size(data,2)) %forall trajectory
        trajectory.y{i} = [];
        %to avoid problem after
        trajectory.totTime(i) =size(data{i},1) ; %total number of samples
        trajectory.yMat{i} =  data{i}; %matrice that contains trajectory input (x= number of sample, y= number of input)
        for j = 1: trajectory.nbInput
           trajectory.y{i}=  [ trajectory.y{i} ; data{i}(:,j) ]; %vector that contains trajectory inputs
        end
        trajectory.label = nameT; %label of the trajectory.

end

if(referenceNumber ~= -1)%compute the modulation time of the trajectory
    for i=1:trajectory.nbTraj
        trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
    end 
end