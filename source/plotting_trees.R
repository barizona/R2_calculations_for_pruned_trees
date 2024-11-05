library(tidyverse)
source("source/functions.R")

#xxxxxxxxxxxxxxxxxxxxx
# AIM: Plot a phylogenetic trees and colour the pruned tip branches -------
#xxxxxxxxxxxxxxxxxxxxx

plotting_tree_colouring_pruned(tree_list_full = tree_list_unpruned_unrooted, 
                               tree_list_pruned = tree_list_treeshrink_v1_unrooted,
                               output_fig_dir = "output/treeshrink_v1_pruned/")

plotting_tree_colouring_pruned(tree_list_full = tree_list_unpruned_unrooted, 
                               tree_list_pruned = tree_list_iqr_rooted,
                               output_fig_dir = "output/iqr_pruned/")

plotting_tree_colouring_pruned(tree_list_full = tree_list_unpruned_unrooted, 
                               tree_list_pruned = tree_list_PSFA_unrooted,
                               output_fig_dir = "output/PSFA_pruned/")

plotting_tree_colouring_pruned(tree_list_full = tree_list_unpruned_unrooted, 
                               tree_list_pruned = tree_list_CPA_unrooted,
                               output_fig_dir = "output/CPA_pruned/")

plotting_tree_colouring_pruned(tree_list_full = tree_list_unpruned_unrooted, 
                               tree_list_pruned = tree_list_CPA_PSFA_unrooted,
                               output_fig_dir = "output/CPA+PSFA_pruned/")

plotting_tree_colouring_pruned(tree_list_full = tree_list_unpruned_unrooted, 
                               tree_list_pruned = tree_list_PSFA_CPA_PSFA_unrooted,
                               output_fig_dir = "output/PSFA+CPA+PSFA_pruned/")
