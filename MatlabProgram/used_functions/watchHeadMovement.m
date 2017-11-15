function promp = watchHeadMovement(promp,connexion, varargin)
%continueMovement plays the trajectory recognized into gazebo.

if(~isempty(varargin))
    list= varargin{1}
else
    list= {'unamed','unamed','unamed','unamed','unamed','unamed', 'unamed','unamed','unamed'}
end

rep = input(['Keep looking at the init position and press a key. At the end of the trajectory ', promp.traj.label , ', press a new key.' ]);
tic;
nbTest = length(promp.traj.yMat);

for i = 1:length(promp.traj.yMat) %replay all trajectories
    for t = 1:length(promp.traj.yMat{i})

         %do the learned movement
        connexion.b.clear();
        for j = 1 : 7 %cartesian position 
            connexion.b.addDouble(promp.traj.yMat{i}(t,j));
        end
        %compliance calculated in the previous boucle
        connexion.b.addDouble(0.0);
        connexion.port.write(connexion.b);
        %display(['Sending ', num2str(val(t,1)), ' ' , num2str(val(t,2)), ' etc. Waiting answer']);
        connexion.port.read(connexion.c);
        num = str2num(connexion.c);
 
         %%read head
         connexion.b.clear();
         connexion.b.addDouble(1.0);
         connexion.portHP.write(connexion.b);
         connexion.c.clear();
         connexion.portHP.read(connexion.c);
         promp.traj.yMat{i}(t,promp.traj.nbInput + 1:promp.traj.nbInput + 3) = str2num(connexion.c);
%         promp.traj.realTime(i,t) = toc;
    end
    promp.traj.y{i} = reshape(promp.traj.yMat{i},[],numel(promp.traj.yMat{i}))';
end
    promp.traj.nbInput = promp.traj.nbInput + 3; 

%Send prompormation about the end of the trajectory and verify it
%receives it.
connexion.b.clear();
connexion.b.addDouble(0.0);
connexion.port.write(connexion.b);
connexion.port.read(connexion.c);


end
