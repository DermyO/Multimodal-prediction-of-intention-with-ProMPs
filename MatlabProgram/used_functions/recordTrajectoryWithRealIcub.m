function t = recordTrajectoryWithRealIcub(connexion, typeName, nbInput, s_bar, varargin)

    %continueRecording=20;
    t.nbTraj = 0;
    t.label = typeName;
    t.nbInput = nbInput;
    nbRecord = [];
    
    if(~isempty(varargin))
        for i=1:length(varargin)
            if(strcmp(varargin{i},'update') ==1)
                t = varargin{i+1};
            elseif(strcmp(varargin{i},'nbRecord') ==1)
                nbRecord = varargin{i+1};
            end
        end
    end
    while(isempty(nbRecord))
        nbRecord = input('Enter the number of trajectories to record');
    end
    
    
    while(t.nbTraj < nbRecord)
        a = input('Go to home position');
        ok=0;
      %  disp('You can begin a movement. Maintain the robot left arm and move it till the end of the movement.');
%    if(t.nbTraj == 5 || t.nbTraj == 10 || t.nbTraj ==15)
%        while(strcmp(num2str(a), 'a')==0)
%         a = input('reinit wbd and press a','s');
%        end
%        connexion.port4.close;
% %       connexion.port4 = Port;
%        connexion.port4.open('/matlab/wrenches');
%     %
%     command = 'yarp connect /wholeBodyDynamics/left_arm/endEffectorWrench:o /matlab/wrenches';
%     system(command);

%   end
    a = input('Press enter when you are ready');
        
%         display('waiting skin contact');
%         %wait for skin contact
%         while(ok==0)
%             skinContact;
%         end
%         display('Contact detected. Recording the trajectory');
        
        cpt=1;
        val = 0;
        tic;
        % Set up the stop box:
        FS = stoploop({'Stop me at the end of the trajectory'}) ;
            
        while (~FS.Stop())
        %while(ok==1)  
            connexion.state.clear(); 
            connexion.portState.read(connexion.state); 
            num3 = str2num(connexion.state);   
            connexion.wrenches.clear();
            connexion.portWrenches.read(connexion.wrenches);             
            numW = str2num(connexion.wrenches);   
            num(cpt,:) = [num3, numW];
            cpt=cpt+1
                %verify contact
                %skinContact;
        end
        timeEl = toc;
        length(num)
        if(length(num) >10)
            disp('trajectory is used');
            t.nbTraj = t.nbTraj+1;
            t.interval(t.nbTraj) = timeEl /length(num);
            t.totTime(t.nbTraj) =length(num); 
            t.yMat{t.nbTraj} = num;
            t.y{t.nbTraj} = reshape(t.yMat{t.nbTraj}, [], numel(t.yMat{t.nbTraj}),1); %[num(:,1) ; num(:,2) ; num(:,3) ; num(:,4) ; num(:,5);num(:,6);num(:,7);num(:,8);num(:,9);num(:,10);num(:,11);num(:,12);num(:,13)];
            t.alpha(t.nbTraj) = s_bar / length(num);
           % continueRecording = continueRecording -1;
        else
            disp('trajectory is not used')
        end
        clear num;
    end
end