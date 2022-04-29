function fakeData = fakeData(promp, nbProMP, n,t, nbInput,M,s_bar,c,h,expNoise,inputName, varargin)
%FAKEDATA create n fictive data from the given PromP.
%varargin : we can precise in which figure we want to plot.

% 1) take two random numbers (i,j) between 1 and promp{nbProMP}.nbTraj.
% 2) take 1/4 of min_{i,j}(promp{nbProMP}.traj{min}.totTime).
% 3) Create a fake beginning of a trajectory
% 4) infer the continuation of the trajectory.
% 5) Plot this new trajectory with the ProMP.
% 6) Record it in a new file.

has_ymin=0;
figNumber =10;
if (~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'fig')==1)
            figNumber = varargin{i+1};
        elseif(strcmp(varargin{i},'ymin')==1)
            has_ymin = 1;
            ymin = varargin{i+1};
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
    drawDistribution(promp{nbProMP}, inputName,s_bar, 'col', col, 'ymin', [0,0,-50],'ymax', [1500,100,250], 'xmin', [1,1,1], 'xmax', [14,14,14], 'fig',figNumber);
else
    drawDistribution(promp{nbProMP}, inputName,s_bar, 'col', col, 'ymin', ymin, 'fig',figNumber);  
    
end
for new=1:n  %for all trajectories to create
    i = floor(1 + (promp{nbProMP}.traj.nbTraj - 1)*rand(1)); %random traj 1
    %random traj2
    j=i; 
    while (j==i)
       j =  floor(1 + (promp{nbProMP}.traj.nbTraj - 1)*rand(1));
    end
    
    %time init
    min = promp{nbProMP}.traj.totTime(i);
    if(min > promp{nbProMP}.traj.totTime(j))
        min = promp{nbProMP}.traj.totTime(j);
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
    totTimei = promp{nbProMP}.traj.totTime(i);
    totTimej = promp{nbProMP}.traj.totTime(j);
    for inp =1 : nbInput(1)
        for time = 1: nbTime 
           test2{new}.partialTraj(time + ((inp-1)*nbTime)) = alpha*promp{nbProMP}.traj.y{i}(totTimei*(inp-1) + time) + beta*promp{nbProMP}.traj.y{j}(totTimej*(inp-1) + time);
           test2{new}.partialTrajMat(time,inp) = alpha*promp{nbProMP}.traj.y{i}(totTimei*(inp-1) + time) + beta*promp{nbProMP}.traj.y{j}(totTimej*(inp-1) + time);
%           [promp{nbProMP}.traj.y{i}(totTimei*(inp-1) + time) , promp{nbProMP}.traj.y{j}(totTimej*(inp-1) + time), test2{new}.partialTraj(time + ((inp-1)*nbTime))]
        end
    end
    test2{new}.partialTraj= test2{new}.partialTraj';
    test = test2{new};
    w = computeAlpha(test.nbData,t, nbInput,M,s_bar,c,h,expNoise);
    for i=1:size(promp,2)
        promp{i}.w_alpha = w{i};
    end
    alphaTraj = 1;
   % [alphaTraj,type, x] = inferenceAlpha(promp,test,M,s_bar,c,h,test.nbData, expNoise, 'MO');

    fakeData{new} = inference(promp, test, M, s_bar, c, h, test.nbData, expNoise, alphaTraj, nbInput);
    fig = figure(figNumber);
    posterior{new} = fakeData{new}.PHI*fakeData{new}.mu_w;
    
   %%AVANT : test boucle for ci dessous à la place 
   % if(sum(nbInput) >1)
        %for inp = 1:sum(nbInput)
        %    subplot(sum(nbInput),1,inp);
        %    visualisation(posterior, sum(nbInput), fakeData{new}.timeInf, inp, 'r',fig);%,[intervalInf:intervalInf:RTInf]);
        %end
    %else
        %visualisation(posterior, sum(nbInput), fakeData{new}.timeInf, 1, 'r',fig);%,[intervalInf:intervalInf:RTInf]);
    %end
end

for i=1:n
%     if(sum(nbInput) >1)
%         for inp = 1:sum(nbInput)
%             subplot(sum(nbInput),1,inp);
%             visualisation(posterior, sum(nbInput), fakeData{new}.timeInf, inp, 'r',fig);%,[intervalInf:intervalInf:RTInf]);
%         end
%     else
%         visualisation(posterior, sum(nbInput), fakeData{new}.timeInf, 1, 'r',fig);%,[intervalInf:intervalInf:RTInf]);
%     end
    
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

