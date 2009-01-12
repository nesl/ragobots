import java.io.*;
import net.tinyos.message.*;
import net.tinyos.util.*;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

public class MoteComm
    implements MessageListener {
  MoteIF mote;
  ConnectionListener connectionListener;

  public MoteComm(ConnectionListener connectionListener) {
    mote = new MoteIF(PrintStreamMessenger.err, -1);
    mote.registerListener(new MoveMsg(), this);
    mote.registerListener(new RfidMsg(), this);

    this.connectionListener = connectionListener;
  }

  public void sendMessage(short ragobotId, MoveMsg moveMsg) {
    try {
      mote.send(ragobotId, moveMsg);
    }
    catch (IOException e) {
    }
  }

  /**
   * messageReceived
   *
   * @param int0 int
   * @param message Message
   * @todo Implement this net.tinyos.message.MessageListener method
   */
  public void messageReceived(int int0, Message message) {
    if (message instanceof MoveMsg) {
    }
    else if (message instanceof RfidMsg){
      connectionListener.receiveRfidMessage((RfidMsg) message);
    }
    else {
     throw new RuntimeException("messageReceived: Got bad message type: " + message);
    }
  }

}
