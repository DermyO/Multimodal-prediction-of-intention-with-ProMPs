connexion.portGrasp.open('/matlab/grasp:o');
system('yarp connect /matlab/grasp:o /grasper/rpc:i');
connexion.grasp.clear();
closeEndOrder
connexion.grasp.fromString(closeEndOrder);
connexion.portGrasp.write(connexion.grasp);
connexion.portGrasp.close; 
