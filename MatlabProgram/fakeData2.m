function fakeData = fakeData2(promp, nbProMP, n,t, nbInput,M,s_bar,c,h,expNoise,inputName, varargin)
%FAKEDATA2 create n fictive data from the given a PromP. Improvement with
%fakeData: doesn't predict the good promp (known a priori)
%varargin : we can precise in which figure we want to plot.

% 1) take two random numbers (i,j) between 1 and promp.nbTraj.
% 2) take 1/4 of min_{i,j}(promp.traj{min}.totTime).
% 3) Create a fake beginning of a trajectory
% 4) infer the continuation of the trajectory.
% 5) Plot this new trajectory with the ProMP.
% 6) Record it in a new file.

has_ymin=0;
figNumber =10;
flag_file = 1;
kernel = 'gaussian';
if (~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'fig')==1)
            figNumber = varargin{i+1};
        elseif(strcmp(varargin{i},'ymin')==1)
            has_ymin = 1;
            ymin = varargin{i+1};
        elseif(strcmp(varargin{i},'Periodic')==1)
            kernel = 'Periodic';
        end
    end
end

test2 = cell(n);
col = 'b';
switch nbProMP
    case 1 
        col = 'b';
    case 2 
        col = 'g';
    case 3 
        col = 'r';
    case 4 
        col = 'k';
    otherwise
        col = 'm';
end
if(has_ymin==0)
    drawDistribution(promp, inputName,s_bar, 'col', col, 'ymin', [0,0,-50],'ymax', [1500,100,300], 'xmin', [1,1,1], 'xmax', [t{1}.totTime(1),t{1}.totTime(1),t{1}.totTime(1)], 'fig',figNumber);
else
    drawDistribution(promp, inputName,s_bar, 'col', col, 'ymin', ymin, 'fig',figNumber);  
    
end
for new=1:n  %for all trajectories to create
    i = floor(1 + (promp.traj.nbTraj - 1)*rand(1)); %random traj 1
    %random traj2
    j=i; 
    while (j==i)
       j =  floor(1 + (promp.traj.nbTraj - 1)*rand(1));
    end
    
    %time init
    min = promp.traj.totTime(i);
    if(min > promp.traj.totTime(j))
        min = promp.traj.totTime(j);
    end
    nbTime = floor(min/4);
    
    test2{new}.nbData = nbTime;
    
    %random ponderation between 0.1 to 0.9
    alpha = 0.1 + 0.8*rand(1);
    beta = 1 - alpha;
    if(alpha <0 || alpha >1 || beta <0 || beta >1)
        s = "error : alpha=" + alpha;
        display(s);
    end
    
    %fill data
    totTimei = promp.traj.totTime(i);
    totTimej = promp.traj.totTime(j);
    for inp =1 : nbInput(1)
        for time = 1: nbTime 
           test2{new}.partialTraj(time + ((inp-1)*nbTime)) = alpha*promp.traj.y{i}(totTimei*(inp-1) + time) + beta*promp.traj.y{j}(totTimej*(inp-1) + time);
           test2{new}.partialTrajMat(time,inp) = alpha*promp.traj.y{i}(totTimei*(inp-1) + time) + beta*promp.traj.y{j}(totTimej*(inp-1) + time);
        end
    end
    test2{new}.partialTraj= test2{new}.partialTraj';
    test = test2{new};
    w = computeAlpha(test.nbData,t, nbInput,M,s_bar,c,h,expNoise);
    promp.w_alpha = w{1};
    alphaTraj = 1;
    promps{1} = promp;
    fakeData{new} = inference(promps, test, M, s_bar, c, h, test.nbData, expNoise, alphaTraj, nbInput, kernel);
    fig = figure(figNumber);
    posterior{new} = fakeData{new}.PHI*fakeData{new}.mu_w;
    posterior{new} = controlExtremValues(posterior{new},s_bar);
end

%create file with new data
if(flag_file ==1)
    className = ["Distinction","Pass","Withdrawn","Fail"];
    name = strcat('fake_data_Periodic2_', className(nbProMP), '.csv')
    fid = fopen(name, 'wt')
    fprintf(fid, 'totClicks_1,totClicks_2,totClicks_3,totClicks_4,totClicks_5,totClicks_6,totClicks_7,totClicks_8,totClicks_9,totClicks_10,totClicks_11,totClicks_12,totClicks_13,totClicks_14,score_1,score_2,score_3,score_4,score_5,score_6,score_7,score_8,score_9,score_10,score_11,score_12,score_13,score_14,delay_1,delay_2,delay_3,delay_4,delay_5,delay_6,delay_7,delay_8,delay_9,delay_10,delay_11,delay_12,delay_13,delay_14\n');
    for i=1:n
        sinit= "";
        for time=1:41
            sinit=strcat(sinit, "%f,");
        end
        sinit= strcat(sinit,"%f\n");
        
        fprintf(fid, sinit, posterior{i}(1), posterior{i}(2), posterior{i}(3), posterior{i}(4), posterior{i}(5), posterior{i}(6), posterior{i}(7), posterior{i}(8), posterior{i}(9), posterior{i}(10), posterior{i}(11), posterior{i}(12), posterior{i}(13), posterior{i}(14), posterior{i}(15), posterior{i}(16), posterior{i}(17), posterior{i}(18), posterior{i}(19), posterior{i}(20), posterior{i}(21), posterior{i}(22), posterior{i}(23), posterior{i}(24), posterior{i}(25), posterior{i}(26), posterior{i}(27), posterior{i}(28), posterior{i}(29), posterior{i}(30), posterior{i}(31), posterior{i}(32), posterior{i}(33), posterior{i}(34), posterior{i}(35), posterior{i}(36), posterior{i}(37), posterior{i}(38), posterior{i}(39), posterior{i}(40), posterior{i}(41), posterior{i}(42));
    end
    fclose(fid);  
end


for i=1:n
    mintmp = s_bar;
    if(sum(nbInput)>1)
        for inp = 1:sum(nbInput)
            subplot(sum(nbInput),1,inp);
            fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:mintmp], posterior{i}(1 + mintmp*(inp-1) :mintmp*inp), 'r');hold on;
            if(inp <= nbInput(1))
                fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:test2{i}.nbData], test2{i}.partialTraj(1 + test2{i}.nbData*(inp-1) :test2{i}.nbData*inp), 'ok');hold on;
            end
        end
    else
        fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:mintmp], posterior{i}(1:mintmp), 'r');hold on;
        fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:test2{i}.nbData], test2{i}.partialTraj(1 :test2{i}.nbData), 'ok');hold on;
    end
end



end

