package tests;

import org.junit.jupiter.api.Assertions;

public class Simple {
	static int abs(int x) {
		if (x >= 0)
			return x;
		else
			return -x;
	}

	static int fib(int n) {
		int x = 0, y = 1, z = 1;
		for (int i = 0; i < n; i++) {
			x = y;
			y = z;

			z = x + y;

		}
		return x;
	}

	static int max(int a[], int left, int right) {
		Assertions.assertTrue(a != null);
		Assertions.assertTrue(0 <= left && left < right && right <= a.length);
		right--;
		while (left < right) {
			if (a[left] < a[right])
				left++;
			else
				right--;
		}
		Assertions.assertEquals(left, right);
		return a[left];
	}
}
