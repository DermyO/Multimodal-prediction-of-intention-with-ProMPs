function drawRecoverDataSubplot(traj, subplotTot, selecPlot, varargin)

set(0,'DefaultAxesFontSize',20);
hold on;
list = traj.inputName;
fsize = 20;
fsize2 = 20;
specific = 0;
isInterval = 0;
col = 'm';
valFigure = 1;
if(~isempty(varargin))
    for index = 1:length(varargin)
        if(strcmp(varargin{index},'Specolor'))
            index = index+1;
             col = varargin{index};   
        elseif(strcmp(varargin{index},'Interval'))
            isInterval = 1;
            index = index+1;
            interval = varargin{index};
        elseif(strcmp(varargin{index},'namFig'))
            index = index+1;
            valFigure = varargin{index};
        end
    end
end
fig22 = figure(valFigure);
fig22 = figure(valFigure);
set(gca, 'fontsize', fsize);

cpt = 0;
for l=1:traj.nbInput(1)
    cpt = cpt+1;
    subplot(subplotTot(1), subplotTot(2),selecPlot(l));
    for i=1:traj.nbTraj
        fig22 = visualisation(traj.y{i},traj.nbInput,traj.totTime(i), l, col,fig22);hold on;
    end
    if(isfield(traj,'inputName'))
        ylabel(traj.inputName(l), 'fontsize', fsize);
    end
    if(isfield(traj, "realTime"))
        xticklabels(traj.realTime{i});
    end
    if(l==1)
        title(traj.label);
    end
end

end



