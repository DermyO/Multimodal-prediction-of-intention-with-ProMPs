 function [trajectory] = loadTrajectoryPersonas3(PATH, nameT,varargin)
%LOADTRAJECTORYPERSONAS recovers trajectories of the folder PATH.
% as loadTrajectoryPersonas2 but per m days
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

    referenceNumber= -1;
    m=1;
    %Treat varargin possibilities
    for j=1:2:length(varargin)
        if(strcmp(varargin{j},'refNb')==1)
          referenceNumber = varargin{j+1};
        elseif(strcmp(varargin{j},'m')==1)
            m = varargin{j+1};
        end
    end
 
    data_tot = readtable(PATH);
    minv = min(data_tot.date);
    maxv = max(data_tot.date) ;
    if(minv <0)
        nbMaxDay = maxv - minv +1;
    else 
        nbMaxDay = maxv +1;
    end
    nbCeilDay = ceil(nbMaxDay/m);
    
    trajectory.totTime(1) = nbCeilDay;
    trajectory.y{1} = zeros(nbCeilDay,1);
    trajectory.yMat{1} = zeros(nbCeilDay,1);
    idxStu = 1;
    stu = data_tot.id_student(1);
    trajectory.nbInput = 1;%sum of clicks per stuents
    trajectory.nbTraj = size(unique(data_tot.id_student),1); %unique student id number
    for i=1:size(data_tot,1)
        if(data_tot.id_student(i) ~= stu) % if we pass to another student
            idxStu = idxStu+1;
            trajectory.y{idxStu} =zeros(nbCeilDay,1);
            trajectory.yMat{idxStu} =zeros(nbCeilDay,1);
            trajectory.totTime(idxStu) = nbCeilDay;
            if(referenceNumber ~=-1)
               	trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
            else 
                trajectory.alpha(i) =1;
            end
        end
        if(minv <0)
            trajectory.y{idxStu}(ceil((data_tot.date(i) - minv+1)/m)) = trajectory.y{idxStu}(ceil((data_tot.date(i) - minv+1)/m)) + data_tot.sum_click(i);
            trajectory.yMat{idxStu}(ceil((data_tot.date(i) - minv+1)/m)) = trajectory.yMat{idxStu}(ceil((data_tot.date(i) - minv+1)/m)) + data_tot.sum_click(i);
        else
            trajectory.y{idxStu}(ceil((data_tot.date(i)+1)/m)) = trajectory.y{idxStu}(ceil((data_tot.date(i)+1)/m)) + data_tot.sum_click(i);
            trajectory.yMat{idxStu}(ceil((data_tot.date(i)+1)/m)) = trajectory.yMat{idxStu}(ceil((data_tot.date(i)+1)/m)) + data_tot.sum_click(i);
        end
    end
    trajectory.label = nameT; %label of the trajectory.
    trajectory.nbInput = 1; %nbClick global   
    val = [];
    if(minv <0)
    	for i =1:m:nbMaxDay
            val = [val, i + minv];
        end
    else
        for i =1:m:nbMaxDay
            val = [val, i];
        end
    end
    trajectory.day = val;
end
