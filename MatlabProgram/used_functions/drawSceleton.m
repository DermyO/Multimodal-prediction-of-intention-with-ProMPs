function drawSceleton(t, varargin)
    

    flagPlotInf = 0;
    if(~isempty(varargin))
        flagPlotInf = 1;
        inftraj = varargin{1};
        nbDataInf = varargin{2}
    end
       
    fig =  figure('units','normalized','outerposition',[0 0 0.75 1]);
    
    if(flagPlotInf ==0)
        for tmm=1:70        
            val = t(tmm,:);

            %head
            scatter3(val(19), val(20), val(21), 'k', 'Linewidth', 10);hold on;

            %body
            plot3([val(1), val(10)], [val(2),val(11)], [val(3),val(12)], 'Linewidth',4, 'color', 'k');
            plot3([val(16), val(10)], [val(17),val(11)], [val(18),val(12)], 'Linewidth',4, 'color', 'k');
            plot3([val(16), val(19)], [val(17),val(20)], [val(18),val(21)], 'Linewidth',4, 'color', 'k');

            %left leg
            plot3([val(67), val(64)], [val(68),val(65)], [val(69),val(66)], 'Linewidth',4, 'color', 'k');
            plot3([val(61), val(64)], [val(62),val(65)], [val(63),val(66)], 'Linewidth',4, 'color', 'k');
            plot3([val(61), val(58)], [val(62),val(59)], [val(63),val(60)], 'Linewidth',4, 'color', 'k');
            scatter3(val(67), val(68), val(69), '*k', 'Linewidth', 3);hold on;

    %         
            %link between legs
            plot3([val(46), val(58)], [val(47),val(59)], [val(48),val(60)], 'Linewidth',4, 'color', 'k');

            %rigth leg
            plot3([val(55), val(52)], [val(56),val(53)], [val(57),val(54)], 'Linewidth',4, 'color', 'k');
            plot3([val(52), val(49)], [val(53),val(50)], [val(54),val(51)], 'Linewidth',4, 'color', 'k');
            plot3([val(46), val(49)], [val(47),val(50)], [val(48),val(51)], 'Linewidth',4, 'color', 'k');
            scatter3(val(55), val(56), val(57), '*k', 'Linewidth', 3);hold on;

            %left arm
            plot3([val(43), val(40)], [val(44),val(41)], [val(45),val(42)], 'Linewidth',4, 'color', 'k');
            plot3([val(37), val(40)], [val(38),val(41)], [val(39),val(42)], 'Linewidth',4, 'color', 'k');
            plot3([val(37), val(34)], [val(38),val(35)], [val(39),val(36)], 'Linewidth',4, 'color', 'k');
            scatter3(val(43), val(44), val(45), '*k', 'Linewidth', 3);hold on;

            %link between arms
            plot3([val(22), val(34)], [val(23),val(35)], [val(24),val(36)], 'Linewidth',4, 'color', 'k');

            %right arm
            plot3([val(31), val(28)], [val(32),val(29)], [val(33),val(30)], 'Linewidth',4, 'color', 'k');
            plot3([val(25), val(28)], [val(26),val(29)], [val(27),val(30)], 'Linewidth',4, 'color', 'k');
            plot3([val(25), val(22)], [val(26),val(23)], [val(27),val(24)], 'Linewidth',4, 'color', 'k');
            scatter3(val(31), val(32), val(33), '*k', 'Linewidth', 3);hold on;

            xlim([-1 1]);
            ylim([-1 1]);
            zlim([-1 1]);
            hold off;
            pause(0.0000001);
    end
    
    else
        for tmm=1:nbDataInf        
        val = t(tmm,:);

        %head
        scatter3(val(19), val(20), val(21), 'k', 'Linewidth', 10);hold on;
        
        %body
        plot3([val(1), val(10)], [val(2),val(11)], [val(3),val(12)], 'Linewidth',4, 'color', 'k');
        plot3([val(16), val(10)], [val(17),val(11)], [val(18),val(12)], 'Linewidth',4, 'color', 'k');
        plot3([val(16), val(19)], [val(17),val(20)], [val(18),val(21)], 'Linewidth',4, 'color', 'k');
        
        %left leg
        plot3([val(67), val(64)], [val(68),val(65)], [val(69),val(66)], 'Linewidth',4, 'color', 'k');
        plot3([val(61), val(64)], [val(62),val(65)], [val(63),val(66)], 'Linewidth',4, 'color', 'k');
        plot3([val(61), val(58)], [val(62),val(59)], [val(63),val(60)], 'Linewidth',4, 'color', 'k');
        scatter3(val(67), val(68), val(69), '*k', 'Linewidth', 3);hold on;

%         
        %link between legs
        plot3([val(46), val(58)], [val(47),val(59)], [val(48),val(60)], 'Linewidth',4, 'color', 'k');
        
        %rigth leg
        plot3([val(55), val(52)], [val(56),val(53)], [val(57),val(54)], 'Linewidth',4, 'color', 'k');
        plot3([val(52), val(49)], [val(53),val(50)], [val(54),val(51)], 'Linewidth',4, 'color', 'k');
        plot3([val(46), val(49)], [val(47),val(50)], [val(48),val(51)], 'Linewidth',4, 'color', 'k');
        scatter3(val(55), val(56), val(57), '*k', 'Linewidth', 3);hold on;

        %left arm
        plot3([val(43), val(40)], [val(44),val(41)], [val(45),val(42)], 'Linewidth',4, 'color', 'k');
        plot3([val(37), val(40)], [val(38),val(41)], [val(39),val(42)], 'Linewidth',4, 'color', 'k');
        plot3([val(37), val(34)], [val(38),val(35)], [val(39),val(36)], 'Linewidth',4, 'color', 'k');
        scatter3(val(43), val(44), val(45), '*k', 'Linewidth', 3);hold on;

        %link between arms
        plot3([val(22), val(34)], [val(23),val(35)], [val(24),val(36)], 'Linewidth',4, 'color', 'k');
        
        %right arm
        plot3([val(31), val(28)], [val(32),val(29)], [val(33),val(30)], 'Linewidth',4, 'color', 'k');
        plot3([val(25), val(28)], [val(26),val(29)], [val(27),val(30)], 'Linewidth',4, 'color', 'k');
        plot3([val(25), val(22)], [val(26),val(23)], [val(27),val(24)], 'Linewidth',4, 'color', 'k');
        scatter3(val(31), val(32), val(33), '*k', 'Linewidth', 3);hold on;

        
        
       
        xlim([-1 1]);
        ylim([-1 1]);
        zlim([-1 1]);
        hold off;
        pause(0.00000001);
        
        
        end 
     for tmm=nbDataInf+1:70        
        val = t(tmm,:);

        
        %head
        scatter3(val(19), val(20), val(21), 'k', 'Linewidth', 10);hold on;
        
        %body
        plot3([val(1), val(10)], [val(2),val(11)], [val(3),val(12)], 'Linewidth',4, 'color', 'k');
        plot3([val(16), val(10)], [val(17),val(11)], [val(18),val(12)], 'Linewidth',4, 'color', 'k');
        plot3([val(16), val(19)], [val(17),val(20)], [val(18),val(21)], 'Linewidth',4, 'color', 'k');
        
        %left leg
        plot3([val(67), val(64)], [val(68),val(65)], [val(69),val(66)], 'Linewidth',4, 'color', 'k');
        plot3([val(61), val(64)], [val(62),val(65)], [val(63),val(66)], 'Linewidth',4, 'color', 'k');
        plot3([val(61), val(58)], [val(62),val(59)], [val(63),val(60)], 'Linewidth',4, 'color', 'k');
        scatter3(val(67), val(68), val(69), '*k', 'Linewidth', 3);hold on;

%         
        %link between legs
        plot3([val(46), val(58)], [val(47),val(59)], [val(48),val(60)], 'Linewidth',4, 'color', 'k');
        
        %rigth leg
        plot3([val(55), val(52)], [val(56),val(53)], [val(57),val(54)], 'Linewidth',4, 'color', 'k');
        plot3([val(52), val(49)], [val(53),val(50)], [val(54),val(51)], 'Linewidth',4, 'color', 'k');
        plot3([val(46), val(49)], [val(47),val(50)], [val(48),val(51)], 'Linewidth',4, 'color', 'k');
        scatter3(val(55), val(56), val(57), '*k', 'Linewidth', 3);hold on;

        %left arm
        plot3([val(43), val(40)], [val(44),val(41)], [val(45),val(42)], 'Linewidth',4, 'color', 'k');
        plot3([val(37), val(40)], [val(38),val(41)], [val(39),val(42)], 'Linewidth',4, 'color', 'k');
        plot3([val(37), val(34)], [val(38),val(35)], [val(39),val(36)], 'Linewidth',4, 'color', 'k');
        scatter3(val(43), val(44), val(45), '*k', 'Linewidth', 3);hold on;

        %link between arms
        plot3([val(22), val(34)], [val(23),val(35)], [val(24),val(36)], 'Linewidth',4, 'color', 'k');
        
        %right arm
        plot3([val(31), val(28)], [val(32),val(29)], [val(33),val(30)], 'Linewidth',4, 'color', 'k');
        plot3([val(25), val(28)], [val(26),val(29)], [val(27),val(30)], 'Linewidth',4, 'color', 'k');
        plot3([val(25), val(22)], [val(26),val(23)], [val(27),val(24)], 'Linewidth',4, 'color', 'k');
        scatter3(val(31), val(32), val(33), '*k', 'Linewidth', 3);hold on;

        
        val = inftraj(tmm,:);
   
        
        
        %head
        scatter3(val(19), val(20), val(21), 'r', 'Linewidth', 10);hold on;
        
        %body
        plot3([val(1), val(10)], [val(2),val(11)], [val(3),val(12)], 'Linewidth',4, 'color', 'r');
        plot3([val(16), val(10)], [val(17),val(11)], [val(18),val(12)], 'Linewidth',4, 'color', 'r');
        plot3([val(16), val(19)], [val(17),val(20)], [val(18),val(21)], 'Linewidth',4, 'color', 'r');
        
        %left leg
        plot3([val(67), val(64)], [val(68),val(65)], [val(69),val(66)], 'Linewidth',4, 'color', 'r');
        plot3([val(61), val(64)], [val(62),val(65)], [val(63),val(66)], 'Linewidth',4, 'color', 'r');
        plot3([val(61), val(58)], [val(62),val(59)], [val(63),val(60)], 'Linewidth',4, 'color', 'r');
        scatter3(val(67), val(68), val(69), '*r', 'Linewidth', 3);hold on;

        
        %link between legs
        plot3([val(46), val(58)], [val(47),val(59)], [val(48),val(60)], 'Linewidth',4, 'color', 'r');
        
        %rigth leg
        plot3([val(55), val(52)], [val(56),val(53)], [val(57),val(54)], 'Linewidth',4, 'color', 'r');
        plot3([val(52), val(49)], [val(53),val(50)], [val(54),val(51)], 'Linewidth',4, 'color', 'r');
        plot3([val(46), val(49)], [val(47),val(50)], [val(48),val(51)], 'Linewidth',4, 'color', 'r');
        scatter3(val(55), val(56), val(57), '*r', 'Linewidth', 3);hold on;

        %left arm
        plot3([val(43), val(40)], [val(44),val(41)], [val(45),val(42)], 'Linewidth',4, 'color', 'r');
        plot3([val(37), val(40)], [val(38),val(41)], [val(39),val(42)], 'Linewidth',4, 'color', 'r');
        plot3([val(37), val(34)], [val(38),val(35)], [val(39),val(36)], 'Linewidth',4, 'color', 'r');
        scatter3(val(43), val(44), val(45), '*r', 'Linewidth', 3);hold on;

        %link between arms
        plot3([val(22), val(34)], [val(23),val(35)], [val(24),val(36)], 'Linewidth',4, 'color', 'r');
        
        %right arm
        plot3([val(31), val(28)], [val(32),val(29)], [val(33),val(30)], 'Linewidth',4, 'color', 'r');
        plot3([val(25), val(28)], [val(26),val(29)], [val(27),val(30)], 'Linewidth',4, 'color', 'r');
        plot3([val(25), val(22)], [val(26),val(23)], [val(27),val(24)], 'Linewidth',4, 'color', 'r');
        scatter3(val(31), val(32), val(33), '*r', 'Linewidth', 3);hold on;

        
        
       
        xlim([-1 1]);
        ylim([-1 1]);
        zlim([-1 1]);
        hold off;
        pause(0.00000001);
     end
    end
    

end