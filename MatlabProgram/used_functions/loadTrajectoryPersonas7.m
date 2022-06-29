function [trajectories] = loadTrajectoryPersonas7(PATH, l_id, varargin)
%LOADTRAJECTORYPERSONAS6 recovers trajectories of the folder PATH.
%here with real data
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
maxTraj=100000000000000000;

%Treat varargin possibilities
for j=1:length(varargin)
    if(strcmp(varargin{j},'refNb')==1)
        referenceNumber = varargin{j+1};
    elseif(strcmp(varargin{j},'maxTraj')==1)
        maxTraj = varargin{j+1};
   
    end
end

data_tot = readtable(PATH);

trajectories = cell(4,1);

idxStu = [0,0,0,0];
stu = zeros(4,1);



%init all students trajectories for each class
for class=1:4
    trajectories{class}.nbInput = 1; %nbClick global
    if(size(l_id{class},1) > maxTraj)
        vall = maxTraj;
    else
        vall = size(l_id{class},1);
    end
    trajectories{class}.nbTraj = vall;
    for idx = 1 : vall
        trajectories{class}.totTime(idx) = 40;
        trajectories{class}.realTime{idx} = linspace(-18,261,40);
        trajectories{class}.y{idx} = zeros(40,1);
        trajectories{class}.yMat{idx} = zeros(40,1);
        if(referenceNumber ~=-1)
            trajectories{class}.alpha(idx) = referenceNumber / trajectories{class}.totTime(idx);
        else
            trajectories{class}.alpha(idx) =1;
        end
        trajectories{class}.id_stu(idx) = l_id{class}(idx);
    end
end



for i=1:size(data_tot,1)
    %research the class of the student.
    class=1;
    while(class <4 && isempty(find(l_id{class}==data_tot.id_student(i))))
        class = class+1;
    end
    if(isempty(find(l_id{class}==data_tot.id_student(i))))
        continue;
    end
    idx = find(l_id{class}==data_tot.id_student(i));
    idTable = floor((data_tot(i,:).date +18)/7)+1;
    if(idTable > 40 )
        idTable =40;
    elseif(idTable <=0)
        idTable = 1;
    end
    trajectories{class}.y{idx}(idTable) =  trajectories{class}.y{idx}(idTable) + data_tot(i,:).sum_click; %data_tot(i,3:size(data_tot,2)).Variables';
    trajectories{class}.yMat{idx} =trajectories{class}.y{idx};

        
end

trajectories{1}.label = "Distinction"; %label of the trajectories{class}.
trajectories{2}.label = "Pass";
trajectories{3}.label = "Withdrawn";
trajectories{4}.label = "Fail";


end
