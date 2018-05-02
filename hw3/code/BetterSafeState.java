import java.util.concurrent.locks.ReentrantLock;

class BetterSafeState implements State {
    private byte[] value;
    private byte maxval;
    private final ReentrantLock lock = new ReentrantLock();

    BetterSafeState(byte[] v) { value = v; maxval = 127; }

    BetterSafeState(byte[] v, byte m) { value = v; maxval = m; }

    public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
        lock.lock();
        boolean returnVal = false;
        try {
            if (value[i] > 0 && value[j] < maxval) {
                value[i]--;
                value[j]++;
                returnVal = true;
            }
        } finally {
            lock.unlock();
        }
        return returnVal;
    }
}
