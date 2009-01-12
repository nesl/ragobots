

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2004</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

public class RfidTag {
  static int MAX_NUM_HINTS = 100;
  static int MAX_NUM_TREASURES = 100;

  private int x, y;
  private int treasureValue;

  public RfidTag() {
  }

  public RfidTag(int x, int y, int treasureValue) {
    this.x = x;
    this.y = y;
    this.treasureValue = treasureValue;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public int getTreasureValue() {
    return treasureValue;
  }
}
