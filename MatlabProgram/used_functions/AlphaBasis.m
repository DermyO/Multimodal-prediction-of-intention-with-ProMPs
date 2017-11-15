function RBF = AlphaBasis(x, varargin)
%AlphaBasis is not finish yet, will allow to compute Basis functions 
%to model the alpha value according to the input variation.
%INPUT:
%x: all the variation inputs for each trajectory
%OUTPUT:
%RBF the RBF of the alpha model.

  nbTypeData = 3;
 
  if(~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i}, 'nbTypeData') == 1 )
            nbTypeData = varargin{i+1};
        end
    end
  end

  for i=1:nbTypeData
      minv(i) = min(x(:,i));
     maxv(i) = max(x(:,i));
  end
   inter = (maxv - minv + 1)  / 5;

    RBF = [];
    Phi = cell(size(x,2));
    for traj=1:size(x,2) %for each input
        Phi{traj}= zeros(size(x,1),5);
        for t=1:size(x,1) %nbData 
            %TODO the RBF as parameter
            for i=1:5 %5 RBF 
                c = minv(traj) +  inter(traj)*(i-1);
                if(isnan(x(t)))
                    Phi{traj}(t,i) = 0;
                else
                    Phi{traj}(t,i) = exp(-power(x(t,traj)' - c,2) /sqrt(0.2));
                end
            end
                sumBI = sum(Phi{traj}(t,:));
                if(sumBI ~=0)
               	    Phi{traj}(t,:) = Phi{traj}(t,:)/sumBI;
               	else
                    %todo a ameliorer
                    Phi{traj}(t,:) = 0;
                end
        end
            RBF = [RBF,Phi{traj}];
    end
end