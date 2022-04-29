 function [trajectory] = loadTrajectory(PATH, nameT,varargin)
%LOADTRAJECTORY recovers trajectories of the folder PATH.
%
%INPUTS:
% PATH: path for the trajectory where the "recordX.txt" files are 
% nameT: label of the type of trajectory
% varargin: parameters that you can add
% ['refNum', x]: precise the reference number of iteration 'x'.
% ['nbInput', x]: precise the number of inputs: 
%                 if x=[a,b] then only the first 'a' inputs will be used to
%                 recognize the trajectory during inference
% ['Specific', x]: precise information about the data structure.
% If x='FromGeom': retrieve the data structure of the C++ program that
% records geomagic data.
% If x='Time': the first data column corresponds to the time
%OUTPUT:
% trajectory: give an object trajectory 
% FILE STRUCTURE
%The file .txt has to be structured as following:
%#TIME #geomagicPositionX #geomagicPositionY #geomagicPositionZ #fx #fy #fz #wx #wy #wz #icubX #icubY #icubZ.
%This function records an object "trajectory" where the input variable are (iCubX; iCubY; iCubZ; fx; fy; fz; wx; wy; wz).

    max = 1000000;
    specific=0;
    columnTime=0;
    referenceNumber= -1;
    nbInput=-1;
    %Treat varargin possibilities
    for j=1:2:length(varargin)
        if(strcmp(varargin{j},'refNb')==1)
                referenceNumber = varargin{j+1};
                %display(['Specification: reference number=', num2str(referenceNumber)]);
        elseif(strcmp(varargin{j},'nbInput')==1)
            nbInput= varargin{j+1};
        elseif(strcmp(varargin{j}, 'max') == 1)
            max = str2num(varargin{j+1});
        elseif(strcmp(varargin{j},'Specific')==1)
            if(strcmp(varargin{j+1},'Time')==1)
                columnTime=1;
            elseif(strcmp(varargin{j+1}, 'FromGeom')==1) %from the geomagic program that records: "Time Xgeom Ygeom Zgeom Fx Fy Fz Mx My Mz Xicub Yicub zicub"
               % display('specification: data from geomagic');
                specific=1;
            elseif(strcmp(varargin{j+1},'Covid')==1)
                specific=2;
            elseif(strcmp(varargin{j+1}, 'CovidW')==1)
                specific=3;
            elseif(strcmp(varargin{j+1}, 'CovidM')==1)
                specific=5;
            elseif(strcmp(varargin{j+1},'covid2') == 1)
                specific = 4;
            end
        end
    end
    
    
    %Retrieve all data in data{j} cells for each trajectory, and put
    %"trajectory.realTime{j} cells value, if it readed.
    cont=1; %verify if exists other trajectories
    j=1;
    listtmp = dir(PATH);
    listtmp2 = find(vertcat(listtmp.isdir));
    list = listtmp(listtmp2);
    if (length(list)>3) %treats record files that are in subfolder of PATH
        for parc=3:length(list)
            cont=1;
            k=1;
            PATH2 = [PATH, '/', list(parc).name];
            if (~exist([PATH2,'/record',num2str(k-1),'.txt']))
                display('error no files with this name');
                display([PATH,'/record',num2str(j-1),'.txt']);
                cont=0;
            end
            while cont==1
                data_tot{j} = load([PATH2,'/record',num2str(k-1),'.txt']);
				if(specific==1)%if it correspond to "Time Xgeom Ygeom Zgeom Fx Fy Fz Mx My Mz Xicub Yicub zicub"
		            data{j} = zeros( size(data_tot{j},1),9); % tall: nbIteration:9 (9 for position, forces and moment) 
		            data{j}(:,1:9) = [data_tot{j}(:,11:13),data_tot{j}(:,5:10)]; %11:13: real position of the robot; 5:10 forces and wrench
		            trajectory.realTime{j} = data_tot{j}(:,1); %Time information
		        elseif(columnTime==1) %if the first column corresponds to time information
		                data{j} = [data_tot{j}(:,2:size(data_tot{j},2))]; %all
		                trajectory.realTime{j} = data_tot{j}(:,1);
		        else
		                data{j} = data_tot{j};
                end

                j=j+1;
                k = k+1;
                if ~exist([PATH2,'/record',num2str(k-1),'.txt'])
                    cont=0;
                end
            end
        end
        
    else if(specific == 4)
            data_tot{1} = importdata(PATH);% load(PATH); 
            data{1} = zeros(size(data_tot{j},1)-1,size(data_tot{j},2));  
            data{1} = [data_tot{j}(1:size(data_tot{j},1),:)];
    else %treats record files directly in the PATH folder
	    if ~exist([PATH,'/record',num2str(j-1),'.txt'])
	        display('error no files with this name');
	        display([PATH,'/record',num2str(j-1),'.txt']);
	        cont=0;
	    end
	    while cont==1
	        data_tot{j} = load([PATH,'/record',num2str(j-1),'.txt']);
	        if(specific==1)%if it correspond to "Time Xgeom Ygeom Zgeom Fx Fy Fz Mx My Mz Xicub Yicub zicub"
	            data{j} = zeros(size(data_tot{j},1),9); % tall: nbIteration:9 (9 for position, forces and moment) 
	            data{j}(:,1:9) = [data_tot{j}(:,11:13),data_tot{j}(:,5:10)]; %11:13: real position of the robot; 5:10 forces and wrench
	            trajectory.realTime{j} = data_tot{j}(:,1); %Time information
	        elseif(columnTime==1) %if the first column corresponds to time information
	                data{j} = [data_tot{j}(:,2:size(data_tot{j},2))]; %all
	                trajectory.realTime{j} = data_tot{j}(:,1);
            elseif(specific ==2 || specific == 3)%if it correspond to covid data
                data{j} = zeros(size(data_tot{j},1),7);  
	            data{j}(:,1:7) = [data_tot{j}(:,3:5),data_tot{j}(:,7),data_tot{j}(:,9:11)];
	            trajectory.realTime{j} = data_tot{j}(:,1); %Time information
            elseif(specific==5) %covid data retrieve per week treated per month
                data_tmp{j} = zeros(size(data_tot{j},1),7);  
	            data_tmp{j}(:,1:7) = [data_tot{j}(:,3:5),data_tot{j}(:,7),data_tot{j}(:,9:11)]; %interesting columns
                data{j} = zeros(size(data_tot{j},1),7);
                
                for(i=1:floor(size(data_tmp{j},1)/4))
                   sum2 = data_tmp{j}(1 +(i-1)*4,:);
                   sum2 = sum2 + data_tmp{j}(2 +(i-1)*4,:);
                   sum2 = sum2 + data_tmp{j}(3 +(i-1)*4,:);
                   sum2 = sum2 + data_tmp{j}(4 +(i-1)*4,:);
                   data{j}(i,:) = sum2;
                end
                tmp= size(data_tmp{j},1) - floor(size(data_tmp{j},1)/4)*4;
                
                if(tmp>0)
                    sum2 = 0;
                    for(i=1:tmp)
                        sum2 = sum2 + data_tmp{j}(floor(size(data_tmp{j},1)/4)*4+i,:);
                    end
                    data{j}(floor(size(data_tmp{j},1)/4)+1,:) = sum2;
                end
	            trajectory.realTime{j} = data_tot{j}(:,1); %Time information
            else
	            data{j} = data_tot{j};
	        end
	        j=j+1;
            if ((j>max)|| (~exist([PATH,'/record',num2str(j-1),'.txt'])))
	            cont=0;
	        end
	    end
    end
    
    
    if(specific ==4)
        %%%Fill trajectories information using the retrieved data{j} values
        trajectory.nbTraj = 1;
        
        if(size(data{1}.textdata,2)==1)
           tmpName = data{1}.textdata(1,:);
           tmpName2 = regexprep(tmpName,'10 ','News- ');
           tmpName = regexprep(tmpName2,' 10',' News');
           tmpName2 = regexprep(tmpName,'11 ','Res.Reserv- ');
           tmpName = regexprep(tmpName2,' 11',' Res.Reserv');
           tmpName2 = regexprep(tmpName,'12 ','Res.inLine- ');
           tmpName = regexprep(tmpName2,' 12',' Res.inLine');
           tmpName2 = regexprep(tmpName,'15 ','Pedag.It.- ');
           tmpName = regexprep(tmpName2,' 15',' Pedag.It.');
           tmpName2 = regexprep(tmpName,'16 ','Collect.- ');
           tmpName = regexprep(tmpName2,' 16',' Collect.');
           tmpName2 = regexprep(tmpName,'1 ','Stock- ');
           tmpName = regexprep(tmpName2,' 1',' Stock');
           tmpName2 = regexprep(tmpName,'2 ','Collab- ');
           tmpName = regexprep(tmpName2,' 2',' Collab');
           tmpName2 = regexprep(tmpName,'3 ','Marks- ');
           tmpName = regexprep(tmpName2,' 3',' Marks');
           tmpName2 = regexprep(tmpName,'4 ','Abscence- ');
           tmpName = regexprep(tmpName2,' 4',' Absence');
           tmpName2 = regexprep(tmpName,'5 ','SchoolLife- ');
           tmpName = regexprep(tmpName2,' 5',' SchoolLife');
           tmpName2 = regexprep(tmpName,'6 ','CompetM- ');
           tmpName = regexprep(tmpName2,' 6',' Compet');
           tmpName2 = regexprep(tmpName,'7 ','TimeM- ');
           tmpName = regexprep(tmpName2,' 7',' TimeM');
           tmpName2 = regexprep(tmpName,'8 ','Homework- ');
           tmpName = regexprep(tmpName2,' 8',' Homework');
           tmpName2 = regexprep(tmpName,'9 ','Mail- ');
           tmpName = regexprep(tmpName2,' 9',' Mail');

           trajectory.inputName = erase(erase(split(tmpName{1}(6:end-1),"("), ") "), ")") ;
           trajectory.inputName = erase(trajectory.inputName(2:end,:)," ");
        else
            trajectory.inputName = data{1}.textdata(1,2:size(data{1}.textdata,2));%  colheaders; 
            
                tmpName = data{1}.textdata(1,2:size(data{1}.textdata,2));
                for i=1:size(tmpName,2)
                    tmpName{i} =  regexprep(tmpName{i},'e10','News');
                    tmpName{i} =  regexprep(tmpName{i},'e11','Res.Reserv');
                    tmpName{i} =  regexprep(tmpName{i},'e12','Res.inLine');
                    tmpName{i} =  regexprep(tmpName{i},'e15','Pedag.It.');
                    tmpName{i} =  regexprep(tmpName{i},'e16','Collect.');
                    tmpName{i} =  regexprep(tmpName{i},'e1','Stock');
                    tmpName{i} =  regexprep(tmpName{i},'e2','Collab');
                    tmpName{i} =  regexprep(tmpName{i},'e3','Marks');
                    tmpName{i} =  regexprep(tmpName{i},'e4','Absence');
                    tmpName{i} =  regexprep(tmpName{i},'e5','SchoolLife');
                    tmpName{i} =  regexprep(tmpName{i},'e6','CompetM');
                    tmpName{i} =  regexprep(tmpName{i},'e7','TimeM');
                    tmpName{i} =  regexprep(tmpName{i},'e8','Homework');
                    tmpName{i} =  regexprep(tmpName{i},'e9','Mail');  
                    tmpName{i} =  regexprep(tmpName{i},'I1',' -s- ');
                    tmpName{i} =  regexprep(tmpName{i},'I2',' -mn- ');
                    tmpName{i} =  regexprep(tmpName{i},'I3',' -h- ');
                    tmpName{i} =  regexprep(tmpName{i},'I4',' -d- '); 
                    tmpName{i} =  regexprep(tmpName{i},'I5',' -wk- ');
                    tmpName{i} =  regexprep(tmpName{i},'I6',' -mt- ');  
                end
                 trajectory.inputName  = tmpName;
        end
        if(nbInput ==-1) %if the number of input parameters is not given in input, it computes it
            trajectory.nbInput = size(data{1}.data,2);
        else
            trajectory.nbInput = nbInput;
        end
         i=1;
        trajectory.y{i} = [];
        %to avoid problem after
        trajectory.totTime(i) =size(data{1}.data,1) ; %total number of samples
        if(isfield(trajectory, 'realTime'))
            trajectory.interval(i) = (trajectory.realTime{i}(trajectory.totTime(i)) - trajectory.realTime{i}(1)) /trajectory.totTime(i); %time inteval between sample
        end
        trajectory.yMat{i} =  data{1}.data; %matrice that contains trajectory input (x= number of sample, y= number of input)
        for j = 1: sum(trajectory.nbInput)
           trajectory.y{i}=  [ trajectory.y{i} ; data{1}.data(:,j) ]; %vector that contains trajectory inputs
        end
        trajectory.label = nameT; %label of the trajectory.

        if(referenceNumber ~= -1)%compute the modulation time of the trajectory
            for i=1:trajectory.nbTraj
                trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
            end 
        end
    
    else
        %%%Fill trajectories information using the retrieved data{j} values
        trajectory.nbTraj = size(data,2); %total number of trajectory
        if(nbInput ==-1) %if the number of input parameters is not given in input, it computes it
            trajectory.nbInput = size(data{1},2);
        else
            trajectory.nbInput = nbInput;
        end
        for i=1:trajectory.nbTraj %for each trajectory, fill other variables
            trajectory.y{i} = [];
            %val = [];
            %to avoid problem after
            trajectory.totTime(i) =size(data{i},1) ; %total number of samples
            if(isfield(trajectory, 'realTime'))
                trajectory.interval(i) = (trajectory.realTime{i}(trajectory.totTime(i)) - trajectory.realTime{i}(1)) /trajectory.totTime(i); %time inteval between sample
            end
            trajectory.yMat{i} =  data{i}(1:trajectory.totTime(i),:); %matrice that contains trajectory input (x= number of sample, y= number of input)
            for j = 1: sum(trajectory.nbInput)

               trajectory.y{i}=  [ trajectory.y{i} ; data{i}(1:trajectory.totTime(i),j) ]; %vector that contains trajectory inputs
               %val =  [val ; data{i}(1:floor(size(data{i},1)/z):totalTime(i),j)];
            end
        end 

        trajectory.label = nameT; %label of the trajectory.

        if(referenceNumber ~= -1)%compute the modulation time of the trajectory
            for i=1:trajectory.nbTraj
                trajectory.alpha(i) = referenceNumber / trajectory.totTime(i);
            end 
        end
    end

end
