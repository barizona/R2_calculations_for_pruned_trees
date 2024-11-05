library(tidyverse)
source("source/functions.R")


#xxxxxxxxxxxxxxxxxxxxxxxxxx
# Bactdate rooting, R2 ----------------------------------------------------
#xxxxxxxxxxxxxxxxxxxxxxxxxx

run_bactdate_parallel(tree_list = tree_list_unpruned_unrooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/unpruned/")

run_bactdate_parallel(tree_list = tree_list_treeshrink_v1_unrooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/treeshrink_v1_pruned/")

run_bactdate_parallel(tree_list = tree_list_iqr_rooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/iqr_pruned/")

run_bactdate_parallel(tree_list = tree_list_PSFA_unrooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/PSFA_pruned/")

run_bactdate_parallel(tree_list = tree_list_CPA_unrooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/CPA_pruned/")

run_bactdate_parallel(tree_list = tree_list_CPA_PSFA_unrooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/CPA+PSFA_pruned/")

run_bactdate_parallel(tree_list = tree_list_PSFA_CPA_PSFA_unrooted,
                      date_tab = date_tab_full,
                      output_fig_dir = "output/PSFA+CPA+PSFA_pruned/")
