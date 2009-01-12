import java.io.*;
import java.net.*;
import java.util.*;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

public class ConnectionHandler extends Thread {
  Socket socket;
  PrintWriter out;
  BufferedReader in;
  short ragobotId;
  MoteComm moteComm;

  public ConnectionHandler(MoteComm moteComm, Socket socket, short ragobotId) {
    super();

    try {
      this.socket = socket;
      out = new PrintWriter(socket.getOutputStream(), true);
      in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      this.ragobotId = ragobotId;
      this.moteComm = moteComm;
    }
    catch (IOException e) {
      System.err.println(e.getMessage());
      System.exit(1);
    }

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
    String message;

    try {
      while (true) {
        message = in.readLine();
        System.out.println(message);

        moteComm.sendMessage((short) (this.ragobotId + 2), parseMessage(message));
      }
    }
    catch (IOException e) {
      System.err.println(e.getMessage());
      //System.exit(1);
    }
  }

  public void sendMessage(String message) {
  }

  private MoveMsg parseMessage(String message) {
    StringTokenizer tokens = new StringTokenizer(message, " ");
    String messageType = tokens.nextToken();
    MoveMsg moveMsg = new MoveMsg();

    if (messageType.equalsIgnoreCase("MOVE")) {
      moveMsg.set_type(Short.parseShort(tokens.nextToken()));
      moveMsg.set_x(Integer.parseInt(tokens.nextToken()));
      moveMsg.set_y(Integer.parseInt(tokens.nextToken()));

      return moveMsg;
    }

    return null;
  }
}
