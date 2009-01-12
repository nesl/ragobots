/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'StartMsg'
 * message type.
 */

public class StartMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 1;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 12;

    /** Create a new StartMsg of size 1. */
    public StartMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new StartMsg of the given data_length. */
    public StartMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new StartMsg with the given data_length
     * and base offset.
     */
    public StartMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new StartMsg using the given byte array
     * as backing store.
     */
    public StartMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new StartMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public StartMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new StartMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public StartMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new StartMsg embedded in the given message
     * at the given base offset.
     */
    public StartMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new StartMsg embedded in the given message
     * at the given base offset and length.
     */
    public StartMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <StartMsg> \n";
      try {
        s += "  [dummy=0x"+Long.toHexString(get_dummy())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dummy
    //   Field type: short, unsigned
    //   Offset (bits): 0
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dummy' is signed (false).
     */
    public static boolean isSigned_dummy() {
        return false;
    }

    /**
     * Return whether the field 'dummy' is an array (false).
     */
    public static boolean isArray_dummy() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dummy'
     */
    public static int offset_dummy() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dummy'
     */
    public static int offsetBits_dummy() {
        return 0;
    }

    /**
     * Return the value (as a short) of the field 'dummy'
     */
    public short get_dummy() {
        return (short)getUIntElement(offsetBits_dummy(), 8);
    }

    /**
     * Set the value of the field 'dummy'
     */
    public void set_dummy(short value) {
        setUIntElement(offsetBits_dummy(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'dummy'
     */
    public static int size_dummy() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dummy'
     */
    public static int sizeBits_dummy() {
        return 8;
    }

}
