function drawInference(promp,list, infTraj, test,s_ref, varargin)

nbInput = promp{1}.traj.nbInput;
set(0,'DefaultLineLinewidth',1)
set(0,'DefaultAxesFontSize',12)

isInterval=0;
isNamed=0;
dataReco = nbInput(1);
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
      %      i = i+1;
           subplotInfo2 = ceil(length(varargin{i}) /2)%length(varargin{i});
        elseif(strcmp(varargin{i},'dataReco')==1)
            i = i+1;
            dataReco = varargin{i}; 
        end
    end
end


%Plot the total trial and the data we have
nameFig = figure;

if(isInterval==1)
    cpt=0;
    i = infTraj.reco;%reco{1};
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
        interval = test.realTime(test.totTime) / test.totTime;
        else
            interval = 0.01;
        end
        RTInf = infTraj.timeInf*0.01;
        intervalInf = 0.01;%RTInf / infTraj.timeInf;
       
        visualisationShared(prior, varPrior, sum(nbInput), infTraj.timeInf,  vff, 'b', nameFig, 'vecX',[intervalInf:intervalInf:RTInf]);
        
        for tmp = 1:length(OtherPro)
            if(OtherPro(tmp) == 1)
            visualisationShared(otherPrior{tmp}, varOtherPrior{tmp}, sum(nbInput), infTraj.timeInf,  vff, 'g', nameFig, 'vecX',[intervalInf:intervalInf:RTInf]);
            nameFig = visualisation(otherPrior{tmp}, sum(nbInput), infTraj.timeInf, vff, 'g', nameFig,[intervalInf:intervalInf:RTInf]);
            end
        end
        otherP = size(nameFig,2);

        nameFig = visualisation(prior - varPrior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,[intervalInf:intervalInf:RTInf]);
        nameFig = visualisation(prior + varPrior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,[intervalInf:intervalInf:RTInf]);

        nameFig = visualisation(prior, sum(nbInput), infTraj.timeInf, vff, 'b', nameFig,[intervalInf:intervalInf:RTInf]);
        prevG = size(nameFig,2);
        visualisationShared(posterior, varPosterior, sum(nbInput), infTraj.timeInf,  vff,'r', nameFig,'vecX', [intervalInf:intervalInf:RTInf]);

        nameFig = visualisation(posterior, sum(nbInput), infTraj.timeInf, vff, 'r', nameFig,[intervalInf:intervalInf:RTInf]);
        newG = size(nameFig,2);
        if(isfield(test, 'realTime'))
            nameFig(size(nameFig,2) + 1) = plot( test.realTime,test.yMat(:,vff), ':k', 'linewidth', 2);
        else
            nameFig(size(nameFig,2) + 1) = plot( [0.01:0.01:test.totTime*0.01],test.yMat(:,vff), ':k', 'linewidth', 2);
        end
        %visualisation2(test.yMat,sum(nbInput), test.totTime,vff, ':k', 1, nameFig);hold on;
        dtG = size(nameFig,2);
        if(ismember(vff,dataReco))%<= nbInput(1))
            cpt2 = cpt2 +1 ;
            nameFig(size(nameFig,2) + 1) = plot([interval:interval:test.nbData*interval],test.partialTraj(1+ test.nbData*(cpt2-1):test.nbData*(cpt2)),'.-k','linewidth',3);
           dnG = size(nameFig,2);
        end

        ylabel(list{vff}, 'fontsize', 24);
        if(vff==nbInput(1))
        	xlabel('Time [s]', 'fontsize', 24);
        end
        set(gca, 'fontsize', 20)
    end
    if(exist('otherP','var'))
            %    if(ismember(vff,dataReco))%<= nbInput(1))

           % legend(nameFig(1,[dtG,otherP, dnG, prevG, newG]),'ground truth', 'other prior', 'observations','prior proMP', 'prediction', 'Location', 'southeast');
           %     else
                    legend(nameFig(1,[dtG,otherP, prevG, newG]),'ground truth', 'other prior','prior proMP', 'prediction', 'Location', 'southeast');
           %     end
    else
            legend(nameFig(1,[dtG, dnG, prevG, newG]),'ground truth', 'observations','prior proMP', 'prediction', 'Location', 'southeast');
    end
else
    for vff=1:nbInput(1)
        subplot(nbInput(1),1,vff);
                i = infTraj.reco;%reco{1};

            if(isfield(test, 'realTime'))
                interval =  test.realTime;%(test.totTime) / test.totTime;
                RTInf = (interval(test.nbData) ) / test.nbData;%infTraj.timeInf*0.01;
            else
                promp{i}.meanInterval = 0.01
                RTInf =    promp{i}.meanInterval;
                interval =  [0:promp{i}.meanInterval:promp{i}.meanInterval*test.nbData];

            end
        
        intervalInf = [0:RTInf:RTInf*(infTraj.timeInf-1)] ;%/ infTraj.timeInf;
        prior = infTraj.PHI*promp{i}.mu_w;
        varPrior = infTraj.PHI*1.96*sqrt(diag(promp{i}.sigma_w ));
        visualisationShared(prior, varPrior, sum(nbInput), infTraj.timeInf,  vff, 'b', nameFig, 'vecX',intervalInf);
       %         nameFig = visualisation(prior - varPrior, sum(nbInput), infTraj.timeInf, vff, 'k', nameFig,[intervalInf:intervalInf:RTInf]);

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
        
        if(isfield(test, 'realTime'))%isfield(test, 'interval') && 
                nameFig(size(nameFig,2) + 1) = plot( test.realTime -test.realTime(1) ,test.yMat(:,vff), ':k', 'linewidth', 2); %
            else
                nameFig(size(nameFig,2) + 1) = plot( [0:RTInf:(test.totTime-1)*RTInf], test.yMat(:,vff), ':k', 'linewidth', 2);
            end
            %visualisation2(test.yMat,sum(nbInput), test.totTime,vff, ':k', 1, nameFig);hold on;
            dtG = size(nameFig,2);
        nameFig(size(nameFig,2) + 1) = plot(interval(1:test.nbData) - interval(1),test.partialTraj(1+ test.nbData*(vff-1):test.nbData + test.nbData*(vff-1)),'.-k','linewidth',3);
        dnG = size(nameFig,2);

        ylabel(list{vff}, 'fontsize', 24);

    %            switch vff
    %                case 1: axis([-0.35 -0.25 0 100]);
    %                case 2: asis([-0.1 0 0 100]);
    %                case 3: axis([-0.1 0.2]);
    %            end
               if(vff==nbInput(1))
                   xlabel('Time [s]', 'fontsize', 24);
%                elseif(vff == 1)
%                    title(['Inference of trajectory', promp{i}.traj.label])
             end
             set(gca, 'fontsize', 20)
    end
    if(exist('dtG'))
        if(isfield(test, 'type'))
            if(test.type == infTraj.reco)
                legend(nameFig(1,[dtG,otherP, dnG, prevG, newG]),'ground truth', 'other prior', 'observations','prior proMP', 'good prediction', 'Location', 'southeast');
            else
                legend(nameFig(1,[dtG,otherG, otherP, dnG, prevG, newG]),'ground truth', 'expected ProMP','other prior', 'observations','prior proMP', 'bad prediction', 'Location', 'southeast');
            end
        else
            if(exist('otherP'))
                legend(nameFig(1,[dtG,otherP, dnG, prevG, newG]),'ground truth', 'other prior', 'observations','prior proMP', 'prediction', 'Location', 'southeast');
            else
               legend(nameFig(1,[dtG, dnG, prevG, newG]),'ground truth', 'observations','prior proMP', 'prediction', 'Location', 'southeast');
            end
        end
    else
            legend(nameFig(1,[otherP, dnG, prevG, newG]), 'other prior', 'observations','prior proMP', 'prediction', 'Location', 'southeast');
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