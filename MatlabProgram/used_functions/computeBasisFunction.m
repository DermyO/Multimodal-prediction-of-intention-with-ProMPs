function PHI = computeBasisFunction(s_ref,M, nbInput, alpha, totalTime, c, h, nbData, varargin)
%COMPUTEBASISFUNCTION creates the basis function matrix.
%tall: [nbInput*nbData]x[nbFunctions*nbData]
%Inputs:
% s_ref: time reference used to compute promp independently to the
% trajectory phases.
% M: number of RBF we want to model the trajectory
% alpha: phasis of the trajectory
% totalTime: the total number of samples to finish the trajectory
% c: where the functions will be placed.
% h: bandwith of the RBF
% nbData: normally = totalTime. But if you want a subpart of the matrix,
% you can specify this number.
kernel = 'gaussian';
flag_draw=0;
if(~isempty(varargin))
    for i=1:length(varargin)
        if(strcmp(varargin{i}, 'Periodic')==1)
            kernel = 'Periodic';
        elseif(strcmp(varargin{i}, 'Draw')==1)
            flag_draw=1;
        end
    end
end


if(strcmp(kernel, 'gaussian')==1)
    for k=1:length(M)
        for i = 1 : M(k)
            center(k,i) = c(k)*(i-1);
        end
        
        for t=1:totalTime
            %creating a basis functions model (time*nbFunctions)
            for i = 1 : M(k)
                val{k} = -((alpha*t*(1/s_ref)-center(k,i))*(alpha*t*(1/s_ref)-center(k,i)))/h(k);
                basis{k}(t,i) = exp(val{k});
            end
            
            %normalization of the RBF
            sumBI = sum(basis{k}(t,:));
            phi{k}(t,1) = basis{k}(t,1) / sumBI ;
            for i = 1 : M(k)
                phi{k}(t,i) = basis{k}(t,i) / sumBI;
            end
        end
      
    end
    if(flag_draw==1)
    plot(phi{1}, 'r');
    plot(basis{k}, 'b');
    end
elseif(strcmp(kernel, 'Periodic')==1)
    for k=1:length(M)
        for i = 1 : M(k)
            center(k,i) = c(k)*(i-1);
        end
        
        for t=1:totalTime
            %creating a basis functions model (time*nbFunctions)
            for i = 1 : M(k)
                val{k} = cos(2*pi*(alpha*t*(1/s_ref)-center(k,i)))/(2*h(k));
                %-(alpha*t*(1/s_ref)-center(k,i))*(alpha*t*(1/s_ref)-center(k,i))/(2*h(k));
                basis{k}(t,i) = exp(val{k});
            end
            
            %normalization of the RBF
           sumBI = sum(basis{k}(t,:));
            phi{k}(t,1) = basis{k}(t,1) / sumBI ;
            for i = 1 : M(k)
                phi{k}(t,i) = basis{k}(t,i) / sumBI;
            end
        end
    end
    
elseif(strcmp(kernel, 'Student')==1)
    for k=1:length(M)
        for i = 1 : M(k)
            center(k,i) = c(k)*(i-1);
        end
        
        for t=1:totalTime
            %creating a basis functions model (time*nbFunctions)
            for i = 1 : M(k)
                val{k} = cos(2*pi*(alpha*t*(1/s_ref)-center(k,i)))/(2*h(k));
                basis{k}(t,i) = exp(val{k});
            end
            
            %normalization of the RBF
      %      sumBI = sum(basis{k}(t,:));
            phi{k}(t,1) = basis{k}(t,1);% / sumBI ;
            for i = 1 : M(k)
                phi{k}(t,i) = basis{k}(t,i) ;%/ sumBI;
            end
        end
    end
    
        
    
end



%IF we want the RBF as a matrix matrix
if((~isempty(varargin)) && (strcmp(varargin{1},'Mat')))
    display('matrix!!')
    
    for t=1:nbData
        for i=1:length(M)
            for j =1:nbInput(i)
                if and(i==1,j==1)
                    PHI{t} = phi{i}(t,:);
                else
                    PHI{t} = blkdiag(PHI{t}, phi{i}(t,:)); %TODO to optimize: can be use for inf? (loglikelihood)
                end
            end
        end
    end
else
    for i=1:length(M)
        for j =1:nbInput(i)
            if and(i==1,j==1)
                PHI = phi{i}(1:nbData,:);
            else
                PHI = blkdiag(PHI, phi{i}(1:nbData,:));
            end
        end
    end
end

end
