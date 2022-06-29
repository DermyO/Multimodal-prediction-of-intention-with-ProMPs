function [trajectories] = loadTrajectoryPersonas6(PATH, l_id, varargin)
%LOADTRAJECTORYPERSONAS6 recovers trajectories of the folder PATH.
% as loadTrajectoryPersonas (per m days). We can decide without days with 0 clicks.
%
%INPUTS:
% PATH for the file that contains all click number per student per exam.
% l_id list of student id per class
% varargin: parameters that you can add
% ['refNum', x]: precise the reference number of iteration 'x'.
%OUTPUT:
% trajectory: give an object trajectory
% FILE STRUCTURE
%The file .csv has to be structured as following:

%#.....
%This function records an object "trajectory" where the input variable is #nbclicks.

referenceNumber= -1;
maxTraj=-1;
s_bar = 14;
%Treat varargin possibilities
for j=1:length(varargin)
    if(strcmp(varargin{j},'refNb')==1)
        referenceNumber = varargin{j+1};
    elseif(strcmp(varargin{j},'maxTraj')==1)
        maxTraj = varargin{j+1};
    elseif(strcmp(varargin{j},'s_bar')==1)
        s_bar = varargin{j+1};
    end
end

data_tot = readtable(PATH);

trajectories = cell(4,1);

idxStu = [0,0,0,0];
stu = zeros(4,1);
%for each student (raw)
for i=1:size(data_tot,1)
    %research the class of the student.
    class=1;
    while(class <4 && isempty(find(l_id{class}==data_tot.id_student(i))))
        class = class+1;
    end
    if(isempty(find(l_id{class}==data_tot.id_student(i))))
        continue;
    end
    %init for each class
    if(idxStu(class)==0)
        trajectories{class}.nbInput = 1; %nbClick global
        idxStu(class) = 1;
        trajectories{class}.totTime(1) = s_bar;
        trajectories{class}.y{1} = zeros(s_bar,1);
        trajectories{class}.yMat{1} = zeros(s_bar,1);
        if(referenceNumber ~=-1)
            trajectories{class}.alpha(1) = referenceNumber / trajectories{class}.totTime(1);
        else
            trajectories{class}.alpha(1) =1;
        end
        stu(class) = data_tot.id_student(i);
        trajectories{class}.id_stu(idxStu(class)) = stu(class);
        trajectories{class}.nbInput = 1;%sum of clicks per stuents
    end
    
    if(data_tot.id_student(i) ~= stu(class)) % if we pass to another student
        idxStu(class) = idxStu(class)+1;
        trajectories{class}.id_stu(idxStu(class)) = data_tot.id_student(i);
        if(maxTraj>0 && idxStu(class) > maxTraj)
            break;
        end
        stu(class) = data_tot.id_student(i);
        trajectories{class}.y{idxStu(class)} =zeros(s_bar,1);
        trajectories{class}.yMat{idxStu(class)} =zeros(s_bar,1);
        trajectories{class}.totTime(idxStu(class)) = s_bar;
        if(referenceNumber ~=-1)
            trajectories{class}.alpha(idxStu(class)) = referenceNumber / trajectories{class}.totTime(idxStu(class));
        else
            trajectories{class}.alpha(idxStu(class)) =1;
        end
    end
        
    trajectories{class}.y{idxStu(class)} =  data_tot(i,3:size(data_tot,2)).Variables';
    
    for timeTmp=s_bar:-1:2
         trajectories{class}.y{idxStu(class)}(timeTmp) = trajectories{class}.y{idxStu(class)}(timeTmp) - trajectories{class}.y{idxStu(class)}(timeTmp-1) ;
    end
    trajectories{class}.yMat{idxStu(class)}=  trajectories{class}.y{idxStu(class)};%data_tot(i,3:size(data_tot,2)).Variables';
    
    
        
end

trajectories{1}.label = "Distinction"; %label of the trajectories{class}.
trajectories{2}.label = "Pass";
trajectories{3}.label = "Withdrawn";
trajectories{4}.label = "Fail";


%date of the 14 Exams
dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];

for class=1:4
    if(maxTraj==-1)
        trajectories{class}.nbTraj = size(trajectories{class}.y,2);
    else
        trajectories{class}.nbTraj = min(maxTraj, size(trajectories{class}.y,2));
    end
    % for all students
    for stu=1:size(trajectories{class}.y,2)
        trajectories{class}.totTime(stu) = size(trajectories{class}.y{stu},1);
        trajectories{class}.realTime{stu} = dateExam;
    end
end


end
