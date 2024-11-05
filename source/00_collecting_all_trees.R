library(tidyverse)
library(ape)
#xxxxxxxxxxxxxxxxxxx
# AIM: Downloading trees from node8_R10 -----------------------------------
#xxxxxxxxxxxxxxxxxxx

# STs
STs <- readLines("input/STs.txt") %>% 
    # numeric sort
    str_remove("ST") %>% 
    as.numeric() %>% 
    sort() %>% 
    paste0("ST", .)

# Dates
date_tab_full <- read_tsv("/home/barizona/remote/project_ecoli_hgt_2022/nextflow_run_20240925/ST10/input/Coli_samples_collection_date_2024.06.14.tsv",
                          col_names = c("label", "Sample collection date"),
                          show_col_types = FALSE) %>% 
    # create a new column with decimal dates
    mutate(`Sample collection date decimal` = decimal_date(`Sample collection date`))

write_tsv(date_tab_full, "input/Coli_samples_collection_date_2024.06.14.tsv", na = "")

#xxxxxxxxxxxxxxxxxxx
# Unpruned, unrooted ------------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("input/unpruned_unrooted_Ecoli_trees/",
                     STs,
                     "_unpruned.nwk")

tree_list_unpruned_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_unpruned_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_unpruned_unrooted) <- STs


#xxxxxxxxxxxxxxxxxxx
# Treeshrink pruned, unrooted ---------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("/home/barizona/Eszter/Kutatas/Tree_pruning/treeshrink_testing/output_v1/",
                     STs,
                     "_unpruned_treeshrink/",
                     STs,
                     "_treeshrink.nwk")

tree_list_treeshrink_v1_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_treeshrink_v1_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_treeshrink_v1_unrooted) <- STs

# write out trees
for(i in 1:length(STs)) {
    write.tree(tree_list_treeshrink_v1_unrooted[[i]], 
               paste0("input/treeshrink_v1_pruned_unrooted/", STs[i], "_treeshrink_v1.nwk"))
}

#xxxxxxxxxxxxxxxxxxx
# IQR pruned, Tamas rooted ------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("/home/barizona/remote/project_ecoli_hgt_2022/nextflow_run_20240925/",
                     STs,
                     "/results/choose_rooted_tree/final_rooted_tree.tre")

tree_list_iqr_rooted <- list()
for(i in 1:length(list_files)) {
    tree_list_iqr_rooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_iqr_rooted) <- STs

# write out trees
for(i in 1:length(STs)) {
    write.tree(tree_list_iqr_rooted[[i]], 
               paste0("input/iqr_pruned_rooted/", STs[i], "_iqr_rooted.nwk"))
}

#xxxxxxxxxxxxxxxxxxx
# PSFA --------------------------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

# fewer STs
STs_fewer <- list.files("input/PSFA+CPA+PSFA_pruned_unrooted/") %>% 
    str_remove(".newick") %>% 
    str_remove("ST") %>% 
    as.numeric() %>% 
    sort() %>% 
    paste0("ST", .)

list_files <- paste0("input/PSFA_pruned_unrooted/",
                     STs_fewer,
                     ".newick")

tree_list_PSFA_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_PSFA_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_PSFA_unrooted) <- STs_fewer


#xxxxxxxxxxxxxxxxxxx
# CPA ---------------------------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("input/CPA_pruned_unrooted/",
                     STs,
                     ".newick")

tree_list_CPA_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_CPA_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_CPA_unrooted) <- STs



#xxxxxxxxxxxxxxxxxxx
# CPA+PSFA ----------------------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("input/CPA+PSFA_pruned_unrooted/",
                     STs_fewer,
                     ".newick")

tree_list_CPA_PSFA_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_CPA_PSFA_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_CPA_PSFA_unrooted) <- STs_fewer

#xxxxxxxxxxxxxxxxxxx
# PSFA+CPA+PSFA -----------------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("input/PSFA+CPA+PSFA_pruned_unrooted/",
                     STs_fewer,
                     ".newick")

tree_list_PSFA_CPA_PSFA_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_PSFA_CPA_PSFA_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_PSFA_CPA_PSFA_unrooted) <- STs_fewer



rm(i, list_files)
