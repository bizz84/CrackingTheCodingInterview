# Cracking The Coding Interview

This playground is a collection of solutions to some of the exercises in this book:

## [Cracking the Coding Interview: 150 Programming Questions and Solutions](http://www.amazon.co.uk/Cracking-Coding-Interview-Programming-Questions/dp/098478280X/ref=sr_1_2?ie=UTF8&qid=1437988505&sr=8-2&keywords=cracking+the+code+interview)

## Notes
All written in Swift 2.0.
Tested on Xcode 7.0 beta 3.
Each chapter is included as a Swift module file.

The list of exercises is incomplete and the solutions are entirely my own, rather than a port of the ones in the book. Some solutions may be wrong and there is some work to be done in updating the code to best Swift 2.0 practices.

## Some background

**Hash Tables (Dictionary)** 
- Count occurrences of characters/strings in sets. Useful to check for uniqueness/ remove duplicates (no second pass required)
Linked Lists
- Runner technique (use two pointers, one can move faster or be k steps ahead…). Useful to detect loops,
- Note: Removal of one node can be done in O(1)
- Can partition linked lists by manipulation of nodes/data
- Can implement addition of two linked lists of digits. Careful with exit conditions
- Check if list is palindrome: Get to half of list with 2-by-1 steps runner and build reverse of first half, then compare with the rest.

**Stacks & queues**
- Stack is LIFO, implemented as array or queue, has peek method
- Implement three stacks with one array: just indices manipulation and insert in place (O(n)). Check if stacks have fixed or dynamic length
- Array with push, pop, min, all in O(1). Idea: store min value in node at each push so that min is retained across push/pop operations
- SetOfStacks problem (shows OO skills)
- Can solve Tower of Hanoi (solve subproblems with correct choice of origin, buffer, destination)
- Can implement a queue using 2 stacks (reversal is needed, at minimum on pop or peek)
- Sorting stacks? Can be done but tricky, needs load/unload to separate stack
- Animal shelter problem with 2 queues (OO skills)

**Trees & Graphs**
- Assumptions (binary vs binary search tree, balanced vs unbalanced, full & complete)
- Tries ??
- DFS, BFS
Questions
- Check if binary tree is balanced: scans whole tree passing min and max depth as inout parameters
- Shortest path between two nodes in graph? Use BFS, keeping track of nodes already visited.
- Create binary search tree of minimal height out of sorted array: binary search with method to create a subtree out of [left, right] subarray
- Create linked lists of levels of a tree: In order trasversal, level passed around and used to add to correct list, can also be implemented with BFS
- Check if binary tree is binary search tree: scan subtrees by passing correct min/max boundaries
- Find next in-order successor in BST: find in descendants, find in ancestors being careful of returning the first one that is on the right of the given node
- Find common ancestors of two nodes in binary tree (messy, won’t ask)
- Find subtree in tree. Needs identical method to be called on each node of tree. Interesting complexity

**Bit Manipulation** 
- getBit, setBit, clearBit, updateBit (can be done in ranges)
- Insert M into N at position j...i: use masking, shifting, or with result
- Given a double between 0 and 1, print the binary representation. Loop with mulitplication by 2 and adding n >= 1 ? “1” : “0” to output string, stops when n == 0
- Given a positive integer, print the next smallest and next largest number that have the same number of 1 bits in their binary representation (won’t ask in interview)
- ((n & n-1) == 0) checks if power of 2
- Number of bits to flip to convert A into B: for (c = a ^ b; c != 0; c = c & (c-1)) count++ (uses xor property, and count how many times we need to flip the least significant bit)
- Swap odd and even bits of an integer with as few ops as possible -> 
((x & 0x55555555) >> 1) | ((x & 0xAAAAAAAA) << 1)
- Implement drawHorizontalLine on a matrix of bits(M, w, x1, x2, y) -> careful choice of offsets and boundary conditions

**Mathematics and probability** 
- Primes, divisibility, etc.
- P(A and B) = P(B given A)P(A)
- P(A or B) = P(A) + P(B) - P(A and B)
- Independence: P(A and B) = P(A)P(B)
- Mutually exclusive = P(A or B) = P(A) + P(B)
- Binomial (n choose r) = n! / (n! (n - r)!)
- Permutations of N elements = N!
- For which values of p there is higher probability of making (1 hoop in 1 shot) or (at least 2 hoops on 3 shots). 
P(3 shots) = p^3, P(2 shots) = 3(1-p)p^2 
P(2 or 3 shots) = 3p^2 - 2p^3
solve p > 3p^2 - 2p^3 -> p < 0.5
- Probability of collision with ants walking on polygon
- Implement subtract, multiply, divide using only add.
Subtract: add -1 x times
Multiply: choose the bigger as the base and add it N times
divide: Check how many times b fits in A.
Given a two dimensional graph with points on it, find a line which passes the most number of points
-> Calculate lines across all pairs of points, store them in a hash map by slope

**Recursion and Dynamic programming** 
- Good for recursion: “compute the nth…”, “list the first n…”, “method to compute all…”
- Bottom up recursion: solves f(n) given f(n-1)
- Top down recursion: complex
- Dynamic programming = recursion + caching
- Child running up n stairs can do 1, 2, 3 hops, how many ways can do the stairs? Top down approach with cache
- Robot on grid problem. How many paths to bottom right? binomial (X Y)
- Find magic index (i = A[i]) in array -> Binary search + range scan for duplicates
- Write a method to return all subsets of a set -> Recursion or combinatorics. Each step of the recursion doubles the solution by adding the new element to each of the subsets
Remember: combinations are unordered (set = 2^N), permutations are (N!)
- Write all permutations of a string of N characters: Base case and build by inserting new character in all possible positions
- Algorithm to print all valid combinations of n-pairs of parentheses -> Recursive approach is inefficient in dealing with duplicates. using the rules yields better result. bottom up
- paintfill with cached results to avoid doing unnecessary work
- Calculate number of ways of representing n cents using 25,10,5,1 coins. It’s a top down approach, need to get the recursion properties right -> won’t ask during interview
- Find all ways of arranging 8 queens in 8x8 chess board. Also top down with tricky recursion

**Sorting and Searching**
- Bucket sort, Bubble Sort, Selection Sort, Insertion Sort, Merge Sort, Quick Sort, Binary search
- Sort an array of strings so that they are grouped in anagrams -> Hash table with sorted character representation, or array sort with custom comparator
- Find element in rotated sorted array -> hacky binary search
- Find string in sorted array with empty strings -> hacky binary search
-> MxN matrix with sorted rows, columns, find an element. 2 dimensional binary search
-> Longest increasing subsequence on 2 dimensions. Sort either dimension and calculate longest increasing subsequence on other.
- Stream of values, way of calculating rank. O(N) would be sorted array where rank is index. BST would be more efficient O(log N)
