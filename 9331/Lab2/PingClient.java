import java.io.*;
import java.net.*;
import java.util.*;

/*
 * Server to process ping requests over UDP. 
 * The server sits in an infinite loop listening for incoming UDP packets. 
 * When a packet comes in, the server simply sends the encapsulated data back to the client.
 */

public class PingClient
{
   
   
   private static final int Wait = 1000;
   public static void main(String[] args) throws Exception
   {
      
		if (args.length != 2) {
			System.out.println("Required arguments: Server and port");
			return;
		}
		
		int port = Integer.parseInt(args[1]);
		
		InetAddress server;
		server = InetAddress.getByName(args[0]);

		
		DatagramSocket socket = new DatagramSocket();

		int sequence_number = 0;
		
		// Send 10 ping request
		while (sequence_number < 10) {
			// Timestamp 
			Date now = new Date();
			long msSend = now.getTime();
			
			// create time stamp to send
			String str = "ping to " + args[0] + "seq = " + sequence_number + " " + msSend + " \n";
			byte[] buf = new byte[1024];
			buf = str.getBytes();
			
			// Create object as UDP packet.
			DatagramPacket ping = new DatagramPacket(buf, buf.length, server, port);

			// Send the Ping datagram to the specified server
			socket.send(ping);
			// Try to receive the packet wait max 1s
			try {
				// Set up the timeout 1000 ms = 1 sec
				
				socket.setSoTimeout(Wait);
				
				// Set up an UPD packet for recieving
				DatagramPacket response = new DatagramPacket(new byte[1024], 1024);
				
				// Try to receive the response from the ping
				socket.receive(response);
				// If exceed 1s it, exception handle it. 
				now = new Date();
				long msReceived = now.getTime();
				
				// Print the packet and the delay
				printData(response, msReceived - msSend);
			} catch (IOException e) {
				
				System.out.println("Timeout for seq " + sequence_number);
			}
			// next packet
			sequence_number ++;
		}
}

   /* 
    * Print ping data to the standard output stream.
    */
   private static void printData(DatagramPacket request, long delay) throws Exception
   {
      

      // Print host address and data received from it.
      System.out.println(
         "Received from " + 
         request.getAddress().getHostAddress() + 
         ": " +
         "Delay:" + delay);
   }
}
