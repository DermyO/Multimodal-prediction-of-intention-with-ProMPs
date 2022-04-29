
%This demo computes N proMPs given a set of recorded trajectories containing the demonstrations for the N types of movements. 
%It plots the results. We use it per year (whited shape or colored ProMPs)
%and per cities (different colors).

% by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]
close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
s_bar=12;

M(1) = 30; %number of basis functions for the first type of input

%variable tuned to achieve the trajectory correctly
expNoise = 2;
percentData = 48; %number of data max with what you try to find the correct movement

%%%%%%%%%%%%%% END VARIABLE CHOICE

%some variable computation to create basis function, you might have to
%change them
dimRBF = 0; 

%%%%%%%%%%%%%% END VARIABLE CHOICE
%%Enregistrement dans Data/covid/PerMonth/{name}/{année}
%Dedans il y a des fichiers types : 14e3f2d361664dd092940fa20a3f693b.txt ( {id_user}.txt) des 20 utilisateurs qui utilisent le plus les pages de l’ENT cette année là dans cette ville là.

display('Load t1')
name = 'department';%'Val_dOise';%'Toulouse';%'Strasbourg';%
t{1} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2018'), '2018', 'refNb', s_bar);
display('Load t2')
t{2} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2019'), '2019', 'refNb', s_bar);
%display('Load t7')
%t{7} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2020'), '2020', 'refNb', s_bar);



display('Load t3')
name = 'city';% 'Strasbourg';%'Toulouse';%'Strasbourg';%
t{3} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2018'), '2018', 'refNb', s_bar);
display('Load t4')
t{4} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2019'), '2019', 'refNb', s_bar);
%display('Load t8')
%t{8} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2020'), '2020', 'refNb', s_bar);


%display('Load t5')
%name = 'Oise';%'Toulouse';%'Strasbourg';%
%t{5} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2018'), '2018', 'refNb', s_bar);
%display('Load t6')
%t{6} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2019'), '2019', 'refNb', s_bar);
%display('Load t9')
%t{9} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2020'), '2020', 'refNb', s_bar);


for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*t{1}.nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end
inputName = t{1}.inputName;
%display('Plot data')
%plot recoverData
% drawRecoverData(t{1}, t{1}.inputName,  'Interval', [1:8],'Specolor','+-b','namFig', 1);hold on;
% drawRecoverData(t{2}, t{2}.inputName, 'Interval', [1:8],  'Specolor','x-r','namFig', 1);
 %legend(t{1}.label);
 %drawRecoverData(t{1}, t{1}.inputName,  'Interval', [9:17],'Specolor','+-b','namFig', 2);hold on;
% drawRecoverData(t{2}, t{2}.inputName, 'Interval', [9:17],  'Specolor','x-r','namFig', 2);
 %legend(t{1}.label);
% 
%  fig = figure(1);
%  Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     xl = get(MySubplot,'xlim');
%     set(MySubplot,'xlim',[1 xl(2)]);
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
%  
%  fig = figure(2);
%  Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     xl = get(MySubplot,'xlim');
%     set(MySubplot,'xlim',[1 xl(2)]);
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
%  
 
 
 
%take one of the trajectory randomly to do test, the others are stocked in
%train.
%[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
%[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);

%Compute the distribution for each kind of trajectories.
display('Training t1')
promp{1} = computeDistribution(t{1}, M, s_bar,c,h);
display('Training t2')
promp{2} = computeDistribution(t{2}, M, s_bar,c,h);
display('Training t3')
promp{3} = computeDistribution(t{3}, M, s_bar,c,h);
display('Training t4')
promp{4} = computeDistribution(t{4}, M, s_bar,c,h);
% display('Training t5')
% %promp{5} = computeDistribution(t{5}, M, s_bar,c,h);
% display('Training t6')
% promp{6} = computeDistribution(t{6}, M, s_bar,c,h);
% 
% display('Training t7')
% promp{7} = computeDistribution(t{7}, M, s_bar,c,h);
% display('Training t8')
% promp{8} = computeDistribution(t{8}, M, s_bar,c,h);
% display('Training t9')
% promp{9} = computeDistribution(t{9}, M, s_bar,c,h);

display('Drawing Distributions ...')
% %plot distribution


%all sites
% %drawDistribution(promp{1}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [0.8,0.8,1],'without');
% drawDistribution(promp{2}, inputName,s_bar,'interval', [1:8], 'shaded','col', 'b','without');
% %drawDistribution(promp{3}, inputName,s_bar,'interval', [1:8], 'shaded','col', [1,0.8,0.8],'without');
% drawDistribution(promp{4}, inputName,s_bar,'interval', [1:8],'shaded', 'col', 'r','without');
% %drawDistribution(promp{5}, inputName,s_bar,'interval', [1:8], 'col', 'c');
% drawDistribution(promp{6}, inputName,s_bar,'interval', [1:8],'shaded', 'col', 'g', 'without');
% 
% %drawDistribution(promp{1}, inputName,s_bar,[9:17], 'col', 'b');
% %drawDistribution(promp{2}, inputName,s_bar,[9:17], 'col', 'r');
% 
% fig = figure(10);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     xl = get(MySubplot,'xlim');
%     set(MySubplot,'xlim',[1 xl(2)]);
%     tt = get(MySubplot,'ylabel');
%    if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% 
% 
% %drawDistribution(promp{1}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.8,0.8,1],'without', 'fig',11);
% drawDistribution(promp{2}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'b','without', 'fig',11);
% %drawDistribution(promp{3}, inputName,s_bar,'shaded','interval',[9:17], 'col', [1,0.8,0.8],'without', 'fig',11);
% drawDistribution(promp{4}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'r','without', 'fig',11);
% %drawDistribution(promp{5}, inputName,s_bar,'interval',[9:17], 'col', 'g', 'fig',11);
% drawDistribution(promp{6}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'g', 'without','fig',11);
% 
% 
% fig = figure(11);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     xl = get(MySubplot,'xlim');
%     set(MySubplot,'xlim',[1 xl(2)]);
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end


%%juste VO 2018-2020

% %%juste VO
% %drawDistribution(promp{1}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [0.8,0.8,1],'without', 'fig',13);
% %drawDistribution(promp{2}, inputName,s_bar,'interval', [1:8], 'shaded','col', [0.6,0.6,1], 'b','without', 'fig', 13);
% %drawDistribution(promp{7}, inputName,s_bar,'interval', [1:8], 'shaded','col', 'b','without', 'fig', 13);
% 
% %drawDistribution2(promp{1},promp{2}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [0.8,0.8,1],'without', 'fig',13);
% %drawDistribution2(promp{2},promp{7}, inputName,s_bar,'interval', [1:8],'shaded', 'col', 'b','without', 'fig',13);
% 
% fig = figure(13);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     if(mod(i,2)==1)
%      set(MySubplot,'xlim',[1 4]);
%     else
%      xl = get(MySubplot,'xlim');
%      set(MySubplot,'xlim',[1 xl(2)]);
%     end
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     
%     tt = get(MySubplot,'ylabel');
%    if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% 
% %drawDistribution(promp{1}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.8,0.8,1],'without', 'fig',12);
% %drawDistribution(promp{2}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.6,0.6,1], 'b','without', 'fig',12);
% %drawDistribution(promp{7}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'b','without', 'fig',12);
% drawDistribution2(promp{1},promp{2}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.8,0.8,1],'without', 'fig',12);
% drawDistribution2(promp{2},promp{7}, inputName,s_bar,'shaded','interval',[9:17], 'col',  'b','without', 'fig',12);
% 
% 
% 
% fig = figure(12);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     if(mod(i,2)==1)
%      set(MySubplot,'xlim',[1 4]);
%     else
%      xl = get(MySubplot,'xlim');
%      set(MySubplot,'xlim',[1 xl(2)]);
%     end
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% %%juste Stras 2018-2020
% 
% drawDistribution2(promp{3},promp{4}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [1,0.8,0.8],'without', 'fig',20);
% drawDistribution2(promp{4},promp{8}, inputName,s_bar,'interval', [1:8],'shaded', 'col', 'r','without', 'fig',20);
% 
% fig = figure(20);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     if(mod(i,2)==1)
%      set(MySubplot,'xlim',[1 4]);
%     else
%      xl = get(MySubplot,'xlim');
%      set(MySubplot,'xlim',[1 xl(2)]);
%     end
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     
%     tt = get(MySubplot,'ylabel');
%    if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% drawDistribution2(promp{3},promp{4}, inputName,s_bar,'shaded','interval',[9:17], 'col', [1,0.8,0.8],'without', 'fig',21);
% drawDistribution2(promp{4},promp{8}, inputName,s_bar,'shaded','interval',[9:17], 'col',  'r','without', 'fig',21);
% 
% 
% 
% fig = figure(21);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     if(mod(i,2)==1)
%      set(MySubplot,'xlim',[1 4]);
%     else
%      xl = get(MySubplot,'xlim');
%      set(MySubplot,'xlim',[1 xl(2)]);
%     end
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% 
% 
% 
% %all sites 2018-2028
% %drawDistribution(promp{1}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [0.8,0.8,1],'without');
% drawDistribution2(promp{2},promp{7}, inputName,s_bar,'interval', [1:8], 'shaded','col', 'b','without');
% %drawDistribution(promp{3}, inputName,s_bar,'interval', [1:8], 'shaded','col', [1,0.8,0.8],'without');
% drawDistribution2(promp{4}, promp{8}, inputName,s_bar,'interval', [1:8],'shaded', 'col', 'r','without');
% %drawDistribution(promp{5}, inputName,s_bar,'interval', [1:8], 'col', 'c');
% drawDistribution2(promp{6}, promp{9}, inputName,s_bar,'interval', [1:8],'shaded', 'col', 'g', 'without');
% 
% %drawDistribution(promp{1}, inputName,s_bar,[9:17], 'col', 'b');
% %drawDistribution(promp{2}, inputName,s_bar,[9:17], 'col', 'r');
% 
% fig = figure(10);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     if(mod(i,2)==1)
%      set(MySubplot,'xlim',[1 4]);
%     else
%      xl = get(MySubplot,'xlim');
%      set(MySubplot,'xlim',[1 xl(2)]);
%     end
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% 
% 
% %drawDistribution(promp{1}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.8,0.8,1],'without', 'fig',11);
% drawDistribution2(promp{2}, promp{7}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'b','without', 'fig',11);
% %drawDistribution(promp{3}, inputName,s_bar,'shaded','interval',[9:17], 'col', [1,0.8,0.8],'without', 'fig',11);
% drawDistribution2(promp{4}, promp{8}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'r','without', 'fig',11);
% %drawDistribution(promp{5}, inputName,s_bar,'interval',[9:17], 'col', 'g', 'fig',11);
% drawDistribution2(promp{6}, promp{9}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'g', 'without','fig',11);
% 
% 
% fig = figure(11);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     if(mod(i,2)==1)
%      set(MySubplot,'xlim',[1 4]);
%     else
%      xl = get(MySubplot,'xlim');
%      set(MySubplot,'xlim',[1 xl(2)]);
%     end
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 







%%juste VO
%drawDistribution(promp{1}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [0.8,0.8,1],'without', 'fig',13);
%drawDistribution(promp{2}, inputName,s_bar,'interval', [1:8], 'shaded','col', [0.6,0.6,1], 'b','without', 'fig', 13);
%drawDistribution(promp{7}, inputName,s_bar,'interval', [1:8], 'shaded','col', 'b','without', 'fig', 13);

drawDistribution(promp{1}, inputName,s_bar,'interval', [1:6],'shaded', 'col', [0.6,0.6,1],'without', 'fig',13);
drawDistribution(promp{2}, inputName,s_bar,'interval', [1:6], 'shaded','col', 'b','without', 'fig', 13);



fig = figure(13);
Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
    if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','timeM.');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','collab.');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','SkillM.');
    elseif(strcmp(tt.String, 'ServicesScolaires'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','storeSh.');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','homewk.');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','onlineRes.');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','collect.');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','Peda.It.');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','reserv.');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','orient.');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','news');
     elseif(strcmp(tt.String, 'Absences'))
        set(get(MySubplot,'YLabel'), 'String','abs');
     elseif(strcmp(tt.String, 'PageENT'))
        set(get(MySubplot,'YLabel'), 'String','worksp.Pg');
     elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
     elseif(strcmp(tt.String, 'Notes'))
        set(get(MySubplot,'YLabel'), 'String','marks');
     end
end



%drawDistribution(promp{1}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.8,0.8,1],'without', 'fig',12);
%drawDistribution(promp{2}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.6,0.6,1], 'b','without', 'fig',12);
%drawDistribution(promp{7}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'b','without', 'fig',12);


drawDistribution(promp{1}, inputName,s_bar,'shaded','interval',[7,8,9,10,11,12], 'col', [0.6,0.6,1],'without', 'fig',12);
drawDistribution(promp{2}, inputName,s_bar,'shaded','interval',[7,8,9,10,11,12], 'b','without', 'fig',12);



fig = figure(12);
Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
    if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','timeM.');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','collab.');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','SkillM.');
    elseif(strcmp(tt.String, 'ServicesScolaires'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','storeSh.');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','homewk.');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','onlineRes.');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','collect.');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','Peda.It.');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','reserv.');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','orient.');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','news');
     elseif(strcmp(tt.String, 'Absences'))
        set(get(MySubplot,'YLabel'), 'String','abs');
     elseif(strcmp(tt.String, 'PageENT'))
        set(get(MySubplot,'YLabel'), 'String','worksp.Pg');
     elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
     elseif(strcmp(tt.String, 'Notes'))
        set(get(MySubplot,'YLabel'), 'String','marks');
     end
end





%%juste stras
% drawDistribution(promp{3}, inputName,s_bar,'interval', [1:8],'shaded', 'col', [1,0.8,0.8],'without', 'fig',15);
% drawDistribution(promp{4}, inputName,s_bar,'interval', [1:8], 'shaded','col', [1,0.6,0.6], 'r','without', 'fig', 15);
% drawDistribution(promp{8}, inputName,s_bar,'interval', [1:8], 'shaded','col', 'r','without', 'fig', 15);

drawDistribution(promp{3}, inputName,s_bar,'interval', [1,2,3,4,5],'shaded', 'col', [1,0.6,0.6],'without', 'fig',15);
drawDistribution(promp{4}, inputName,s_bar,'interval', [1,2,3,4,5], 'shaded','col', 'r','without', 'fig', 15);

fig = figure(15);
Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
   if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','timeM.');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','collab.');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','SkillM.');
    elseif(strcmp(tt.String, 'ServicesScolaires'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','storeSh.');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','homewk.');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','onlineRes.');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','collect.');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','Peda.It.');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','reserv.');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','orient.');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','news');
     elseif(strcmp(tt.String, 'Absences'))
        set(get(MySubplot,'YLabel'), 'String','abs');
     elseif(strcmp(tt.String, 'PageENT'))
        set(get(MySubplot,'YLabel'), 'String','worksp.Pg');
     elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
        
     elseif(strcmp(tt.String, 'Notes'))
        set(get(MySubplot,'YLabel'), 'String','marks');
     end
end



% drawDistribution(promp{3}, inputName,s_bar,'shaded','interval',[9:17], 'col', [1,0.8,0.8],'without', 'fig',16);
% drawDistribution(promp{4}, inputName,s_bar,'shaded','interval',[9:17], 'col', [1,0.6,0.6],'without', 'fig',16);
% drawDistribution(promp{8}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'r','without', 'fig',16);
drawDistribution(promp{3}, inputName,s_bar,'shaded','interval',[7,8,9,10,12,15], 'col', [1,0.6,0.6],'without', 'fig',16);
drawDistribution(promp{4}, inputName,s_bar,'shaded','interval',[7,8,9,10,12,15], 'col', 'r','without', 'fig',16);


fig = figure(16);
Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
    if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','timeM.');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','collab.');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','SkillM.');
    elseif(strcmp(tt.String, 'ServicesScolaires'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','storeSh.');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','homewk.');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','onlineRes.');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','collect.');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','Peda.It.');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','reserv.');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','orient.');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','news');
     elseif(strcmp(tt.String, 'Absences'))
        set(get(MySubplot,'YLabel'), 'String','abs');
     elseif(strcmp(tt.String, 'PageENT'))
        set(get(MySubplot,'YLabel'), 'String','worksp.Pg');
     elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','sch.Life');
        
     elseif(strcmp(tt.String, 'Notes'))
        set(get(MySubplot,'YLabel'), 'String','marks');
     end
end


% 
% %%juste toulouse
% %drawDistribution(promp{5}, inputName,s_bar,'shaded','interval', [1:8], 'col', [0.8,1.0,0.8],'without', 'fig',17);
% drawDistribution(promp{6}, inputName,s_bar,'interval', [1:8], 'shaded','col', 'g','without', 'fig', 17);
% 
% fig = figure(17);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     xl = get(MySubplot,'xlim');
%     set(MySubplot,'xlim',[1 xl(2)]);
%     tt = get(MySubplot,'ylabel');
%    if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesScolaires'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
% 
% 
% 
% %drawDistribution(promp{5}, inputName,s_bar,'shaded','interval',[9:17], 'col', [0.8,1,0.8],'without', 'fig',18);
% drawDistribution(promp{6}, inputName,s_bar,'shaded','interval',[9:17], 'col', 'g','without', 'fig',18);
% 
% 
% fig = figure(18);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     yl = get(MySubplot,'ylim');
%     set(MySubplot,'ylim',[0 yl(2)]);
%     xl = get(MySubplot,'xlim');
%     set(MySubplot,'xlim',[1 xl(2)]);
%     tt = get(MySubplot,'ylabel');
%     if( strcmp(tt.String, 'GestionTemps'))
%         set(get(MySubplot,'YLabel'), 'String','timeM');
%     elseif(strcmp(tt.String, 'TravailCollaboratif'))
%         set(get(MySubplot,'YLabel'), 'String','Collab');
%     elseif(strcmp(tt.String, 'GestionCompetences'))
%         set(get(MySubplot,'YLabel'), 'String','SkillM');
%     elseif(strcmp(tt.String, 'ServicesSc'))
%         set(get(MySubplot,'YLabel'), 'String','sch.Life');
%     elseif(strcmp(tt.String, 'StockagePartage'))
%         set(get(MySubplot,'YLabel'), 'String','storShare');
%     elseif(contains(tt.String,'Texte'))
%         set(get(MySubplot,'YLabel'), 'String','homewk.');
%     elseif(strcmp(tt.String, 'RessourcesEnLigne'))
%         set(get(MySubplot,'YLabel'), 'String','onlineRes');
%     elseif(strcmp(tt.String, 'ServicesCollectivites'))
%         set(get(MySubplot,'YLabel'), 'String','Collect');
%     elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
%         set(get(MySubplot,'YLabel'), 'String','Peda.It.');
%      elseif(strcmp(tt.String, 'CourrierElectronique'))
%         set(get(MySubplot,'YLabel'), 'String','mails');
%      elseif(strcmp(tt.String, 'DocumentationCDI'))
%         set(get(MySubplot,'YLabel'), 'String','CDI');
%      elseif(strcmp(tt.String, 'ReservationRessources'))
%         set(get(MySubplot,'YLabel'), 'String','reserv.');
%      elseif(strcmp(tt.String, 'Orientation'))
%         set(get(MySubplot,'YLabel'), 'String','orient.');
%      elseif(strcmp(tt.String, 'Actualités'))
%         set(get(MySubplot,'YLabel'), 'String','news');
%      end
% end
