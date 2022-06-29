function drawRecoverData3(traj, list, varargin)

%%ici on suppose 2 var
%set(0,'DefaultAxesFontSize',20);
fsize = 20;
col = 'm';
valFigure = 1;
if(~isempty(varargin))
    for index = 1:length(varargin)
        if(strcmp(varargin{index},'Specolor'))
            index = index+1;
            col = varargin{index};
        elseif(strcmp(varargin{index},'namFig'))
            index = index+1;
            valFigure = varargin{index};
        end
    end
end
fig22 = figure(valFigure);
%set(gca, 'fontsize', fsize);



for i=1:traj.nbTraj
    fig22 = visualisation3(traj.y{i},sum(traj.nbInput),traj.totTime(i), col,fig22);hold on;
end

xticks(linspace(1,traj.totTime(i),3));
if(isfield(traj, "realTime"))
    xticklabels([traj.realTime{i}(1),traj.realTime{i}(traj.totTime(i)/2),traj.realTime{i}(traj.totTime(i))]);
end
end



