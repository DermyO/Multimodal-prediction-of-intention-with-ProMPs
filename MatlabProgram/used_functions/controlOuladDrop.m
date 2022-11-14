function promp = controlOuladDrop(promp)
%TODO test du 18/08/22: pour les étudiants qui échouent ou abandonne, on
%force la promp a aller au max délai/0 pour correspondre aux données
%réelles.

    totalTime = size(promp,1)/3;
    drop = 0;
%     lt = zeros(totalTime,1);
%     lv = zeros(totalTime,1);
    for cpt=2:totalTime
        t= cpt + 80; %delay;    
        vt = promp(t) - promp(t-1);
%         lt(cpt-1) = promp(t);
%         lv(cpt-1) = vt;
        if(vt >50) %drop
           drop=1;
           break;
        end
    end
    
    %if there is a drop
    if(drop==1)
        summ = totalTime - cpt +1;
        promp(totalTime+cpt:totalTime*2) = zeros(summ,1);
        promp(totalTime*2+cpt:totalTime*3) = ones(summ,1)*240;
    end
    
end