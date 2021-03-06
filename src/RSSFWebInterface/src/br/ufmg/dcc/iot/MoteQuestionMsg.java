package br.ufmg.dcc.iot;
/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'MoteMsg'
 * message type.
 */

public class MoteQuestionMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 28;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 240;

    /** Create a new MoteMsg of size 28. */
    public MoteQuestionMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new MoteMsg of the given data_length. */
    public MoteQuestionMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new MoteMsg with the given data_length
     * and base offset.
     */
    public MoteQuestionMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new MoteMsg using the given byte array
     * as backing store.
     */
    public MoteQuestionMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new MoteMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public MoteQuestionMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new MoteMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public MoteQuestionMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new MoteMsg embedded in the given message
     * at the given base offset.
     */
    public MoteQuestionMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new MoteMsg embedded in the given message
     * at the given base offset and length.
     */
    public MoteQuestionMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <MoteMsg> \n";
      try {
        s += "  [version=0x"+Long.toHexString(get_version())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [size=0x"+Long.toHexString(get_size())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [temperature=0x"+Long.toHexString(get_temperature())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [luminosity=0x"+Long.toHexString(get_luminosity())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [src=0x"+Long.toHexString(get_src())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [parent_node=0x"+Long.toHexString(get_parent_node())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [extra_data_2=0x"+Long.toHexString(get_extra_data_2())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [extra_data_3=0x"+Long.toHexString(get_extra_data_3())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [extra_data_4=0x"+Long.toHexString(get_extra_data_4())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [extra_data_5=0x"+Long.toHexString(get_extra_data_5())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: version
    //   Field type: int, unsigned
    //   Offset (bits): 0
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'version' is signed (false).
     */
    public static boolean isSigned_version() {
        return false;
    }

    /**
     * Return whether the field 'version' is an array (false).
     */
    public static boolean isArray_version() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'version'
     */
    public static int offset_version() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'version'
     */
    public static int offsetBits_version() {
        return 0;
    }

    /**
     * Return the value (as a int) of the field 'version'
     */
    public int get_version() {
        return (int)getUIntBEElement(offsetBits_version(), 16);
    }

    /**
     * Set the value of the field 'version'
     */
    public void set_version(int value) {
        setUIntBEElement(offsetBits_version(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'version'
     */
    public static int size_version() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'version'
     */
    public static int sizeBits_version() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: size
    //   Field type: int, unsigned
    //   Offset (bits): 16
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'size' is signed (false).
     */
    public static boolean isSigned_size() {
        return false;
    }

    /**
     * Return whether the field 'size' is an array (false).
     */
    public static boolean isArray_size() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'size'
     */
    public static int offset_size() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'size'
     */
    public static int offsetBits_size() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'size'
     */
    public int get_size() {
        return (int)getUIntBEElement(offsetBits_size(), 16);
    }

    /**
     * Set the value of the field 'size'
     */
    public void set_size(int value) {
        setUIntBEElement(offsetBits_size(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'size'
     */
    public static int size_size() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'size'
     */
    public static int sizeBits_size() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: temperature
    //   Field type: int, unsigned
    //   Offset (bits): 32
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'temperature' is signed (false).
     */
    public static boolean isSigned_temperature() {
        return false;
    }

    /**
     * Return whether the field 'temperature' is an array (false).
     */
    public static boolean isArray_temperature() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'temperature'
     */
    public static int offset_temperature() {
        return (32 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'temperature'
     */
    public static int offsetBits_temperature() {
        return 32;
    }

    /**
     * Return the value (as a int) of the field 'temperature'
     */
    public int get_temperature() {
        return (int)getUIntBEElement(offsetBits_temperature(), 16);
    }

    /**
     * Set the value of the field 'temperature'
     */
    public void set_temperature(int value) {
        setUIntBEElement(offsetBits_temperature(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'temperature'
     */
    public static int size_temperature() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'temperature'
     */
    public static int sizeBits_temperature() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: luminosity
    //   Field type: int, unsigned
    //   Offset (bits): 48
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'luminosity' is signed (false).
     */
    public static boolean isSigned_luminosity() {
        return false;
    }

    /**
     * Return whether the field 'luminosity' is an array (false).
     */
    public static boolean isArray_luminosity() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'luminosity'
     */
    public static int offset_luminosity() {
        return (48 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'luminosity'
     */
    public static int offsetBits_luminosity() {
        return 48;
    }

    /**
     * Return the value (as a int) of the field 'luminosity'
     */
    public int get_luminosity() {
        return (int)getUIntBEElement(offsetBits_luminosity(), 16);
    }

    /**
     * Set the value of the field 'luminosity'
     */
    public void set_luminosity(int value) {
        setUIntBEElement(offsetBits_luminosity(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'luminosity'
     */
    public static int size_luminosity() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'luminosity'
     */
    public static int sizeBits_luminosity() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: src
    //   Field type: int, unsigned
    //   Offset (bits): 64
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'src' is signed (false).
     */
    public static boolean isSigned_src() {
        return false;
    }

    /**
     * Return whether the field 'src' is an array (false).
     */
    public static boolean isArray_src() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'src'
     */
    public static int offset_src() {
        return (64 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'src'
     */
    public static int offsetBits_src() {
        return 64;
    }

    /**
     * Return the value (as a int) of the field 'src'
     */
    public int get_src() {
        return (int)getUIntBEElement(offsetBits_src(), 16);
    }

    /**
     * Set the value of the field 'src'
     */
    public void set_src(int value) {
        setUIntBEElement(offsetBits_src(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'src'
     */
    public static int size_src() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'src'
     */
    public static int sizeBits_src() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: parent_node
    //   Field type: int, unsigned
    //   Offset (bits): 80
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'parent_node' is signed (false).
     */
    public static boolean isSigned_parent_node() {
        return false;
    }

    /**
     * Return whether the field 'parent_node' is an array (false).
     */
    public static boolean isArray_parent_node() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'parent_node'
     */
    public static int offset_parent_node() {
        return (80 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'parent_node'
     */
    public static int offsetBits_parent_node() {
        return 80;
    }

    /**
     * Return the value (as a int) of the field 'parent_node'
     */
    public int get_parent_node() {
        return (int)getUIntBEElement(offsetBits_parent_node(), 16);
    }

    /**
     * Set the value of the field 'parent_node'
     */
    public void set_parent_node(int value) {
        setUIntBEElement(offsetBits_parent_node(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'parent_node'
     */
    public static int size_parent_node() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'parent_node'
     */
    public static int sizeBits_parent_node() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: extra_data_2
    //   Field type: long, unsigned
    //   Offset (bits): 96
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'extra_data_2' is signed (false).
     */
    public static boolean isSigned_extra_data_2() {
        return false;
    }

    /**
     * Return whether the field 'extra_data_2' is an array (false).
     */
    public static boolean isArray_extra_data_2() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'extra_data_2'
     */
    public static int offset_extra_data_2() {
        return (96 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'extra_data_2'
     */
    public static int offsetBits_extra_data_2() {
        return 96;
    }

    /**
     * Return the value (as a long) of the field 'extra_data_2'
     */
    public long get_extra_data_2() {
        return (long)getUIntBEElement(offsetBits_extra_data_2(), 32);
    }

    /**
     * Set the value of the field 'extra_data_2'
     */
    public void set_extra_data_2(long value) {
        setUIntBEElement(offsetBits_extra_data_2(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'extra_data_2'
     */
    public static int size_extra_data_2() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'extra_data_2'
     */
    public static int sizeBits_extra_data_2() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: extra_data_3
    //   Field type: long, unsigned
    //   Offset (bits): 128
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'extra_data_3' is signed (false).
     */
    public static boolean isSigned_extra_data_3() {
        return false;
    }

    /**
     * Return whether the field 'extra_data_3' is an array (false).
     */
    public static boolean isArray_extra_data_3() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'extra_data_3'
     */
    public static int offset_extra_data_3() {
        return (128 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'extra_data_3'
     */
    public static int offsetBits_extra_data_3() {
        return 128;
    }

    /**
     * Return the value (as a long) of the field 'extra_data_3'
     */
    public long get_extra_data_3() {
        return (long)getUIntBEElement(offsetBits_extra_data_3(), 32);
    }

    /**
     * Set the value of the field 'extra_data_3'
     */
    public void set_extra_data_3(long value) {
        setUIntBEElement(offsetBits_extra_data_3(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'extra_data_3'
     */
    public static int size_extra_data_3() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'extra_data_3'
     */
    public static int sizeBits_extra_data_3() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: extra_data_4
    //   Field type: long, unsigned
    //   Offset (bits): 160
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'extra_data_4' is signed (false).
     */
    public static boolean isSigned_extra_data_4() {
        return false;
    }

    /**
     * Return whether the field 'extra_data_4' is an array (false).
     */
    public static boolean isArray_extra_data_4() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'extra_data_4'
     */
    public static int offset_extra_data_4() {
        return (160 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'extra_data_4'
     */
    public static int offsetBits_extra_data_4() {
        return 160;
    }

    /**
     * Return the value (as a long) of the field 'extra_data_4'
     */
    public long get_extra_data_4() {
        return (long)getUIntBEElement(offsetBits_extra_data_4(), 32);
    }

    /**
     * Set the value of the field 'extra_data_4'
     */
    public void set_extra_data_4(long value) {
        setUIntBEElement(offsetBits_extra_data_4(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'extra_data_4'
     */
    public static int size_extra_data_4() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'extra_data_4'
     */
    public static int sizeBits_extra_data_4() {
        return 32;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: extra_data_5
    //   Field type: long, unsigned
    //   Offset (bits): 192
    //   Size (bits): 32
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'extra_data_5' is signed (false).
     */
    public static boolean isSigned_extra_data_5() {
        return false;
    }

    /**
     * Return whether the field 'extra_data_5' is an array (false).
     */
    public static boolean isArray_extra_data_5() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'extra_data_5'
     */
    public static int offset_extra_data_5() {
        return (192 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'extra_data_5'
     */
    public static int offsetBits_extra_data_5() {
        return 192;
    }

    /**
     * Return the value (as a long) of the field 'extra_data_5'
     */
    public long get_extra_data_5() {
        return (long)getUIntBEElement(offsetBits_extra_data_5(), 32);
    }

    /**
     * Set the value of the field 'extra_data_5'
     */
    public void set_extra_data_5(long value) {
        setUIntBEElement(offsetBits_extra_data_5(), 32, value);
    }

    /**
     * Return the size, in bytes, of the field 'extra_data_5'
     */
    public static int size_extra_data_5() {
        return (32 / 8);
    }

    /**
     * Return the size, in bits, of the field 'extra_data_5'
     */
    public static int sizeBits_extra_data_5() {
        return 32;
    }

}
