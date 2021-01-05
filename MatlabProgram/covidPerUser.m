
%This demo computes N proMPs given a set of recorded trajectories containing the demonstrations for the N types of movements. 
%It plots the results.

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
display('Load t1')
name = 'Val_dOise';%'Toulouse';%'Strasbourg';%
t{1} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2018'), '2018', 'refNb', s_bar);
display('Load t2')
t{2} = loadUsersTrajectory(strcat('Data/Covid/PerMonth/',name,'/2019'), '2019', 'refNb', s_bar);
for i=1:size(M,2)
    dimRBF = dimRBF + M(i)*t{1}.nbInput(i);
    c(i) = 1.0 / (M(i));%center of gaussians
    h(i) = c(i)/M(i); %bandwidth of gaussians
end
inputName = t{1}.inputName;
display('Plot data')
%plot recoverData
 drawRecoverData(t{1}, t{1}.inputName,  'Interval', [1:8],'Specolor','+-b','namFig', 1);hold on;
 drawRecoverData(t{2}, t{2}.inputName, 'Interval', [1:8],  'Specolor','x-r','namFig', 1);
 %legend(t{1}.label);
 drawRecoverData(t{1}, t{1}.inputName,  'Interval', [9:17],'Specolor','+-b','namFig', 2);hold on;
 drawRecoverData(t{2}, t{2}.inputName, 'Interval', [9:17],  'Specolor','x-r','namFig', 2);
 %legend(t{1}.label);

 fig = figure(1);
 Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
    if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','GesTps');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','Collab');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','GesCompet');
    elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','vieScol');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','StockPart');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','CahTxt');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','RessLigne');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','Collect');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','ParcPeda');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','Reserv');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','Orient');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','Actu');
     end
end
 
 fig = figure(2);
 Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
    if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','GesTps');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','Collab');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','GesCompet');
    elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','vieScol');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','StockPart');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','CahTxt');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','RessLigne');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','Collect');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','ParcPeda');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','Reserv');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','Orient');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','Actu');
     end
end
 
 
 
 
%take one of the trajectory randomly to do test, the others are stocked in
%train.
%[train{1},test{1}] = partitionTrajectory(t{1},1,percentData,s_bar);
%[train{2},test{2}] = partitionTrajectory(t{2},1,percentData,s_bar);

%Compute the distribution for each kind of trajectories.
display('Training t1')
promp{1} = computeDistribution(t{1}, M, s_bar,c,h);
display('Training t2')
promp{2} = computeDistribution(t{2}, M, s_bar,c,h);

display('Drawing Distributions ...')
%plot distribution
drawDistribution(promp{1}, inputName,s_bar,[1:8], 'col', 'b');
drawDistribution(promp{2}, inputName,s_bar,[1:8], 'col', 'r');
%drawDistribution(promp{1}, inputName,s_bar,[9:17], 'col', 'b');
%drawDistribution(promp{2}, inputName,s_bar,[9:17], 'col', 'r');

fig = figure(10);
Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
   if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','GesTps');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','Collab');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','GesCompet');
    elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','vieScol');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','StockPart');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','CahTxt');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','RessLigne');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','Collect');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','ParcPeda');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','Reserv');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','Orient');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','Actu');
     end
end



drawDistribution(promp{1}, inputName,s_bar,[9:17], 'col', 'b');
drawDistribution(promp{2}, inputName,s_bar,[9:17], 'col', 'r');

fig = figure(10);
Allsubplots=get(fig,'children'); 
for i=1:length(Allsubplots)% 9-17 =8
    MySubplot=Allsubplots(i);
    yl = get(MySubplot,'ylim');
    set(MySubplot,'ylim',[0 yl(2)]);
    xl = get(MySubplot,'xlim');
    set(MySubplot,'xlim',[1 xl(2)]);
    tt = get(MySubplot,'ylabel');
    if( strcmp(tt.String, 'GestionTemps'))
        set(get(MySubplot,'YLabel'), 'String','GesTps');
    elseif(strcmp(tt.String, 'TravailCollaboratif'))
        set(get(MySubplot,'YLabel'), 'String','Collab');
    elseif(strcmp(tt.String, 'GestionCompetences'))
        set(get(MySubplot,'YLabel'), 'String','GesCompet');
    elseif(strcmp(tt.String, 'ServicesVieScolaire'))
        set(get(MySubplot,'YLabel'), 'String','vieScol');
    elseif(strcmp(tt.String, 'StockagePartage'))
        set(get(MySubplot,'YLabel'), 'String','StockPart');
    elseif(contains(tt.String,'Texte'))
        set(get(MySubplot,'YLabel'), 'String','CahTxt');
    elseif(strcmp(tt.String, 'RessourcesEnLigne'))
        set(get(MySubplot,'YLabel'), 'String','RessLigne');
    elseif(strcmp(tt.String, 'ServicesCollectivites'))
        set(get(MySubplot,'YLabel'), 'String','Collect');
    elseif(strcmp(tt.String, 'ParcoursPedagogiques'))
        set(get(MySubplot,'YLabel'), 'String','ParcPeda');
     elseif(strcmp(tt.String, 'CourrierElectronique'))
        set(get(MySubplot,'YLabel'), 'String','mails');
     elseif(strcmp(tt.String, 'DocumentationCDI'))
        set(get(MySubplot,'YLabel'), 'String','CDI');
     elseif(strcmp(tt.String, 'ReservationRessources'))
        set(get(MySubplot,'YLabel'), 'String','Reserv');
     elseif(strcmp(tt.String, 'Orientation'))
        set(get(MySubplot,'YLabel'), 'String','Orient');
     elseif(strcmp(tt.String, 'Actualités'))
        set(get(MySubplot,'YLabel'), 'String','Actu');
     end
end
