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

public class ClientComm extends Thread {
  private ClientUI clientUI;
  private Socket socket;
  private PrintWriter out;
  private BufferedReader in;
  private String machine;

  public ClientComm(ClientUI clientUI, String machine) {
    this.clientUI = clientUI;
    this.machine = machine;
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
      socket = new Socket(this.machine, 6076);
      out = new PrintWriter(socket.getOutputStream(), true);
      in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

      while (true) {
        message = in.readLine();
        this.parseMessage(message);
        System.out.println(message);
      }
    }
    catch (Exception e) {
      System.err.println(e.getMessage());
      System.exit(1);
    }
  }

  public void send(String message) {
    out.println(message);
  }

  private void parseMessage(String message) {
    StringTokenizer tokens = new StringTokenizer(message, " ");
    String messageType = tokens.nextToken();

    if (messageType.equalsIgnoreCase("HINT")) {
      clientUI.registerHint(Integer.parseInt(tokens.nextToken()),
                            Integer.parseInt(tokens.nextToken()),
                            Integer.parseInt(tokens.nextToken()));

      System.out.println("Found hint.\n");
    }
    else if (messageType.equalsIgnoreCase("TREASURE")) {
      clientUI.registerTreasure(Integer.parseInt(tokens.nextToken()),
                                Integer.parseInt(tokens.nextToken()),
                                Integer.parseInt(tokens.nextToken()));

      System.out.println("Found hint.\n");
    }
  }
}
