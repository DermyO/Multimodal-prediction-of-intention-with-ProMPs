function createFileFromOulad(t)

className = ["Distinction","Pass","Withdrawn","Fail"];


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

end