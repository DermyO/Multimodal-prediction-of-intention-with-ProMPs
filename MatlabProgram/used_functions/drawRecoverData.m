function drawRecoverData(traj, list, varargin)

%set(0,'DefaultLineLinewidth',0.1);
set(0,'DefaultAxesFontSize',18);

fsize = 14;
fsize2 = 12;
specific = 0;
isInterval = 0;
col = 'm';
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
        end
    end
end

if(specific==1)%If you want to plot position/forces/moment separately
        
        %Here we plot the forces
            fig22 = figure;
            set(gca, 'fontsize', fsize);
            for l=traj.nbInput(1)+1:6  
                subplot(3,1,l-traj.nbInput(1));%size(nbDof,2),l);
                for i=1:traj.nbTraj     
                    fig22 = visualisation(traj.y{i},sum(traj.nbInput),traj.totTime(i), l, col,fig22,traj.realTime{i});hold on;
                end

                 ylabel(list{l}, 'fontsize', fsize);
                 if(l==6)
                      xlabel('Time [s]', 'fontsize', fsize);
                 end
                 set(gca, 'fontsize', 20)
            end

        %Here we plot the moments
            fig22 = figure;
                 set(gca, 'fontsize', fsize2);

            for l= 7:9  
                subplot(3,1,l-6);%size(nbDof,2),l);
                for i=1:traj.nbTraj     
                    fig22 = visualisation(traj.y{i},length(list),traj.totTime(i), l, col,fig22,traj.realTime{i});hold on;
                end

                 ylabel(list{l}, 'fontsize', fsize);
                 if(l==9)
                      xlabel('Time [s]', 'fontsize', fsize);
                 end
                 set(gca, 'fontsize', 20)
            end
        
        
        %Here we plot the cartesian position
        if(exist('valFigure','var'))
            fig22 = figure(valFigure);
        elseif(~exist('fig22','var'))
            fig22 = figure;
        end
            set(gca, 'fontsize', fsize2);

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



        %Here we plot the forces and moments
        %     fig22 = figure;
        %     for l=traj.nbInput(1)+1:sum(traj.nbInput) 
        %         subplot(traj.nbInput(2),1,l-traj.nbInput(1));%size(nbDof,2),l);
        %         for i=1:traj.nbTraj  
        %             fig22 = visualisation(traj.y{i},sum(traj.nbInput),traj.totTime(i), l, ':b',fig22,traj.realTime{i});hold on;
        %         end
        % 
        %          ylabel(list{l}, 'fontsize', fsize);
        %          if(l==sum(traj.nbInput))
        %               xlabel('Time [s]', 'fontsize', fsize);
        %          end
        %       set(gca, 'fontsize', 20)
        %     end
        % end
elseif(isInterval==1)
    fig22 = figure(valFigure);
    set(gca, 'fontsize', fsize2);
    cpt=0;
    list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'};
    % listl = [9,10,11,12,01,02,03,04,05,06,07,08];
    for l=interval  
        cpt=cpt+1;
        subplot(ceil(length(interval)/2),2,cpt)
        for i=1:traj.nbTraj     
            fig22 = visualisation(traj.y{i},length(list),traj.totTime(i), l, col,fig22);hold on;
        end

         ylabel(list{l}, 'fontsize', fsize);
         xticks([1 2 3 4 5 6 7 8 9 10 11 12])
         xticklabels(list1)
         %xlabel(list1,'fontsize', fsize);
         if(cpt==length(interval))
              xlabel('Mois', 'fontsize', fsize);
         end
    end        
else

fig22 = figure(valFigure);
set(gca, 'fontsize', fsize2);

for l=1:traj.nbInput(1)  
	subplot(ceil(traj.nbInput(1)/2),2,l)
    for i=1:traj.nbTraj     
    	fig22 = visualisation(traj.y{i},length(list),traj.totTime(i), l, col,fig22);hold on;
    end
    list1 =  {'sep','oct','nov','dec','jan','fev','mar','avr','mai','jun','jul','aou'};

    ylabel(list{l}, 'fontsize', fsize);
     xticks([1 2 3 4 5 6 7 8 9 10 11 12])
         xticklabels(list1)
% 
%          if(l==traj.nbInput(1))
%               xlabel('Time [s]', 'fontsize', fsize);
%          end
    end
end
end



