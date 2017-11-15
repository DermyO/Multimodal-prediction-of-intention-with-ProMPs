function test = beginAHeadTrajectory(connexion, varargin)

    if(~isempty(varargin)) % record nbData
        nbData = varargin{1};
        clear rep;
        rep = input('Keep looking at the init position and press a key. Then, do the trajectory.');
        t=1;
        tic;
        cont =1;
        t = 0;
        cpt = 0;
        begin_traj = true;
        while (cont ==1)
            t = t+1;
%             connexion.b.clear();
%             connexion.b.addDouble(1.0);
%             connexion.portHP.write(connexion.b);
            %retrieve data
            connexion.c.clear();
            connexion.portHP.read(connexion.c);
            test.data(t,:) = str2num(connexion.c);

             if((test.data(t,1) ==-1) && (begin_traj == true))
                 t = t-1;
                 continue;
             end
                begin_traj = false;
                test.realTime(t) = toc;
                test.realTime(t)
                if(t==nbData)
                    if(test.data(t,1) ==-1)
                        t = t-1; 
                        continue;
                    end
                    cont = 0;
                end
%             else 
%                 t = t-1;
%             end
            
        end
        test.totTime = length(test.data);
        test.nbData = test.totTime;
        test.yMat = test.data;
        test.partialTraj = reshape(test.data,[],numel(test.data))';
        

            
        %delete empty data at the end of the traj
        while (test.data(size(test.data,1),1)==-1)
            test.data(size(test.data,1),:) = [];
            test.realTime(size(test.data,1)) = [];
        end

        %delete empty data at the begining of the traj
        while(test.data(1,1)==-1)
                test.data(1,:) = [];
                test.realTime(1) = [];
        end
        tmp_time = test.realTime(1);
        test.realTime(1) = 0;

% with matlab spline            
%             data2 =data;
%   [line_idx] = find(data2{j}{i}(:,1)~=-1);    
%   val{j}{i}(:,1) = spline(line_idx,data2{j}{i}(line_idx,1),1:length(data2{j}{i}));
%   val{j}{i}(:,2) = spline(line_idx,data2{j}{i}(line_idx,2),1:length(data2{j}{i}));
%   val{j}{i}(:,3) = spline(line_idx,data2{j}{i}(line_idx,3),1:length(data2{j}{i}));
%   figure;
%   plot(val{j}{i}(:,1));hold on
%     for t=1:length(data2{j}{i}(:,1))
%             scatter(t, data2{j}{i}(t,1), 'xr');
%     end

%delete empty data at the middle with prediction fo the value
%(ponderation of neighboor according to time)
        for t=2:size(test.data,1)
            test.realTime(t) = test.realTime(t) -tmp_time ;
            if(test.data(t,1)==-1)
                tmp = 0;
                c= t+1;
                while(tmp==0)
                    if(test.data(c,1)==-1)
                        c = c +1;
                    else
                        tmp = 1;
                    end
                end
                test.data(t,1) = ((c-t)*test.data(t-1,1) + test.data(c,1)) / (c-t+1);
                test.data(t,2) = ((c-t)*test.data(t-1,2) + test.data(c,2)) / (c-t+1);
                test.data(t,3) = ((c-t)*test.data(t-1,3) + test.data(c,3)) / (c-t+1);
            end
        end
        
        
        
        
        
    else
    sayType(['Keep looking at the init position and press a key. At the end of the expected trajectory , press a new key.' ], connexion);
    clear rep;
    rep = input(['Keep looking at the init position and press a key. At the end of the expected trajectory , press a new key.' ]);
    t=1;
    tic;
    % Set up the stop box:
    FS = stoploop({'Stop me before', '5 seconds have elapsed'}) ;

    while (~FS.Stop())
        connexion.b.clear();
        connexion.b.addDouble(1.0);
        connexion.portHP.write(connexion.b);
        %retrieve data
        connexion.c.clear();
        connexion.portHP.read(connexion.c);
        test.data(t,:) = str2num(connexion.c);
        test.data(t,:)
        if(test.data(t,1) ~=-1)
        test.realTime(t) = toc;
        t=t+1;
        end
    end
    
    test.totTime = length(test.data);
    test.nbData = test.totTime;
    test.yMat = test.data;
    test.partialTraj = reshape(test.data,[],numel(test.data))';
    toc;
    FS.Clear() ;  % Clear up the box
    clear FS ; 
    
         
        %delete empty data at the end of the traj
        while (test.data(size(test.data,1),1)==-1)
            test.data(size(test.data,1),:) = [];
            test.realTime(size(test.data,1)) = [];
        end

        %delete empty data at the begining of the traj
        while(test.data(1,1)==-1)
                test.data(1,:) = [];
                test.realTime(1) = [];
        end
        tmp_time = test.realTime(1);
        test.realTime(1) = 0;

% with matlab spline            
%             data2 =data;
%   [line_idx] = find(data2{j}{i}(:,1)~=-1);    
%   val{j}{i}(:,1) = spline(line_idx,data2{j}{i}(line_idx,1),1:length(data2{j}{i}));
%   val{j}{i}(:,2) = spline(line_idx,data2{j}{i}(line_idx,2),1:length(data2{j}{i}));
%   val{j}{i}(:,3) = spline(line_idx,data2{j}{i}(line_idx,3),1:length(data2{j}{i}));
%   figure;
%   plot(val{j}{i}(:,1));hold on
%     for t=1:length(data2{j}{i}(:,1))
%             scatter(t, data2{j}{i}(t,1), 'xr');
%     end

%delete empty data at the middle with prediction fo the value
%(ponderation of neighboor according to time)
        for t=2:size(test.data,1)
            test.realTime(t) = test.realTime(t) -tmp_time ;
            if(test.data(t,1)==-1)
                tmp = 0;
                c= t+1;
                while(tmp==0)
                    if(test.data(c,1)==-1)
                        c = c +1;
                    else
                        tmp = 1;
                    end
                end
                test.data(t,1) = ((c-t)*test.data(t-1,1) + test.data(c,1)) / (c-t+1);
                test.data(t,2) = ((c-t)*test.data(t-1,2) + test.data(c,2)) / (c-t+1);
                test.data(t,3) = ((c-t)*test.data(t-1,3) + test.data(c,3)) / (c-t+1);
            end
        end
    
    
    
    
    end
end