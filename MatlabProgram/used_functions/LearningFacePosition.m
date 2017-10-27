function promp = LearningFacePosition(promp, varargin)
%LEARNINGFACEPOSITION learns orientation of the face according to the
%proMP.
%INPUTS:
%
    flag_closeConnexion = 1;
    if (~isempty(varargin))
       nbTest = varargin{1};
       durationTest = varargin{2};
       if(nargin > 3)
           connexion= varargin{3}
           flag_closeConnexion = 0;
    else
        nbTest = 20;
        durationTest = 50;
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
    
    for j=1:length(promp)
        data_tot{j} = [];
    end

    for i=1:nbTest
        for j=1:length(promp)
            sentence = ['say "', promp{j}.traj.label, '"']
            connexion.ispeak.clear();
            connexion.ispeak.fromString(sentence);
            connexion.ispeak.fromString(sentence);
            connexion.port2.write(connexion.ispeak);
            rep = input(['Keep looking at goal ', promp{j}.traj.label , ', and press a key.' ]);
            for t=1:durationTest
                %ask data
                connexion.b.clear();
                connexion.b.addDouble(1.0);
                connexion.port.write(connexion.b);
                %retrieve data
                connexion.c.clear();
                connexion.port.read(connexion.c);
                data{j}{i}(t,:) = str2num(connexion.c);
            end
            data_tot{j} = [data_tot{j} ; data{j}{i}];
        end
    end

    if(flag_closeConnexion ==1)
        closeConnexion(connexion);
    end
    
    %learn distribution
    for j=1:length(promp)
        promp{j}.facePose.data = data_tot{j};
        promp{j}.facePose.mu = mean(data_tot{j});
        promp{j}.facePose.sigma = cov(data_tot{j});
        clear subPart;
        subPart{1} = promp{j};
        %learn accepted variation
        cpt=1;
       for i=1:10:(length(data_tot{j}) -10)
            test.data = data_tot{j}(i:i+10,:); 
            test.mu = mean(test.data);
            test.sigma = cov(test.data);
            [type, dist(j,cpt)] = PriorNearestDistribution(test, subPart)
            cpt = cpt+1;
       end
        promp{j}.facePose.dist.mu = mean(dist(j,:));
        promp{j}.facePose.dist.sigma = cov(dist(j,:));
    end
    
end