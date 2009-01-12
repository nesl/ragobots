import java.awt.*;
import java.awt.event.*;
import java.net.*;
import javax.imageio.*;
import javax.swing.*;
import com.borland.jbcl.layout.*;
import java.awt.image.ImageObserver;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

public class ClientUI extends JFrame
    implements ActionListener, ImageObserver {
  static int IMAGE_WIDTH = 480;
  static int IMAGE_HEIGHT = 704;
  static int IMAGE_X_POSITION = 5;
  static int IMAGE_Y_POSITION = 25;

  JPanel contentPane;
  XYLayout xYLayout1 = new XYLayout();
  JLabel terrain = new JLabel();

  String url = new String("http://128.97.93.192/jpg/image.jpg");
  ClientComm clientComm;

  //Timer to refresh image from camera
  Timer refreshTimer;
  static int refreshRate = 2000; //in milliseconds

  Timer gameDurationTimer;
  static int gameDuration = 100000000; //in milliseconds

  RfidTag hintList[];
  RfidTag treasureList[];
  JTextArea scoreValue = new JTextArea();
  JTextArea scoreText = new JTextArea();
  JLabel helpLabel = new JLabel();

  //Construct the frame
  public ClientUI() {
    enableEvents(AWTEvent.WINDOW_EVENT_MASK | AWTEvent.MOUSE_EVENT_MASK);
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    clientComm = new ClientComm(this, JOptionPane.showInputDialog("Enter machine name"));

    //Set timer
    refreshTimer = new Timer(refreshRate, this);
    refreshTimer.setInitialDelay(0);
    refreshTimer.start();

    gameDurationTimer = new Timer(gameDuration, this);
    gameDurationTimer.setInitialDelay(0);
    gameDurationTimer.setRepeats(false);
    gameDurationTimer.start();

    hintList = new RfidTag[RfidTag.MAX_NUM_HINTS];
    treasureList = new RfidTag[RfidTag.MAX_NUM_TREASURES];
  }

  //Component initialization
  private void jbInit() throws Exception  {
    contentPane = (JPanel) this.getContentPane();
    contentPane.setLayout(xYLayout1);
    this.setSize(new Dimension(733, 565));
    this.setTitle("Client UI");
    terrain.setIconTextGap(0);
    terrain.setText("");
    scoreValue.setEditable(false);
    scoreValue.setText("0");
    scoreText.setEditable(false);
    scoreText.setText("Score:");
    helpLabel.setText("Left-click on the image to send a Ragobot to that location. Right-click " +
    "to stop Ragobot.");
    contentPane.add(terrain,   new XYConstraints(2, 2, 750, 498));
    contentPane.add(scoreText,  new XYConstraints(8, 508, 48, 21));
    contentPane.add(scoreValue,   new XYConstraints(55, 508, 29, 21));
    contentPane.add(helpLabel,      new XYConstraints(293, 508, 418, 21));
  }

  //Overridden so we can exit when window is closed
  protected void processWindowEvent(WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      System.exit(0);
    }
  }

  /**
   * Processes mouse events occurring on this component by dispatching them to
   * any registered <code>MouseListener</code> objects.
   *
   * @param e the mouse event
   * @todo Implement this java.awt.Component method
   */
  protected void processMouseEvent(MouseEvent e) {
    Point mousePosition;

    super.processMouseEvent(e);

    if (e.getID() == MouseEvent.MOUSE_CLICKED) {
      try {
        if (e.getButton() == MouseEvent.BUTTON1)
          clientComm.send("MOVE 1 " + Integer.toString(e.getX() - IMAGE_X_POSITION) + " " +
                          Integer.toString(IMAGE_WIDTH - e.getY() + IMAGE_Y_POSITION));
        else
          clientComm.send("MOVE 2 0 0");
      }
      catch (HeadlessException he) {
        System.err.println(he.getMessage());
        System.exit(1);
      }
    }
  }

  /**
   * Invoked when an action occurs.
   *
   * @param e ActionEvent
   * @todo Implement this java.awt.event.ActionListener method
   */
  public void actionPerformed(ActionEvent e) {
    Image image;
    Graphics graphics;
    int i;

    if (gameDurationTimer.isRunning() == false) {
      //  Put dialog box here.
    }

    try {
      graphics = this.getGraphics();

      image = ImageIO.read(new URL(url)).getScaledInstance(704, 480, Image.SCALE_DEFAULT);
      graphics.drawImage(image, IMAGE_X_POSITION, IMAGE_Y_POSITION, this);

      graphics.setColor(Color.BLACK);
      for (i = 0; hintList[i] != null; ++i)
      {
        graphics.drawOval(hintList[i].getX() + IMAGE_X_POSITION, IMAGE_WIDTH - hintList[i].getY() + IMAGE_Y_POSITION, 25, 25);
      }

      graphics.setColor(Color.BLUE);
      for (i = 0; treasureList[i] != null; ++i)
      {
        graphics.drawOval(treasureList[i].getX() + IMAGE_X_POSITION, IMAGE_WIDTH - treasureList[i].getY() + IMAGE_Y_POSITION, 25, 25);
      }
    }
    catch (Exception exception) {
      System.err.println(exception.getMessage());
      System.exit(1);
    }
  }

  void registerHint(int x, int y, int treasureValue) {
    RfidTag hint = new RfidTag(x, y, treasureValue);
    int i;

    for (i = 0; hintList[i] != null; ++i);
    hintList[i] = hint;
  }

  void registerTreasure(int x, int y, int treasureValue) {
    RfidTag treasure = new RfidTag(x, y, treasureValue);
    int i;

    for (i = 0; treasureList[i] != null; ++i);
    treasureList[i] = treasure;

    scoreValue.setText(String.valueOf(Integer.parseInt(scoreValue.getText()) + treasureValue));
  }

  /**
   * This method is called when information about an image which was previously
   * requested using an asynchronous interface becomes available.
   *
   * @param img the image being observed.
   * @param infoflags the bitwise inclusive OR of the following flags:
   *   <code>WIDTH</code>, <code>HEIGHT</code>, <code>PROPERTIES</code>,
   *   <code>SOMEBITS</code>, <code>FRAMEBITS</code>, <code>ALLBITS</code>,
   *   <code>ERROR</code>, <code>ABORT</code>.
   * @param x the <i>x</i> coordinate.
   * @param y the <i>y</i> coordinate.
   * @param width the width.
   * @param height the height.
   * @return <code>false</code> if the infoflags indicate that the image is
   *   completely loaded; <code>true</code> otherwise.
   * @todo Implement this java.awt.image.ImageObserver method
   */
  public boolean imageUpdate(Image img, int infoflags, int x, int y, int width,
                             int height) {
    return true;
  }
}
