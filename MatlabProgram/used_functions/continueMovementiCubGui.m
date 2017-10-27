function inf = continueMovementiCubGui(inf,connection,nbData,z, PHI_norm, varargin)
%continueMovementiCubGui plays the trajectory recognized into icubGui.

withP = 0;
isP = 0;
if(~isempty(varargin))
  for i = 1:length(varargin)   
      if(strcmp(varargin{i},'withPrior')==1) 
         withP = 1;
         prior = varargin{i+1};
      elseif(strcmp(varargin{i},'isPrior')==1) 
          isP = 1;
          inf.PHI = PHI_norm;
          inf.timeInf = z;
      end
  end
end


data =inf.PHI*inf.mu_w;%PHI_norm*inf.mu_w; %inf.PHI*inf.mu_w; %PHI_norm*inf.mu_w;
if(withP==1) %force the infered trajectory to be included in the prior distribution
    meanPrior = inf.PHI*prior.mu_w;
    varPrior = inf.PHI*1.96*sqrt(diag(prior.sigma_w ));
    dmin = meanPrior - varPrior;
    dmax = meanPrior + varPrior;
    for i=1:3
        for j=1:inf.timeInf
            vmin(j,i) = dmin(inf.timeInf*(i-1)+j);
            vmax(j,i) = dmax(inf.timeInf*(i-1)+j);
            val(j,i) = data(inf.timeInf*(i-1)+j);
            if(val(j,i)<vmin(i,j))
                val(j,i)=vmin(i,j);
            elseif(val(j,i)>vmax(i,j))
                val(j,i)=vmax(i,j);
            end
        end
    end
else
    for i=1:3
        for j=1:inf.timeInf
            val(j,i) = data(inf.timeInf*(i-1)+j);
        end
    end    
end

connection.b.clear();
connection.b.addString('reset');
connection.portIG.write(connection.b);

for t = 1: nbData%:inf.timeInf %round(inf.alpha*nbData): inf.timeInf
    connection.b.clear();
    
    connection.b.addString('object');
    name = num2str(t);
    connection.b.addString(name);
    
    %dimensions
    connection.b.addDouble(30);
    connection.b.addDouble(30);
    connection.b.addDouble(30);
    %position
    for i = 1 : 3 %cartesian position information
        connection.b.addDouble(val(t,i)*1000);
    end
    %orientation
    connection.b.addDouble(0);
    connection.b.addDouble(0);
    connection.b.addDouble(0);
    %color
    connection.b.addInt(0);
    connection.b.addInt(255);
    connection.b.addInt(0);
    %alpha
    connection.b.addDouble(1);
  % display(['Write on iCubGui: object', name, '30 30 30 ', num2str(val(t,1)*1000), ' ', num2str(val(t,2)*1000), ' ', num2str(val(t,3)*1000), ' 0 0 0 255 0 0 1 ']);
    connection.portIG.write(connection.b);
  % a = input('continue');
end

for t = nbData:inf.timeInf %round(inf.alpha*nbData): inf.timeInf
    connection.b.clear();
    
    connection.b.addString('object');
    name = num2str(t);
    connection.b.addString(name);
    
    %dimensions
    connection.b.addDouble(30);
    connection.b.addDouble(30);
    connection.b.addDouble(30);
    %position
    for i = 1 : 3 %cartesian position information
        connection.b.addDouble(val(t,i)*1000);
    end
    %orientation
    connection.b.addDouble(0);
    connection.b.addDouble(0);
    connection.b.addDouble(0);
    %color
    connection.b.addInt(255);
    connection.b.addInt(0);
    connection.b.addInt(0);
    %alpha
    connection.b.addDouble(1);
%  display(['Write on iCubGui: object', name, '30 30 30 ', num2str(val(t,1)*1000), ' ', num2str(val(t,2)*1000), ' ', num2str(val(t,3)*1000), ' 0 0 0 255 0 0 1 ']);
    connection.portIG.write(connection.b);
end

%a = input('press enter to delete the trajectory');


% for t = round(inf.alpha*nbData):10: inf.timeInf
%     connection.b.clear();
%     
%     connection.b.addString('object');
%     name = num2str(t);
%     connection.b.addString(name);
%     
%     %dimensions
%     connection.b.addDouble(30);
%     connection.b.addDouble(30);
%     connection.b.addDouble(30);
%     %position
%     for i = 1 : 3 %cartesian position information
%         val(t,i) = data(inf.timeInf*(i-1)+t);
%         connection.b.addDouble(val(t,i)*1000);
%     end
%     %orientation
%     connection.b.addDouble(0);
%     connection.b.addDouble(0);
%     connection.b.addDouble(0);
%     %color
%     connection.b.addInt(0);
%     connection.b.addInt(255);
%     connection.b.addInt(0);
%     %alpha
%     connection.b.addDouble(1);
%    %display(['Write on iCubGui: object', name, '30 30 30 ', num2str(val(t,1)*1000), ' ', num2str(val(t,2)*1000), ' ', num2str(val(t,3)*1000), ' 0 0 0 0 255 0 1 ']);
%     connection.portIG.write(connection.b);
%   % a = input('continue');
%end




end