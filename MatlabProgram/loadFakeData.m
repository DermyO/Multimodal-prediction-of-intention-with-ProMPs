function t = loadFakeData(PATH, label)

dateExam = [23,25,51,53,79,81,114,116,149,151,170,200,206,240];
data_tot = readtable(PATH);
t.label = label;
t.nbTraj = size(data_tot,1);
t.y = cell(t.nbTraj,1);
t.yMat = cell(t.nbTraj,1);
t.realTime = cell(t.nbTraj,1);

for n=1:t.nbTraj
    t.y{n}= data_tot(n,:).Variables';
    t.yMat{n} = [data_tot(n,1:14).Variables',data_tot(n,15:28).Variables', data_tot(n,29:42).Variables'];
    t.totTime(n) = 14;
    t.nbInput=3;
    t.alpha(n) = 1;
    t.realTime{n} = dateExam;
end

end