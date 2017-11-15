function t = recordTrajectoryAndHeadWithRealIcub(connexion, typeName, nbInput, s_bar)

    %continueRecording=20;
    t.nbTraj = 0;
    t.label = typeName;
    t.nbInput = nbInput;

    while(t.nbTraj < 10)
        a = input('Go to home position');
        ok=0;
        a = input(['Keep looking at the init position and press a key. At the end of the trajectory, press a new key.' ]);

        cpt=1;
        val = 0;
        tic;
        % Set up the stop box:
        FS = stoploop({'Stop me at the end of the trajectory'}) ;
            
        while (~FS.Stop())
           connexion.b.clear();
           connexion.b.addDouble(1.0);
           connexion.portHP.write(connexion.b);
           %retrieve data
           connexion.c.clear();
           connexion.portHP.read(connexion.c);
           numF =  str2num(connexion.c);
           connexion.state.clear(); 
            connexion.portState.read(connexion.state); 
            num3 = str2num(connexion.state);   
            connexion.wrenches.clear();
            connexion.portWrenches.read(connexion.wrenches);             
            numW = str2num(connexion.wrenches);   
            num(cpt,:) = [num3, numW, numF];
            cpt=cpt+1
 
        end
        timeEl = toc;
        length(num)
        if(length(num) >10)
            disp('trajectory is used');
            t.nbTraj = t.nbTraj+1
            t.interval(t.nbTraj) = timeEl /length(num);
            t.totTime(t.nbTraj) =length(num); 
            t.yMat{t.nbTraj} = num;
            t.y{t.nbTraj} = reshape(t.yMat{t.nbTraj}, [], numel(t.yMat{t.nbTraj}),1); 
            t.alpha(t.nbTraj) = s_bar / length(num);
        else
            disp('trajectory is not used')
        end
        clear num;

    end
end