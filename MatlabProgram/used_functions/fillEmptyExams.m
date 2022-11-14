function grades = fillEmptyExams(dgrades)
%function specifics to bresilian data to fill empty grades.

if(isempty(dgrades.TR))
    dgrades.TR = -1;
end
if(isempty(dgrades.ForumM))
    dgrades.ForumM = -1;
end
if(isempty(dgrades.TMII))
    dgrades.TMII = -1;
end
if(isempty(dgrades.TMIII))
    dgrades.TMIII = -1;
end
if(isempty(dgrades.TMIV))
    dgrades.TMIV = -1;
end
if(isempty(dgrades.TMV))
    dgrades.TMV = -1;
end
if(isempty(dgrades.TS))
    dgrades.TS = -1;
end

 
 
 tab = [dgrades.ForumM,dgrades.TMII,dgrades.TMIII,dgrades.TMIV,dgrades.TMV,dgrades.TR,dgrades.TS];
 
 
%init research min defined date
i=1;
while ((i <= size(tab,2)) && (tab(i)==-1))
    i = i+1;
end
if(i<=size(tab,2))%si pas de date on retourne le tab de -1
    minDate = tab(i);
    for j=1:i-1
        tab(j) = tab(i);
    end
end
%other results
for j=i:size(tab,2)
    if(tab(j)==-1)
        k= j+1;
        while(k <= size(tab,2) && tab(k)==-1)
            k = k+1
        end
        if(k<= size(tab,2))
            maxDate = tab(k);
            increment = (maxDate-minDate) / (k-j+1);
            for l=j:k-1
                tab(l)= tab(l-1) + increment; 
            end
            minDate = tab(k);
        else
            break;
        end
    else
        minDate = tab(j);
    end
end

grades.ForumM = tab(1);
grades.TMII = tab(2);
grades.TMIII = tab(3);
grades.TMIV = tab(4);
grades.TMV = tab(5);
grades.TR = tab(6);
grades.TS = tab(7);

%Debug
%display(dgrades)
%display(grades)
 
end