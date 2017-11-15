function promp = LearningFaceTrajectory(promp, s_bar, varargin)
%LEARNINGFACEPOSITION learns orientation of the face according to the
%proMP.
%INPUTS:
%
    flag_closeConnexion = 1;
    if (~isempty(varargin))
       nbTest = varargin{1};
       if(length(varargin) == 2)
           connexion= varargin{2}
           flag_closeConnexion = 0;
       end
    else
        nbTest = 20;
    end

    
    %connexion
    if(flag_closeConnexion ==1)
        connexion = initializeconnexion;
        command = 'yarp connect /headPos:o /matlab/write';
        system(command);
        command = 'yarp connect /matlab/write /headPos:o';
        system(command);
        command = 'yarp connect /faceIntraface/image:o /view';
        system(command);
        command = ' yarp connect /grabber /faceIntraface/image:i';
        system(command);
        command = 'yarp connect /matlab/ispeak /icub/speech:rpc';
        system(command);
    end
    
%     for j=1:length(promp)
%         data_tot{j} = [];
%     end

    for i=1:nbTest
        for j=1:length(promp)
            sentence = ['say "', promp{j}.traj.label, '"']
            connexion.ispeak.clear();
            connexion.ispeak.fromString(sentence);
            connexion.ispeak.fromString(sentence);
            connexion.port2.write(connexion.ispeak);
            rep = input(['Keep looking at the init position and press a key. At the end of the trajectory ', promp{j}.traj.label , ', press a new key.' ]);
            t=1;
            tic;
            % Set up the stop box:
            FS = stoploop({'Stop me before', '5 seconds have elapsed'}) ;
            % Display elapsed time
           % fprintf('\nSTOPLOOP: elapsed time (s): %5.2f\n',toc)
            
            while (~FS.Stop())
              %  fprintf('%c',repmat(8,6,1)) ;   % clear up previous time
                %ask data
                connexion.b.clear();
                connexion.b.addDouble(1.0);
                connexion.portHP.write(connexion.b);
                %retrieve data
                connexion.c.clear();
                connexion.portHP.read(connexion.c);
                data{j}{i}(t,:) = str2num(connexion.c);
                data{j}{i}(t,:)
                realTime{j}{i}(t) = toc;
                t=t+1
                %fprintf('%5.2f\n',toc) ;        % display elapsed time
            end
            toc;
            FS.Clear() ;  % Clear up the box
            clear FS ; 
            
        %    data_tot{j} = [data_tot{j} ; data{j}{i}];
        end
    end

    if(flag_closeConnexion ==1)
        closeConnexion(connexion);
    end
    
    %learn distribution
    for j=1:length(promp)
        promp{j}.facePose.nbTraj = nbTest;
        promp{j}.facePose.nbInput = length(data{j}{i}(1,:)) ;
        for i=1:promp{j}.facePose.nbTraj
            promp{j}.facePose.alpha(i) = s_bar / length(data{j}{i}) ;
            promp{j}.facePose.totTime(i) = length(data{j}{i});
            promp{j}.facePose.yMat{i}  = data{j}{i};
            promp{j}.facePose.y{i} = [data{j}{i}(:,1);data{j}{i}(:,2);data{j}{i}(:,3)];
            promp{j}.facePose.realTime{i} = realTime{j}{i};
            promp{j}.facePose.interval(i) = promp{j}.facePose.realTime{i}(promp{j}.facePose.totTime(i));
        end       
    end
        
        
        
%         promp{j}.facePose.data = data{j};
%         promp{j}.facePose.mu = mean(data{j});
%         promp{j}.facePose.sigma = cov(data{j});
%         clear subPart;
%         subPart{1} = promp{j};
%         %learn accepted variation
%         cpt=1;
%        for i=1:10:(length(data_tot{j}) -10)
%             test.data = data_tot{j}(i:i+10,:); 
%             test.mu = mean(test.data);
%             test.sigma = cov(test.data);
%             [type, dist(j,cpt)] = PriorNearestDistribution(test, subPart)
%             cpt = cpt+1;
%        end
%         promp{j}.facePose.dist.mu = mean(dist(j,:));
%         promp{j}.facePose.dist.sigma = cov(dist(j,:));
end