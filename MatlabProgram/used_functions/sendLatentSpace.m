function sendLatentSpace(infTraj,zs, connection)
    

    posterior = infTraj.PHI*infTraj.mu_w;

    connection.c.clear();
    connection.portHP.read(connection.c);
    
    while(~strcmp(connection.c.toString, 'ask_data'))
        connection.c.clear();
        connection.portHP.read(connection.c);
    end
    connection.c.clear()

    for t= 1:infTraj.timeInf
        connection.b.clear();
         for i = 1 : zs
             
            connection.b.addDouble(posterior((i-1)*infTraj.timeInf + t));
         end
       % connection.b.toString
        connection.port.write(connection.b);    
    end

end