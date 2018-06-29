function sendListError(error, connection)
  
    connection.b.clear();
    connection.c.clear();
    connection.portHP.read(connection.c);
    %display(connection.c.toString)
    while(~strcmp(connection.c.toString, 'ask_error_list'))
        connection.c.clear();
        connection.portHP.read(connection.c);
    end
    connection.b.clear();
    for i = 1:length(error)
      connection.b.addDouble(error(i));
    end
    connection.port.write(connection.b);        
    %connection.port.write(connection.b);    
    connection.c.clear()

end