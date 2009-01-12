import net.tinyos.util.*;
import net.tinyos.message.*;
import java.io.*;
import java.util.*;
import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

public class SerialCommunicator /*extends Panel*/ implements MessageListener
{
  MoteIF locationMote, commandMote, startMote, stopMote;

  SerialCommunicator() {
    locationMote = new MoteIF(PrintStreamMessenger.err, -1);
    locationMote.registerListener(new LocationMsg(), this);

    commandMote = new MoteIF(PrintStreamMessenger.err, -1);
    commandMote.registerListener(new CommandMsg(), this);

    startMote = new MoteIF(PrintStreamMessenger.err, -1);
    startMote.registerListener(new StartMsg(), this);

    stopMote = new MoteIF(PrintStreamMessenger.err, -1);
    stopMote.registerListener(new StopMsg(), this);
  }

  public static byte[] toByteArray(short foo) {
    return toByteArray(foo, new byte[2]);
  }

  public static byte[] toByteArray(int foo) {
    return toByteArray(foo, new byte[4]);
  }
 
  public static byte[] toByteArray(long foo) {
    return toByteArray(foo, new byte[8]);
  }
 
  private static byte[] toByteArray(long foo, byte[] array) {
    for (int iInd = 0; iInd < array.length; ++iInd) {
      array[iInd] = (byte) ((foo >> (iInd*8)) % 0xFF);
    }
 
    return array;
  }

  private void locationMsgReceived(int dest_addr, LocationMsg locationMsg) {
  }

  public void messageReceived(int dest_addr, Message msg) {
    if (msg instanceof LocationMsg) { 
      locationMsgReceived(dest_addr,(LocationMsg)msg);
    }
    else {
     throw new RuntimeException("messageReceived: Got bad message type: " + msg);
    }
  }

  public void send(LocationMsg locationMsg) {
    try {
      locationMote.send(net.tinyos.message.MoteIF.TOS_BCAST_ADDR, locationMsg);
    }
    catch (IOException ioe) {
      System.out.println("Caught exception: " + ioe.toString());
    }
    return;
  }

  public void commands() {
    int i;
    byte[] byteCoordinate;
    short[] command1 = {7,
			50, 50,
			80, 50,
			200, 200,
			500, 200,
			100, 100,
			400, 100,
			300, 200};

    byte[] byteCommand = new byte[29];
    byte[] dummy = new byte[1];
    CommandMsg commandMsg;
    StartMsg startMsg = new StartMsg(dummy);
    StopMsg stopMsg = new StopMsg(dummy);

    byteCommand[0] = (toByteArray(command1[0]))[0];
    for(i=0;i<14;++i) {
	byteCoordinate = toByteArray(command1[i + 1]);
	byteCommand[i*2 + 1] = byteCoordinate[0];
	byteCommand[i*2 + 2] = byteCoordinate[1];
    }

    commandMsg = new CommandMsg(byteCommand);
    try {
      commandMote.send(1, commandMsg);
      commandMote.send(1, commandMsg);
      commandMote.send(1, commandMsg);
      commandMote.send(1, commandMsg);
      commandMote.send(1, commandMsg);
    }
    catch (IOException ioe) {
	System.out.println(ioe.toString());
    }

    try {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String str = "";
	System.out.print("> ");
	str = in.readLine();
	startMote.send(net.tinyos.message.MoteIF.TOS_BCAST_ADDR, startMsg);
	System.out.print("StartMsg sent.\n> ");
	str = in.readLine();
	startMote.send(net.tinyos.message.MoteIF.TOS_BCAST_ADDR, stopMsg);
	System.out.print("StopMsg sent.\n");
    } 
    catch (IOException e) {
    }
    return;
  }

  public static void main(String[] args) {
    SerialCommunicator sc = new SerialCommunicator();
    LocationReceiver lr = new LocationReceiver(sc);

    sc.commands();
  }
}
