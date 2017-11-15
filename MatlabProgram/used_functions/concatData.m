function wdata = concatData(pdata)


%init
for j = 1:length(pdata{1})
        wdata{j}.nbTraj = 0;
        wdata{j}.nbInput = pdata{1}{j}.nbInput;
        wdata{j}.label = pdata{1}{j}.label;
        wdata{j}.alpha = [];
        wdata{j}.totTime = [];
        wdata{j}.yMat = [];
        wdata{j}.y = [];
        wdata{j}.realTime = [];
        wdata{j}.interval = [];
end     


for i=1:length(pdata)
    for j = 1:length(pdata{i})
        for k = 1:pdata{i}{j}.nbTraj
            wdata{j}.alpha(wdata{j}.nbTraj + k) = pdata{i}{j}.alpha(k);
            wdata{j}.totTime(wdata{j}.nbTraj + k) = pdata{i}{j}.totTime(k);
            wdata{j}.yMat{(wdata{j}.nbTraj + k)} = pdata{i}{j}.yMat{k};
            wdata{j}.y{(wdata{j}.nbTraj + k)} = pdata{i}{j}.y{k};
            wdata{j}.realTime{(wdata{j}.nbTraj + k)} = pdata{i}{j}.realTime{k};
            wdata{j}.interval(wdata{j}.nbTraj + k) = pdata{i}{j}.interval(k); 
        end
        wdata{j}.nbTraj = wdata{j}.nbTraj + pdata{i}{j}.nbTraj;
    end
end

end