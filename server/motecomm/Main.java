import net.tinyos.util.*;
import net.tinyos.message.*;
import java.io.*;
import java.util.*;
import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

// Opening TCP connection
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.net.*;

public class Main /*extends Panel*/ implements MessageListener
{
  MoteIF mote;
  ServerSocketChannel serverSocketChannel; // Server socket to communicate with localization server
    //  Selector selector;
  SocketChannel sChannel;

  Main() {
    ByteBuffer byteBuffer = ByteBuffer.allocateDirect(280);
    byte[] byteArray;
    int b = 0;
    mote = new MoteIF(PrintStreamMessenger.err, -1);
    mote.registerListener(new LocationMsg(), this);
    LocationMsg locationMsg;

    byteArray = new byte[28];

    // Create a non-blocking server socket and check for connections
    // from localization server
    try {
      // Create the selector
      // Selector selector = Selector.open();
    
      // Create a non-blocking server socket channel on port 9002
      serverSocketChannel = ServerSocketChannel.open();
      serverSocketChannel.configureBlocking(true);
      serverSocketChannel.socket().bind(new InetSocketAddress(9002));
    
      // Register both channels with selector
      // serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);

      sChannel = serverSocketChannel.accept();
      System.out.println("Connection set up.");

      /*      while(sChannel == null) {
	  //serverSocketChannel.wait(100);
	sChannel = serverSocketChannel.accept();
      }
      System.out.println("Connection Accepted");

      // Before the socket is usable, the connection must be completed
      // by calling finishConnect(), which is non-blocking
      while (!sChannel.finishConnect()) {
	  System.out.println("Waiting to finish connect.");
      }
      */

      b = sChannel.read(byteBuffer);
    }
    catch (Exception e) {
    }

    while(b != -1) {
      System.out.println(" bytes read " + b);
      byteBuffer.flip();
      byteBuffer.get(byteArray);
      locationMsg = new LocationMsg(byteArray);

      //      System.out.println(locationMsg.toString());

      byteBuffer = ByteBuffer.allocateDirect(280);
      try {
	mote.send(net.tinyos.message.MoteIF.TOS_BCAST_ADDR, locationMsg);
	b = sChannel.read(byteBuffer);
      }
      catch (IOException e) {
      }
    }
  }

  public void messageReceived(int dest_addr, Message msg) 
  {
    if (msg instanceof LocationMsg) { 
      LocationMsgReceived(dest_addr,(LocationMsg)msg);
    }
    else {
     throw new RuntimeException("messageReceived: Got bad message type: " + msg);
    }
  }

  public void LocationMsgReceived(int dest_addr, LocationMsg locationMsg) {
  }

  public static void main(String[] args) {
    javax.swing.SwingUtilities.invokeLater(new Runnable() {
        public void run() {
	    Main temp = new Main();
        }
    });
  }
}
