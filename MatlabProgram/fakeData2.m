function fakeData = fakeData2(promp, nbProMP, n,t, nbInput,M,s_bar,c,h,expNoise,inputName, varargin)
%FAKEDATA2 create n fictive data from the given a PromP. Improvement with
%fakeData: doesn't predict the good promp (known a priori)
%varargin : we can precise in which figure we want to plot.

% 1) take two random numbers (i,j) between 1 and promp.nbTraj.
% 2) take 1/4 of min_{i,j}(promp.traj{min}.totTime).
% 3) Create a fake beginning of a trajectory
% 4) infer the continuation of the trajectory.
% 5) Plot this new trajectory with the ProMP.
% 6) Record it in a new file.

has_ymin=0;
figNumber =10;
flag_file = 0;
kernel = 'gaussian';
oulad=0;
flag_plot = 0;
if (~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'fig')==1)
            figNumber = varargin{i+1};
            flag_plot =1;
        elseif(strcmp(varargin{i},'ymin')==1)
            has_ymin = 1;
            ymin = varargin{i+1};
        elseif(strcmp(varargin{i},'Periodic')==1)
            kernel = 'Periodic';
        elseif(strcmp(varargin{i},'save')==1)
            flag_file = 1;
        elseif(strcmp(varargin{i},'OULAD')==1) %specific to OULAD data clicks/marks/delays
            oulad = varargin{i+1};
            dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
            idTableExam0 = zeros(size(dateExam));
            idTableExam = zeros(size(dateExam));
            idTableExam2 = zeros(size(dateExam));
            %knowing that data goes from -18 -11 ... 261 (all 7 days) ==> 40
            for k =1:size(dateExam,2)
                idTableExam0(k) = floor((dateExam(k) +18)/7)+1;
                idTableExam(k) = floor((dateExam(k) +18)/7)+1 + s_bar;
                idTableExam2(k) = floor((dateExam(k) +18)/7)+1 + s_bar*2;
            end
        end
    end
end

test2 = cell(n);
col = 'b';
switch nbProMP
    case 1 
        col = 'b';
    case 2 
        col = 'g';
    case 3 
        col = 'r';
    case 4 
        col = 'k';
    otherwise
        col = 'm';
end

if(flag_plot==1)
    if(oulad == 0)
        if(has_ymin==0)
            drawDistribution(promp, inputName,s_bar, 'col', col, 'ymin', [0,0,-50],'ymax', [1500,100,300], 'xmin', [1,1,1], 'xmax', [t{1}.totTime(1),t{1}.totTime(1),t{1}.totTime(1)], 'fig',figNumber);
        else
            drawDistribution(promp, inputName,s_bar, 'col', col, 'ymin', ymin, 'fig',figNumber);  
        end
    else 
        if(has_ymin==0)
            drawDistribution(promp, inputName,s_bar, 'col', col, 'ymin', [0,0,-50,-100,-100,-100],'ymax', [1500,100,300,1500,1500,1500], 'xmin', [1,1,1,1,1,1], 'xmax', [t{1}.totTime(1),t{1}.totTime(1),t{1}.totTime(1),t{1}.totTime(1),t{1}.totTime(1),t{1}.totTime(1)], 'fig',figNumber, 'OULAD');
        else
            drawDistribution(promp, inputName,s_bar, 'col', col, 'ymin', ymin, 'fig',figNumber, 'OULAD');
        end
    end
end

%for all trajectories to create, 
%we initialize the trajectories from two random real trajectories of the cluster (Yinit = a*t(1) + b*t(2), a + b =1).
%then, we compute the continuation of this new trajectory using the
%corresponding ProMP.
for new=1:n  
    i = floor(1 + (promp.traj.nbTraj - 1)*rand(1)); %random traj 1
    %random traj2
    j=i; 
    while (j==i)
       j =  floor(1 + (promp.traj.nbTraj - 1)*rand(1));
    end
    
    %time init
    min = promp.traj.totTime(i);
    if(min > promp.traj.totTime(j))
        min = promp.traj.totTime(j);
    end
    nbTime = floor(min/4);
    
    test2{new}.nbData = nbTime;
    
    %random ponderation between 0.1 to 0.9
    alpha = 0.1 + 0.8*rand(1);
    beta = 1 - alpha;
    if(alpha <0 || alpha >1 || beta <0 || beta >1)
        s = "error : alpha=" + alpha;
        display(s);
    end
    
    %fill data
    totTimei = promp.traj.totTime(i);
    totTimej = promp.traj.totTime(j);
    for inp =1 : nbInput(1)
        for time = 1: nbTime 
           test2{new}.partialTraj(time + ((inp-1)*nbTime)) = alpha*promp.traj.y{i}(totTimei*(inp-1) + time) + beta*promp.traj.y{j}(totTimej*(inp-1) + time);
           test2{new}.partialTrajMat(time,inp) = alpha*promp.traj.y{i}(totTimei*(inp-1) + time) + beta*promp.traj.y{j}(totTimej*(inp-1) + time);
        end
    end
    test2{new}.partialTraj= test2{new}.partialTraj';
    test = test2{new};
    w = computeAlpha(test.nbData,t, nbInput,M,s_bar,c,h,expNoise);
    promp.w_alpha = w{1};
    alphaTraj = 1;
    promps{1} = promp;
    fakeData{new} = inference(promps, test, M, s_bar, c, h, test.nbData, expNoise, alphaTraj, nbInput, kernel);
    posterior{new} = fakeData{new}.PHI*fakeData{new}.mu_w;
    posterior{new} = controlExtremValues(posterior{new},s_bar);
end

%create file with new data    posterior{new} = fakeData{new}.PHI*fakeData{new}.mu_w;

if(flag_file ==1)
    className = ["Distinction","Pass","Withdrawn","Fail"];
    name = strcat('fake_data_', kernel, '_', className(nbProMP), '.csv')
    fid = fopen(name, 'wt')
    
    
     dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
	 idTableExam0 = zeros(size(dateExam));
     idTableExam = zeros(size(dateExam));
     idTableExam2 = zeros(size(dateExam));
            %knowing that data goes from -18 -11 ... 261 (all 7 days) ==> 40
	 for k =1:size(dateExam,2)
        idTableExam0(k) = floor((dateExam(k) +18)/7)+1;
        idTableExam(k) = floor((dateExam(k) +18)/7)+1 + s_bar;
        idTableExam2(k) = floor((dateExam(k) +18)/7)+1 + s_bar*2;
     end
    
    
    %create string name
    s= "";
    for i=1:40
        val = (i-1)*7-18;
        s = strcat(s,"totClicks_",int2str(val),",");
    end
    s = strcat(s, "score_1,score_2,score_3,score_4,score_5,score_6,score_7,score_8,score_9,score_10,score_11,score_12,score_13,score_14,delay_1,delay_2,delay_3,delay_4,delay_5,delay_6,delay_7,delay_8,delay_9,delay_10,delay_11,delay_12,delay_13,delay_14\n");
    fprintf(fid, s);
    for i=1:n
        sinit= "";
        for time=1:67%41
            sinit=strcat(sinit, "%f,");
        end
        sinit= strcat(sinit,"%f\n");
        
        pp = zeros(68,1);
        
        pp(1:40) = posterior{i}(1:40);
        pp(40+1:40+14) = posterior{i}(idTableExam);
        pp(40+14+1:40+28) = posterior{i}(idTableExam2);

        fprintf(fid, sinit, pp);
    end
    fclose(fid);  
end


if(flag_plot==1)
	fig = figure(figNumber);
    if(oulad ==0)
        for i=1:n %for all created trajectories
            mintmp = s_bar;
            if(sum(nbInput)>1)%if multidim
                for inp = 1:sum(nbInput) %for all dimension of the trajectory
                    if(nbInput<4) 
                        subplot(sum(nbInput),1,inp); %we create a subplot
                    else
                            subplot(sum(nbInput)/2,2,inp); %we create a subplot
                    end
                    fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:mintmp], posterior{i}(1 + mintmp*(inp-1) :mintmp*inp), 'm');hold on;
                    if(inp <= nbInput(1))
                        fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:test2{i}.nbData], test2{i}.partialTraj(1 + test2{i}.nbData*(inp-1) :test2{i}.nbData*inp), 'ok');hold on;
                    end
                end
            else % we plot posterior trajectory (red) from the init trajectory (o in black)
                fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:mintmp], posterior{i}(1:mintmp), 'm');hold on;
                fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:test2{i}.nbData], test2{i}.partialTraj(1 :test2{i}.nbData), 'ok');hold on;
            end
        end
    elseif(oulad ==1) % input 2 & 3 = exam & date ==> only specific dates.
        for i=1:n %for all created trajectories
           mintmp = s_bar;
           %create subplot for clicks
           if(sum(nbInput)<4) 
               subplot(sum(nbInput),1,1); %we create a subplot
           else
               subplot(sum(nbInput)/2,2,1); %we create a subplot
           end
           fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:mintmp], posterior{i}(1:mintmp), '--m');hold on;
           fig(size(fig,2) + 1) =  plot([alphaTraj:alphaTraj:test2{i}.nbData], test2{i}.partialTraj(1:test2{i}.nbData), 'ok');hold on;
           %create subplot for date then exam
           if(sum(nbInput)<4) 
            subplot(sum(nbInput),1,2);
           else
            subplot(sum(nbInput)/2,2,2);
           end
           fig(size(fig,2) + 1) =  plot(idTableExam0, posterior{i}(idTableExam), ':xm');hold on;
           
           if(sum(nbInput)<4) 
           	subplot(sum(nbInput),1,3);
           else
            subplot(sum(nbInput)/2,2,3);
           end
            fig(size(fig,2) + 1) =  plot(idTableExam0, posterior{i}(idTableExam2), ':xm');hold on;
  

        end

    end
end

