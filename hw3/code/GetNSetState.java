import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State {
    private AtomicIntegerArray value;
    private int maxval;

    GetNSetState(byte[] v) { this(v, (byte) 127); }

    GetNSetState(byte[] v, byte m) {
        int[] intArr = new int[v.length];
        for(int i = 0; i < v.length; i++)
            intArr[i] = v[i];
        value = new AtomicIntegerArray(intArr);
        maxval = m;
    }

    public int size() { return value.length(); }

    public byte[] current() {
        byte[] byteArr = new byte[value.length()];
        for(int i = 0; i< value.length(); i++)
            byteArr[i] = (byte) value.get(i);
        return byteArr;
    }

    public boolean swap(int i, int j) {
        int first = value.getAndDecrement(i);
        int second = value.getAndIncrement(j);
        if (first <= 0 || second >= maxval) {
            value.getAndIncrement(i);
            value.getAndDecrement(j);
            return false;
        }
        return true;
    }
}
