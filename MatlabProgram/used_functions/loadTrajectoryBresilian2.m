function  t = loadTrajectoryBresilian(listName)

t.nbTraj = size(listName,2);
t.nbInput = 17; %17 events
datetime.setDefaultFormats('default','dd/MM/yyyyHH:mm');
t.label = "test";
nbEvents = 19;%18 +1 (exams);


weeksExam = [week(datetime('11/09/202016:00')),week(datetime('27/09/202016:00')),week(datetime('11/10/202016:00')),week(datetime('25/10/202016:00')),week(datetime('07/11/202016:00')),week(datetime('20/11/202016:00')),week(datetime('30/12/202016:00'))];%the last date is unknown

for k=1:size(listName,2)
    fid = fopen(listName{k});
    raw = fread(fid,inf);
    str = char(raw');
    fclose(fid);    
    data = JSON.parse(str);
      
    dateInit = week(datetime(data.interactions{1}.Hora));
    dateEnd = week(datetime(data.interactions{size(data.interactions,2)}.Hora));
    t.totTime{k} =  dateEnd - dateInit +1; %totalNumber of weeks
    t.realTime{k} =(dateInit:dateEnd);
    if(t.totTime{k} <0)%if there is a year change
        t.totTime{k} = t.totTime{k} + 53;  
        t.realTime{k} =(dateInit:dateEnd+53);
    end
    
    t.yMat{k} = zeros(t.totTime{k},nbEvents);
    t.y{k} = zeros(t.totTime{k}*nbEvents,nbEvents);
    listEvents = ["Cursovisto"];
    
    t.alpha(k) = 1;
    
    %treatment of the exams
    id_date = weeksExam(1) - dateInit+1;
    if(id_date < 0) 
       id_date= id_date +53;
    end
    t.yMat{k}(id_date,19) = data.grades.ForumM;
    
    id_date = weeksExam(2) - dateInit+1;
    if(id_date < 0) 
       id_date= id_date +53;
    end
    t.yMat{k}(id_date,19) = data.grades.TMII;
    
    id_date = weeksExam(3) - dateInit+1;
    if(id_date < 0) 
       id_date= id_date +53;
    end
    t.yMat{k}(id_date,19) = data.grades.TMIII;
    
    id_date = weeksExam(4) - dateInit+1;
    if(id_date < 0) 
       id_date= id_date +53;
    end
    t.yMat{k}(id_date,19) = data.grades.TMIV;

    id_date = weeksExam(5) - dateInit+1;
    if(id_date < 0) 
       id_date= id_date +53;
    end
    t.yMat{k}(id_date,19) = data.grades.TMV;

    id_date = weeksExam(7) - dateInit+1;
    if(id_date < 0) 
       id_date= id_date +53;
    end
    t.yMat{k}(id_date,19) = data.grades.TS;
    
    
    %%TODO maintenant que j'ai récupéré les notes, fiare les courbes entre
    %%dates d'exams.
    
    
    %treatment of all interactions
    for i=1:size(data.interactions,2)
        if(isempty(find(listEvents== data.interactions{i}.Nomedoevento)))
            listEvents = [listEvents, data.interactions{i}.Nomedoevento];
        end
        id_date = week(datetime(data.interactions{i}.Hora)) - dateInit + 1;
        if(id_date < 0) 
            id_date= id_date +53;
        end
        id_event = find(listEvents == data.interactions{i}.Nomedoevento);
        t.yMat{k}(id_date,id_event) = t.yMat{k}(id_date,id_event)+1;
    end
    t.y{k} = reshape(t.yMat{k}', [size(t.yMat{k},1)*size(t.yMat{k},2),1]);
end
t.inputName = listEvents;
%dateExam = [11/09/2020;27/09/2020;11/10/2020;25/10/2020;07/11/2020;20/11/2020;31/12/2020];

end

