function data2 = groupDataBresilian(data, type)


%%groups data in forum pages (interactif, passif), file pages
%%(interactif,passif), pages and web-conf.
if(strcmp(type,'perType')==1)    
    list_forum_interactif = ["Postcriado", "Algumconte\u00fadofoipublicado.","Postatualizado","Comentariocriado", "Discussiocriada"];
    list_forum_passif = ["Discussiovisualizada","Assinaturadediscussiocriada","Comentariovisualizado","Relatoriodenotasdousuariovisualizado","Listadeusuariosvistos"];
    list_file_interactif = ["Ousuariosalvouumenvio.","Umarquivofoienviado.","Submissiocriada.","Umenviofoisubmetido."];
    list_file_passif = ["Ostatusdasubmissioivisualizado.","Formulariodesubmissiovisualizado.", "Formulariodeconfirmatiodesubmissiovisualizado."];
    list_page = ["Cursovisto","Modulodocursovisualizado","Listadeinst\u00e2nciasdemodulosdecursosvisualizados","Ousuarioaceitouoacordodatarefa.","Relatoriodevisiogeralvisualizado"];
    list_webconf = ["ReuniiodeBigBlueButtonBNadicionada","AtividadeBigBlueButtonBNvisualizada"];
    list_notImportant = ["Relatoriodeumutilizadordocursovisualizado", "Perfildousuariovisto","Visualizadorelatoriodeusuario","ReuniioBigBlueButtonBNcriada","ReuniiodeBigBlueButtonBNexclueda","Assinaturadediscussioexclueda","Assinaturacriada","Comentarioexcluedo","Postexcluedo"];
    data2.inputName = ["interactif forum","passif forum","interactif file","passif file","pages","webconf", "mark"];
    data2.nbTraj = data.nbTraj;
    data2.label = data.label;
    data2.totTime = data.totTime;
    data2.realTime = data.realTime;
    data2.y = cell(size(data.y));
    data2.yMat = cell(size(data.yMat));
    data2.alpha = data.alpha;
    
    %%%
    forum_interactif = [];
    forum_passif = [];
    file_interactif = [];
    file_passif = [];
    page = [];
    webconf = [];
    for i=1:size(data.inputName,2)
        if(any(list_forum_interactif==data.inputName(i))==1)
            forum_interactif = [forum_interactif, i];
        elseif(any(list_forum_passif==data.inputName(i))==1)
            forum_passif= [forum_passif,i];
        elseif(any(list_file_interactif==data.inputName(i))==1)
            file_interactif = [file_interactif,i];
        elseif(any(list_file_passif==data.inputName(i))==1)
            file_passif = [file_passif,i];
        elseif(any(list_page==data.inputName(i))==1)
            page = [page, i];
        elseif(any(list_webconf==data.inputName(i))==1)
            webconf = [webconf,i];
        elseif(any(list_notImportant==data.inputName(i))==0)
            display("error:");
            display(data.inputName(i));
        end
    end
    
    for traj=1:data2.nbTraj%pour chaque trajectoire
        for tt=1:data2.totTime(traj) %pour chaque horodatage, groupement
            data2.yMat{traj}(tt,1) =  sum(data.yMat{traj}(tt,forum_interactif));
            data2.yMat{traj}(tt,2) =  sum(data.yMat{traj}(tt,forum_passif));
            data2.yMat{traj}(tt,3) =  sum(data.yMat{traj}(tt,file_interactif));
            data2.yMat{traj}(tt,4) =  sum(data.yMat{traj}(tt,file_passif));
            data2.yMat{traj}(tt,5) =  sum(data.yMat{traj}(tt,page));
            data2.yMat{traj}(tt,6) =  sum(data.yMat{traj}(tt,webconf));
            data2.yMat{traj}(tt,7) = data.yMat{traj}(tt,35); %notes    
        end
        data2.y{traj} =  reshape(data2.yMat{traj}', [size(data2.yMat{traj},1)*size(data2.yMat{traj},2),1]);
    end
    
end

end