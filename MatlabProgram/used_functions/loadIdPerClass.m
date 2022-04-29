function list = loadIdPerClass(PATH, PATH2, PATH3, PATH4)
%loadIdPerClass recovers a list of id_stu in a specific file.
%INPUT: PATH is the file path.

data = readtable(PATH);
list{1} = data.id_student;
data = readtable(PATH2);
list{2} = data.id_student;
data = readtable(PATH3);
list{3} = data.id_student;
data = readtable(PATH4);
list{4} = data.id_student;
end