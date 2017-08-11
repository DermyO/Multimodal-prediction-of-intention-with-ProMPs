function drawFacePose(promp, varargin)
figure;
subplot(3,1,1);
%TODO treat other cases


if(length(promp)==3) %TODO faire mieux
    if(isempty(varargin))
        subplot(3,1,1);
        boxplot([promp{1}.facePose.data(:,1) promp{2}.facePose.data(:,1) promp{3}.facePose.data(:,1)]);
        ylabel('R');
        subplot(3,1,2);
        boxplot([promp{1}.facePose.data(:,2) promp{2}.facePose.data(:,2) promp{3}.facePose.data(:,2)]);
        ylabel('P');
        subplot(3,1,3);
        boxplot([promp{1}.facePose.data(:,3) promp{2}.facePose.data(:,3) promp{3}.facePose.data(:,3)]);
        ylabel('Y');
    elseif(strcmp(varargin{1}, 'test')==1)
        test = varargin{2};
        subplot(3,1,1);
        xx = [-10:0.1:10];
        norm = normpdf(xx,promp{1}.facePose.mu(1), promp{1}.facePose.sigma(1,1));
        fy = plot(xx, norm, 'b');hold on;
        norm = normpdf(xx,promp{2}.facePose.mu(1), promp{2}.facePose.sigma(1,1));
        fp = plot(xx, norm, 'r');
        norm = normpdf(xx,promp{3}.facePose.mu(1), promp{3}.facePose.sigma(1,1));
        fr = plot(xx, norm, 'g');
        norm = normpdf(xx,test.mu(1), test.sigma(1,1));
        ft = plot(xx, norm, 'k');
        legend('Y', 'P', 'R', 'test');
        
        subplot(3,1,2);
        norm = normpdf(xx,promp{1}.facePose.mu(2), promp{1}.facePose.sigma(2,2));
        fy = plot(xx, norm, 'b');hold on;
        norm = normpdf(xx,promp{2}.facePose.mu(2), promp{2}.facePose.sigma(2,2));
        fp = plot(xx, norm, 'r');
        norm = normpdf(xx,promp{3}.facePose.mu(2), promp{3}.facePose.sigma(2,2));
        fr = plot(xx, norm, 'g');
        norm = normpdf(xx,test.mu(2), test.sigma(2,2));
        ft = plot(xx, norm, 'k');
        
        subplot(3,1,3);
        xx=[-5:0.1:40]
        
        norm = normpdf(xx,promp{1}.facePose.mu(3), promp{1}.facePose.sigma(3,3));
        fy = plot(xx, norm, 'b');hold on;
        norm = normpdf(xx,promp{2}.facePose.mu(3), promp{2}.facePose.sigma(3,3));
        fp = plot(xx, norm, 'r');
        norm = normpdf(xx,promp{3}.facePose.mu(3), promp{3}.facePose.sigma(3,3));
        fr = plot(xx, norm, 'g');
        norm = normpdf(xx,test.mu(3), test.sigma(3,3));
        ft = plot(xx, norm, 'k');
    elseif(strcmp(varargin{1}, 'test2')==1)
                       test = varargin{2};
 
        xx = [1:20 101:120 201:220 301:320 401:420];
        drstring = char('test');
        %origin= [promp{1}.traj.label ; promp{2}.traj.label ; promp{3}.traj.label ; char('test')];
        promp{1}.traj.label
                origin= {'top' ; 'front' ; 'bottom' ; 'test'};

        subplot(3,1,1);
                
        boxplot([promp{1}.facePose.data(xx,1) promp{2}.facePose.data(xx,1) promp{3}.facePose.data(xx,1) test.data(:,1)], origin);
        ylabel('R');
        subplot(3,1,2);
        boxplot([promp{1}.facePose.data(xx,2) promp{2}.facePose.data(xx,2) promp{3}.facePose.data(xx,2) test.data(:,2)], origin);
        ylabel('P');
        subplot(3,1,3);
        boxplot([promp{1}.facePose.data(xx,3) promp{2}.facePose.data(xx,3) promp{3}.facePose.data(xx,3) test.data(:,3)], origin);
        ylabel('Y');
    end
elseif(length(promp)==2) %TODO faire mieux
    if(isempty(varargin))
        subplot(2,1,1);
        boxplot([promp{1}.facePose.data(:,1) promp{2}.facePose.data(:,1) ]);
        ylabel('R');
        subplot(2,1,2);
        boxplot([promp{1}.facePose.data(:,2) promp{2}.facePose.data(:,2) ]);
        ylabel('P');
        subplot(3,1,3);
        boxplot([promp{1}.facePose.data(:,3) promp{2}.facePose.data(:,3) ]);
        ylabel('Y');
    elseif(strcmp(varargin{1}, 'test')==1)
        test = varargin{2};
        subplot(3,1,1);
        xx = [-10:0.1:10];
        norm = normpdf(xx,promp{1}.facePose.mu(1), promp{1}.facePose.sigma(1,1));
        fy = plot(xx, norm, 'b');hold on;
        norm = normpdf(xx,promp{2}.facePose.mu(1), promp{2}.facePose.sigma(1,1));
        fp = plot(xx, norm, 'r');
        norm = normpdf(xx,test.mu(1), test.sigma(1,1));
        ft = plot(xx, norm, 'k');
        legend('Y', 'P', 'R', 'test');
        
        subplot(3,1,2);
        norm = normpdf(xx,promp{1}.facePose.mu(2), promp{1}.facePose.sigma(2,2));
        fy = plot(xx, norm, 'b');hold on;
        norm = normpdf(xx,promp{2}.facePose.mu(2), promp{2}.facePose.sigma(2,2));
        fp = plot(xx, norm, 'r');
        norm = normpdf(xx,test.mu(2), test.sigma(2,2));
        ft = plot(xx, norm, 'k');
        
        subplot(3,1,3);
        xx=[-5:0.1:40]
        
        norm = normpdf(xx,promp{1}.facePose.mu(3), promp{1}.facePose.sigma(3,3));
        fy = plot(xx, norm, 'b');hold on;
        norm = normpdf(xx,promp{2}.facePose.mu(3), promp{2}.facePose.sigma(3,3));
        fp = plot(xx, norm, 'r');
        norm = normpdf(xx,test.mu(3), test.sigma(3,3));
        ft = plot(xx, norm, 'k');
    elseif(strcmp(varargin{1}, 'test2')==1)
                       test = varargin{2};
 %xx = [1:10 101:110 201:210 301:310 401:410];
        xx = [1:2 101:102 201:202 301:302 401:402];
        drstring = char('test');
        %origin= [promp{1}.traj.label ; promp{2}.traj.label ; promp{3}.traj.label ; char('test')];
        origin= {'left'; 'front'; 'test'};%{'top' ; 'front' ; 'bottom' ; 'test'};

        subplot(3,1,1);
                
        boxplot([promp{1}.facePose.data(xx,1) promp{2}.facePose.data(xx,1) test.data(:,1)] , origin);
        ylabel('R');
        subplot(3,1,2);
        boxplot([promp{1}.facePose.data(xx,2) promp{2}.facePose.data(xx,2) test.data(:,2)], origin);
        ylabel('P');
        subplot(3,1,3);
        boxplot([promp{1}.facePose.data(xx,3) promp{2}.facePose.data(xx,3) test.data(:,3)], origin);
        ylabel('Y');
    end
end



end