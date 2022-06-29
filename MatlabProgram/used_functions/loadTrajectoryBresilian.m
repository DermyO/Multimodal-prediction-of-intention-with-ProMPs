function  t = loadTrajectoryBresilian(listName)

t.nbTraj = size(listName,2);

fid = fopen(listName{1});
raw = fread(fid,inf);
str = char(raw');
fclose(fid);

data = JSON.parse(str)



dateExam = [11/09/2020;27/09/2020;11/10/2020;25/10/2020;07/11/2020;20/11/2020;31/12/2020];

end

