public class Iterate {
        public static <T> Iterable<T> flatten(Collection<T>... cols) {
                return new Iterable<T> {
                        public Iterator<T> iterator() {

                        }
                }

        }

}
