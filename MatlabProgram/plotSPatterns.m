%This demo plots the most longer/frequent s-patterns month per month
%without learning any ProMP.
import mlreportgen.dom.*;
% by Oriane Dermy 01/2020
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

close all;
clearvars;
warning('off','MATLAB:colon:nonIntegerIndex')
addpath('used_functions'); %add some fonctions we use.

%%%%%%%%%%%%%%%VARIABLES, please refer you to the readme
s_bar=12;

%%%%%%%%%%%%%% END VARIABLE CHOICE

display('load t1')
t{1} = loadTrajectory('Data/Covid/sPatterns/Strasbourgfreq2018.txt', 'Strasfreq2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{1},'inputName'))
    t{1}.inputName = inputName
end
display('load t2')
t{2} = loadTrajectory('Data/Covid/sPatterns/Strasbourgfreq2019.txt', 'Strasfreq2019', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{2},'inputName'))
    t{2}.inputName = inputName
end


display('load t3')

t{3} = loadTrajectory('Data/Covid/sPatterns/Strasbourglong2018.txt', 'Straslong2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{3},'inputName'))
    t{3}.inputName = inputName
end
display('load t4')

t{4} = loadTrajectory('Data/Covid/sPatterns/Strasbourglong2019.txt', 'Straslong2019', 'refNb', s_bar, 'Specific', 'covid2');
if(~isfield(t{4},'inputName'))
    t{4}.inputName = inputName
end

display('load t5')
t{5} = loadTrajectory('Data/Covid/sPatterns/Val_dOisefreq2018.txt', 'VOfreq2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{5},'inputName'))
    t{5}.inputName = inputName
end
display('load t6')
t{6} = loadTrajectory('Data/Covid/sPatterns/Val_dOisefreq2019.txt', 'VOfreq2019', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{6},'inputName'))
    t{6}.inputName = inputName
end
display('load t7')

t{7} = loadTrajectory('Data/Covid/sPatterns/Val_dOiselong2018.txt', 'VOlong2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{7},'inputName'))
    t{7}.inputName = inputName
end
display('load t8')

t{8} = loadTrajectory('Data/Covid/sPatterns/Val_dOiselong2019.txt', 'VOlong2019', 'refNb', s_bar, 'Specific', 'covid2');
if(~isfield(t{8},'inputName'))
    t{8}.inputName = inputName
end



display('treatment...')

%voir quels motifs fréquents sont présents à Stras 2018-2019
strasFreq = {};
strasFreq2018 = {};
strasFreq2019 = {};
for i=1:length(t{1}.inputName)
    tname = t{1}.inputName{i}
    if(sum(contains(t{2}.inputName,tname)))
        strasFreq =cat(1,strasFreq, {tname})
    else
       strasFreq2018= cat(1,strasFreq2018,{tname})
    end
end
for i=1:length(t{2}.inputName)
    tname2 = t{2}.inputName{i}
    if(~sum(contains(strasFreq,tname2)))
        strasFreq2019 = cat(1,strasFreq2019,{tname2})
    end
end

%voir quels motifs fréquents sont présents à VO 2018-2019
voFreq = []
voFreq2018 = []
voFreq2019 = []
for i=1:length(t{5}.inputName)
    tname = t{5}.inputName{i}
    if(sum(contains(t{6}.inputName,tname)))
        voFreq= cat(1,voFreq,{tname})
    else 
        voFreq2018 =cat(1,voFreq2018,{tname})
    end
end
for i=1:length(t{6}.inputName)
    tname2 = t{6}.inputName{i}
    if(~sum(contains(voFreq,tname2)))
        voFreq2019=cat(1,voFreq2019,{tname2})
    end
end
%voir quels motifs fréquents sont présents à VO et Stras 2018-2019
voStrasFreq = []
for i=1:length(voFreq)
    tname = voFreq{i}
    if(sum(contains(strasFreq,tname)))
        voStrasFreq=cat(1,voStrasFreq,{tname})
    end
end


 
%plot recoverData
 
%motifs communs 2018-19 Stras & VO
drawRecoverData(t{1}, t{1}.inputName, 'Interval', [1,2,7,3,8,5],  'Specolor',':xr','namFig', 1);
drawRecoverData(t{2}, t{2}.inputName, 'Interval', [4,1,8,2,9,3], 'Specolor','x-r','namFig', 1);
drawRecoverData(t{5}, t{5}.inputName, 'Interval', [3,4,13,14,16,16],  'Specolor',':+b','namFig', 1);
drawRecoverData(t{6}, t{6}.inputName, 'Interval', [2,1,5,12,6,10], 'Specolor','+-b','namFig', 1);
legend('D_c_1_8','D_c_1_9','D_d_1_8','D_d_1_9')

%motifs communs 2018-19 VO
drawRecoverData(t{5}, t{5}.inputName, 'Interval', [8,10],  'Specolor',':b','namFig', 2);
drawRecoverData(t{6}, t{6}.inputName, 'Interval', [3,4], 'Specolor','+-b','namFig', 2);
legend('D_d_1_8','D_d_1_9')% 

%motifs communs 2018-19 Stras
  drawRecoverData(t{1}, t{1}.inputName, 'Interval', [4,6,5],  'Specolor',':r','namFig', 3);
  drawRecoverData(t{2}, t{2}.inputName, 'Interval', [5,16,3], 'Specolor','+-r','namFig', 3);
  legend('D_c_1_8','D_c_1_9')

%motifs unique Stras 2018
 drawRecoverData(t{1}, t{1}.inputName, 'Interval', [10,11],  'Specolor',':r','namFig', 4);
 legend('Stras18 (unique)')
 %motifs unique Stras 2019
 drawRecoverData(t{2}, t{2}.inputName, 'Interval', [6,7,10,11,12,13,14],  'Specolor','+-r','namFig', 5);
 legend('Stras19 (unique)')


%motifs unique 2018 VO
drawRecoverData(t{5}, t{5}.inputName, 'Interval', [1,2,5,6,7,9,11,12,15,17],  'Specolor',':b','namFig', 6);
legend('VO18 (unique)')

%motifs unique 2019 VO
drawRecoverData(t{6}, t{6}.inputName, 'Interval', [7,8,9,10,11,13,14,15,16], 'Specolor','+-b','namFig',7);
legend('VO19 (unique)') 






%voir quels motifs fréquents sont présents à Stras 2018-2019
strasLong = {};
strasLong2018 = {};
strasLong2019 = {};
indexList2018 = {};
indexList2019 = {};
for i=1:length(t{3}.inputName)
    tname = t{3}.inputName{i};
    if(sum(contains(t{4}.inputName,tname)))
        strasLong =cat(1,strasLong, {tname});
    else
       strasLong2018= cat(1,strasLong2018,{tname});
    end
end
for i=1:length(t{4}.inputName)
    tname2 = t{4}.inputName{i};
    if(~sum(contains(strasLong,tname2)))
        strasLong2019 = cat(1,strasLong2019,{tname2});
    end
end

%voir quels motifs fréquents sont présents à VO 2018-2019
voLong = [];
voLong2018 = [];
voLong2019 = [];
for i=1:length(t{7}.inputName)
    tname = t{7}.inputName{i};
    if(sum(contains(t{8}.inputName,tname)))
        voLong= cat(1,voLong,{tname});
    else 
        voLong2018 =cat(1,voLong2018,{tname});
    end
end
for i=1:length(t{8}.inputName)
    tname2 = t{8}.inputName{i};
    if(~sum(contains(voLong,tname2)))
        voLong2019=cat(1,voLong2019,{tname2});
    end
end
%voir quels motifs fréquents sont présents à VO et Stras 2018-2019
voStrasLong = [];
for i=1:length(voLong)
    tname = voLong{i};
    if(sum(contains(strasLong,tname)))
        voStrasLong=cat(1,voStrasLong,{tname});
    end
end


%motifs communs 2018-19 Stras & VO
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', [], 'Specolor',':r','namFig', 1);
% drawRecoverData(t{4}, t{4}.inputName, 'Interval', [], 'Specolor','+-r','namFig', 1);
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', [],  'Specolor',':b','namFig', 1);
% drawRecoverData(t{8}, t{8}.inputName, 'Interval', [], 'Specolor','+-b','namFig', 1);
% legend('Stras18','Stras19','VO18','VO19')

%motifs communs 2018-19 VO
% drawRecoverData(t{7}, t{7}.inputName, 'Interval',[23], 'Specolor',':b','namFig', 1);
% drawRecoverData(t{8}, t{8}.inputName,'Interval',[8], 'Specolor','+-b','namFig', 1);
% legend('VO18','VO19')
% 
% %motifs communs 2018-19 Stras
% drawRecoverData(t{3}, t{3}.inputName, 'Interval',[], 'Specolor',':r','namFig', 3);
% drawRecoverData(t{4}, t{4}.inputName,'Interval',[], 'Specolor','+-r','namFig', 3);
% legend('Stras18','Stras19')
