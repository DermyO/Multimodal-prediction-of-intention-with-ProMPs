function continueMovement(inf,connection,nbData,z, PHI_norm, varargin)
%continueMovement plays the trajectory recognized into gazebo or with the real robot.
withP = 0;
infoSend = 7 ;
isEul = 0;
nbInput = 7;
list= {'unamed','unamed','unamed','unamed','unamed','unamed', 'unamed','unamed','unamed'};

if(~isempty(varargin))
  for i = 1:length(varargin)   
      if(strcmp(varargin{i},'withPrior')==1) 
         withP = 1;
         prior = varargin{i+1};
       elseif(strcmp(varargin{i},'isPrior')==1) 
          inf.PHI = PHI_norm;
          inf.timeInf = z;
      elseif(strcmp(varargin{i},'isEul')==1)
          isEul =1;
          nbInput = 6;
      elseif(strcmp(varargin{i},'withoutOr')==1)
          infoSend =3;
      else
          list= varargin{i};
      end
  end
end

data =inf.PHI*inf.mu_w;%PHI_norm*inf.mu_w; %inf.PHI*inf.mu_w; %PHI_norm*inf.mu_w;
val = zeros(inf.timeInf, 7);
if(withP==1) %force the infered trajectory to be included in the prior distribution
    meanPrior = inf.PHI*prior.mu_w;
    varPrior = inf.PHI*1.96*sqrt(diag(prior.sigma_w ));
    dmin = meanPrior - varPrior;
    dmax = meanPrior + varPrior;
    for i=1:nbInput
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
    for i=1:nbInput
        for j=1:inf.timeInf
            val(j,i) = data(inf.timeInf*(i-1)+j);
        end
    end    
end

if(nbInput == 6)
        for j=1:inf.timeInf
            if(j ==57)
                
            end
            tmp =eul2quat(val(j,4:6)');
            val(j,4) = tmp(1);
            val(j,5) = tmp(2);
            val(j,6) = tmp(3);
            val(j,7) = tmp(4);
        end
end



%data = PHI_norm*inf.mu_w;
data_max = inf.PHI*(inf.mu_w + 1.96*sqrt(diag(inf.sigma_w)));
data_min = inf.PHI*(inf.mu_w - 1.96*sqrt(diag(inf.sigma_w)));
compliance = 0.0;


for t = nbData:inf.timeInf
%for t = round(inf.alpha*nbData): z
    connection.b.clear();
    for i = 1 :infoSend %cartesian position information
        connection.b.addDouble(val(t,i));
    end
    
    %compliance inforamtion calculate in the previous boucle
    connection.b.addDouble(compliance);
    
    connection.port.write(connection.b);
  %  display(['Sending ', num2str(val(t,1)), ' ' , num2str(val(t,2)), ' etc. Waiting answer']);
    connection.port.read(connection.c);
    num = str2num(connection.c);
   %disp(['Receiving: forces = ', num2str(num(1,1)), ' ',num2str(num(1,2)),' ', num2str(num(1,3))]);
   % disp(['Expected:  forces = ', num2str(data(z*(4-1)+t)),' ', num2str(data(z*(5-1)+t)),' ', num2str(data(z*(6 -1)+t))]);
    
%    disp(['Receiving: wrenches = ', num2str(num(1,4)), ' ',num2str(num(1,5)), ' ',num2str(num(1,6))]);
%    disp(['Expected:  wrenches = ', num2str(data(z*(7-1)+t)),' ', num2str(data(z*(8-1)+t)), ' ',num2str(data(z*(9 -1)+t))]);

    compliance = 0.0;
%     
%     for i= 1 : 6 %forces&wrench information
%         f(t,i) = data(z*(i-1 + 3)+t);
%         fmax(t,i) = data_max((z*(i-1 + 3)+t));
%         fmin(t,i) = data_min((z*(i-1 + 3)+t));
%         valActu = num(1, i);
%         if(( valActu > fmin(t,i)) && (valActu <= f(t,i)))
%             compliance = compliance + 1 -  (abs(f(t,i) - valActu )/ abs(fmin(t,i) - f(t,i)));
%         elseif(( valActu < fmax(t,i)) && (valActu > f(t,i)))
%             compliance = compliance +  1 - (abs(f(t,i) - valActu )/ abs(fmax(t,i) - f(t,i)));
%         else
%  %           disp(['Input ', list{i+3}, ' is not expected. We have ',num2str(valActu), ' It should be between ', num2str(fmin(t,i)), ' and ', num2str(fmax(t,i))]);
%         end
%     end
%     compliance = compliance / 6;
 %   disp(['Compliance = ', num2str(compliance)]);
end

%Send information about the end of the trajectory and verify it
%receives it.
connection.b.clear();
connection.b.addDouble(0.0);
connection.port.write(connection.b);
connection.port.read(connection.c);
%disp(connection.c);

% msg = input('Send q to quit\n', 's');
% if(msg == 'q')
%     disp('End of the programm.');
% else
%     inferenceFromZero;
% end

end
