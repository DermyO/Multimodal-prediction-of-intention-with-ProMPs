 function [trajectory] = loadTrajectoryPersonas2(PATH, nameT,varargin)
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

    referenceNumber= -1;
    without0 = 0;
    %Treat varargin possibilities
    for j=1:2:length(varargin)
        if(strcmp(varargin{j},'refNb')==1)
                referenceNumber = varargin{j+1};   
        elseif(strcmp(varargin{j},'without0')==1)
            without0=1;
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
    trajectory.totTime(1) = nbMaxDay;
    trajectory.y{1} = zeros(nbMaxDay,1);
    trajectory.yMat{1} = zeros(nbMaxDay,1);
    idxStu = 1;
    stu = data_tot.id_student(1);
    trajectory.nbInput = 1;%sum of clicks per stuents
    trajectory.nbTraj = size(unique(data_tot.id_student),1); %unique student id number
    for i=1:size(data_tot,1)
        if(data_tot.id_student(i) ~= stu) % if we pass to another student
            idxStu = idxStu+1;
            stu = data_tot.id_student(i);
            trajectory.y{idxStu} =zeros(nbMaxDay,1);
            trajectory.yMat{idxStu} =zeros(nbMaxDay,1);
            trajectory.totTime(idxStu) = nbMaxDay;
            if(referenceNumber ~=-1)
               	trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
            else 
                trajectory.alpha(i) =1;
            end
        end
        if(minv <0)
            trajectory.y{idxStu}(data_tot.date(i) - minv+1) = trajectory.y{idxStu}(data_tot.date(i) -minv+1 ) + data_tot.sum_click(i);
            trajectory.yMat{idxStu}(data_tot.date(i) - minv+1) = trajectory.yMat{idxStu}(data_tot.date(i)- minv+1) + data_tot.sum_click(i);
        else
            trajectory.y{idxStu}(data_tot.date(i)+1) = trajectory.y{idxStu}(data_tot.date(i) +1 ) + data_tot.sum_click(i);
            trajectory.yMat{idxStu}(data_tot.date(i)+1) = trajectory.yMat{idxStu}(data_tot.date(i) +1) + data_tot.sum_click(i);
        end
    end
    trajectory.label = nameT; %label of the trajectory.
    trajectory.nbInput = 1; %nbClick global   
    val = [];
    if(minv <0)
    	for i =1:nbMaxDay
            val = [val, i + minv];
        end
    else
        for i =1:nbMaxDay
            val = [val, i];
        end
    end
    %trajectory.day = val;

    %%%% deleting days with 0 clicks
    if(without0 == 1)
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
         trajectory.totTime(stu) = size(trajectory.y{stu},2);
         trajectory.realTime{stu} = val;
    end
end
