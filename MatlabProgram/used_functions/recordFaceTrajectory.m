function recordTraj = recordFaceTrajectory(promp, s_bar, connexion, varargin)
%recordFaceTrajectory records orientation of the face according to the
%proMP.
%INPUTS:

isNbTest = 0;
     if (~isempty(varargin))
         isNbTest = 1;
       nbTest = varargin{1};
   % else
%      nbTest = 20;
     end

cont = 1;
i=0;
cpt = 1;
    %for i=1:nbTest
    while(cont == 1)
        i =i+1;
        length(promp)
        for j=1:length(promp)
            sentence = ['say "', promp{j}.traj.label, '"'];
            connexion.ispeak.clear();
            connexion.ispeak.fromString(sentence);
            connexion.ispeak.fromString(sentence);
            connexion.portSpeak.write(connexion.ispeak);
            strring = ['Keep looking at the init position and press a key.\n At the end of the trajectory ', promp{j}.traj.label , ', press a new key.' ];
            rep = input(strring);
            t=1;
            tic;
           FS = stoploop({'Stop me before', '5 seconds have elapsed'}) ;
          
            while(~FS.Stop())
              %  fprintf('%c',repmat(8,6,1)) ;   % clear up previous time
                %ask data
%                 connexion.b.clear();
%                 connexion.b.addDouble(1.0);
%                 connexion.portHP.write(connexion.b);
                %retrieve data
                connexion.c.clear();
                connexion.portHP.read(connexion.c);
                data{j}{i}(t,:) = str2num(connexion.c);
                realTime{j}{i}(t) = toc;
                t=t+1
                %end
            end
            toc;
            FS.Clear() ;  % Clear up the box
            clear FS ; 
        end
        if(isNbTest == 1)
            nbTest = nbTest -1;
            if(nbTest == 0)
                cont = 0;
            end
        else
            cont = [];
            while(isempty(cont))
            cont = input('Do you want to record again? yes = 1');
            end
        end
    end
    
    %treatment of -1 (non detected face)
    for j=1:length(data)
        for i=1:length(data{j})
            
            %delete empty data at the end of the traj
            while (data{j}{i}(size(data{j}{i},1),1)==-1)
                realTime{j}{i}(size(data{j}{i},1)) = [];
                data{j}{i}(size(data{j}{i},1),:) = [];
            end
            
            %delete empty data at the begining of the traj
            while(data{j}{i}(1,1)==-1)
                    realTime{j}{i}(1) = [];
                    data{j}{i}(1,:) = [];
            end
            tmp_time = realTime{j}{i}(1);
            realTime{j}{i}(1) = 0;

% with matlab spline            
%             data2 =data;
%   [line_idx] = find(data2{j}{i}(:,1)~=-1);    
%   val{j}{i}(:,1) = spline(line_idx,data2{j}{i}(line_idx,1),1:length(data2{j}{i}));
%   val{j}{i}(:,2) = spline(line_idx,data2{j}{i}(line_idx,2),1:length(data2{j}{i}));
%   val{j}{i}(:,3) = spline(line_idx,data2{j}{i}(line_idx,3),1:length(data2{j}{i}));
%   figure;        toc;   

%   plot(val{j}{i}(:,1));hold on
%     for t=1:length(data2{j}{i}(:,1))
%             scatter(t, data2{j}{i}(t,1), 'xr');
%     end

%delete empty data at the middle with prediction fo the value
%(ponderation of neighboor according to time)
            for t=2:size(data{j}{i},1)
                realTime{j}{i}(t) = realTime{j}{i}(t) -tmp_time ;
                if(data{j}{i}(t,1)==-1)
                    tmp = 0;
                    c= t+1;
                    while(tmp==0)
                        if(data{j}{i}(c,1)==-1)
                            c = c +1;
                        else
                            tmp = 1;
                        end
                    end
                    data{j}{i}(t,1) = ((c-t)*data{j}{i}(t-1,1) + data{j}{i}(c,1)) / (c-t+1);
                    data{j}{i}(t,2) = ((c-t)*data{j}{i}(t-1,2) + data{j}{i}(c,2)) / (c-t+1);
                    data{j}{i}(t,3) = ((c-t)*data{j}{i}(t-1,3) + data{j}{i}(c,3)) / (c-t+1);
                end
            end
        end
    end
                
    
  if(~isempty(data))
    for j=1:length(promp)
        recordTraj{j}.nbTraj = i;
        recordTraj{j}.nbInput = length(data{j}{i}(1,:)) ;
        recordTraj{j}.label = promp{j}.traj.label;
        for k=1:recordTraj{j}.nbTraj
            if(data{j}{k}(size(data{j}{k},1),1) == -1)
                data{j}{k}(size(data{j}{k},1),:) = [];
            end
            recordTraj{j}.alpha(k) = s_bar / length(data{j}{k}) ;
            recordTraj{j}.yMat{k}  = data{j}{k};
            recordTraj{j}.y{k} = [data{j}{k}(:,1);data{j}{k}(:,2);data{j}{k}(:,3)];
            recordTraj{j}.totTime(k) = length(recordTraj{j}.yMat{k});
            recordTraj{j}.realTime{k} = realTime{j}{k};
            recordTraj{j}.interval(k) = recordTraj{j}.realTime{k}(length(recordTraj{j}.realTime{k})) / length(recordTraj{j}.realTime{k});
        end       
    end
  else
      recordTraj = [];
    
end