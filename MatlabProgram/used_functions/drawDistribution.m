function drawDistribution(promp, list,s_ref, varargin)
%DRAWDISTRIBUTION draws the learned distribution



nbInputs = sum(promp.traj.nbInput);
interval = [1:nbInputs];
col1='b';
col2='m';
xLabelName = 'Normalized #samples';
flag_mean = 0;
flag_realT = 0;
flag_ymin = 0;
flag_xmin = 0;
flag_yminAndMax = 0;
flag_xminAndMax = 0;
flag_oulad = 0;
numFig=10;
shaded=0;
without=0;%to not draw original data
if(~isempty(varargin))
    for i=1:length(varargin)
        
        if(strcmp(varargin{i},'without')==1)
            without=1;
        elseif(strcmp(varargin{i},'xLabelName')==1)
            xLabelName=varargin{i+1};
        elseif(strcmp(varargin{i},'interval')==1)
            interval=varargin{i+1};
            nbInputs = length(interval);
        elseif(strcmp(varargin{i},'shaded')==1)
            shaded=1;
        elseif(strcmp(varargin{i},'col')==1)
            i=i+1;
            col1 = varargin{i};
            if(col1 =='b' | col1==[0.5,0.5,1] | col1==[0.8,0.8,1])
                col2 = ':blue';
            elseif(col1=='g' | col1==[0.5,1,0.5] | col1==[0.8,1,0.8])
                col2 = ':green';
            elseif(col1=='r'| col1==[1,0.5,0.5]| col1==[1,0.8,0.8])
                col2 = ':red';
            elseif(col1=='k')
                col2 = ':black';
            elseif(col1=='c')
                col2 = ':cyan';
            elseif(col1=='w')
                col2 = ':white';
            elseif(col1=='y')
                col2 = ':yellow';
            end
        elseif(strcmp(varargin{i},'fig'))
            numFig= varargin{i+1};
        elseif(strcmp(varargin{i},'mean'))
            flag_mean = 1;
        elseif(strcmp(varargin{i},'realT'))
            flag_realT = 1;
        elseif(strcmp(varargin{i}, 'ymin'))
            flag_ymin = 1;
            yminn = varargin{i+1};
        elseif(strcmp(varargin{i}, 'xmin'))
            flag_xmin = 1;
            xminn = varargin{i+1};
        elseif(strcmp(varargin{i}, 'ymax'))
            flag_yminAndMax = 1;
            ymax = varargin{i+1};
        elseif(strcmp(varargin{i}, 'xmax'))
            flag_xminAndMax = 1;
            xmax = varargin{i+1};
        elseif(strcmp(varargin{i},'OULAD')==1) %specific to OULAD data clicks/marks/delays
            %col2 = strrep(col2,':','+')
            flag_oulad = 1;
        end
    end
end
fig = figure(numFig);hold on;

set(0,'DefaultLineLinewidth',1)
set(0,'DefaultAxesFontSize',20)
if(size(interval)==[3,3])
    subplotInfo=  size(interval,1);%ceil(nbInputs/2);
    subplotInfo2 = size(interval,2);
elseif(nbInputs >3)
    subplotInfo=  ceil(nbInputs/2);
    subplotInfo2 = 2;
else
    subplotInfo=  nbInputs;
    subplotInfo2 = 1;
end

cpt=1;
for i=reshape(interval',1,[])
    subplot(subplotInfo,subplotInfo2,cpt);
    
    if(flag_mean == 1)
        meanTraj =promp.PHI_mean*promp.mu_w;
        fig = visualisationShared(meanTraj, promp.PHI_mean*1.96*sqrt(diag(promp.sigma_w )), sum(promp.traj.nbInput), promp.meanTimes,  i, col1, fig,'vecX', [promp.meanInterval:promp.meanInterval:promp.meanTimes*promp.meanInterval], 'shaded',shaded);
        if(without==0)
            if(length(col2) ==3)
                for j = 1 : max(promp.traj.nbTraj,10)
                    fig(size(fig,2) + 1) =  plot([promp.traj.interval(j):promp.traj.interval(j):promp.traj.totTime(j)*promp.traj.interval(j)],promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), 'color', col2,'linewidth',0.5);hold on;
                end
            else
                if(flag_oulad==1 && i>1) %case mark or delays in oulad dataset
                    for j = 1 : max(promp.traj.nbTraj,10)
                       dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
                       idTableExam0 = zeros(size(dateExam));
                       idTableExam = zeros(size(dateExam));
                       idTableExam2 = zeros(size(dateExam));
                       %knowing that data goes from -18 -13 ... 256 (all 5 days) ==> 55
                       for k =1:size(dateExam,2)
                           idTableExam0(k) = floor((dateExam(k) +18)/5)+1;
                           idTableExam(k) = floor((dateExam(k) +18)/5)+1 + mintmp;
                           idTableExam2(k) = floor((dateExam(k) +18)/5)+1 + mintmp*2;
                       end
                       if(i==2)
                           fig(size(fig,2) + 1) =  plot(idTableExam0, promp.traj.y{j}(idTableExam), '-+b');hold on;
                       else
                           fig(size(fig,2) + 1) =  plot(idTableExam0, promp.traj.y{j}(idTableExam2), '-+b');hold on;
                       %fig(size(fig,2) + 1) =  plot([promp.traj.interval(j):promp.traj.interval(j):promp.traj.totTime(j)*promp.traj.interval(j)],promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), strrep(col2,':','+'),'linewidth',0.5);hold on;
                       end
                    end
                else
                    for j = 1 : max(promp.traj.nbTraj,10)
                        fig(size(fig,2) + 1) =  plot([promp.traj.interval(j):promp.traj.interval(j):promp.traj.totTime(j)*promp.traj.interval(j)],promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), col2,'linewidth',0.5);hold on;
                    end
                end
            end
        end
        
        datG = size(fig,2);
        if(length(col1) ==3)
            fig(size(fig,2) + 1) =  plot([promp.meanInterval:promp.meanInterval:promp.meanTimes*promp.meanInterval],meanTraj(1 + promp.meanTimes*(i-1):promp.meanTimes*i), 'color', col1,'linewidth', 2);
        else
            fig(size(fig,2) + 1) =  plot([promp.meanInterval:promp.meanInterval:promp.meanTimes*promp.meanInterval],meanTraj(1 + promp.meanTimes*(i-1):promp.meanTimes*i), col1,'linewidth', 2);
        end
        set(gca, 'fontsize', 20);
        disG = size(fig,2);
        ylabel(list{i}, 'fontsize', 20);
        %  list1 =  {'sep','oct','nov','dec','jan','feb','mar','apr','may','jun','jul','aug'};
        % xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
        %  xticklabels(list1);
        
        if(i==interval(nbInputs))%promp.traj.nbInput(1))
            xlabel('Mois', 'fontsize', 20);
        end
    else
        meanTraj =promp.PHI_norm*promp.mu_w;
        fig = visualisationShared(meanTraj, promp.PHI_norm*1.96*sqrt(diag(promp.sigma_w )), sum(promp.traj.nbInput), s_ref,  i, col1, fig, 'shaded',shaded);
        if(without==0)
            for j = 1 : promp.traj.nbTraj
                if(length(col2) ==3)
                    fig(size(fig,2) + 1) =  plot([promp.traj.alpha(j):promp.traj.alpha(j):s_ref], promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), 'color', col2,'linewidth',0.5);hold on;
                else
                  if(flag_oulad==1 && i>1) %case mark or delays in oulad dataset
                       dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
                       idTableExam0 = zeros(size(dateExam));
                       idTableExam = zeros(size(dateExam));
                       idTableExam2 = zeros(size(dateExam));
                       %knowing that data goes from -18 -11 ... 261 (all 7 days) ==> 40
                       for k =1:size(dateExam,2)
                           idTableExam0(k) = floor((dateExam(k) +18)/7)+1;
                           idTableExam(k) = floor((dateExam(k) +18)/7)+1 + mintmp;
                           idTableExam2(k) = floor((dateExam(k) +18)/7)+1 + mintmp*2;
                       end
                       if(i==2)
                           fig(size(fig,2) + 1) =  plot(idTableExam0, promp.traj.y{j}(idTableExam), strrep(col2,':',':+'));hold on;
                       else
                           fig(size(fig,2) + 1) =  plot(idTableExam0, promp.traj.y{j}(idTableExam2), strrep(col2,':',':+'));hold on;
                       %fig(size(fig,2) + 1) =  plot([promp.traj.interval(j):promp.traj.interval(j):promp.traj.totTime(j)*promp.traj.interval(j)],promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), strrep(col2,':','+'),'linewidth',0.5);hold on;
                       end
                    
                  else  
                    mintmp = s_ref;
                    if(mintmp > promp.traj.totTime(j))
                        mintmp = promp.traj.totTime(j);
                        if(promp.traj.alpha(j) ~=1)
                            display('erreuuuur');
                        end
                    end
                    fig(size(fig,2) + 1) =  plot([promp.traj.alpha(j):promp.traj.alpha(j):mintmp], promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), col2,'linewidth',0.5);hold on;
                  end
                end
            end
        end
        
        if(length(col1) ==3)
            fig(size(fig,2) + 1) =  plot(meanTraj(1 + s_ref*(i-1):s_ref*i), 'color',col1,'linewidth', 2);
            datG = size(fig,2);
        else
            fig(size(fig,2) + 1) =  plot(meanTraj(1 + s_ref*(i-1):s_ref*i), col1,'linewidth', 2);
            datG = size(fig,2);
        end
        set(gca, 'fontsize', 20);
        disG = size(fig,2);
        ylabel(list{i}, 'fontsize', 20);
        %list1 = [1:30:300];
        
        %list1 =  {'sep','oct','nov','dec','jan','feb','mar','apr','may','jun','jul','aug'};
        %xticks([1:2:20])
        %xticklabels(list1)
        if(i==sum(promp.traj.nbInput))
            xlabel(xLabelName, 'fontsize', 20);
        end
    end
    %  fig = visualisation(promp.PHI_norm*promp.mu_w, sum(promp.traj.nbInput), s_ref,  i, 'g', fig);
    
    set(gca, 'fontsize', 20);
    if(flag_yminAndMax)
       ytmp = ylim;
       minn = ytmp(1);
      % if(abs(yminn(cpt)) < abs(minn))
           minn = yminn(cpt);
      % end
       maxx = ytmp(2);
      % if(abs(ymax(cpt)) < abs(maxx))
           maxx = ymax(cpt);
      % end
       ylim([minn, maxx]); 
    elseif(flag_ymin)
       ytmp = ylim;
       minn = ytmp(1);
       %if(abs(yminn(cpt)) < abs(minn))
           minn = yminn(cpt);
       %end
       ylim([minn, ytmp(2)]);
    end
    if(flag_xminAndMax)
       xtmp = xlim;
       minn = xtmp(1);
      % if(abs(yminn(cpt)) < abs(minn))
           minn = xminn(cpt);
      % end
       maxx = xtmp(2);
      % if(abs(ymax(cpt)) < abs(maxx))
           maxx = xmax(cpt);
      % end
       xlim([minn, maxx]); 
    end
    
    
    cpt = cpt+1;
end
%    legend(fig([disG,datG]), 'Distribution learned','Observed data', 'Location', 'Northwest');
end