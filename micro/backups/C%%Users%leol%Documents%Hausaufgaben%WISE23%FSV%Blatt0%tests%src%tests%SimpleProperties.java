package tests;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Disabled;

import net.jqwik.api.ForAll;
import net.jqwik.api.Property;
import net.jqwik.api.constraints.DoubleRange;
import net.jqwik.api.constraints.IntRange;

public class SimpleProperties {
    static int a[] = { 1, 4, 2, 3, 5, 7, 4, 9, -1 };

    @Disabled
	@Property
	void inc(@ForAll int x) {
		Assertions.assertTrue(x + 1 > x);
	}

    @Property
    void testAbs(@ForAll @IntRange(min = 0x80000001, max = Integer.MAX_VALUE) int x) {
        int y = Simple.abs(x);
        Assertions.assertTrue(y == x || y == -x);

        Assertions.assertTrue(y >= 0);
    }

    @Property
    void testMax(@ForAll @IntRange(min = 0, max = 8) int i1, @ForAll @IntRange(min = 0, max = 8) int i2) {
        if (i1 == i2) return;
        int res = Simple.max(a, Math.min(i1, i2), Math.max(i1, i2));
        
        Assertions.assertTrue(isIn(a, res));

        for (int x: a) {
            Assertions.assertTrue(x <= res);
        }
    }


	private boolean isIn(int[] arr, int val) {
	    for (int i = 0; i < arr.length; i++) {
	        if (arr[i] == val) {
	            return true;
	        }
	    }
	    return false;
	}
	
	// 	Oracle
	int fib(int x) {
		if (x <= 0)
			return 0;
		else if (x == 1)
			return 1;
		else
			return fib(x - 1) + fib(x - 2);
	}

	@Property
	void testFib(@ForAll @IntRange(min = 0, max = 10) int n) {
		int actual = Simple.fib(n);
		int expected = this.fib(n);
		Assertions.assertEquals(expected, actual);
	}
	

	@Property
	void sqrt(@ForAll @DoubleRange(min=0, max=100000) double x) {
		double y = Math.sqrt(x);
		double d = Math.abs(x - y * y);
		Assertions.assertTrue(d <= 0.0001);
	}
}
