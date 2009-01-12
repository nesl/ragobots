import net.tinyos.message.*;
import java.io.*;

// For opening TCP connection
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.net.*;

public class LocationReceiver extends Thread {
  ServerSocketChannel serverSocketChannel; // Server socket to communicate with localization server
  SocketChannel sChannel;
  SerialCommunicator serialCommunicator;

  LocationReceiver(SerialCommunicator sc) {
    super("LocationReceiver Thread");
    serialCommunicator = sc;
    start();
  }

  public void run() {
    int bytesRead = 0;
    ByteBuffer byteBuffer = ByteBuffer.allocateDirect(280);
    byte[] byteArray = new byte[28];
    LocationMsg locationMsg;

    try {
      serverSocketChannel = ServerSocketChannel.open();
      serverSocketChannel.configureBlocking(true);
      serverSocketChannel.socket().bind(new InetSocketAddress(9002));
    }
    catch (IOException ioe) {
      System.out.println(ioe.toString());
    }

    while(true) {
      try {
	sChannel = serverSocketChannel.accept();
	System.out.println("New connection set up.");

	bytesRead = sChannel.read(byteBuffer);
      }
      catch (Exception e) {
        System.out.println(e.toString());
      }

      while(bytesRead > 0) {
	byteBuffer.flip();
	byteBuffer.get(byteArray);
	locationMsg = new LocationMsg(byteArray);

	byteBuffer = ByteBuffer.allocateDirect(280);
	try {
	  serialCommunicator.send(locationMsg);
	  bytesRead = sChannel.read(byteBuffer);
	}
	catch (IOException ioe) {
	  System.out.println(ioe.toString());
	  bytesRead = 0;
	}
      }

      System.out.println("Connection closed.");
    }
  }//end of inifinte while loop
}
