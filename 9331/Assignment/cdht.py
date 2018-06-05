import socket
import time
import sys
import threading
import re
import os

#global varibales
peer_num = int(sys.argv[1])
port = peer_num + 50000
one_successor = int(sys.argv[2])
second_successor = int(sys.argv[3])
one_successor_port = one_successor + 50000
second_successor_port = second_successor + 50000
one_successor_lost = 0
second_successor_lost = 0
first_node = False
predecessor_set = set()


#UDP initialize connnection
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  
sock.bind(('localhost', port))

#TCP server  initialize connection
s_tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s_tcp.bind(('localhost', port))
s_tcp.listen(5)


#Ping function
def ping(ping_port): 
    global one_successor_lost, second_successor_lost, sock
    sock.settimeout(3)   
    try:
        sendPing = sock.sendto(str.encode("Ping"), ('localhost', ping_port)) 
        while True:  
            revcData, (remoteHost, remotePort) = sock.recvfrom(2048)
            if revcData.decode() == 'Pong':
                response_successor = int(remotePort) - 50000
                print('A ping response message was received from Peer ' + str(response_successor) + '.')
                if response_successor == one_successor:
                    one_successor_lost = 0
                elif response_successor == second_successor:
                    second_successor_lost = 0
                break 
    except socket.timeout: 
        if ping_port == one_successor_port:
            one_successor_lost += 1
        elif ping_port == second_successor_port:
            second_successor_lost += 1

# Response ping function      
def response_ping():
    global sock, peer_num, first_node, predecessor_set
    try:
        while True:
            revcData, (remoteHost, remotePort) = sock.recvfrom(2048)
            if revcData.decode() == 'Ping':
                sendResponse = sock.sendto(str.encode("Pong"), (remoteHost, remotePort))
                request_peer = remotePort - 50000
                print('A ping request message was received from Peer {0}.'.format(request_peer))
                if remotePort not in predecessor_set and len(predecessor_set) == 2:
                    predecessor_set = set()
                    predecessor_set.add(remotePort)
                else:
                    predecessor_set.add(remotePort)
                if request_peer > peer_num:
                    first_node = True
    except socket.timeout:
        return


# UDP check if peers leave
def check_leave():
    global one_successor_lost, second_successor_lost
    if one_successor_lost >= 30:
        print('Peer %s is no longer alive' % one_successor)
        threading.Thread(target = update_first_successor).start()
    if second_successor_lost >= 30:
        print('Peer %s is no longer alive' % second_successor)
        threading.Thread(target = update_second_succssor).start()

    

# UDP ping threads run
def UDP_run():
    threading.Timer(3, UDP_run).start()
    ping1 = threading.Thread(target = ping, args = (one_successor_port, ))
    ping2 = threading.Thread(target = ping, args = (second_successor_port, ))
    ping_response = threading.Thread(target = response_ping)
    check = threading.Thread(target = check_leave)
    ping1.start()
    ping2.start()
    ping_response.start()
    check.start()


# TCP parts
# TCP request file 
def request_file():
    global one_successor_port, port, predecessor_set, peer_num, second_successor, one_successor
    while  True:
        check_input = input('')
        if re.match(r"request [0-9]{4}$", check_input):
            tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            file_number = check_input[-4:]
            storage_number = int(file_number) % 256
            tcp_client.connect(('localhost', one_successor_port))
            tcp_client.send(str.encode('{0} request file {1} {2} from {3}'.format(port, file_number, storage_number, port)))
            tcp_client.close()
            print('File request message for %s has been send to my successor.' % check_input)
        elif check_input == 'quit':
            for i in predecessor_set:
                try:
                    tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                    tcp_client.connect(('localhost', int(i)))
                    tcp_client.send(str.encode('peer {0} leaving, successors: {1} {2}'.format(peer_num, one_successor, second_successor)))
                    tcp_client.close()
                except:
                    pass



            



# TCP server receive request
def receive_request():
    global s_tcp
    while True:
        connection, address = s_tcp.accept()
        port = str(address[1])
        threading.Thread(target = process_client, args = (connection, port)).start()


# TCP server to process and response the requests
def process_client(connection, port):
    global s_tcp, first_node, peer_num, one_successor_port, one_successor, second_successor, second_successor_port
    client_request = connection.recv(2048)
    request_string = client_request.decode()
    itself_port = peer_num + 50000
    
    # if receive a file request
    if re.match(r"([0-9]+) request file ([0-9]+) ([0-9]+) from ([0-9]+)", request_string):
        m = re.match(r"([0-9]+) request file ([0-9]+) ([0-9]+) from ([0-9]+)", request_string)
        request_port = m.group(1)
        file_number = m.group(2)
        storage_number = m.group(3)
        predecessor_port = m.group(4)
        destined_peer = int(request_port) - 50000 
        if first_node and int(predecessor_port) > (peer_num + 50000):
            predecessor = int(predecessor_port) - 50000
            if int(storage_number) > predecessor or int(storage_number) <= peer_num:
                tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                tcp_client.connect(('localhost', int(request_port)))
                tcp_client.send(str.encode('request file {0} at {1}'.format(file_number, peer_num)))
                tcp_client.close()
                print('File %s is here.' % file_number)
                print('A response messge, destined for peer {0}, has been sent'.format(destined_peer))
            else:
                print('File {0} is not stored here.'.format(file_number))
                tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                tcp_client.connect(('localhost', one_successor_port))
                tcp_client.send(str.encode('{0} request file {1} {2} from {3}'.format(request_port, file_number, storage_number, str(itself_port))))
                tcp_client.close()
                print('File request message been forwarded to my successor.')
        else:
            predecessor = int(predecessor_port) - 50000
            if peer_num >= int(storage_number) and int(storage_number) > predecessor:
                tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                tcp_client.connect(('localhost', int(request_port)))
                tcp_client.send(str.encode('request file {0} at {1}'.format(file_number, peer_num)))
                tcp_client.close()
                print('File %s is here.' % file_number)
                print('A response messge, destined for peer {0}, has been sent'.format(destined_peer))
            else:
                print('File {0} is not stored here.'.format(file_number))
                tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                tcp_client.connect(('localhost', one_successor_port))
                tcp_client.send(str.encode('{0} request file {1} {2} from {3}'.format(request_port, file_number, storage_number, str(itself_port))))
                tcp_client.close()
                print('File request message been forwarded to my successor.')

    #if receive a file response
    elif re.match(r"request file ([0-9]+) at ([0-9]+)", request_string):
        m = re.match(r"request file ([0-9]+) at ([0-9]+)", request_string)
        file_number = m.group(1)
        sourse_at = m.group(2)
        print('Received a response message from peer {0}, which has the file {1}.'.format(sourse_at, file_number))
    
    #if receive peer leaving 
    elif re.match(r"peer ([0-9]+) leaving, successors: ([0-9]+) ([0-9]+)", request_string):
        m = re.match(r"peer ([0-9]+) leaving, successors: ([0-9]+) ([0-9]+)", request_string)
        leaving_peer = int(m.group(1))
        leaving_peer_first_successor = int(m.group(2))
        leaving_peer_second_successor = int(m.group(3))
        if leaving_peer == one_successor:
            one_successor = second_successor
            one_successor_port = one_successor + 50000
            second_successor = leaving_peer_second_successor
            second_successor_port = second_successor + 50000
            print('Peer {0} will depart from the network.'.format(leaving_peer))
            print('My first successor is now peer {0}'.format(one_successor))
            print('My second successor is now peer {0}'.format(second_successor))
        else:
            second_successor = leaving_peer_first_successor
            second_successor_port = second_successor + 50000
            print('Peer {0} will depart from the network.'.format(leaving_peer))
            print('My first successor is now peer {0}'.format(one_successor))
            print('My second successor is now peer {0}'.format(second_successor))
        tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcp_client.connect(('localhost', leaving_peer + 50000))
        tcp_client.send(str.encode('received quit'))
        tcp_client.close()

    elif re.match(r"what is your first successor from ([0-9]+)", request_string):
        m = re.match(r"what is your first successor from ([0-9]+)", request_string)
        response_port = int(m.group(1)) + 50000
        tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcp_client.connect(('localhost', response_port))
        tcp_client.send(str.encode('first is {0}'.format(str(one_successor_port))))
        tcp_client.close()

    elif re.match(r"what is your second successor from ([0-9]+)", request_string):
        m = re.match(r"what is your second successor from ([0-9]+)", request_string)
        response_port = int(m.group(1)) + 50000
        tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcp_client.connect(('localhost', response_port))
        tcp_client.send(str.encode('second is {0}'.format(str(second_successor_port))))
        tcp_client.close()

    elif re.match(r"first is ([0-9]+)", request_string):
        m = re.match(r"first is ([0-9]+)", request_string)
        if second_successor_port == int(m.group(1)):
            tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            tcp_client.connect(('localhost', one_successor_port))
            tcp_client.send(str.encode('what is your second successor from {0}'.format(peer_num)))
            tcp_client.close()
        else:
            second_successor_port = int(m.group(1))
            second_successor = second_successor_port - 50000
            print('My second successor is now peer {0}'.format(second_successor))

    elif re.match(r"second is ([0-9]+)", request_string):
        m = re.match(r"second is ([0-9]+)", request_string)
        second_successor_port = int(m.group(1))
        second_successor = second_successor_port - 50000
        print('My second successor is now peer {0}'.format(second_successor))

    elif request_string == 'received quit':
        os._exit(0)  
    
    connection.close()


def update_first_successor():
    global peer_num, one_successor_port, one_successor, second_successor, second_successor_port, one_successor_lost, second_successor_lost
    one_successor = second_successor
    one_successor_port = one_successor + 50000
    print('My first successor is now peer {0}'.format(one_successor))
    tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcp_client.connect(('localhost', one_successor_port))
    tcp_client.send(str.encode('what is your first successor from {0}'.format(peer_num)))
    tcp_client.close()
    one_successor_lost = 0
    second_successor_lost = 0

def update_second_succssor():
    global peer_num, one_successor_port, one_successor, second_successor, second_successor_port, one_successor_lost, second_successor_lost
    tcp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcp_client.connect(('localhost', one_successor_port))
    tcp_client.send(str.encode('what is your first successor from {0}'.format(peer_num)))
    tcp_client.close()
    one_successor_lost = 0
    second_successor_lost = 0
    print('My first successor is now peer {0}'.format(one_successor))

# TCp run threads    
def TCP_run():
    detect_request = threading.Thread(target = request_file)
    detect_request.start()
    receive_tcp = threading.Thread(target = receive_request)
    receive_tcp.start()




# call functions
if __name__ == "__main__":  
    UDP_run()
    TCP_run()
   

   
    
    
    
    
    
    
    
    



            
              
        
