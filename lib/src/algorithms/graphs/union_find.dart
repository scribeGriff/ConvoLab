part of convolab;

/*
 *  Ported from Mark Allen Weiss' UnionFind.java
 *
 *  A disjoint sets ADT implemented with a Union-Find data structure.
 *  Performs union-by-rank and path compression.  Implemented using arrays.
 *
 *  Elements are represented by ints, numbered from zero.
 *
 *  Each disjoint set has one element designated as its root.
 *  Negative values indicate the element is the root of a set.  The absolute
 *  value of a negative value is the number of elements in the set.
 *  Positive values are an index to where the root was last known to be.
 *  If the set has been unioned with another, the last known root will point
 *  to a more recent root.
 *
 *  var a = new UnionFind(myGraph.length);
 *
 *  var u = a.find(myGraph[i][0]);
 *  var v = a.find(myGraph[i][1]);
 *  a.union(u, v);
 */

class UnionFind {

  List<int> array;

  /*
   * Construct a disjoint sets object.
   *
   * numElements is the initial number of elements--also the initial
   * number of disjoint sets, since every element is initially in its
   * own set.
   */

  UnionFind(int numElements) {
    array = new List<int>(numElements);
    for (var i = 0; i < array.length; i++) {
      array[i] = -1;
    }
  }

  /*
   * union() unites two disjoint sets into a single set.  A union-by-rank
   * heuristic is used to choose the new root.
   *
   * a is an element in the first set.
   * b is an element in the first set.
   */
  void union(int a, int b) {
    int root_a = find(a);
    int root_b = find(b);

    if (root_a == root_b) return;

    if (array[root_b] < array[root_a]) {
      // root_b has more elements, so leave it as the root.
      // first, indicate that the set represented by root_b has grown.
      array[root_b] += array[root_a];
      // Then, point the root of set a at set b.
      array[root_a] = root_b;
    } else {
      array[root_a] += array[root_b];
      array[root_b] = root_a;
    }
  }

  /*
   * find() finds the (int) name of the set containing a given element.
   * Performs path compression along the way.
   *
   * x is the element sought.
   * returns the set containing x.
   */
  int find(int x) {
    if (array[x] < 0) {
      return x;  // x is the root of the tree; return it
    } else {
      // Find out who the root is; compress path by making the root
      // x's parent.
      array[x] = find(array[x]);
      return array[x];  // Return the root
    }
  }
}
