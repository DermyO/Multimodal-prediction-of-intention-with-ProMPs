function closeConnectionRealIcub(connexion,varargin)
%closeconnexion closes the C++ program "replay" and close its port.
connexion.b.clear();
connexion.b.addDouble(-1);    
connexion.port.write(connexion.b);
connexion.port.close;
connexion.portSpeak.close;
connexion.portSkin.close;
connexion.portWrenches.close;
connexion.portState.close;
connexion.portGrasp.close;


connexion.b.clear();
connexion.b.addString('reset');
connexion.portIG.write(connexion.b);
connexion.portIG.close;


if(~isempty(varargin))
   if(strcmp(varargin{1},'withFacePos')) 
       connexion.portHP.close;
   end
end


end