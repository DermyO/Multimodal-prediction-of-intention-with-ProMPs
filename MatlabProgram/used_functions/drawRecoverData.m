function drawRecoverData(traj, list, varargin)

%set(0,'DefaultLineLinewidth',0.1);
set(0,'DefaultAxesFontSize',20);
hold on;
fsize = 20;
fsize2 = 20;
specific = 0;
isInterval = 0;
col = 'm';
flag_persona14d = 0;
valFigure = 1;
if(~isempty(varargin))
    for index = 1:length(varargin)
        if(strcmp(varargin{index},'Specific'))%If you want to plot position/forces/moment separately
            specific =1;
        elseif(strcmp(varargin{index},'Specolor'))
            index = index+1;
            col = varargin{index};
        elseif(strcmp(varargin{index},'Interval'))
            isInterval = 1;
            index = index+1;
            interval = varargin{index};
        elseif(strcmp(varargin{index},'namFig'))
            index = index+1;
            valFigure = varargin{index};
        elseif(strcmp(varargin{index},'personas_14d'))
            flag_persona14d = 1;
        end
    end
end
fig22 = figure(valFigure);
set(gca, 'fontsize', fsize);

if(specific==1)%If you want to plot position/forces/moment separately
    %Here we plot the forces
    for l=traj.nbInput(1)+1:6
        subplot(3,1,l-traj.nbInput(1));%size(nbDof,2),l);
        for i=1:traj.nbTraj
            fig22 = visualisation(traj.y{i},sum(traj.nbInput),traj.totTime(i), l, col,fig22,traj.realTime{i});hold on;
        end
        
        ylabel(list{l}, 'fontsize', fsize);
        if(l==6)
            xlabel('Time [s]', 'fontsize', fsize);
        end
    end
    
    %Here we plot the moments
    for l= 7:9
        subplot(3,1,l-6);%size(nbDof,2),l);
        for i=1:traj.nbTraj
            fig22 = visualisation(traj.y{i},length(list),traj.totTime(i), l, col,fig22,traj.realTime{i});hold on;
        end
        
        ylabel(list{l}, 'fontsize', fsize);
        if(l==9)
            xlabel('Time [s]', 'fontsize', fsize);
        end
    end
    
    %Here we plot the cartesian position
    for l=1:traj.nbInput(1)
        subplot(traj.nbInput(1),1,l)
        for i=1:traj.nbTraj
            fig22 = visualisation(traj.y{i},length(list),traj.totTime(i), l, col,fig22,traj.realTime{i});hold on;
        end
        
        ylabel(list{l}, 'fontsize', fsize);
        
        if(l==traj.nbInput(1))
            xlabel('Time [s]', 'fontsize', fsize);
        end
    end
elseif(isInterval==1)
    cpt=0;
    %list1 =  {'sep','oct','nov','dec','jan','feb','mar','apr','may','jun','jul','aug'};
    for l=interval
        cpt=cpt+1;
        subplot(ceil(length(interval)/2),2,cpt)
        for i=1:traj.nbTraj
            fig22 = visualisation(traj.y{i},length(list),traj.totTime(i), l, col,fig22);hold on;
        end
        %    title(traj.label)
        ylabel(list{l}, 'fontsize', fsize);
        
        if(flag_persona14d==1)
            stickss = zeros(1,traj.totTime(1)/3);
            stickss2 = zeros(1,traj.totTime(1)/3);
            cptt=1;
            for ist =1:3:traj.totTime(1)
                stickss(cptt) = ist;
                stickss2(cptt) = traj.realTime{1}(ist);
                cptt=cptt+1;
            end
            xticks(stickss);
            xticklabels(stickss2);
        end
    end
else
    for l=1:sum(traj.nbInput)
        subplot(sum(traj.nbInput),1,l)
        for i=1:traj.nbTraj
            fig22 = visualisation(traj.y{i},sum(traj.nbInput),traj.totTime(i), l, col,fig22);hold on;
        end
        % list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'};
        if(isfield(traj,'inputName'))
            ylabel(traj.inputName(l), 'fontsize', fsize);
        end
        %ylabel(list{l}, 'fontsize', fsize);
        xticks(linspace(1,traj.totTime(i),3));%[1 2 3 4 5 6 7 8 9 10 11 12])
        if(isfield(traj, "realTime"))
            xticklabels([traj.realTime{i}(1),traj.realTime{i}(ceil(traj.totTime(i)/2)),traj.realTime{i}(traj.totTime(i))]);
        end
    end
end
end



