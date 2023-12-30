function* randomSequence(n) {
    for (let i = 0; i < n; i++) {
        yield Math.floor(n * Math.random());
    }
}

Array.prototype.swap = function(i, j) {
    const temp = this[i];
    this[i] = this[j];
    this[j] = temp;
}

function naive_bubblesort(arr) {
    const n = arr.length;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1])
                arr.swap(j, j+1);
        }
    }
    return arr;
}

// keeps track of index of last swap
function bubblesort(arr) {
    const n = arr.length;
    for (let last, bound = n-1; bound > 0; bound = last) {
        last = 0;
        for (let i = 0; i < bound; i++) {
            if (arr[i] > arr[i+1]) {
                arr.swap(i, i+1);
                last = i;
            }
        }
    }
    return arr;
}

function naive_insertionSort(arr) {
    const n = arr.length;
    for (let i = 1; i < n; i++) {
        const elem = arr[i]
        let j;
        for (j = i; j > 0 && arr[j-1] > elem; j--) {
            arr[j] = arr[j-1];
        }
        arr[j] = elem;
    }
    return arr;
}

function insertionSort(arr) {
    const n = arr.length;
    for (let i = 1; i < n; i++) {
        if (arr[i] >= arr[i-1])
            continue;
        const elem = arr[i];
        let j;
        arr[i] = arr[i-1]
        for (j = i-1; j > 0 && arr[j-1] > elem; j--) {
            arr[j] = arr[j-1];
        }
        arr[j] = elem;
    }
    return arr;
}

function selectionSort(arr) {
    const n = arr.length;
    for (let i = n; i > 0; i--) {
        let max = 0;
        for (let j = 1; j < i; j++) {
            if (arr[j] > arr[max]) {
                max = j;
            }
        }
        arr.swap(max, i-1);
    }
    return arr;
}

const length = +process.argv[2] || 10;
console.log([...randomSequence(length)]);
console.log("done");
