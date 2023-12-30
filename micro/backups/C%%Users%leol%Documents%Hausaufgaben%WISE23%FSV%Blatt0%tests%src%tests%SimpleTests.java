package tests;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class SimpleTests {
	static int a[] = { 1, 4, 2, 3, 5, 7, 4, 9, -1 };

    @Test
    void testAbs() {
        for (int i=0; i<=1000; i++) {
            Assertions.assertEquals(i, Simple.abs(i));
        }

        for (int i=-1; i>=-1000; i--) {
            Assertions.assertEquals(-i, Simple.abs(i));
        }

        Assertions.assertEquals(Integer.MAX_VALUE, Simple.abs(Integer.MAX_VALUE));
        Assertions.assertEquals(0x7fffffff, Simple.abs(0x80000001));
    }

    @Test
    void testFib() {
        Assertions.assertEquals(0, Simple.fib(0));
        Assertions.assertEquals(1, Simple.fib(1));
        Assertions.assertEquals(1, Simple.fib(2));
        Assertions.assertEquals(2, Simple.fib(3));
        Assertions.assertEquals(3, Simple.fib(4));
        Assertions.assertEquals(5, Simple.fib(5));
    }
	
	@Test
	void testMax() {
		Assertions.assertEquals(1, Simple.max(a, 0, 1));
		Assertions.assertEquals(3, Simple.max(a, 2, 4));
		Assertions.assertEquals(9, Simple.max(a, 0, a.length));
	}
}
