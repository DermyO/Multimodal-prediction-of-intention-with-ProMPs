function drawInferenceRescaled(promp,ylabell, infTraj, test,s_ref, varargin)


nbInput = promp{1}.traj.nbInput;
set(0,'DefaultLineLinewidth',1)
set(0,'DefaultAxesFontSize',12)
knownTitle = 0;
isInterval=0;
%recoData = nbInput;
recoData = 1;
shaded=0;
sh=0.5;
if(~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'Interval')==1)
            isInterval=1;
            interval = varargin{i+1};
        elseif(strcmp(varargin{i},'recoData')==1)
            recoData = varargin{i+1};
        elseif(strcmp(varargin{i},'shaded')==1)
            shaded=1;
        elseif(strcmp(varargin{i},'xlim')==1)
            xlimss= varargin{i+1};
        elseif(strcmp(varargin{i},'ylim')==1)
            ylimss = varargin{i+1};
        elseif(strcmp(varargin{i},'xmin')==1)
            xmin= varargin{i+1};
        elseif(strcmp(varargin{i},'ymin')==1)
            ymin= varargin{i+1};
            %         elseif(strcmp(varargin{i},'Title')==1)
            %             i = i+1;
            %             titleFig = varargin{i};
            %             knownTitle = 1;
        elseif(strcmp(varargin{i},'yminForInput')==1)
            inputRescale = varargin{i+1};
            ymin= varargin{i+2};
        end
    end
end

if(isInterval==1)
    %Plot the total trial and the data we have
nameFig = figure;
cpt=0;

    i = infTraj.reco;%reco{1};
    titleFig = promp{i}.traj.label;


for vff=interval
    cpt=cpt+1;
    subplot(ceil(length(interval)/2),2,cpt);
    
    if(shaded==1)
        visualisationShared(promp{i}.PHI_norm*promp{i}.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(promp{i}.sigma_w )), sum(nbInput), s_ref,  vff, 'b', nameFig, 'shaded', 0.5);
        nameFig = visualisation(promp{i}.PHI_norm*promp{i}.mu_w, sum(nbInput), s_ref, vff, 'b', nameFig);
        prevG = size(nameFig,2);
        visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', 'shaded', nameFig, 'shaded', 0.5);
    else    
        visualisationShared(promp{i}.PHI_norm*promp{i}.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(promp{i}.sigma_w )), sum(nbInput), s_ref,  vff, 'b', nameFig);
        nameFig = visualisation(promp{i}.PHI_norm*promp{i}.mu_w, sum(nbInput), s_ref, vff, 'b', nameFig);
        prevG = size(nameFig,2);
        visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);
    end
    %    visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);
    %    visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);
    
    nameFig = visualisation(promp{i}.PHI_norm*infTraj.mu_w, sum(nbInput), s_ref, vff, 'r', nameFig);
    newG = size(nameFig,2);
    nameFig = visualisation2(test.yMat,sum(nbInput), test.totTime,vff, ':k', s_ref / test.totTime, nameFig);hold on;
    dtG = size(nameFig,2);
    if(ismember(vff,recoData))
        init = recoData(1);
        nameFig(size(nameFig,2) + 1) = plot(test.partialTraj(1+ test.nbData*(vff-init):(infTraj.timeInf/s_ref): test.nbData*(vff-init+1)),'ok','linewidth',3);
        dnG = size(nameFig,2);
    end
    ylabel(ylabell{vff}, 'fontsize', 24);
    if(exist('axiss','var'))
        axis(axiss);
    end
    %            switch vff
    %                case 1: axis([-0.35 -0.25 0 100]);
    %                case 2: asis([-0.1 0 0 100]);
    %                case 3: axis([-0.1 0.2]);
    %            end
    if(vff == 1)
        title(titleFig);
        elseif(vff==length(interval)/2)
              xlabel('Normalized #samples', 'fontsize', 24);
         end
         set(gca, 'fontsize', 20)
         
end
legend(nameFig(1,[dtG, dnG, prevG, newG]),'real trajectory', 'observations','prior proMP', 'prediction', 'Location', 'northeast' );
   if(knownTitle ==1)
       title(titleFig);
   end
else
    %Plot the total trial and the data we have
    nameFig = figure;
        i = infTraj.reco;%reco{1};
    
        titleFig = promp{i}.traj.label;

    for vff=1:nbInput(1)
        subplot(nbInput(1),1,vff);

        if(shaded==1)
            visualisationShared(promp{i}.PHI_norm*promp{i}.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(promp{i}.sigma_w )), sum(nbInput), s_ref,  vff, 'b',  nameFig, 'shaded', 0.5);
            nameFig = visualisation(promp{i}.PHI_norm*promp{i}.mu_w, sum(nbInput), s_ref, vff, 'b', nameFig);
            prevG = size(nameFig,2);
            visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig,'shaded', 0.5);
        %    visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);
        %    visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);

            nameFig = visualisation(promp{i}.PHI_norm*infTraj.mu_w, sum(nbInput), s_ref, vff, 'r', nameFig);
            newG = size(nameFig,2);
            nameFig = visualisation2(test.yMat,sum(nbInput), test.totTime,vff, ':k', s_ref / test.totTime,nameFig);hold on;
            dtG = size(nameFig,2);
        else
            visualisationShared(promp{i}.PHI_norm*promp{i}.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(promp{i}.sigma_w )), sum(nbInput), s_ref,  vff, 'b', nameFig);
            nameFig = visualisation(promp{i}.PHI_norm*promp{i}.mu_w, sum(nbInput), s_ref, vff, 'b', nameFig);
            prevG = size(nameFig,2);
            visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);
        %    visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);
        %    visualisationShared(promp{i}.PHI_norm*infTraj.mu_w, promp{i}.PHI_norm*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), s_ref,  vff,'r', nameFig);

            nameFig = visualisation(promp{i}.PHI_norm*infTraj.mu_w, sum(nbInput), s_ref, vff, 'r', nameFig);
            newG = size(nameFig,2);
            nameFig = visualisation2(test.yMat,sum(nbInput), test.totTime,vff, ':k', s_ref / test.totTime, nameFig);hold on;
            dtG = size(nameFig,2);           
        end
        
        if(ismember(vff,recoData))
            init = recoData(1);
       %     nameFig(size(nameFig,2) + 1) = plot(test.partialTraj(1+ test.nbData*(vff-init+1):(infTraj.timeInf/s_ref): test.nbData*(vff-init+2)),'ok','linewidth',3);
         %   nameFig(size(nameFig,2) + 1) = plot(test.partialTraj(1+ test.nbData*(vff-init+1): test.nbData*(vff-init+2)),'ob','linewidth',3);
             nameFig(size(nameFig,2) + 1) = plot([(s_ref/test.totTime):(s_ref/test.totTime):(s_ref/test.totTime)*test.nbData],test.partialTraj(1+ test.nbData*(vff-init): test.nbData*(vff-init+1)),'ob','linewidth',3);
             dnG = size(nameFig,2);
           %  nameFig(size(nameFig,2) + 1) = plot(test.partialTraj(1+ test.nbData*(vff-init): test.nbData*(vff-init+1)),'xb','linewidth',1); 
        end

        ylabel(ylabell{vff}, 'fontsize', 24);
        if(exist('xlimss','var'))
            xlim(xlimss);
        elseif(exist('xmin','var'))
            xtmp = xlim;
            xlim([xmin, xtmp(2)]);
        end
        if(exist('ylimss','var'))
            ylim(ylimss);
        elseif(exist('ymin','var'))
            if(exist('inputRescale'))
                if(vff == inputRescale)
                    ytmp = ylim;
                    ylim([ymin, ytmp(2)]);
                end
            else
                ytmp = ylim;
                ylim([ymin, ytmp(2)]);
            end
        end
        
        if(vff == 1)
            title(titleFig);
        elseif(vff==nbInput(1))
            xlabel('Normalized #samples', 'fontsize', 24);
        end
        set(gca, 'fontsize', 20)
        
    end
    legend(nameFig(1,[dtG, dnG, prevG, newG]),'real trajectory', 'observations','prior proMP', 'prediction', 'Location', 'northeast' );
    if(knownTitle ==1)
       title(titleFig);
   end
end
end