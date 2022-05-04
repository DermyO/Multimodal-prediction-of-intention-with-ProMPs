function drawErrorInference(promp,list, infTraj, test,s_ref, trial, varargin)

nbInput = promp{1}.traj.nbInput;
set(0,'DefaultLineLinewidth',1)
set(0,'DefaultAxesFontSize',12)

isInterval=0;
isNamed=0;
dataReco = nbInput(1);
shaded=0;
if (~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'Name'))
            isNamed=1;
            i=i+1;
            Name = varargin{i};
        elseif(strcmp(varargin{i},'Interval')==1)
            isInterval=1;
            i=i+1;
            intervalPlot = reshape([varargin{i}'] ,1,[]);
            subplotInfo=  2;%ceil(nbInputs/2);
            subplotInfo2 = ceil(length(varargin{i}) /2);
        elseif(strcmp(varargin{i},'dataReco')==1)
            dataReco = varargin{i+1};
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
        elseif(strcmp(varargin{i},'yminForInput')==1)
            inputRescale = varargin{i+1};
            ymin= varargin{i+2};
        end
    end
end


%Plot the total trial and the data we have
nameFig = figure;

if(isInterval==1)
    cpt=0;
    i = infTraj.reco;
    prior = infTraj.PHI*promp{i}.mu_w;
    
    OtherPro = ones(length(promp),1);
    OtherPro(i) = 0;
    
    for tmp = 1:length(OtherPro)
        if(OtherPro(tmp) == 1)
            clear varOtherPrior otherPrior;
            varOtherPrior{tmp} = infTraj.PHI*1.96*sqrt(diag(promp{tmp}.sigma_w ));
            otherPrior{tmp} = infTraj.PHI*promp{tmp}.mu_w;
            
        end
    end
    otherP = size(nameFig,2);
    varPrior = infTraj.PHI*1.96*sqrt(diag(promp{i}.sigma_w ));
    posterior = infTraj.PHI*infTraj.mu_w;
    varPosterior = infTraj.PHI*1.96*sqrt(diag(infTraj.sigma_w));
    cpt2 = 0;
    for vff=intervalPlot
        cpt=cpt+1;
        subplot(subplotInfo,subplotInfo2,cpt);
        
        
        if(isfield(test, 'realTime'))
            interval =  test.realTime;%(test.totTime) / test.totTime;
            RTInf = (interval(test.nbData)- interval(1)) / (test.nbData-1);%infTraj.timeInf*0.01;
            intervalInf = [test.realTime(1):RTInf:test.realTime(1)+RTInf*(infTraj.timeInf-1)] ;%/ infTraj.timeInf;
            
        else
            %promp{i}.meanInterval = 0.01; %TODO QUEST CE QUE CESTTTTTTT !!!
            RTInf =  s_ref/infTraj.timeInf;%03/05/22change   promp{i}.meanInterval;
            interval =  [RTInf:RTInf:RTInf*test.nbData];
            intervalInf = [RTInf:RTInf:RTInf*(infTraj.timeInf)] ;%/ infTraj.timeInf;
            realTime = s_ref /test.totTime ;
            realInterval = [realTime:realTime:s_ref];
            
        end
        if(shaded==1)
            visualisationShared(prior, varPrior, sum(nbInput), infTraj.timeInf,  vff, 'b', 'shaded', nameFig, 'vecX',intervalInf);
            for tmp = 1:length(OtherPro)
                if(OtherPro(tmp) == 1)
                    visualisationShared(otherPrior{tmp}, varOtherPrior{tmp}, sum(nbInput), infTraj.timeInf,  vff, 'g', 'shaded', nameFig, 'vecX',intervalInf);
                    nameFig = visualisation(otherPrior{tmp}, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,intervalInf);
                end
            end
            otherP = size(nameFig,2);     
            nameFig = visualisation(prior - varPrior, sum(nbInput), infTraj.timeInf, vff, 'b',  nameFig,intervalInf);
            nameFig = visualisation(prior + varPrior, sum(nbInput), infTraj.timeInf, vff, 'b',  nameFig,intervalInf);
            nameFig = visualisation(prior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,intervalInf);
            prevG = size(nameFig,2);
            visualisationShared(posterior, varPosterior, sum(nbInput), infTraj.timeInf,  vff,'r', 'shaded', nameFig,'vecX', intervalInf);
            
            nameFig = visualisation(posterior, sum(nbInput), infTraj.timeInf, vff, 'r',  nameFig,intervalInf);
            
        else
            visualisationShared(prior, varPrior, sum(nbInput), infTraj.timeInf,  vff, 'b', nameFig, 'vecX',intervalInf);
            for tmp = 1:length(OtherPro)
                if(OtherPro(tmp) == 1)
                    visualisationShared(otherPrior{tmp}, varOtherPrior{tmp}, sum(nbInput), infTraj.timeInf,  vff, 'g', nameFig, 'vecX',intervalInf);
                    nameFig = visualisation(otherPrior{tmp}, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,intervalInf);
                end
            end
            otherP = size(nameFig,2);
            nameFig = visualisation(prior - varPrior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,intervalInf);
            nameFig = visualisation(prior + varPrior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,intervalInf);
            nameFig = visualisation(prior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,intervalInf);
            prevG = size(nameFig,2);
            visualisationShared(posterior, varPosterior, sum(nbInput), infTraj.timeInf,  vff,'r', nameFig,'vecX', intervalInf);
            nameFig = visualisation(posterior, sum(nbInput), infTraj.timeInf, vff, 'r', nameFig,intervalInf);
        end
        
        newG = size(nameFig,2);
        if(isfield(test, 'realTime'))
            nameFig(size(nameFig,2) + 1) = plot(test.realTime,test.yMat(:,vff), ':k', 'linewidth', 2);
        else
         
            nameFig(size(nameFig,2) + 1) = plot(realInterval,test.yMat(:,vff), ':k', 'linewidth', 2);
        end
        dtG = size(nameFig,2);
        if(ismember(vff,dataReco))
            cpt2 = cpt2 +1 ;
            if(isfield(test, 'realTime'))
                nameFig(size(nameFig,2) + 1) = plot(test.realTime(1:test.nbData),test.partialTraj(1+ test.nbData*(cpt2-1):test.nbData*(cpt2)),'.-k','linewidth',3);
            else
                nameFig(size(nameFig,2) + 1) = plot(realInterval(1:test.nbData),test.partialTraj(1+ test.nbData*(cpt2-1):test.nbData*(cpt2)),'.-k','linewidth',3);
            end
            dnG = size(nameFig,2);
        end
        ylabel(list{vff}, 'fontsize', 24);
        if(vff==nbInput(1))
            xlabel('Time [s]', 'fontsize', 24);
        end
        set(gca, 'fontsize', 20)
    end
    if(exist('otherP','var'))
        legend(nameFig(1,[dtG,otherP, prevG, newG]),'ground truth', 'other prior','prior proMP', 'prediction', 'Location', 'northeast');
    else
        legend(nameFig(1,[dtG, dnG, prevG, newG]),'ground truth', 'observations','prior proMP', 'prediction', 'Location', 'northeast');
    end
else
    for vff=1:nbInput(1)
        subplot(nbInput(1),1,vff);
        i = infTraj.reco;%reco{1};
        if(isfield(test, 'realTime'))
            interval =  test.realTime;%(test.totTime) / test.totTime;
            RTInf = (interval(test.nbData)- interval(1)) / (test.nbData-1);%infTraj.timeInf*0.01;
            intervalInf = [test.realTime(1):RTInf:test.realTime(1)+RTInf*(infTraj.timeInf-1)] ;%/ infTraj.timeInf;
        else
            promp{i}.meanInterval = 0.01; %TODO QUEST CE QUE CESTTTTTTT !!!
            RTInf =    promp{i}.meanInterval;
            interval =  [RTInf:promp{i}.meanInterval:promp{i}.meanInterval*test.nbData];
            intervalInf = [RTInf:RTInf:RTInf*(infTraj.timeInf)] ;%/ infTraj.timeInf;
        end
        prior = infTraj.PHI*promp{i}.mu_w;
        varPrior = infTraj.PHI*1.96*sqrt(diag(promp{i}.sigma_w ));
        if(shaded==1)
            visualisationShared(prior, varPrior, sum(nbInput), infTraj.timeInf,  vff, 'b', nameFig, 'vecX',intervalInf, 'shaded', 0.5);
            nameFig = visualisation(prior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,intervalInf);
            prevG = size(nameFig,2);
            visualisationShared(infTraj.PHI*infTraj.mu_w, infTraj.PHI*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), infTraj.timeInf,  vff,'r', nameFig,'vecX', intervalInf, 'shaded', 0.5);
            nameFig = visualisation(infTraj.PHI*infTraj.mu_w, sum(nbInput), infTraj.timeInf, vff, 'r', nameFig,intervalInf);
            newG = size(nameFig,2);
            OtherPro = ones(length(promp),1);
            OtherPro(i) = 0;
            OtherPro(trial) = 2;
            for tmp = 1:length(OtherPro)
                if(OtherPro(tmp) == 1)
                    clear varOtherPrior otherPrior;
                    varOtherPrior = infTraj.PHI*1.96*sqrt(diag(promp{tmp}.sigma_w ));
                    otherPrior = infTraj.PHI*promp{tmp}.mu_w;
                    if(isfield(test, 'type'))
                        if (test.type ~= infTraj.reco) && (tmp ==test.type)
                            visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'm', nameFig, 'vecX',intervalInf, 'shaded', 1);
                            nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'm', nameFig,intervalInf);
                            otherG = size(nameFig,2);
                        else
                            visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'g', nameFig, 'vecX',intervalInf, 'shaded', 1);
                            nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,intervalInf);
                            otherP = size(nameFig,2);
                        end
                    else
                        visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'g', nameFig, 'vecX',intervalInf,'shaded', 1);
                        nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,intervalInf);
                        otherP = size(nameFig,2);
                    end
                elseif(OtherPro(tmp) == 2) %real Distribution
                    clear varOtherPrior otherPrior;
                    varOtherPrior = infTraj.PHI*1.96*sqrt(diag(promp{tmp}.sigma_w ));
                    otherPrior = infTraj.PHI*promp{tmp}.mu_w;
                    if(isfield(test, 'type'))
                        if (test.type ~= infTraj.reco) && (tmp ==test.type)
                            visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'm', nameFig, 'vecX',intervalInf, 'shaded', 0.5);
                            nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'm', nameFig,intervalInf);
                            otherG = size(nameFig,2);
                        else
                            visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'k', nameFig, 'vecX',intervalInf, 'shaded', 0.5);
                            nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'k', nameFig,intervalInf);
                            otherP = size(nameFig,2);
                        end
                    else
                        visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'k', nameFig, 'vecX',intervalInf,'shaded', 0.5);
                        nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'k', nameFig,intervalInf);
                        goodP = size(nameFig,2);
                    end
                end
            end
            
            
        else
            
            visualisationShared(prior, varPrior, sum(nbInput), infTraj.timeInf,  vff, 'b', nameFig, 'vecX',intervalInf);
            nameFig = visualisation(prior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,intervalInf);
            prevG = size(nameFig,2);
            visualisationShared(infTraj.PHI*infTraj.mu_w, infTraj.PHI*1.96*sqrt(diag(infTraj.sigma_w)), sum(nbInput), infTraj.timeInf,  vff,'r', nameFig,'vecX', intervalInf);
            nameFig = visualisation(infTraj.PHI*infTraj.mu_w, sum(nbInput), infTraj.timeInf, vff, 'r', nameFig,intervalInf);
            newG = size(nameFig,2);
            
            OtherPro = ones(length(promp),1);
            OtherPro(i) = 0;
            for tmp = 1:length(OtherPro)
                if(OtherPro(tmp) == 1)
                    clear varOtherPrior otherPrior;
                    varOtherPrior = infTraj.PHI*1.96*sqrt(diag(promp{tmp}.sigma_w ));
                    otherPrior = infTraj.PHI*promp{tmp}.mu_w;
                    if(isfield(test, 'type'))
                        if (test.type ~= infTraj.reco) && (tmp ==test.type)
                            visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'm', nameFig, 'vecX',intervalInf);
                            nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'm', nameFig,intervalInf);
                            otherG = size(nameFig,2);
                        else
                            visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'g', nameFig, 'vecX',intervalInf);
                            nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,intervalInf);
                            otherP = size(nameFig,2);
                        end
                    else
                        visualisationShared(otherPrior, varOtherPrior, sum(nbInput), infTraj.timeInf,  vff, 'g', nameFig, 'vecX',intervalInf);
                        nameFig = visualisation(otherPrior, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,intervalInf);
                        otherP = size(nameFig,2);
                    end
                end
            end
            
        end
        
        
        if(isfield(test, 'realTime'))%isfield(test, 'interval') &&
            nameFig(size(nameFig,2) + 1) = plot( test.realTime  ,test.yMat(:,vff), ':k', 'linewidth', 2); %
        else
            nameFig(size(nameFig,2) + 1) = plot( [RTInf:RTInf:(test.totTime)*RTInf], test.yMat(:,vff), ':k', 'linewidth', 2);
        end
        %visualisation2(test.yMat,sum(nbInput), test.totTime,vff, ':k', 1, nameFig);hold on;
        dtG = size(nameFig,2);
        nameFig(size(nameFig,2) + 1) = plot(interval(1:test.nbData),test.partialTraj(1+ test.nbData*(vff-1):test.nbData + test.nbData*(vff-1)),'.-k','linewidth',3);
        dnG = size(nameFig,2);
        
        ylabel(list{vff}, 'fontsize', 24);
        if(exist('xlimss','var'))
            xlim(xlimss);
        elseif(exist('xmin','var'))
            xtmp = xlim;
            xlim([xmin, xtmp(2)]);
        end
        if(exist('ylimss','var'))
            ylim(ylimss);
        elseif(exist('ymin','var'))
            if(exist('inputRescale', 'var'))
                if(vff == inputRescale)
                    ytmp = ylim;
                    ylim([ymin, ytmp(2)]);
                end
            else
                ytmp = ylim;
                ylim([ymin, ytmp(2)]);
            end
        end
        
        if(vff==nbInput(1))
            xlabel('Time [s]', 'fontsize', 24);
        end
        set(gca, 'fontsize', 20)
    end
    if(exist('dtG'))
        if(isfield(test, 'type'))
            if(test.type == infTraj.reco)
                legend(nameFig(1,[dtG,otherP, dnG, prevG, newG]),'ground truth', 'other prior', 'observations','prior proMP', 'good prediction', 'Location', 'northeast');
            else
                legend(nameFig(1,[dtG,otherG, otherP, dnG, prevG, newG]),'ground truth', 'expected ProMP','other prior', 'observations','prior proMP', 'bad prediction', 'Location', 'northeast');
            end
        else
            if(exist('goodP', 'var'))
                legend(nameFig(1,[dtG,goodP, otherP, dnG, prevG, newG]),'ground truth', 'good prior','other prior', 'observations','prior proMP', 'prediction', 'Location', 'northeast');
            elseif(exist('otherP', 'var'))
                legend(nameFig(1,[dtG,otherP, dnG, prevG, newG]),'ground truth', 'other prior', 'observations','prior proMP', 'prediction', 'Location', 'northeast');
            else
                legend(nameFig(1,[dtG, dnG, prevG, newG]),'ground truth', 'observations','prior proMP', 'prediction', 'Location', 'northeast');
            end
        end
    else
        legend(nameFig(1,[otherP, dnG, prevG, newG]), 'other prior', 'observations','prior proMP', 'prediction', 'Location', 'northeast');
    end
end


if (isNamed==1)
    title(Name, 'fontsize', 24)
end


end
% lim = axis
% maxVal = max(infTraj.alpha*s_ref,test.totTime);
% meanTimeSample = test.realTime(test.totTime) / test.totTime;
% finalVal = meanTimeSample*(infTraj.alpha*s_ref);
% axis(test.realTime(1), finalVal, lim(3), lim(4));