function [type, test, dist] = recoFacePosition(promp, varargin)
    toClose = 0;
if(~isempty(varargin))
    if(strcmp(varargin{1},'test')==1)
        test = varargin{2};
    elseif(strcmp(varargin{1},'connexion')==1)
        connexion = varargin{2};
    end
end
if(~exist('connexion','var'))
    toClose =1;
        connexion = initializeconnexion;
        command = 'yarp connect /headPos:o /matlab/write';
        system(command);
        command = 'yarp connect /matlab/write /headPos:o';
        system(command);

        command = 'yarp connect /grabber /faceIntraface/image:i';
        system(command);
        command = 'yarp connect /faceIntraface/image:o /view';
        system(command);
end
if(~exist('test','var'))
        clear test;
        for j=1:length(promp)
            data_tot{j} = [];
        end
           sentence = ['say "Look at goal"']
            connexion.ispeak.clear();
            connexion.ispeak.fromString(sentence);
            connexion.ispeak.fromString(sentence);
            connexion.port2.write(connexion.ispeak);
        rep = input(['Look at goal and press a key']);
        %first data
        for t=1:10
            %ask data
            connexion.b.clear();
            connexion.b.addDouble(1.0);
            connexion.portHP.write(connexion.b);
            %retrieve data
            connexion.c.clear();
            connexion.portHP.read(connexion.c);
            test.data(t,:) = str2num(connexion.c);
        end
        test.mu = mean(test.data);
        test.sigma = cov(test.data);
        [type, dist] = PriorNearestDistribution(test, promp);
        
        %valmin = promp{type}.facePose.dist.mu - 1.96*sqrt(diag(promp{type}.facePose.dist.sigma))
        for tmp=1:length(promp)
            valmax{tmp} = promp{1}.facePose.dist.mu; %+ 1.96*sqrt(diag(promp{type}.facePose.dist.sigma))
        end
        if(dist <= valmax{type})
            reco = 1;
            display('DIRECTLY!!');
            display(['Min distance = ', num2str(type), ' (', promp{type}.traj.label, ') with ', num2str(dist)]);
        else
            reco=0;
            cpt=1;
            %moyenne glissante
            while (reco==0)
                reco;
 %               %ask data
 %               connexion.b.clear();
 %%               connexion.b.addDouble(1.0);
                connexion.portHP.write(connexion.b);
                %retrieve data
                connexion.c.clear();
                connexion.portHP.read(connexion.c);
                test.data(cpt,:) = str2num(connexion.c);
                cpt = cpt+1;

                test.mu = mean(test.data);
                test.sigma = cov(test.data);

                [type, dist] = PriorNearestDistribution(test, promp);
                
                if(dist <= valmax{type})
                    reco = 1;
                    display(['Min distance = ', num2str(type), ' (', promp{type}.traj.label, ') with ', num2str(dist)]);
                	break;
                end
                
                if(cpt>10)
                    cpt=1;
                end
            end
        end
if(toClose==1)
            closeconnexion(connexion);
end
else
        [type, dist] = PriorNearestDistribution(test, promp);
end