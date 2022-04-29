 function [trajectory] = loadTrajectoryPersonas4(PATH, nameT,varargin)
%LOADTRAJECTORYPERSONAS recovers trajectories of the folder PATH.
% as loadTrajectoryPersonas3 (per m days). We can descide without days with 0 clicks.
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

%#.....
%This function records an object "trajectory" where the input variable is #nbclicks.

    referenceNumber= -1;
    m=1;
    withoutZero = 0; %false
    maxTraj=-1;
    %Treat varargin possibilities
    for j=1:length(varargin)
        if(strcmp(varargin{j},'refNb')==1)
          referenceNumber = varargin{j+1};
        elseif(strcmp(varargin{j},'m')==1)
            m = varargin{j+1};
        elseif(strcmp(varargin{j},'withoutZero')==1)
            withoutZero=1;
        elseif(strcmp(varargin{j},'maxTraj')==1)
            maxTraj = varargin{j+1};
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
    if(referenceNumber ~=-1)
        trajectory.alpha(1) = referenceNumber / trajectory.totTime(1);
    else 
    	trajectory.alpha(1) =1;
    end
    idxStu = 1;
    stu = data_tot.id_student(1);
    trajectory.id_stu(idxStu) = stu;
    trajectory.nbInput = 1;%sum of clicks per stuents
    if(maxTraj==-1)
    trajectory.nbTraj = size(unique(data_tot.id_student),1); %unique student id number
    else
        trajectory.nbTraj = min(maxTraj, size(unique(data_tot.id_student),1));
    end
    for i=1:size(data_tot,1)
        if(data_tot.id_student(i) ~= stu) % if we pass to another student
            idxStu = idxStu+1;
            trajectory.id_stu(idxStu) = data_tot.id_student(i);
            if(idxStu > trajectory.nbTraj) 
                break;
            end
            stu = data_tot.id_student(i);
            trajectory.y{idxStu} =zeros(nbCeilDay,1);
            trajectory.yMat{idxStu} =zeros(nbCeilDay,1);
            trajectory.totTime(idxStu) = nbCeilDay;
            if(referenceNumber ~=-1)
               	trajectory.alpha(idxStu) = referenceNumber / trajectory.totTime(idxStu);
            else 
                trajectory.alpha(idxStu) =1;
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
    
    if(withoutZero==1)
        %%%% deleting days with 0 clicks
        % for all students
        for stu=1:size(trajectory.y,2)
            dateWithout0 = find(trajectory.y{stu});
            trajectory.totTime(stu) = size(dateWithout0,1);
            trajectory.y{stu} = nonzeros(trajectory.y{stu});
            trajectory.realTime{stu} = zeros(size(dateWithout0,1),1);
            for i = 1: size(dateWithout0,1)
                trajectory.realTime{stu}(i) = val(1,dateWithout0(i));
            end
        end    
    else
        % for all students
        for stu=1:size(trajectory.y,2)
            trajectory.totTime(stu) = size(trajectory.y{stu},1);
            trajectory.realTime{stu} = val;
        end  
    end
end
