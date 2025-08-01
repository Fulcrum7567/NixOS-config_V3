import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class Iterate {
        public static <T> Iterable<T> flatten(Collection<T>... cols) {
                if (cols.length == 0) {
                        throw new IllegalArgumentException();
                }

                return new Iterable<T>() {
                        public Iterator<T> iterator() {
                                return new Iterator<T>() {

                                        Iterator<T> it = cols[0].iterator();
                                        int i = 0;

                                        @Override
                                        public boolean hasNext() {
                                                while(!it.hasNext() && i < cols.length - 2) {
                                                        it = cols[++i].iterator();
                                                }
                                                return it.hasNext();
                                        }

                                        @Override
                                        public T next() {
                                                if(!this.hasNext()) {
                                                        throw new NoSuchElementException();
                                                }
                                                return it.next();
                                        }
                                };
                        }
                };

        }

}
