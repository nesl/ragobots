import java.io.*;
import java.net.*;
import java.nio.channels.*;
import java.nio.channels.spi.*;
import java.util.*;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

public class ConnectionListener extends Thread {
  static int MAX_NUM_RAGOBOTS = 2;
  ConnectionHandler chList[] = new ConnectionHandler[MAX_NUM_RAGOBOTS];
  static int numClients;
  MoteComm moteComm;

  public ConnectionListener() {
    numClients = 0;
    moteComm = new MoteComm(this);
    this.start();
  }

  /**
   * When an object implementing interface <code>Runnable</code> is used to
   * create a thread, starting the thread causes the object's <code>run</code>
   * method to be called in that separately executing thread.
   *
   * @todo Implement this java.lang.Runnable method
   */
  public void run() {
    ServerSocket serverSocket;
    Socket socket;
    short i;

    try {
      serverSocket = new ServerSocket(6076);

      while (true) {
        socket = serverSocket.accept();

        for (i = 0; i < MAX_NUM_RAGOBOTS; ++i)
        {
          if (chList[i] == null || chList[i].isAlive() == false)
          {
            chList[i] = new ConnectionHandler(moteComm,
                                              socket,
                                              i);
            break;
          }
        }

        numClients++;
        System.out.println("Connection Established");
      }
    }
    catch (IOException e) {
      System.err.println(e.getMessage());
      System.exit(1);
    }
  }

  public void receiveRfidMessage(RfidMsg rfidMsg) {
    if (rfidMsg.get_type() == 0 &&
        chList[rfidMsg.get_ragobotId() - 2] != null) {
      chList[rfidMsg.get_ragobotId() - 2].out.println("HINT" + " " +
                                                      Integer.toString(rfidMsg.
          get_x()) + " " +
                                                      Integer.toString(rfidMsg.
          get_y()) + " " +
                                                      Integer.toString(rfidMsg.
          get_value()));
    }
    else if (chList[rfidMsg.get_ragobotId() - 2] != null) {
      chList[rfidMsg.get_ragobotId() - 2].out.println("TREASURE" + " " +
                                                      Integer.toString(rfidMsg.
          get_x()) + " " +
                                                      Integer.toString(rfidMsg.
          get_y()) + " " +
                                                      Integer.toString(rfidMsg.
          get_value()));
    }
  }
}
