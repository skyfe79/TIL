package kr.pe.burt;

import java.util.Iterator;
import java.util.LinkedList;


// @see http://www.geeksforgeeks.org/breadth-first-traversal-for-a-graph/
public class Main {

    public static void main(String[] args) {

        Graph g = new Graph(4);
        g.addEdge(0, 1);
        g.addEdge(0, 2);
        g.addEdge(1, 2);
        g.addEdge(2, 0);
        g.addEdge(2, 3);
        g.addEdge(3, 3);

        g.BFS(2);
    }

    static class Graph {
        private int V;                          // No. of vertices
        private LinkedList<Integer> adj[];      // Adjacency Lists

        Graph(int v) {
            V = v;
            adj = new LinkedList[v];
            for (int i=0; i<v; ++i) {
                adj[i] = new LinkedList();
            }
        }

        // Function to add an edge into the graph
        void addEdge(int v, int w) {
            adj[v].add(w);
        }

        // prints BFS traversal from a given source s
        void BFS(int s) {
            boolean visited[] = new boolean[V];

            LinkedList<Integer> queue = new LinkedList();

            visited[s] = true;
            queue.add(s);

            while (queue.size() != 0) {
                // dequeue a vertex from queue and print it
                s = queue.poll();
                System.out.print(s+ " ");

                Iterator<Integer> i = adj[s].listIterator();
                while (i.hasNext()) {
                    int n = i.next();
                    if(!visited[n]) {
                        visited[n] = true;
                        queue.add(n);
                    }
                }
            }
        }
    }
}
