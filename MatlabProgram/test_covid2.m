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

%%%%%%%%%%%%%% END VARIABLE CHOICE

% display('load t1')
% t{1} = loadTrajectory('Data/Covid/tiPatterns/Strasbourgfreq2018.txt', 'Strasfreq2018', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{1},'inputName'))
%     t{1}.inputName = inputName
% end
% display('load t2')
% t{2} = loadTrajectory('Data/Covid/tiPatterns/Strasbourgfreq2019.txt', 'Strasfreq2019', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{2},'inputName'))
%     t{2}.inputName = inputName
% end
% display('load t3')
% 
% t{3} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2018.txt', 'Straslong2018', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{3},'inputName'))
%     t{3}.inputName = inputName
% end
% display('load t4')
% 
% t{4} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2019.txt', 'Straslong2019', 'refNb', s_bar, 'Specific', 'covid2');
% if(~isfield(t{4},'inputName'))
%     t{4}.inputName = inputName
% end

display('load t5')
t{5} = loadTrajectory('Data/Covid/tiPatterns/Val_dOisefreq2018.txt', 'VOfreq2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{5},'inputName'))
    t{5}.inputName = inputName
end
display('load t6')
t{6} = loadTrajectory('Data/Covid/tiPatterns/Val_dOisefreq2019.txt', 'VOfreq2019', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{6},'inputName'))
    t{6}.inputName = inputName
end
display('load t7')

t{7} = loadTrajectory('Data/Covid/tiPatterns/Val_dOiselong2018.txt', 'VOlong2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{7},'inputName'))
    t{7}.inputName = inputName
end
display('load t8')

t{8} = loadTrajectory('Data/Covid/tiPatterns/Val_dOiselong2019.txt', 'VOlong2019', 'refNb', s_bar, 'Specific', 'covid2');
if(~isfield(t{8},'inputName'))
    t{8}.inputName = inputName
end


display('load t9')

t{9} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2018.txt', 'StraslongWith2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{9},'inputName'))
    t{9}.inputName = inputName
end
display('load t10')

t{10} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2019.txt', 'StraslongWith2019', 'refNb', s_bar, 'Specific', 'covid2');
if(~isfield(t{10},'inputName'))
    t{10}.inputName = inputName
end



display('treatment...')


%plot recoverData
% drawRecoverData(t{1}, t{1}.inputName,  'Specolor','xb','namFig', 1);
% drawRecoverData(t{2}, t{2}.inputName, 'Specolor','+r','namFig', 1);
% legend(t{1}.label,t{2}.label);
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', [1:8],'Specolor','xb','namFig', 2);
% drawRecoverData(t{4}, t{4}.inputName, 'Interval', [1:8],'Specolor','+r','namFig',2);
% legend(t{3}.label,t{4}.label);
% 
% 
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', [9:17],'Specolor','xb','namFig', 5);
% drawRecoverData(t{4}, t{4}.inputName, 'Interval', [9:17],'Specolor','+r','namFig',5);
% legend(t{3}.label,t{4}.label);


% drawRecoverData(t{9}, t{9}.inputName, 'Interval', [1:10], 'Specolor','xb','namFig', 6);
% drawRecoverData(t{10}, t{10}.inputName,'Interval', [1:10],'Specolor','+r','namFig',6);
% legend(t{9}.label,t{10}.label);
% 
% drawRecoverData(t{9}, t{9}.inputName, 'Interval', [11:19], 'Specolor','xb','namFig', 7);
% drawRecoverData(t{10}, t{10}.inputName, 'Interval', [11:19],'Specolor','+r','namFig',7);
% legend(t{9}.label,t{10}.label);
% 
% drawRecoverData(t{9}, t{9}.inputName, 'Interval', [20:27], 'Specolor','xb','namFig', 8);
% drawRecoverData(t{10}, t{10}.inputName,'Interval', [20:27],'Specolor','+r','namFig',8);
% legend(t{9}.label,t{10}.label);


%plot recoverData
drawRecoverData(t{5}, t{5}.inputName, 'Interval', [1:6], 'Specolor','xb','namFig', 3);
drawRecoverData(t{6}, t{6}.inputName, 'Interval', [1:6], 'Specolor','+r','namFig', 3);
legend(t{5}.label,t{6}.label);

drawRecoverData(t{5}, t{5}.inputName, 'Interval', [7:12], 'Specolor','xb','namFig', 32);
drawRecoverData(t{6}, t{6}.inputName, 'Interval', [7:12], 'Specolor','+r','namFig', 32);
legend(t{5}.label,t{6}.label);


drawRecoverData(t{7}, t{7}.inputName, 'Interval', [1:10],'Specolor','xb','namFig', 4);
drawRecoverData(t{8}, t{8}.inputName, 'Interval', [1:10],'Specolor','+r','namFig',4);
legend(t{7}.label,t{8}.label);


drawRecoverData(t{7}, t{7}.inputName, 'Interval', [11:20],'Specolor','xb','namFig', 5);
drawRecoverData(t{8}, t{8}.inputName, 'Interval', [11:20],'Specolor','+r','namFig',5);
legend(t{7}.label,t{8}.label);


drawRecoverData(t{7}, t{7}.inputName, 'Interval', [21:30],'Specolor','xb','namFig', 6);
drawRecoverData(t{8}, t{8}.inputName, 'Interval', [21:30],'Specolor','+r','namFig',6);
legend(t{7}.label,t{8}.label);