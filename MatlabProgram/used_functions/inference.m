function [infTraj, typeReco] = inference(promps,obsTraj,M,s_bar,c,h,nbData, expNoise, expAlpha, varargin)
%INFERENCE
%in this function, we recongize a movement from some initial data
%and we complete it. We recognize and modify only the position information 
%In this inference version, we do the hypothesis that the phasis of the movement is the mean of the
%phasis used during the learning.

nbKindOfTraj = length(promps);
nbInput= promps{1}.traj.nbInput;


flag_spe = false;
flag_spe_int = false;
% nbInputReco = nbInput;
 if(~isempty(varargin))
     for i=1:length(varargin)
         if(strcmp(varargin{i}, 'speHead')==1)
             flag_spe = true;
             i=i+1;
             speInputs(1) = varargin{i};
             i = i+1;
             speInputs(2) = varargin{i};
         elseif(strcmp(varargin{i}, 'speInt')==1)
             flag_spe_int = true;
             speInputs = varargin{i+1};
         end
     end
 end

 
 if((flag_spe == false ) &&(flag_spe_int == false ) )


    %we cut the mu_w variables to correspond only to the
    %known input
    for i=1:nbKindOfTraj
        mu_w_coord{i} = promps{i}.mu_w(1:nbInput(1)*M(1));
        sigma_w_coord{i} = promps{i}.sigma_w(1:nbInput(1)*M(1),1:nbInput(1)*M(1));
    end

    % we compute for each learned distribution the loglikelihood that this
    % movement correspond to the distribution
    reco = {0 , -Inf };
    for i=1:nbKindOfTraj
        
        %matrix of cartesian basis functions that correspond to the first nbData
        if(expAlpha == -1 || isnan(expAlpha ))
            valAlpha(i) = promps{i}.mu_alpha;
        else
            valAlpha(i) = expAlpha;
        end
    if(round(s_bar/valAlpha(i)) < nbData)
        valAlpha(i) = s_bar / nbData;
    end
        PHI_coor{i} = computeBasisFunction(s_bar,M(1), nbInput(1), valAlpha(i), round(s_bar/valAlpha(i)), c(1), h(1), nbData);
        %matrix of forces basis functions that correspond to the first nbData
        %PHI_forces{i} = computeBasisFunction(z,nbFunctions(2), promps{i}.traj.nbInput(2),promps{i}.mu_alpha, round(z/promps{i}.mu_alpha), center_gaussian(2), h(2), nbData);%computeBasisForces(z,nbFunctions(2),mu_alpha(i), round(z/mu_alpha(i)), h, nbData);

        %matrix of basis functions for all data that correspond to the first
        %nbData with phasis alpha_mean
        PHI{i} =  computeBasisFunction(s_bar,M, nbInput, valAlpha(i), round(s_bar/valAlpha(i)), c, h, round(s_bar/valAlpha(i)));%blkdiag(PHI_coor{i},PHI_forces{i}); %PHI_coor{i};

        %we compute the learned distribution trajectory of cartesian position
        u{i} = PHI_coor{i}*mu_w_coord{i};
        sigma{i} = PHI_coor{i}*sigma_w_coord{i}*PHI_coor{i}' + expNoise*eye(size(PHI_coor{i}*sigma_w_coord{i}*PHI_coor{i}'));

        %TODO change this part: from the initial movement it is more correct to
        %compare the distance than le likelihood 
        %we compute the probability it correspond to the actual trial
        prob{i}= - mean(abs(obsTraj.partialTraj(1:nbInput(1)*nbData,:) -u{i}));     

        %we record the max of probability to know wich distribution we
        %recognize
        if(prob{i} > reco{2})
            reco{2} = prob{i};
            reco{1} = i;
        end
    end

    % disp(['The recognize trajectory is the number ', num2str(reco{1})])
     typeReco= reco{1};
    %we retrieve the computed distribution that correspond to the recognized
    %trajectory
    mu_new = promps{reco{1}}.mu_w;
    sigma_new = promps{reco{1}}.sigma_w;

    %we aren't suppose to know "realData",  here it is only used to draw the real
    %trajectory of the sample if we continue it to the end

    %display(['The real phasis is ', num2str(obsTraj.alpha), ' with total time : ', num2str(obsTraj.totTime) ])
    %display(['The supposed phasis is ', num2str(expAlpha), ' with total time : ', num2str(z / expAlpha) ])

    %%Creation of the basis function with mean phasis & nbData iterations

    infTraj.alpha =  valAlpha(typeReco);
    infTraj.timeInf = round(s_bar / infTraj.alpha);
    infTraj.PHI = PHI{reco{1}};
    ma = ones(1,nbData);
    mb = zeros(1,round(s_bar /infTraj.alpha)- nbData); 
    mc = zeros(1, round(s_bar /infTraj.alpha));
    ma = [ma, mb]; % 1 for data we know 0 for the others
    mk = []; % C/C the mask for other data
    for vv = 1:nbInput
        mk = [mk, ma]; 
    end 
    mask = logical(mk);
ma = ones(1,nbData);
mc = zeros(1,round(s_bar /infTraj.alpha)); 
mb = zeros(1,round(s_bar /infTraj.alpha)- nbData); 
ma = [ma, mb]; % 1 for data we know 0 for the others
mk = []; % C/C the mask for other data

for vv = 1:nbInput(1)
    mk = [mk, ma]; 
end
for vv = nbInput(1)+1:sum(nbInput)
    mk = [mk, mc]; 
end 
mask = logical(mk);
    %creation  of the basis function matrix
    PHI_update = infTraj.PHI(mask,:);

    %distribution update
    K = sigma_new*PHI_update' / (expNoise*eye(size(PHI_update*sigma_new*PHI_update')) + PHI_update*sigma_new*PHI_update');
    mu_new = mu_new + K* (obsTraj.partialTraj(1:nbData*nbInput(1),:) - PHI_update*mu_new);
    sigma_new = sigma_new - K*(PHI_update*sigma_new);

    infTraj.mu_w = mu_new;
    infTraj.sigma_w = sigma_new;
    infTraj.reco = reco{1}; 

    % %to compute error function
    % psi_inf_tot = computeBasisFunction(z,nbFunctions, nbDof, alphacomp, (z/alphacomp), center_gaussian, h, (z/alphacomp));
    % minSize= min(size(psi_inf_tot,1), size(newTraj.traj,1));
    % tmp = psi_inf_tot*mu_new;
    % display(['difference entre les courbes for ', num2str(nbData), 'data']);
    % sum(abs(newTraj.traj(1:minSize,:) -tmp(1:minSize,:)))

 elseif(flag_spe_int ==true)

     
     tmp = [];
     for i = speInputs
        tmp = [ tmp ,  (i-1)*M(1) + 1 : i*M(1)];
     end
     
     
    
    for i=1:nbKindOfTraj
        mu_w_coord{i} = promps{i}.mu_w(tmp);
        sigma_w_coord{i} = promps{i}.sigma_w(tmp,tmp);
    end

    % we compute for each learned distribution the loglikelihood that this
    % movement correspond to the distribution
    reco = {0 , -Inf };
    for i=1:nbKindOfTraj
        %matrix of cartesian basis functions that correspond to the first nbData
        if(expAlpha == -1 || isnan(expAlpha))
            valAlpha(i) = promps{i}.mu_alpha;
        else
            valAlpha(i) = expAlpha;
        end
        if(round(s_bar/valAlpha(i)) < nbData)
            valAlpha(i) = s_bar / nbData;
        end
        PHI_coor{i} = computeBasisFunction(s_bar,M(1), length(speInputs), valAlpha(i), round(s_bar/valAlpha(i)), c(1), h(1), nbData);

        %matrix of basis functions for all data that correspond to the first
        %nbData with phasis alpha_mean
        PHI{i} =  computeBasisFunction(s_bar,M, nbInput, valAlpha(i), round(s_bar/valAlpha(i)), c, h, round(s_bar/valAlpha(i)));%blkdiag(PHI_coor{i},PHI_forces{i}); %PHI_coor{i};

        %we compute the learned distribution trajectory of cartesian position
        u{i} = PHI_coor{i}*mu_w_coord{i};
        sigma{i} = PHI_coor{i}*sigma_w_coord{i}*PHI_coor{i}' + expNoise*eye(size(PHI_coor{i}*sigma_w_coord{i}*PHI_coor{i}'));

        %TODO change this part: from the initial movement it is more correct to
        %compare the distance than le likelihood 
        %we compute the probability it correspond to the actual trial
        %dataTest = reshape(,[],numel(obsTraj.data))';
        prob{i}= - mean(abs( obsTraj.partialTraj-u{i}));     

        %we record the max of probability to know wich distribution we
        %recognize
        if(prob{i} > reco{2})
            reco{2} = prob{i};
            reco{1} = i;
        end
    end

    % disp(['The recognize trajectory is the number ', num2str(reco{1})])
     typeReco= reco{1};
    %we retrieve the computed distribution that correspond to the recognized
    %trajectory
    mu_new = promps{reco{1}}.mu_w;
    sigma_new = promps{reco{1}}.sigma_w;

    %we aren't suppose to know "realData",  here it is only used to draw the real
    %trajectory of the sample if we continue it to the end

    %display(['The real phasis is ', num2str(obsTraj.alpha), ' with total time : ', num2str(obsTraj.totTime) ])
    %display(['The supposed phasis is ', num2str(expAlpha), ' with total time : ', num2str(z / expAlpha) ])

    %%Creation of the basis function with mean phasis & nbData iterations

    infTraj.alpha =  valAlpha(reco{1}) ;%   valAlpha(typeReco);
    infTraj.timeInf = round(s_bar / valAlpha(reco{1}));% round(s_bar / infTraj.alpha);
    infTraj.PHI = PHI{reco{1}};
    ma = ones(1,nbData);
    mc = zeros(1,round(s_bar /infTraj.alpha)); 
    mb = zeros(1,round(s_bar /infTraj.alpha)- nbData); 
    ma = [ma, mb]; % 1 for data we know 0 for the others
    mk = []; % C/C the mask for other data
    for vv = 1:nbInput
        if(isempty(find (speInputs==vv)))
            mk = [mk, mc];
        else
            mk = [mk, ma];              
        end
    end
    
    mask = logical(mk);

    %creation  of the basis function matrix
    PHI_update = infTraj.PHI(mask,:);

    %distribution update
    K = sigma_new*PHI_update' / (expNoise*eye(size(PHI_update*sigma_new*PHI_update')) + PHI_update*sigma_new*PHI_update');
    mu_new = mu_new + K* (obsTraj.partialTraj - PHI_update*mu_new);
    sigma_new = sigma_new - K*(PHI_update*sigma_new);

    infTraj.mu_w = mu_new;
    infTraj.sigma_w = sigma_new;
    infTraj.reco = reco{1}; 

 else

     
    for i=1:nbKindOfTraj
        tmp_int = (speInputs(1)-1)*M(1)+1:speInputs(2)*M(1);
        mu_w_coord{i} = promps{i}.mu_w(tmp_int);
        sigma_w_coord{i} = promps{i}.sigma_w(tmp_int,tmp_int);
    end

    % we compute for each learned distribution the loglikelihood that this
    % movement correspond to the distribution
    reco = {0 , -Inf };
    for i=1:nbKindOfTraj
        %matrix of cartesian basis functions that correspond to the first nbData
        if(expAlpha == -1 || isnan(expAlpha))
            valAlpha(i) = promps{i}.mu_alpha;
        else
            valAlpha(i) = expAlpha;
        end
        if(round(s_bar/valAlpha(i)) < nbData)
            valAlpha(i) = s_bar / nbData;
        end
        PHI_coor{i} = computeBasisFunction(s_bar,M(1), length(speInputs(1):speInputs(2)), valAlpha(i), round(s_bar/valAlpha(i)), c(1), h(1), nbData);
        %matrix of forces basis functions that correspond to the first nbData
        %PHI_forces{i} = computeBasisFunction(z,nbFunctions(2), promps{i}.traj.nbInput(2),promps{i}.mu_alpha, round(z/promps{i}.mu_alpha), center_gaussian(2), h(2), nbData);%computeBasisForces(z,nbFunctions(2),mu_alpha(i), round(z/mu_alpha(i)), h, nbData);

        %matrix of basis functions for all data that correspond to the first
        %nbData with phasis alpha_mean
        PHI{i} =  computeBasisFunction(s_bar,M, nbInput, valAlpha(i), round(s_bar/valAlpha(i)), c, h, round(s_bar/valAlpha(i)));%blkdiag(PHI_coor{i},PHI_forces{i}); %PHI_coor{i};

        %we compute the learned distribution trajectory of cartesian position
        u{i} = PHI_coor{i}*mu_w_coord{i};
        sigma{i} = PHI_coor{i}*sigma_w_coord{i}*PHI_coor{i}' + expNoise*eye(size(PHI_coor{i}*sigma_w_coord{i}*PHI_coor{i}'));

        %TODO change this part: from the initial movement it is more correct to
        %compare the distance than le likelihood 
        %we compute the probability it correspond to the actual trial
        %dataTest = reshape(,[],numel(obsTraj.data))';
        prob{i}= - mean(abs( obsTraj.partialTraj-u{i}));     

        %we record the max of probability to know wich distribution we
        %recognize
        if(prob{i} > reco{2})
            reco{2} = prob{i};
            reco{1} = i;
        end
    end

    % disp(['The recognize trajectory is the number ', num2str(reco{1})])
     typeReco= reco{1};
    %we retrieve the computed distribution that correspond to the recognized
    %trajectory
    mu_new = promps{reco{1}}.mu_w;
    sigma_new = promps{reco{1}}.sigma_w;

    %we aren't suppose to know "realData",  here it is only used to draw the real
    %trajectory of the sample if we continue it to the end

    %display(['The real phasis is ', num2str(obsTraj.alpha), ' with total time : ', num2str(obsTraj.totTime) ])
    %display(['The supposed phasis is ', num2str(expAlpha), ' with total time : ', num2str(z / expAlpha) ])

    %%Creation of the basis function with mean phasis & nbData iterations

    infTraj.alpha =  valAlpha(reco{1}) ;%   valAlpha(typeReco);
    infTraj.timeInf = round(s_bar / valAlpha(reco{1}));% round(s_bar / infTraj.alpha);
    infTraj.PHI = PHI{reco{1}};
    ma = ones(1,nbData);
    mc = zeros(1,round(s_bar /infTraj.alpha)); 
    mb = zeros(1,round(s_bar /infTraj.alpha)- nbData); 
    ma = [ma, mb]; % 1 for data we know 0 for the others
    mk = []; % C/C the mask for other data
    for vv = 1:(speInputs(1) - 1)  %nbInput
        mk = [mk, mc];
    end
    for vv = speInputs(1):speInputs(2)
        mk = [mk, ma];  
    end
    for vv = (speInputs(2)+1):nbInput
        mk = [mk, mc]; 
    end 
    mask = logical(mk);

    %creation  of the basis function matrix
    PHI_update = infTraj.PHI(mask,:);

    %distribution update
    K = sigma_new*PHI_update' / (expNoise*eye(size(PHI_update*sigma_new*PHI_update')) + PHI_update*sigma_new*PHI_update');
    mu_new = mu_new + K* (obsTraj.partialTraj - PHI_update*mu_new);
    sigma_new = sigma_new - K*(PHI_update*sigma_new);

    infTraj.mu_w = mu_new;
    infTraj.sigma_w = sigma_new;
    infTraj.reco = reco{1}; 



end