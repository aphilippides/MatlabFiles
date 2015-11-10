function e=open_robot_ethernet(addr,portno)  
e = tcpip(addr,portno ,'NetworkRole', 'client');
%pause(1000);
fopen(e);
flushinput(e);
end