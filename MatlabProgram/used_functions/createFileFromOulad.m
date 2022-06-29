function createFileFromOulad(t,varargin)


version = 1;
if (~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i},'v2')==1)
            version=2;
        end
    end
end

className = ["Distinction","Pass","Withdrawn","Fail"];

if(version==1)
    for class = 1:4
        name = strcat('real_data_', className(class), '.csv')
        fid = fopen(name, 'wt')
        fprintf(fid, 'totClicks_1,totClicks_2,totClicks_3,totClicks_4,totClicks_5,totClicks_6,totClicks_7,totClicks_8,totClicks_9,totClicks_10,totClicks_11,totClicks_12,totClicks_13,totClicks_14,score_1,score_2,score_3,score_4,score_5,score_6,score_7,score_8,score_9,score_10,score_11,score_12,score_13,score_14,delay_1,delay_2,delay_3,delay_4,delay_5,delay_6,delay_7,delay_8,delay_9,delay_10,delay_11,delay_12,delay_13,delay_14\n');
        for i=1: t{class}.nbTraj
            sinit= "";
            for time=1:41
                sinit=strcat(sinit, "%f,");
            end
            sinit= strcat(sinit,"%f\n");
            
            fprintf(fid, sinit, t{class}.y{i}(1), t{class}.y{i}(2), t{class}.y{i}(3), t{class}.y{i}(4), t{class}.y{i}(5), t{class}.y{i}(6), t{class}.y{i}(7), t{class}.y{i}(8), t{class}.y{i}(9), t{class}.y{i}(10), t{class}.y{i}(11), t{class}.y{i}(12), t{class}.y{i}(13), t{class}.y{i}(14), t{class}.y{i}(15), t{class}.y{i}(16), t{class}.y{i}(17), t{class}.y{i}(18), t{class}.y{i}(19), t{class}.y{i}(20), t{class}.y{i}(21), t{class}.y{i}(22), t{class}.y{i}(23), t{class}.y{i}(24), t{class}.y{i}(25), t{class}.y{i}(26), t{class}.y{i}(27), t{class}.y{i}(28), t{class}.y{i}(29), t{class}.y{i}(30), t{class}.y{i}(31), t{class}.y{i}(32), t{class}.y{i}(33), t{class}.y{i}(34), t{class}.y{i}(35), t{class}.y{i}(36), t{class}.y{i}(37), t{class}.y{i}(38), t{class}.y{i}(39), t{class}.y{i}(40), t{class}.y{i}(41), t{class}.y{i}(42));
        end
        fclose(fid);
    end
else %v2
    
    dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
    idTableExam0 = zeros(size(dateExam));
    idTableExam = zeros(size(dateExam));
    idTableExam2 = zeros(size(dateExam));
    %knowing that data goes from -18 -11 ... 261 (all 7 days) ==> 40
    for k =1:size(dateExam,2)
        idTableExam0(k) = floor((dateExam(k) +18)/7)+1;
        idTableExam(k) = floor((dateExam(k) +18)/7)+1 + 40;
        idTableExam2(k) = floor((dateExam(k) +18)/7)+1 + 40*2;
    end
    
    
    for class = 1:4
        name = strcat('real_data_', className(class), '.csv')
        fid = fopen(name, 'wt')
        
        
        %create string name
        s= "";
        for i=1:40
            val = (i-1)*7-18;
            s = strcat(s,"totClicks_",int2str(val),",");
        end
        s = strcat(s, "score_1,score_2,score_3,score_4,score_5,score_6,score_7,score_8,score_9,score_10,score_11,score_12,score_13,score_14,delay_1,delay_2,delay_3,delay_4,delay_5,delay_6,delay_7,delay_8,delay_9,delay_10,delay_11,delay_12,delay_13,delay_14\n");
        fprintf(fid, s);
        
        
        for i=1: t{class}.nbTraj
            sinit= "";
            for time=1:67%41
                sinit=strcat(sinit, "%f,");
            end
            sinit= strcat(sinit,"%f\n");
            pp = zeros(68,1);
            pp(1:40) = t{class}.y{i}(1:40);
            pp(40+1:40+14) = t{class}.y{i}(idTableExam);
            pp(40+14+1:40+28) = t{class}.y{i}(idTableExam2);
            fprintf(fid, sinit, pp);
        end
        fclose(fid);
    end
    
end

end