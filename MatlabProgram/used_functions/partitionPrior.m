function  [test, train ] = partitionPrior(promp, type, varargin)
        lengthData =length(promp.facePose.data);
        if(varargin{1} == 1)
                   ind = ceil(rand(1)*lengthData / 50);
                   test.data = promp.facePose.data(50*(ind-1)+1:50*(ind-1)+50,:);
                   train.data = promp.facePose.data;
                   train.data(50*(ind-1)+1:50*(ind-1)+50,:) = [];
        else
            percent = varargin{1};
            nbData = ceil(percent*lengthData /100);
            train.data = promp.facePose.data;
            for i=1:nbData
               ind = ceil(rand(1)*lengthData);
               test.data(50*(i-1)+1:50*i,:) =   promp.facePose.data(50*(ind-1)+1:50*(ind-1)+50,:);
               train.data(50*(ind-1)+1:50*ind,:) = [];
               lengthData = lengthData-1;
            end

        end
       test.mu = mean(test.data);
       test.sigma = cov(test.data);
       train.mu = mean(train.data);
       train.sigma = cov(train.data);
end
