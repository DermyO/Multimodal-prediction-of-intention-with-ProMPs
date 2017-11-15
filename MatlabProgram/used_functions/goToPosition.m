function goToPosition(xd, od, connection,varargin)
%goToPosition give an order on the icub
    compliance = 0.0;

    
    %verify on icubGui
    connection.b.clear();
    connection.b.addString('object');
    connection.b.addString('1');
    
    %dimensions
    connection.b.addDouble(30);
    connection.b.addDouble(30);
    connection.b.addDouble(30);
    %position
    for i = 1 : 3 %cartesian position information
        connection.b.addDouble(xd(i)*1000);
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
    connection.portIG.write(connection.b);
    
    verifyOK = menu('DO you want to go to this position ?', 'Yes','No');
    
    if(verifyOK ==1)

        connection.b.clear();
        for i = 1 :3 %cartesian position information
            connection.b.addDouble(xd(i));
        end
        for i = 1 :4 %cartesian position information
            connection.b.addDouble(od(i));
        end

        %compliance inforamtion calculate in the previous boucle
        connection.b.addDouble(compliance);
        connection.port.write(connection.b);
        connection.port.read(connection.c);
        num = str2num(connection.c);


        %Send information about the end of the trajectory and verify it
        %receives it.
        connection.b.clear();
        connection.b.addDouble(0.0);
        connection.port.write(connection.b);
        connection.port.read(connection.c);
    end

end
