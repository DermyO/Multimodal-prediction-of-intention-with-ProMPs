function connexion = initializeconnexionRealIcub(varargin)
%initializeconnexion opens the port and create bottles to communicates with the "replay" program.


LoadYarp;
import yarp.Port;
import yarp.Bottle;

connexion.port=Port;
connexion.port.close;

connexion.portSpeak=Port;
connexion.portSpeak.close;

connexion.portSkin=Port;
connexion.portSkin.close;

connexion.portWrenches=Port;
connexion.portWrenches.close;

connexion.portState=Port;
connexion.portState.close;

connexion.portGrasp=Port;
% connexion.portGrasp.close;

connexion.portIG=Port;
connexion.portIG.close;

disp('Going to open port /matlab/write');
connexion.port.open('/matlab/write');
disp('Going to open port /matlab/ispeak');
connexion.portSpeak.open('/matlab/ispeak');
disp('Going to open port /matlab/skin');
connexion.portSkin.open('/matlab/skin');
disp('Going to open port /matlab/wrenches');
connexion.portWrenches.open('/matlab/wrenches');
disp('Going to open port /matlab/state');
connexion.portState.open('/matlab/state');
%disp('Going to open port /matlab/grasp:o');
%connexion.portGrasp.open('/matlab/grasp:o');
disp('Going to open port /matlab/IG:o');
connexion.portIG.open('/matlab/IG:o');

if(~isempty(varargin))
   if(strcmp(varargin{1},'withFacePos')) 
       connexion.portHP =  Port;
       connexion.portHP.close;
        disp('Going to open port /matlab/HP');
        connexion.portHP.open('/matlab/HP');
   end
end

rep = input('Please connect to a bottle sink (e.g. yarp read/write) and press a button.\n');
connexion.b = Bottle;
connexion.c = Bottle;
connexion.ispeak = Bottle;
connexion.skin = Bottle;
connexion.wrenches = Bottle;
connexion.state = Bottle;
connexion.grasp = Bottle;
%connexion.graspAns =Bottle;
% command = 'yarp connect /headPos:o /matlab/HP';
% system(command);
% command = 'yarp connect /matlab/HP /headPos:o';
% system(command);
% command = 'yarp connect /wholeBodyDynamics/left_arm/cartesianEndEffectorWrench:o /matlab/wrenches';
% system(command);
% command = 'yarp connect /icub/cartesianController/left_arm/state:o /matlab/state';
% system(command);
% command = 'yarp connect /matlab/HP /headPos:o';
% system(command);

end
