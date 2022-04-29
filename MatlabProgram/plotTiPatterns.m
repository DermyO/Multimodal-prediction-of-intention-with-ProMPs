%This demo plots the most longer/frequent ti-pattern month per month
%without learning any ProMP.

% by Oriane Dermy 12/2020
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

display('load t1')
t{1} = loadTrajectory('Data/Covid/tiPatterns/Strasbourgfreq2018.txt', 'Strasfreq2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{1},'inputName'))
     display('error')
    t{1}.inputName = inputName
end
display('load t2')
t{2} = loadTrajectory('Data/Covid/tiPatterns/Strasbourgfreq2019.txt', 'Strasfreq2019', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{2},'inputName'))
     display('erràr')
    t{2}.inputName = inputName
end


display('load t3')

t{3} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2018.txt', 'StraslongWith2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{3},'inputName'))
    display('erràr')
    t{3}.inputName = inputName
end
display('load t4')

t{4} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2019.txt', 'StraslongWith2019', 'refNb', s_bar, 'Specific', 'covid2');
if(~isfield(t{4},'inputName'))
    t{4}.inputName = inputName
end


display('load t5')
t{5} = loadTrajectory('Data/Covid/tiPatterns/Val_dOisefreq2018.txt', 'VOfreq2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{5},'inputName'))
     display('erràr')
    t{5}.inputName = inputName
end
display('load t6')
t{6} = loadTrajectory('Data/Covid/tiPatterns/Val_dOisefreq2019.txt', 'VOfreq2019', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{6},'inputName'))

     display('error')
    t{6}.inputName = inputName
end
display('load t7')

t{7} = loadTrajectory('Data/Covid/tiPatterns/Val_dOiselong2018.txt', 'VOlong2018', 'refNb', s_bar,  'Specific', 'covid2');
if(~isfield(t{7},'inputName'))
     display('erràr')
    t{7}.inputName = inputName
end
display('load t8')

t{8} = loadTrajectory('Data/Covid/tiPatterns/Val_dOiselong2019.txt', 'VOlong2019', 'refNb', s_bar, 'Specific', 'covid2');
if(~isfield(t{8},'inputName'))
     display('erràr')
    t{8}.inputName = inputName
end


% display('load t9')
% t{9} = loadTrajectory('Data/Covid/tiPatterns/Strasbourgfreq2020.txt', 'Strasfreq2020', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{9},'inputName'))
%      display('error')
%     t{9}.inputName = inputName
% end
% 
% display('load t10')
% 
% t{10} = loadTrajectory('Data/Covid/tiPatterns/Strasbourglong2020_2.txt', 'StraslongWith2020', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{10},'inputName'))
%     display('error')
%     t{10}.inputName = inputName
% end
% 
% display('load t11')
% t{11} = loadTrajectory('Data/Covid/tiPatterns/Val_dOisefreq2020_2.txt', 'VOfreq2020', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{11},'inputName'))
%      display('error')
%     t{11}.inputName = inputName
% end
% 
% display('load t12')
% 
% t{12} = loadTrajectory('Data/Covid/tiPatterns/Val_dOiselong2020_2.txt', 'VOlong2020', 'refNb', s_bar,  'Specific', 'covid2');
% if(~isfield(t{12},'inputName'))
%      display('error')
%     t{12}.inputName = inputName
% end

display('treatment...')
%voir quels motifs fréquents sont présents à Stras 2018-2019
strasFreq = {};
strasFreq2018 = {};
strasFreq2019 = {};
for i=1:length(t{1}.inputName)
    tname = t{1}.inputName{i};
    if(sum(contains(t{2}.inputName,tname)))
        strasFreq =cat(1,strasFreq, {tname});
    else
       strasFreq2018= cat(1,strasFreq2018,{tname});
    end
end
for i=1:length(t{2}.inputName)
    tname2 = t{2}.inputName{i};
    if(~sum(contains(strasFreq,tname2)))
        strasFreq2019 = cat(1,strasFreq2019,{tname2});
    end
end

%voir quels motifs fréquents sont présents à Stras 2019-2020
% strasFreqi = {};
% strasFreq2019i = {};
% strasFreq2020 = {};
% for i=1:length(t{2}.inputName)
%     tname = t{2}.inputName{i};
%     if(sum(contains(t{9}.inputName,tname)))
%         strasFreqi =cat(1,strasFreqi, {tname});
%     else
%        strasFreq2019i= cat(1,strasFreq2019i,{tname});
%     end
% end
% for i=1:length(t{9}.inputName)
%     tname2 = t{9}.inputName{i};
%     if(~sum(contains(strasFreqi,tname2)))
%         strasFreq2020 = cat(1,strasFreq2020,{tname2});
%     end
% end

%voir quels motifs fréquents sont présents à VO 2018-2019
voFreq = [];
voFreq2018 = [];
voFreq2019 = [];
for i=1:length(t{5}.inputName)
    tname = t{5}.inputName{i};
    if(sum(contains(t{6}.inputName,tname)))
        voFreq= cat(1,voFreq,{tname});
    else 
        voFreq2018 =cat(1,voFreq2018,{tname});
    end
end
for i=1:length(t{6}.inputName)
    tname2 = t{6}.inputName{i};
    if(~sum(contains(voFreq,tname2)))
        voFreq2019=cat(1,voFreq2019,{tname2});
    end
end

%voir quels motifs fréquents sont présents à VO 2019-2020
% voFreqi = [];
% voFreq2019i = [];
% voFreq2020 = [];
% for i=1:length(t{6}.inputName)
%     tname = t{6}.inputName{i};
%     if(sum(contains(t{11}.inputName,tname)))
%         voFreqi= cat(1,voFreqi,{tname});
%     else 
%         voFreq2019i =cat(1,voFreq2019i,{tname});
%     end
% end
% for i=1:length(t{11}.inputName)
%     tname2 = t{11}.inputName{i};
%     if(~sum(contains(voFreqi,tname2)))
%         voFreq2020=cat(1,voFreq2020,{tname2});
%     end
% end

%voir quels motifs fréquents sont présents à VO et Stras 2018-2019
voStrasFreq = [];
for i=1:length(voFreq)
    tname = voFreq{i};
    if(sum(contains(strasFreq,tname)))
        voStrasFreq=cat(1,voStrasFreq,{tname});
    end
end

%voir quels motifs fréquents sont présents à VO et Stras 2019-2020
% voStrasFreqi = [];
% for i=1:length(voFreqi)
%     tname = voFreqi{i};
%     if(sum(contains(strasFreqi,tname)))
%         voStrasFreqi=cat(1,voStrasFreqi,{tname});
%     end
% end

% %plot recoverData
% 
% %motifs communs 2018-19 Stras & VO
% drawRecoverData(t{1}, t{1}.inputName, 'Interval', [2,1,11,5,8,7], 'Specolor',':xr','namFig', 1);
% drawRecoverData(t{2}, t{2}.inputName, 'Interval', [2,1,11,5,8,7], 'Specolor','x-r','namFig', 1);
% drawRecoverData(t{5}, t{5}.inputName, 'Interval', [3,4,5,6,9,10],  'Specolor',':+b','namFig', 1);
% drawRecoverData(t{6}, t{6}.inputName, 'Interval', [3,4,5,6,9,10], 'Specolor','+-b','namFig', 1);
% legend('D_c_1_8','D_c_1_9','D_d_1_8','D_d_1_9')

% %motifs communs 2019-20 Stras & VO
% drawRecoverData(t{2}, t{2}.inputName, 'Interval', [2,1,5], 'Specolor',':xr','namFig', 12);
% drawRecoverData(t{9}, t{9}.inputName, 'Interval', [2,1,8], 'Specolor','x-r','namFig', 12);
% drawRecoverData(t{6}, t{6}.inputName, 'Interval', [3,4,6],  'Specolor',':+b','namFig', 12);
% drawRecoverData(t{11}, t{11}.inputName, 'Interval', [8,3,7], 'Specolor','+-b','namFig', 12);
% legend('D_c_1_9','D_c_2_0','D_d_1_9','D_d_2_0')

% fig = figure(12);
% Allsubplots=get(fig,'children'); 
% for i=1:length(Allsubplots)% 9-17 =8
%     MySubplot=Allsubplots(i);
%     set(MySubplot,'xlim',[1 4]);
% end

% %motifs communs 2018-19 VO
% drawRecoverData(t{5}, t{5}.inputName, 'Specolor',':b','namFig', 2);
% drawRecoverData(t{6}, t{6}.inputName,'Specolor','+-b','namFig', 2);
% legend('D_d_1_8','D_d_1_9')% 

% %motifs communs 2019-20 VO
% drawRecoverData(t{6}, t{6}.inputName, 'Interval',[1,2,7,8,11], 'Specolor',':b','namFig', 16);hold on;
% drawRecoverData(t{11}, t{11}.inputName, 'Interval', [1,2,4,5,6],'Specolor','+-b','namFig', 16);
% legend('D_d_1_9','D_d_2_0')% 

%motifs communs 2018-19 Stras
drawRecoverData(t{1}, t{1}.inputName, 'Interval',[1,2,3,4,5,8],  'Specolor',':xr','namFig', 3);
drawRecoverData(t{2}, t{2}.inputName, 'Interval',[2,1,3,4,9,10], 'Specolor','x-r','namFig', 3);
legend('D_c_1_8','D_c_1_9')

% %motifs communs 2019-20 Stras
%  drawRecoverData(t{2}, t{2}.inputName,  'Specolor',':r','namFig', 13);
%  drawRecoverData(t{9}, t{9}.inputName, 'Specolor','+-r','namFig', 13);
%  legend('Stras19','Stras20')

%motifs communs 2019 VO
drawRecoverData(t{5}, t{5}.inputName,  'Specolor',':b','namFig', 14);
drawRecoverData(t{6}, t{6}.inputName, 'Specolor','+-b','namFig', 14);
legend('VO18','VO19')% 

%motifs communs 2018-19 Stras
drawRecoverData(t{1}, t{1}.inputName,  'Specolor',':r','namFig', 15);
drawRecoverData(t{2}, t{2}.inputName, 'Specolor','+-r','namFig', 15);
legend('Stras18','Stras19')

%%%long
%voir quels motifs fréquents sont présents à Stras 2018-2019
% strasLong = {};
% strasLong2018 = {};
% strasLong2019 = {};
% istras18 = [];
% istras19 = [];
% istrascomLong18 = [];
% istrascomLong19 = [];
% for i=1:length(t{3}.inputName)
%     tname = t{3}.inputName{i};
%     if(sum(contains(t{4}.inputName,tname)))
%         strasLong =cat(1,strasLong, {tname});
%         istrascomLong18 = cat(1,istrascomLong18,i);
%         isIn = cellfun(@(x)isequal(x,tname),t{4}.inputName);
%         [row,col] = find(isIn);
%         istrascomLong19 = cat(1,istrascomLong19,col);
%     else
%        strasLong2018= cat(1,strasLong2018,{tname});
%        istras18 = cat(1,istras18, i);
% 
%     end
% end
% for i=1:length(t{4}.inputName)
%     tname2 = t{4}.inputName{i};
%     if(~sum(contains(strasLong,tname2)))
%         strasLong2019 = cat(1,strasLong2019,{tname2});
%         istras19 = cat(1,istras19, i);
% 
%     end
% end
% 
% %voir quels motifs fréquents sont présents à VO 2018-2019
% voLong = [];
% voLong2018 = [];
% voLong2019 = [];
% ivo18 = [];
% ivo19 = [];
% ivocomLong18 = [];
% ivocomLong19 = [];
% for i=1:length(t{7}.inputName)
%     tname = t{7}.inputName{i};
%     if(sum(contains(t{8}.inputName,tname)))
%         voLong= cat(1,voLong,{tname});
%         ivocomLong18 = cat(1,ivocomLong18,i);
%         isIn = cellfun(@(x)isequal(x,tname),t{8}.inputName);
%         [row,col] = find(isIn);
%         ivocomLong19 = cat(1,ivocomLong19,col);
%     else 
%         voLong2018 =cat(1,voLong2018,{tname});
%         ivo18 = cat(1,ivo18, i);
%     end
% end
% for i=1:length(t{8}.inputName)
%     tname2 = t{8}.inputName{i};
%     if(~sum(contains(voLong,tname2)))
%         voLong2019=cat(1,voLong2019,{tname2});
%         ivo19 = cat(1,ivo19,i);
%     end
% end
%voir quels motifs fréquents sont présents à VO et Stras 2018-2019
% voStrasLong = [];
% ivostraslongSt18 = [];
% ivostraslongSt19 = [];
% ivostraslongVo18 = [];
% ivostraslongVo19 = [];
% for i=1:length(voLong)
%     tname = voLong{i};
%     if(sum(contains(strasLong,tname)))
%         voStrasLong=cat(1,voStrasLong,{tname});
%         isIn = cellfun(@(x)isequal(x,tname),t{3}.inputName);
%         [row,id] = find(isIn);
%         ivostraslongSt18 = cat(1,ivostraslongSt18,id);
%         isIn = cellfun(@(x)isequal(x,tname),t{4}.inputName);
%         [row,id] = find(isIn);
%         ivostraslongSt19 = cat(1,ivostraslongSt19,id);
%         isIn = cellfun(@(x)isequal(x,tname),t{7}.inputName);
%         [row,id] = find(isIn);
%         ivostraslongVo18 = cat(1,ivostraslongVo18,id);
%         isIn = cellfun(@(x)isequal(x,tname),t{8}.inputName);
%         [row,id] = find(isIn);
%         ivostraslongVo19 = cat(1,ivostraslongVo19,id);
%     end
% end



%plot recoverData
%motifs communs 2018-19 Stras & VO
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', ivostraslongSt18, 'Specolor',':r','namFig', 1);
% drawRecoverData(t{4}, t{4}.inputName, 'Interval', ivostraslongSt19, 'Specolor','+-r','namFig', 1);
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', ivostraslongVo18,  'Specolor',':b','namFig', 1);
% drawRecoverData(t{8}, t{8}.inputName, 'Interval', ivostraslongVo19, 'Specolor','+-b','namFig', 1);
% legend('Stras18','Stras19','VO18','VO19')  

%ivo18  ivo19 ivocomLong18 ivocomLong19 
%motifs communs 2018-19 VO
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', ivocomLong18(1:size(ivocomLong18,1)/2)', 'Specolor',':b','namFig', 111);
% drawRecoverData(t{8}, t{8}.inputName,'Interval', ivocomLong19(1:size(ivocomLong19,1)/2)', 'Specolor','+-b','namFig', 111);
% legend('VO18','VO19')
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', ivocomLong18(floor(size(ivocomLong18,1))/2+1:end)', 'Specolor',':b','namFig', 211);
% drawRecoverData(t{8}, t{8}.inputName,'Interval', ivocomLong19(floor(size(ivocomLong19,1))/2+1:end)', 'Specolor','+-b','namFig', 211);
% legend('VO18','VO19') ;
% 
% %motifs communs 2018-19 Stras
% if (size(istrascomLong18,1)>0)
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', istrascomLong18(1:size(istrascomLong18,1)/2)', 'Specolor',':r','namFig', 311);
% end
% if (size(istrascomLong19,1)>0)
% drawRecoverData(t{4}, t{4}.inputName,'Interval',istrascomLong19(1:size(istrascomLong19,1)/2)', 'Specolor','+-r','namFig', 311);
% legend('Stras18','Stras19');
% end
% if (size(istrascomLong18,1)>0)
% 
% drawRecoverData(t{3}, t{3}.inputName, 'Interval',istrascomLong18(floor(size(istrascomLong18,1))/2+1:end)', 'Specolor',':r','namFig', 411);
% end
% if (size(istrascomLong19,1)>0)
% 
% drawRecoverData(t{4}, t{4}.inputName, 'Interval',istrascomLong19(floor(size(istrascomLong19,1))/2+1:end)','Specolor','+-r','namFig', 411);
% legend('Stras18','Stras19');
% end
%%%%%%%%%%%%%%%%%%%Old version%%%%%%%%%%%%%%%%%%%%%
%plot recoverData
% drawRecoverData(t{1}, t{1}.inputName,  'Specolor','xb','namFig', 1);
% drawRecoverData(t{2}, t{2}.inputName, 'Specolor','+r','namFig', 1);
% legend(t{1}.label,t{2}.label);
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', [1:8],'Specolor','xb','namFig', 2);
% drawRecoverData(t{4}, t{4}.inputName, 'Interval', [1:8],'Specolor','+r','namFig',2);
% legend(t{3}.label,t{4}.label);
% 
% 
% drawRecoverData(t{3}, t{3}.inputName, 'Interval', [9:17],'Specolor','xb','namFig', 22);
% drawRecoverData(t{4}, t{4}.inputName, 'Interval', [9:17],'Specolor','+r','namFig',22);
% legend(t{3}.label,t{4}.label);


% drawRecoverData(t{9}, t{9}.inputName, 'Interval', [1:10], 'Specolor','xb','namFig', 6);
% drawRecoverData(t{10}, t{10}.inputName,'Interval', [1:10],'Specolor','+r','namFig',6);
% legend(t{9}.label,t{10}.label);
% 
% drawRecoverData(t{9}, t{9}.inputName, 'Interval display('erràr')', [11:19], 'Specolor','xb','namFig', 7);
% drawRecoverData(t{10}, t{10}.inputName, 'Interval', [11:19],'Specolor','+r','namFig',7);
% legend(t{9}.label,t{10}.label);
% 
% drawRecoverData(t{9}, t{9}.inputName, 'Interval', [20:27], 'Specolor','xb','namFig', 8);
% drawRecoverData(t{10}, t{10}.inputName,'Interval', [20:27],'Specolor','+r','namFig',8);
% legend(t{9}.label,t{10}.label);
% 
% 
% %plot recoverData
% drawRecoverData(t{5}, t{5}.inputName, 'Interval', [1:6], 'Specolor','xb','namFig', 3);
% drawRecoverData(t{6}, t{6}.inputName, 'Interval', [1:6], 'Specolor','+r','namFig', 3);
% legend(t{5}.label,t{6}.label);
% 
% drawRecoverData(t{5}, t{5}.inputName, 'Interval', [7:12], 'Specolor','xb','namFig', 32);
% drawRecoverData(t{6}, t{6}.inputName, 'Interval', [7:12], 'Specolor','+r','namFig', 32);
% legend(t{5}.label,t{6}.label);
% 
% 
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', [1:10],'Specolor','xb','namFig', 4);
% drawRecoverData(t{8}, t{8}.inputName, 'Interval', [1:10],'Specolor','+r','namFig',4);
% legend(t{7}.label,t{8}.label);
% 
% 
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', [11:20],'Specolor','xb','namFig', 5);
% drawRecoverData(t{8}, t{8}.inputName, 'Interval', [11:20],'Specolor','+r','namFig',5);
% legend(t{7}.label,t{8}.label);
% 
% 
% drawRecoverData(t{7}, t{7}.inputName, 'Interval', [21:30],'Specolor','xb','namFig', 6);
% drawRecoverData(t{8}, t{8}.inputName, 'Interval', [21:30],'Specolor','+r','namFig',6);
% legend(t{7}.label,t{8}.label);