df <- data.table::fread("~/Desktop/CDUP/2012_cfs.txt", data.table = FALSE)

library(plyr)
library(dplyr)

edge_list <- df %>%
  # Create unique columns for location
  mutate(ORIG = paste(ORIG_STATE, ORIG_MA, ORIG_CFS_AREA, sep = "|"),
         DEST = paste(DEST_STATE, DEST_MA, DEST_CFS_AREA, sep = "|")) %>%
  # Group the data by shipping route
  group_by(ORIG, DEST) %>%
  # Calculate summaries of each shipping route
  summarize(n_shipments = n(), # number of shipments in dataset
            weight = sum(SHIPMT_WGHT), # average weight
            value = sum(SHIPMT_VALUE), # average value
            distance = sum(SHIPMT_DIST_ROUTED)) # average distance

library(igraph)
graph <- graph_from_data_frame(edge_list, directed = TRUE)
Aij <- as.matrix(get.adjacency(graph, type=c("both"), attr="value"))
Aij <- Aij + t(Aij)

DC <- as.matrix(get.adjacency(as.undirected(graph), type="both"))
DC <- rowSums(DC)

r_centrality <- Aij %*% DC
r_power <- Aij %*% (1/DC)
