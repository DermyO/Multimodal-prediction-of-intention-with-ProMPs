function  t = loadTrajectoryBresilian(listName, s_bar, label, varargin)

%%Function that load bresilian data.
%if some mark are missing, we create it as the average between marks that
%occurs before and after.
%curveMark : create values per week between each mark to have a curve


listEvents = ["Cursovisto"];
isCurve = false;
for j=1:length(varargin)
    if(strcmp(varargin{j},'listName')==1)
        listEvents = varargin{j+1};
    elseif(strcmp(varargin{j},'curveMark')==1)
        isCurve = true;
    end
end

datetime.setDefaultFormats('default','dd/MM/yyyyHH:mm');
t.label = label;

weeksExam = [week(datetime('11/09/202016:00')),week(datetime('27/09/202016:00')),week(datetime('11/10/202016:00')),week(datetime('25/10/202016:00')),week(datetime('07/11/202016:00')),week(datetime('20/11/202016:00')),week(datetime('30/12/202016:00'))];%the last date is unknown

nbEvents = 35;%nbEvents;%18 +1 (exams);

k=0;
for kk=1:size(listName,1)
    
    %retrieve data
    fid = fopen(listName{kk});
    raw = fread(fid,inf);
    str = char(raw');
    fclose(fid);
    data = JSON.parse(str);
 
    %fill empty exams 
    data.grades = fillEmptyExams(data.grades);
    
    %retrieve first interaction week
    if(~ isfield(data, "interactions"))
        continue;
    else
        k=k+1;
    end
    
    dI = datetime(data.interactions{1}.Hora);
    dateInit = week(dI);
    if(dateInit > weeksExam(1))
        dateInit = weeksExam(1);
    end
    
    %retrieve last interaction week
    dE = datetime(data.interactions{size(data.interactions,2)}.Hora);
    dateEnd = week(dE) + 53*(year(dE) - year(dI));%adding 53 for all additional year.
    if(dateEnd < weeksExam(7))
        dateEnd = weeksExam(7);
    end
    
    t.totTime(k) =  dateEnd - dateInit +1; %totalNumber of weeks
    t.realTime{k} =(dateInit:dateEnd);
    if(t.totTime(k) <0)%if there is a year change
        display("erreur l54 load trajectory Bresilian");
        % Normally not usefull thanks to the previous add of 53*...
        % t.totTime(k) = t.totTime(k) + 53;
        % t.realTime{k} =(dateInit:dateEnd+53);
    end
    
    t.yMat{k} = zeros(t.totTime(k),nbEvents);
    t.y{k} = zeros(t.totTime(k)*nbEvents,1);
    t.alpha(k) = s_bar / t.totTime(k);%TODO changer ici en fonction de s_bar
    
    %%treatment of the exams
    id_date = weeksExam(1) - dateInit+1;
    if(id_date <= 0)
        id_date= id_date +53;
    end
    t.yMat{k}(id_date,35) = data.grades.ForumM;
    
    %treatment before first exam to plot a curve
    if(isCurve)
        for idx=1:id_date
            t.yMat{k}(idx,35) = t.yMat{k}(id_date,35);
        end
    end
    
    id_date = weeksExam(2) - dateInit+1;
    if(id_date < 0)
        id_date= id_date +53;
    end
    t.yMat{k}(id_date,35) = data.grades.TMII;
    %between 1st and 2nd mark: curve y = ax+b
    if(isCurve)
        a = (t.yMat{k}(idx,35) -  t.yMat{k}(id_date,35)) / (idx - id_date);
        b = t.yMat{k}(idx,35) - a*idx;
        if(id_date-idx <0)
            display("ici");
        end
        for idx2=idx+1:id_date-1
            t.yMat{k}(idx2,35) = a*idx2 +b;
        end
    end
    
    id_date = weeksExam(3) - dateInit+1;
    if(id_date < 0)
        id_date= id_date +53;
    end
    t.yMat{k}(id_date,35) = data.grades.TMIII;
    %between 2st and 3rd mark: curve y = ax+b
    if(isCurve)
        a = (t.yMat{k}(idx2+1,35) -  t.yMat{k}(id_date,35)) / (idx2+1 - id_date);
        b = t.yMat{k}(idx2+1,35) - a*(idx2+1);
        for idx=idx2+1:id_date-1
            t.yMat{k}(idx,35) = a*idx +b;
        end
    end
    
    id_date = weeksExam(4) - dateInit+1;
    if(id_date < 0)
        id_date= id_date +53;
    end
    t.yMat{k}(id_date,35) = data.grades.TMIV;
    %between 3rd and 4th mark: curve y = ax+b
    if(isCurve)
        a = (t.yMat{k}(idx2+1,35) - t.yMat{k}(id_date,35)) / (idx+1 - id_date);
        b = t.yMat{k}(idx2+1,35) - a*(idx+1);
        for idx2=idx+1:id_date-1
            t.yMat{k}(idx2,35) = a*idx2 +b;
        end
    end
    
    id_date = weeksExam(5) - dateInit+1;
    if(id_date < 0)
        id_date= id_date +53;
    end
    t.yMat{k}(id_date,35) = data.grades.TMV;
    %between 4th and 5th mark: curve y = ax+b
    if(isCurve)
        a = (t.yMat{k}(idx+1,35) - t.yMat{k}(id_date,35)) / (idx2+1 - id_date);
        b = t.yMat{k}(idx+1,35) - a*(idx2+1);
        for idx=idx2+1:id_date-1
            t.yMat{k}(idx,35) = a*idx +b;
        end
    end
    
    id_date = weeksExam(7) - dateInit+1;
    if(id_date < 0)
        id_date= id_date +53;
    end
    t.yMat{k}(id_date,35) = data.grades.TS;
    %between 5th and 7th mark: curve y = ax+b
    if(isCurve)
        a = (t.yMat{k}(idx2+1,35) - t.yMat{k}(id_date,35)) / (idx+1 - id_date);
        b = t.yMat{k}(idx2+1,35) - a*(idx+1);
        for idx2=idx+1:id_date-1
            t.yMat{k}(idx2,35) = a*idx2 +b;
        end
    end
    
    
    %treatment after last exam to plot a curve
    if(isCurve)
        for idx=id_date:dateEnd
            t.yMat{k}(idx,35) = t.yMat{k}(id_date,35);
        end
    end
    
    %TODO verifier plot notes
    %treatment of all interactions
    for i=1:size(data.interactions,2)
        if(isempty(find(listEvents == data.interactions{i}.Nomedoevento)))
            listEvents = [listEvents, data.interactions{i}.Nomedoevento];
        end
        date = datetime(data.interactions{i}.Hora);
        id_date = week(date) +53*(year(date)-year(dI)) - dateInit + 1;
        id_event = find(listEvents == data.interactions{i}.Nomedoevento);
        t.yMat{k}(id_date,id_event) = t.yMat{k}(id_date,id_event)+1;
    end
    t.y{k} = reshape(t.yMat{k}', [size(t.yMat{k},1)*size(t.yMat{k},2),1]);
end
t.inputName = listEvents;
t.nbTraj = k;


%dateExam = [11/09/2020;27/09/2020;11/10/2020;25/10/2020;07/11/2020;20/11/2020;31/12/2020];

end

