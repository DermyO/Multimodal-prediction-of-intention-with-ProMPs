function drawDistribution2(promp, promp2, list,s_ref, varargin)
%DRAWDISTRIBUTION2 is based on drawdistribution but where there is two
%ProMPs to draw

set(0,'DefaultLineLinewidth',1)
set(0,'DefaultAxesFontSize',20)


nbInputs = sum(promp.traj.nbInput)*2;
interval = [1:sum(promp.traj.nbInput)];
col1='b';
col2='m';
flag_mean = 0;
flag_realT = 0;
numFig=10;
shaded=0;
without=0;%to not draw original data
if(~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'without')==1)
            without=1;
        elseif(strcmp(varargin{i},'interval')==1)
            interval=varargin{i+1};
            nbInputs = length(interval)*2;
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
            
         %   fig = figure(10);
            hold on;
        elseif(strcmp(varargin{i},'fig'))
            numFig= varargin{i+1};
        elseif(strcmp(varargin{i},'mean'))
            flag_mean = 1; 
        elseif(strcmp(varargin{i},'realT'))
            flag_realT = 1;
        end
    end
end
fig = figure(numFig);hold on;
    if(nbInputs> 6)
        subplotInfo=  ceil(nbInputs/4);
        subplotInfo2 = 4;
    else
        subplotInfo=  ceil(nbInputs/2);
        subplotInfo2 = 2;
    end
% elseif(size(interval)==[3,3]) 
%     subplotInfo=  size(interval,1);%ceil(nbInputs/2);
%     subplotInfo2 = size(interval,2);
% elseif(nbInputs >3)
%     subplotInfo=  ceil(nbInputs/2);
%     subplotInfo2 = 2;
% else
%     subplotInfo=  nbInputs;
%     subplotInfo2 = 1;
% end

    x=floor(nbInputs/4);
    cpt3=0;
    cpt=1+2*cpt3;
    cpt2=2+2*cpt3;
    
    for i=reshape(interval',1,[])
        
        subplot(subplotInfo,subplotInfo2,cpt);
              display('cpt=');
              cpt
        if(flag_mean == 1)
            meanTraj =promp.PHI_mean*promp.mu_w;
            fig = visualisationShared(meanTraj, promp.PHI_mean*1.96*sqrt(diag(promp.sigma_w )), sum(promp.traj.nbInput), promp.meanTimes,  i, col1, fig,'vecX', [promp.meanInterval:promp.meanInterval:promp.meanTimes*promp.meanInterval], 'shaded',shaded);
            if(without==0)
                if(length(col2) ==3)
                    for j = 1 : max(promp.traj.nbTraj,10)
                        fig(size(fig,2) + 1) =  plot([promp.traj.interval(j):promp.traj.interval(j):promp.traj.totTime(j)*promp.traj.interval(j)],promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), 'color', col2,'linewidth',0.5);hold on;
                    end
                else
                    for j = 1 : max(promp.traj.nbTraj,10)
                        fig(size(fig,2) + 1) =  plot([promp.traj.interval(j):promp.traj.interval(j):promp.traj.totTime(j)*promp.traj.interval(j)],promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), col2,'linewidth',0.5);hold on;
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
            list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'}; 
            xticks([1 2 3 4 5 6 7 8 9 10 11 12])
            xticklabels(list1)
            
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
                        fig(size(fig,2) + 1) =  plot([promp.traj.alpha(j):promp.traj.alpha(j):s_ref], promp.traj.y{j}(1 + promp.traj.totTime(j)*(i-1) :promp.traj.totTime(j)*i), col2,'linewidth',0.5);hold on;
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
               list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'}; 
            xticks([1 2 3 4 5 6 7 8 9 10 11 12])
            xticklabels(list1)
            if(i==promp.traj.nbInput(1))
                xlabel('Normalized #samples', 'fontsize', 20);
            end  
        end
          %  fig = visualisation(promp.PHI_norm*promp.mu_w, sum(promp.traj.nbInput), s_ref,  i, 'g', fig);
            
         set(gca, 'fontsize', 20);
         
         %%%Deuxieme ProMP
         subplot(subplotInfo,subplotInfo2,cpt2);
           display('cpt2=')
           cpt2
        if(flag_mean == 1)
            meanTraj =promp2.PHI_mean*promp2.mu_w;
            fig = visualisationShared(meanTraj, promp2.PHI_mean*1.96*sqrt(diag(promp2.sigma_w )), sum(promp2.traj.nbInput), promp2.meanTimes,  i, col1, fig,'vecX', [promp2.meanInterval:promp2.meanInterval:promp2.meanTimes*promp2.meanInterval], 'shaded',shaded);
            if(without==0)
                if(length(col2) ==3)
                    for j = 1 : max(promp2.traj.nbTraj,10)
                        fig(size(fig,2) + 1) =  plot([promp2.traj.interval(j):promp2.traj.interval(j):promp2.traj.totTime(j)*promp2.traj.interval(j)],promp2.traj.y{j}(1 + promp2.traj.totTime(j)*(i-1) :promp2.traj.totTime(j)*i), 'color', col2,'linewidth',0.5);hold on;
                    end
                else
                    for j = 1 : max(promp2.traj.nbTraj,10)
                        fig(size(fig,2) + 1) =  plot([promp2.traj.interval(j):promp2.traj.interval(j):promp2.traj.totTime(j)*promp2.traj.interval(j)],promp2.traj.y{j}(1 + promp2.traj.totTime(j)*(i-1) :promp2.traj.totTime(j)*i), col2,'linewidth',0.5);hold on;
                    end
                end
            end
            
            datG = size(fig,2);
            if(length(col1) ==3)
                fig(size(fig,2) + 1) =  plot([promp2.meanInterval:promp2.meanInterval:promp2.meanTimes*promp2.meanInterval],meanTraj(1 + promp2.meanTimes*(i-1):promp2.meanTimes*i), 'color', col1,'linewidth', 2);  
            else
                fig(size(fig,2) + 1) =  plot([promp2.meanInterval:promp2.meanInterval:promp2.meanTimes*promp2.meanInterval],meanTraj(1 + promp2.meanTimes*(i-1):promp2.meanTimes*i), col1,'linewidth', 2);  
            end
            set(gca, 'fontsize', 20);
            disG = size(fig,2);
            ylabel(list{i}, 'fontsize', 20);
            list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'}; 
            xticks([1 2 3 4 5 6 7 8 9 10 11 12])
            xticklabels(list1)
            
            if(i==interval(nbInputs))%promp2.traj.nbInput(1))
                xlabel('Mois', 'fontsize', 20);
            end
        else
            meanTraj =promp2.PHI_norm*promp2.mu_w;
            fig = visualisationShared(meanTraj, promp2.PHI_norm*1.96*sqrt(diag(promp2.sigma_w )), sum(promp2.traj.nbInput), s_ref,  i, col1, fig, 'shaded',shaded);
            if(without==0)
                for j = 1 : promp2.traj.nbTraj
                    if(length(col2) ==3)
                        fig(size(fig,2) + 1) =  plot([promp2.traj.alpha(j):promp2.traj.alpha(j):s_ref], promp2.traj.y{j}(1 + promp2.traj.totTime(j)*(i-1) :promp2.traj.totTime(j)*i), 'color', col2,'linewidth',0.5);hold on;
                    else
                        fig(size(fig,2) + 1) =  plot([promp2.traj.alpha(j):promp2.traj.alpha(j):s_ref], promp2.traj.y{j}(1 + promp2.traj.totTime(j)*(i-1) :promp2.traj.totTime(j)*i), col2,'linewidth',0.5);hold on;
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
               list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'}; 
            xticks([1 2 3 4 5 6 7 8 9 10 11 12])
            xticklabels(list1)
            if(i==promp2.traj.nbInput(1))
                xlabel('Normalized #samples', 'fontsize', 20);
            end  
        end
          %  fig = visualisation(promp2.PHI_norm*promp2.mu_w, sum(promp2.traj.nbInput), s_ref,  i, 'g', fig);
            
         set(gca, 'fontsize', 20);
         
         
         if(cpt>3*x)
            cpt3=cpt3+1;
            cpt=1+2*cpt3;
            cpt2 = 2+2*cpt3;
         else
            cpt = cpt+x;
            cpt2 = cpt2+x;
         end
         
    end
    %    legend(fig([disG,datG]), 'Distribution learned','Observed data', 'Location', 'Northwest');
end