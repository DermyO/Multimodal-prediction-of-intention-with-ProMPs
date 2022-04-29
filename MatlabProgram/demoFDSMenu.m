% by Oriane Dermy
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]


init_FDS;

continueM=1;
while(continueM==1)
    k = menu('Choose an action','draw hand distribution','draw head distribution','go to home position', 'replay hand trajectory', 'record head trajectory','record hand trajectory', 'visual Inference','physical Inference', 'close the menu' );

    switch k
        case 1
            fig2 = figure;
            lll = length(promp);
            for i=1:lll
            drawDistribution(promp{i}, inputName,s_bar,[1:6], 'col', [(i/lll), 1-(i/lll),0 ], 'fig', fig2, 'mean');
            end
        case 2
            if(~ isfield(promp_head{1},'PHI'))
                a = menu('Sorry, no face trajectory has been saved.', 'Ok');
            else
                fig = figure;
                lll = length(promp_head);
                for i=1:lll
                    drawDistribution(promp_head{i}, inputName2,s_bar,[1:3], 'col', [(i/lll), 1-(i/lll),0 ], 'fig', fig, 'mean');
                end
            end
        case 3
            xd(1) = -0.153531;
            xd(2) = -0.177835;
            xd(3) = -0.124959;
            od(1) = 0.338334;
            od(2) = 0.448351;
            od(3) =-0.827352;
            od(4) = 2.558946;
            goToPosition(xd,od,connexion);
        case 4
            listing = [];
           for i =1:length(promp)
               listing{i} = promp{i}.traj.label;
           end
                 typePromp = menu('Which movement do you want to replay?', listing);
                 if((typePromp <1) || (typePromp > length(promp)))
                     menu('error, this movement does not exist');
                     continue;
                 end
                 continueMovementiCubGui(promp{typePromp},connexion, 1,s_bar, promp{typePromp}.PHI_norm,inputName,'isPrior');
                a = menu('Do you want to replay the trajectory in real ?', 'Yes', 'No');
                if(a == 1)
                    continueMovement(promp{typePromp},connexion, 1,s_bar, promp{typePromp}.PHI_norm,inputName,'isPrior', 'isEul','withoutOr');
                end
        case 5 
                nbDistrib = nbDistrib +1;
                data_action{nbDistrib} = recordFaceTrajectory(promp_head,s_bar, connexion);
                if(isempty(data_action{nbDistrib}))
                    break;
                end
                val = [];
                while(isempty(val))
                    val = input('Do you want to save the data? Yes =1. No=0.');
                end
                if(val ==1)
                    display('saving');
                    if(exist(fileNameHead)>0)
                        save(fileNameHead,'data_action','-append'); 
                    else
                        save(fileNameHead,'data_action'); 
                    end
                    save(fileNameHead,'nbDistrib','-append');    
                    a =0;
                    wholeData = concatData(data_action);
                    for i=1:length(wholeData)
                        promp_head{i} = computeDistribution(wholeData{i}, M, s_bar,c,h);
                    end
                else
                    nbDistrib = nbDistrib -1;
                end
    
        case 6
            a = menu('Do you want to:', 'Create a new trajectory type', 'Complete a trajectory');
            
            %creating a new PROMP
            if(a==1)
                ii = input('Enter the trajectory name');
                t{length(t)+1} = recordTrajectoryWithRealIcub(connexion, ii, nbInput, s_bar);
                namFig = figure;
                drawRecoverData(t{length(t)}, inputName, 'Specolor','b','namFig', 1);
                a = menu('Do you want to record this trajectory type?', 'Yes','No');
                if(a== 1)
                    save(fileNameHand, 't', '-append');
                    promp{length(t)} = computeDistribution(t{length(t)}, M, s_bar,c,h);
                else
                    t{length(t)} = [];
                end
            %completing a PROMP distribution
            else
            	listing = [];
                for i =1:length(promp)
                    listing{i} = promp{i}.traj.label;
                end
                typePromp = menu('Which movement do you want to replay?', listing);
                if((typePromp <1) || (typePromp > length(promp)))
                	menu('error, this movement does not exist');
                    continue;
                end
                temp_t = recordTrajectoryWithRealIcub(connexion, listing{typePromp}, nbInput, s_bar,'update', t{typePromp});
                namFig = figure;
                drawRecoverData(t{typePromp}, inputName, 'Specolor','b','namFig', 1);
                drawRecoverData(temp_t, inputName, 'Specolor','.r','namFig', 1);
                a = menu('Do you want to record this trajectory type?', 'Yes','No');
                if(a== 1)
                    t{typePromp} = temp_t;
                	save(fileNameHand, 't', '-append');
                    promp{typePromp} = computeDistribution(t{typePromp}, M, s_bar,c,h);
                end
            end
        case 7
            %%Testing the learning   
            nbd = min(cellfun(@(x)(x.meanTimes),promp_head));
            clear test;
            
            test = beginAHeadTrajectory(connexion,nbd);

            %Recognition of the movement
            [alphaTraj,type, x] = inferenceAlpha(promp_head,test,M,s_bar,c,h,test.nbData, expNoise, 'ML');
            recoPromp{1} =promp_head{type}; % we keep only the inferred ProMP
            [infTraj,typeReco] = inference(recoPromp, test, M, s_bar, c, h, test.nbData, expNoise, alphaTraj, connexion);
            display(['the recognized type is ',promp_head{type}.traj.label ])
            %to ask icub to say the label of the recognize trajectory

            sayType(promp_head{type}.traj.label, connexion);
            drawInference(promp_head,inputName2,infTraj, test,s_bar)
            
           inf = continueMovementiCubGui(promp{type},connexion, test.nbData,s_bar, promp{type}.PHI_norm,inputName, 'isPrior');
           %   a = menu('Do you want to replay?','Yes', 'No');
           %   if(a==1)
                continueMovement(promp{type},connexion, 1,s_bar, promp{type}.PHI_norm,inputName,'isPrior','withoutOr');

            %end
        case 8
            clear test;
            test{1} = beginATrajectoryWithRealIcub(connexion);
            
            w = computeAlpha(test{1}.nbData,t, nbInput);
            
            for i=1:length(promp)
                promp{i}.w_alpha= w{i};
            end
            
            %Recognition of the movement
            [alphaTraj,type, x] = inferenceAlpha(promp,test{1},M,s_bar,c,h,test{1}.nbData, expNoise, 'MO');
            recoPromp{1} =promp{type}; % we keep only the inferred ProMP
            [infTraj,typeReco] = inference(promp, test{1}, M, s_bar, c, h, test{1}.nbData, expNoise, alphaTraj, connexion);

            %to ask icub to say the label of the recognize trajectory
            sayType(promp{typeReco}.traj.label, connexion);
            drawInference(promp,inputName,infTraj, test{1},s_bar)

            continueMovementiCubGui(infTraj,connexion, test{1}.nbData,s_bar, promp{type}.PHI_norm,inputName);
            %replay the movement
            a = menu('Do you want to play on icub?', 'Yes', 'Promp','No');
            
            if(a==1)
                a = menu('clique OK when you are ready.'); 
                continueMovement(infTraj,connexion, test{1}.nbData,s_bar, promp{type}.PHI_norm,inputName,'withoutOr');

            elseif(a==2)
                inf = continueMovementiCubGui(promp{type},connexion, test{1}.nbData,s_bar, promp{type}.PHI_norm,inputName, 'isPrior');
                %continueMovement(inf,connexion, test{1}.nbData,s_bar, promp{type}.PHI_norm,inputName, 'isPrior','withoutOr');
                continueMovement(promp{type},connexion, 1,s_bar, promp{type}.PHI_norm,inputName,'isPrior','withoutOr');

            end
%         case 9
%             subMenu = menu('Which grasping do you want?', 'close', 'open');
%             if(subMenu == 1)
%                 closeEndOrder = 'left close_hand';
%             else
%                 closeEndOrder = 'left open_hand';
%             end
%             closeHand;
            
        case 9
            continueM =0;
    end
end

a = menu('Close connection?', 'Yes', 'No');
if(a==1)
    %close the port and the program replay.
    closeConnectionRealIcub(connexion,'withFacePos');
end
