# Network Analysis and Web Mining

The projects in this repository were created while working on the course Network Analysis and Web Mining for my postgraduate studies. They include the following:

1. **Network Metrics & Network Generation**: based on the two networks included in the files, generate networks using random graph model (Erdős-Renyi), Watts-Strogatz model, Barabasi-Albert model (both undirected and directed graph) and then calculate different metrics such as number of nodes, number of edges, average clustering coefficient, global clustering coefficient and more.
2. **Community Detection**: use of two community detection methods which are Greedy Modularity Maximization (Clauset-Newman-Moore) and Divisive Hierarchical Clustering (Girvan-Newman).
3. **Neo4j and Cypher**: using data from a hypothetical lending library, create a relational graph database Neo4j and then create some search queries in Cypher graph query language.
4. **Node Embeddings**: generate node embeddings using χρησιμοποιώντας Node2Vec with q=2 and p=1, Node2Vec with q=0.5 and p=1, Node2Vec with q=1 and p=1. To evaluate the performance of embeddings we will use them in the following problems:

    - Link Prediction. Measure accuracy/precision/recall.
    - Clustering: apply K-Means to the embeddings. Assume K=3 and calculate modularity and purity. Use the t-SNE method to visualize vector representations of nodes in two dimensions. Use the visualization to compare the clustering results with the actual class of nodes.
