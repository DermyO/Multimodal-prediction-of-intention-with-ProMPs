function [tt] = loadTrajectoryPersonas5(PATH, trajectory,nbInput, varargin)
%LOADTRAJECTORYPERSONAS completes trajectories with data contained in the folder PATH.
%
%INPUTS:
% PATH: path for the trajectory where the "recordX.txt" files are

%OUTPUT:
% trajectory: give an object trajectory
% FILE STRUCTURE
% The file .csv has to be structured as following:
% id_student,clicks_forum,clicks_oucontent,clicks_homepage,clicks_subpage,total_clicks,score_1,score_2,score_3,score_4,score_5,score_6,score_7,score_8,score_9,score_10,score_11,score_12,score_13,
% score_14,delay_1,delay_2,delay_3,delay_4,delay_5,delay_6,delay_7,delay_8,delay_9,delay_10,delay_11,delay_12,delay_13,delay_14,active_days_forum,active_days_oucontent,active_days_homepage,
% active_days_subpage,total_active_days,mean_clicks_forum.day,mean_clicks_oucontent.day,mean_clicks_homepage.day,mean_clicks_subpage.day,mean_clicks_day,nb_resources,nb_types

% This function add to the object "trajectory", the input variable (score ; delay) using the student id.
name = 'DDD_2013B';
type = 1;
if (~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'type')==1)
            type=0;
        elseif(strcmp(varargin{i},'name')==1)
            name = varargin{i+1};
        end
    end
end

%Retrieve all data in data{j} cells for each trajectory, and put 
%trajectory.realTime{j} cells value, if it readed.
data_tot{1} = importdata(PATH);% load(PATH);
data = data_tot{1}.data;

id_stus = data_tot{1}.data(:,1);

if(strcmp(name,'DDD_2013B'))
    %date of the 14 Exams
    dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
    scores = data_tot{1}.data(:,7:20);
    delays = data_tot{1}.data(:,21:34);
elseif(strcmp(name,'DDD_2014B'))
    dateExam = [25,53,74,116,158,200,240];
    scores = data_tot{1}.data(:,7:13);
    delays = data_tot{1}.data(:,14:20);
else %%%BBB_2013B
    dateExam = [19,47,54,89,124,159,187,240];
    scores = data_tot{1}.data(:,7:17);
    delays = data_tot{1}.data(:,18:28);
end

%changing trajectory input
tt.nbInput = nbInput;
tt.label = trajectory.label;

cpt = 0;
%for each trajectory, add dimension score and delay
for i=1:size(id_stus,1)
    id_stu = id_stus(i);
    
    %%find the corresponding trajectory
    idT = find(trajectory.id_stu == id_stu);
    if(isempty(idT)) 
        continue;
    end
    cpt = cpt+1;
    %Then, create score and delay dimension of the trajectory to have the
    %same time axis.
    %init : before the first exam, same value.
    j = 1; %index exam
    t = 1 ; %index realTime
    scoreTmp = zeros(trajectory.totTime(idT),1);
    delayTmp = zeros(trajectory.totTime(idT),1);
    while (trajectory.realTime{idT}(t) <= dateExam(j))
        scoreTmp(t) = scores(i,j);
        delayTmp(t) = delays(i,j);
        t = t+1;
    end
    
    
    if(type==1)
        %general case: init line values
        %score line
        as = (dateExam(j+1) - dateExam(j)) / (scores(i, j+1) - scores(i,j));
        bs = dateExam(j) - as*scores(i,j);
        %delay line
        ad = (dateExam(j+1) - dateExam(j)) / (delays(i, j+1) - delays(i,j));
        bd = dateExam(j) - ad*delays(i,j);
        while ((t <= trajectory.totTime(idT)) && (trajectory.realTime{idT}(t) < dateExam(size(dateExam,2))))
            %if require to update line
            if(trajectory.realTime{idT}(t) > dateExam(j+1))
                %searching the current line
                while(trajectory.realTime{idT}(t) > dateExam(j+1))
                    j = j+1;
                end
                %udate line values
                %score line
                as = (dateExam(j+1) - dateExam(j)) / (scores(i, j+1) - scores(i,j));
                bs = dateExam(j) - as*scores(i,j);
                %delay line
                ad = (dateExam(j+1) - dateExam(j)) / (delays(i, j+1) - delays(i,j));
                bd = dateExam(j) - ad*delays(i,j);
            end
            if(as ~=0 && as ~=Inf)
                scoreTmp(t) = (trajectory.realTime{idT}(t) - bs)/as;
            else
                scoreTmp(t) = scores(i, j);
            end
            if(ad ~=0 && ad ~= Inf)
                delayTmp(t) = (trajectory.realTime{idT}(t) - bd)/ad ;
                if(isnan(delayTmp(t)))
                    print('isnan');
                end
            else
                delayTmp(t) = delays(i,j);
            end
            t = t+1;
        end
    else
        %general case
        while ((t <= trajectory.totTime(idT)) && (trajectory.realTime{idT}(t) < dateExam(size(dateExam,2))))
            %if require to update line
            if(trajectory.realTime{idT}(t) > dateExam(j+1))
                %searching the current line
                while(trajectory.realTime{idT}(t) > dateExam(j+1))
                    j = j+1;
                end
            end           
            scoreTmp(t) = scores(i, j);
            delayTmp(t) = delays(i,j);
            t = t+1;
        end
    end 
    
    %when the last exam has been spend, all the resting line equals to last
    %values
    while(t <= trajectory.totTime(idT))
        scoreTmp(t) = scores(i,size(scores,2));
        delayTmp(t) = delays(i,size(delays,2));
        t = t+1;
    end
   
    %%%Then, add these two dimension into the trajectory. 
    tt.y{cpt} = [trajectory.y{idT}; scoreTmp; delayTmp];
    tt.yMat{cpt} = [trajectory.yMat{idT}, scoreTmp, delayTmp];
    tt.id_stu(cpt) = id_stu;
    tt.realTime{cpt} = trajectory.realTime{idT};
    tt.totTime(cpt) = trajectory.totTime(idT);
    tt.alpha(cpt) = trajectory.alpha(idT);
end
tt.nbTraj = size(tt.totTime,2);
end
