function promp = computeDistribution(traj, M, s_ref,c,h, varargin)
%COMPUTEDISTRIBUTION
%This function computes the distribution for each kind of trajectory.

%varargin: 
%- Draw to plot gaussians, weights and so on.

    flag_draw = 0;
    kernel= 'gaussian';
    if(~isempty(varargin))
        for i=1:length(varargin)
            if(strcmp(varargin{i},'Draw') ==1)
                flag_draw = 1;
            elseif(strcmp(varargin{i}, 'Periodic')==1)
                kernel = 'Periodic';
            end
        end
    end


    promp.traj = traj;
   %for each trajectory
    for j = 1:traj.nbTraj 
        %we compute the corresponding PHI matrix
         promp.PHI{j} = computeBasisFunction (s_ref,M, promp.traj.nbInput, promp.traj.alpha(j), promp.traj.totTime(j), c, h, promp.traj.totTime(j), kernel);
    end
    
    %%if plotGaussians
    if(flag_draw==1)
        figure;
        plot(promp.PHI{1})
    end
    
    promp.mu_alpha = mean(promp.traj.alpha);
    promp.sigma_alpha = cov(promp.traj.alpha);
    promp.PHI_norm = computeBasisFunction (s_ref,M,promp.traj.nbInput, 1, s_ref,c,h, s_ref, kernel);
    promp.PHI_mean = computeBasisFunction (s_ref,M,promp.traj.nbInput, promp.mu_alpha, s_ref / promp.mu_alpha,c,h, s_ref / promp.mu_alpha, kernel);

%     val = 0;
%     for cpt =1:size(promp.traj.nbInput,2)
%         val = val + promp.traj.nbInput(cpt)*nbFunctions(cpt);
%     end
    %w computation for each trials
    for j = 1 : promp.traj.nbTraj
        %resolve a little bug
        sizeY  = size(promp.traj.y{j},1);
        if(sizeY ~= size(promp.PHI{j},1))
            promp.traj.y{j} = promp.traj.y{j}(1:sizeY-(sum(promp.traj.nbInput)));
            promp.traj.totTime(j) = promp.traj.totTime(j) -sum(promp.traj.nbInput);
            promp.traj.alpha(j) = s_ref /promp.traj.totTime(j);
        end
       sizeNoise = size(promp.PHI{j}'*promp.PHI{j});
       %Least square
        w(j,:) = (promp.PHI{j}'*promp.PHI{j}+1e-12*eye(sizeNoise)) \ promp.PHI{j}' * promp.traj.y{j};        
        listw(j,:) =w(j,:); 
      %  promp.traj.interval(j) = promp.traj.interval(j)  + promp.traj.realTime{j}(promp.traj.totTime);
    end
    
    %computation of the w distribution     
    promp.mu_w = mean(listw)';
    promp.sigma_w = cov(listw); %sometimes have < 0 for forces as it is not
    promp.sigma_w = nearestSPD(promp.sigma_w);
    promp.meanTimes= size(promp.PHI_mean,1) / sum(promp.traj.nbInput);%mean(promp.traj.totTime);

    if(isfield(promp.traj, 'interval'))
       promp.meanInterval = mean(promp.traj.interval);
    end
    
    if(flag_draw)
        figure();
        subplot(2,2,1);
        plot(promp.PHI{1});
        subplot(2,2,2);
        plot(listw', ':b');
        hold on;
        plot(promp.mu_w,'*-k','LineWidth', 2);
      %  plot(promp.mu_w + diag(promp.sigma_w),'*-r');
      %  plot(promp.mu_w - diag(promp.sigma_w),'*-r');
        subplot(2,2,3);
        plot((promp.PHI{1}*promp.mu_w)', '*-r');hold on;
        plot((promp.PHI{1}*promp.mu_w +promp.PHI{1}*diag(promp.sigma_w) )', '*-r');
        plot((promp.PHI{1}*promp.mu_w -promp.PHI{1}*diag(promp.sigma_w) )', '*-r');
        subplot(2,2,4);
        plot((promp.PHI{1}*promp.mu_w)', '*-k');
    end
    
    
end
   
   
