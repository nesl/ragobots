/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'LocationMsg'
 * message type.
 */

public class LocationMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 28;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 10;

    /** Create a new LocationMsg of size 28. */
    public LocationMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new LocationMsg of the given data_length. */
    public LocationMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new LocationMsg with the given data_length
     * and base offset.
     */
    public LocationMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new LocationMsg using the given byte array
     * as backing store.
     */
    public LocationMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new LocationMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public LocationMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new LocationMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public LocationMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new LocationMsg embedded in the given message
     * at the given base offset.
     */
    public LocationMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new LocationMsg embedded in the given message
     * at the given base offset and length.
     */
    public LocationMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <LocationMsg> \n";
      try {
        s += "  [locationInfo.id=";
        for (int i = 0; i < 4; i++) {
          s += "0x"+Long.toHexString(getElement_locationInfo_id(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [locationInfo.x=";
        for (int i = 0; i < 4; i++) {
          s += "0x"+Long.toHexString(getElement_locationInfo_x(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [locationInfo.y=";
        for (int i = 0; i < 4; i++) {
          s += "0x"+Long.toHexString(getElement_locationInfo_y(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [locationInfo.orientation=";
        for (int i = 0; i < 4; i++) {
          s += "0x"+Long.toHexString(getElement_locationInfo_orientation(i) & 0xff)+" ";
        }
        s += "]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: locationInfo.id
    //   Field type: short[]
    //   Offset (bits): 0
    //   Size of each element (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'locationInfo.id' is signed (false).
     */
    public static boolean isSigned_locationInfo_id() {
        return false;
    }

    /**
     * Return whether the field 'locationInfo.id' is an array (true).
     */
    public static boolean isArray_locationInfo_id() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'locationInfo.id'
     */
    public static int offset_locationInfo_id(int index1) {
        int offset = 0;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'locationInfo.id'
     */
    public static int offsetBits_locationInfo_id(int index1) {
        int offset = 0;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return offset;
    }

    /**
     * Return the entire array 'locationInfo.id' as a short[]
     */
    public short[] get_locationInfo_id() {
        short[] tmp = new short[4];
        for (int index0 = 0; index0 < numElements_locationInfo_id(0); index0++) {
            tmp[index0] = getElement_locationInfo_id(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'locationInfo.id' from the given short[]
     */
    public void set_locationInfo_id(short[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_locationInfo_id(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a short) of the array 'locationInfo.id'
     */
    public short getElement_locationInfo_id(int index1) {
        return (short)getUIntElement(offsetBits_locationInfo_id(index1), 8);
    }

    /**
     * Set an element of the array 'locationInfo.id'
     */
    public void setElement_locationInfo_id(int index1, short value) {
        setUIntElement(offsetBits_locationInfo_id(index1), 8, value);
    }

    /**
     * Return the total size, in bytes, of the array 'locationInfo.id'
     */
    public static int totalSize_locationInfo_id() {
        return (224 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'locationInfo.id'
     */
    public static int totalSizeBits_locationInfo_id() {
        return 224;
    }

    /**
     * Return the size, in bytes, of each element of the array 'locationInfo.id'
     */
    public static int elementSize_locationInfo_id() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'locationInfo.id'
     */
    public static int elementSizeBits_locationInfo_id() {
        return 8;
    }

    /**
     * Return the number of dimensions in the array 'locationInfo.id'
     */
    public static int numDimensions_locationInfo_id() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'locationInfo.id'
     */
    public static int numElements_locationInfo_id() {
        return 4;
    }

    /**
     * Return the number of elements in the array 'locationInfo.id'
     * for the given dimension.
     */
    public static int numElements_locationInfo_id(int dimension) {
      int array_dims[] = { 4,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

    /**
     * Fill in the array 'locationInfo.id' with a String
     */
    public void setString_locationInfo_id(String s) { 
         int len = s.length();
         int i;
         for (i = 0; i < len; i++) {
             setElement_locationInfo_id(i, (short)s.charAt(i));
         }
         setElement_locationInfo_id(i, (short)0); //null terminate
    }

    /**
     * Read the array 'locationInfo.id' as a String
     */
    public String getString_locationInfo_id() { 
         char carr[] = new char[Math.min(net.tinyos.message.Message.MAX_CONVERTED_STRING_LENGTH,4)];
         int i;
         for (i = 0; i < carr.length; i++) {
             if ((char)getElement_locationInfo_id(i) == (char)0) break;
             carr[i] = (char)getElement_locationInfo_id(i);
         }
         return new String(carr,0,i);
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: locationInfo.x
    //   Field type: int[]
    //   Offset (bits): 8
    //   Size of each element (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'locationInfo.x' is signed (false).
     */
    public static boolean isSigned_locationInfo_x() {
        return false;
    }

    /**
     * Return whether the field 'locationInfo.x' is an array (true).
     */
    public static boolean isArray_locationInfo_x() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'locationInfo.x'
     */
    public static int offset_locationInfo_x(int index1) {
        int offset = 8;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'locationInfo.x'
     */
    public static int offsetBits_locationInfo_x(int index1) {
        int offset = 8;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return offset;
    }

    /**
     * Return the entire array 'locationInfo.x' as a int[]
     */
    public int[] get_locationInfo_x() {
        int[] tmp = new int[4];
        for (int index0 = 0; index0 < numElements_locationInfo_x(0); index0++) {
            tmp[index0] = getElement_locationInfo_x(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'locationInfo.x' from the given int[]
     */
    public void set_locationInfo_x(int[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_locationInfo_x(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a int) of the array 'locationInfo.x'
     */
    public int getElement_locationInfo_x(int index1) {
        return (int)getUIntElement(offsetBits_locationInfo_x(index1), 16);
    }

    /**
     * Set an element of the array 'locationInfo.x'
     */
    public void setElement_locationInfo_x(int index1, int value) {
        setUIntElement(offsetBits_locationInfo_x(index1), 16, value);
    }

    /**
     * Return the total size, in bytes, of the array 'locationInfo.x'
     */
    public static int totalSize_locationInfo_x() {
        return (224 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'locationInfo.x'
     */
    public static int totalSizeBits_locationInfo_x() {
        return 224;
    }

    /**
     * Return the size, in bytes, of each element of the array 'locationInfo.x'
     */
    public static int elementSize_locationInfo_x() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'locationInfo.x'
     */
    public static int elementSizeBits_locationInfo_x() {
        return 16;
    }

    /**
     * Return the number of dimensions in the array 'locationInfo.x'
     */
    public static int numDimensions_locationInfo_x() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'locationInfo.x'
     */
    public static int numElements_locationInfo_x() {
        return 4;
    }

    /**
     * Return the number of elements in the array 'locationInfo.x'
     * for the given dimension.
     */
    public static int numElements_locationInfo_x(int dimension) {
      int array_dims[] = { 4,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: locationInfo.y
    //   Field type: int[]
    //   Offset (bits): 24
    //   Size of each element (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'locationInfo.y' is signed (false).
     */
    public static boolean isSigned_locationInfo_y() {
        return false;
    }

    /**
     * Return whether the field 'locationInfo.y' is an array (true).
     */
    public static boolean isArray_locationInfo_y() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'locationInfo.y'
     */
    public static int offset_locationInfo_y(int index1) {
        int offset = 24;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'locationInfo.y'
     */
    public static int offsetBits_locationInfo_y(int index1) {
        int offset = 24;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return offset;
    }

    /**
     * Return the entire array 'locationInfo.y' as a int[]
     */
    public int[] get_locationInfo_y() {
        int[] tmp = new int[4];
        for (int index0 = 0; index0 < numElements_locationInfo_y(0); index0++) {
            tmp[index0] = getElement_locationInfo_y(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'locationInfo.y' from the given int[]
     */
    public void set_locationInfo_y(int[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_locationInfo_y(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a int) of the array 'locationInfo.y'
     */
    public int getElement_locationInfo_y(int index1) {
        return (int)getUIntElement(offsetBits_locationInfo_y(index1), 16);
    }

    /**
     * Set an element of the array 'locationInfo.y'
     */
    public void setElement_locationInfo_y(int index1, int value) {
        setUIntElement(offsetBits_locationInfo_y(index1), 16, value);
    }

    /**
     * Return the total size, in bytes, of the array 'locationInfo.y'
     */
    public static int totalSize_locationInfo_y() {
        return (224 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'locationInfo.y'
     */
    public static int totalSizeBits_locationInfo_y() {
        return 224;
    }

    /**
     * Return the size, in bytes, of each element of the array 'locationInfo.y'
     */
    public static int elementSize_locationInfo_y() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'locationInfo.y'
     */
    public static int elementSizeBits_locationInfo_y() {
        return 16;
    }

    /**
     * Return the number of dimensions in the array 'locationInfo.y'
     */
    public static int numDimensions_locationInfo_y() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'locationInfo.y'
     */
    public static int numElements_locationInfo_y() {
        return 4;
    }

    /**
     * Return the number of elements in the array 'locationInfo.y'
     * for the given dimension.
     */
    public static int numElements_locationInfo_y(int dimension) {
      int array_dims[] = { 4,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: locationInfo.orientation
    //   Field type: int[]
    //   Offset (bits): 40
    //   Size of each element (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'locationInfo.orientation' is signed (false).
     */
    public static boolean isSigned_locationInfo_orientation() {
        return false;
    }

    /**
     * Return whether the field 'locationInfo.orientation' is an array (true).
     */
    public static boolean isArray_locationInfo_orientation() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'locationInfo.orientation'
     */
    public static int offset_locationInfo_orientation(int index1) {
        int offset = 40;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'locationInfo.orientation'
     */
    public static int offsetBits_locationInfo_orientation(int index1) {
        int offset = 40;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 56;
        return offset;
    }

    /**
     * Return the entire array 'locationInfo.orientation' as a int[]
     */
    public int[] get_locationInfo_orientation() {
        int[] tmp = new int[4];
        for (int index0 = 0; index0 < numElements_locationInfo_orientation(0); index0++) {
            tmp[index0] = getElement_locationInfo_orientation(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'locationInfo.orientation' from the given int[]
     */
    public void set_locationInfo_orientation(int[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_locationInfo_orientation(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a int) of the array 'locationInfo.orientation'
     */
    public int getElement_locationInfo_orientation(int index1) {
        return (int)getUIntElement(offsetBits_locationInfo_orientation(index1), 16);
    }

    /**
     * Set an element of the array 'locationInfo.orientation'
     */
    public void setElement_locationInfo_orientation(int index1, int value) {
        setUIntElement(offsetBits_locationInfo_orientation(index1), 16, value);
    }

    /**
     * Return the total size, in bytes, of the array 'locationInfo.orientation'
     */
    public static int totalSize_locationInfo_orientation() {
        return (224 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'locationInfo.orientation'
     */
    public static int totalSizeBits_locationInfo_orientation() {
        return 224;
    }

    /**
     * Return the size, in bytes, of each element of the array 'locationInfo.orientation'
     */
    public static int elementSize_locationInfo_orientation() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'locationInfo.orientation'
     */
    public static int elementSizeBits_locationInfo_orientation() {
        return 16;
    }

    /**
     * Return the number of dimensions in the array 'locationInfo.orientation'
     */
    public static int numDimensions_locationInfo_orientation() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'locationInfo.orientation'
     */
    public static int numElements_locationInfo_orientation() {
        return 4;
    }

    /**
     * Return the number of elements in the array 'locationInfo.orientation'
     * for the given dimension.
     */
    public static int numElements_locationInfo_orientation(int dimension) {
      int array_dims[] = { 4,  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

}
