
function replayProMP(promp, connection,s_bar, varargin)
%In this function we will play the trajectory into gazebo.
withO = 0;
if(~isempty(varargin))
  for i = 1:length(varargin)   
      if(varargin{i} == 'withOrientation') 
         withO = 1;
      end
  end
end

data = promp.PHI_norm*promp.mu_w;

%totTime = s_bar*promp.mu_alpha;
    for t = 1 : s_bar
         connection.b.clear();
        for i = 1 : 3 %+ nbDof(2)
            val(t,i) = data(s_bar*(i-1)+t);
            connection.b.addDouble(val(t,i));
        end
        %compliance information
        %connection.b.addDouble(0.0);
        
         %test orientation
        if(withO ==1)
         for i = 4 : 7
             val(t,i) = data(s_bar*(i-1)+t);
             connection.b.addDouble(val(t,i));
         end
        end
        connection.port.write(connection.b);
        val(t,:)
        connection.port.read(connection.c);
%        disp(connection.c);
    end
    
    %Send information about the end of the trajectory and verify it
    %receives it.
    connection.b.clear();
    connection.b.addDouble(0.0)
    connection.port.write(connection.b);
    connection.port.read(connection.c);
%    disp(connection.c);
end