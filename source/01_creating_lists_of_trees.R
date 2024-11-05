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
date_tab_full <- read_tsv("input/Coli_samples_collection_date_2024.06.14.tsv")

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

list_files <- paste0("input/treeshrink_v1_pruned_unrooted/", 
                     STs,
                     "_treeshrink_v1.nwk")

tree_list_treeshrink_v1_unrooted <- list()
for(i in 1:length(list_files)) {
    tree_list_treeshrink_v1_unrooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_treeshrink_v1_unrooted) <- STs

#xxxxxxxxxxxxxxxxxxx
# IQR pruned, Tamas rooted ------------------------------------------------
#xxxxxxxxxxxxxxxxxxx

list_files <- paste0("input/iqr_pruned_rooted/", 
                     STs,
                     "_iqr_rooted.nwk")

tree_list_iqr_rooted <- list()
for(i in 1:length(list_files)) {
    tree_list_iqr_rooted[[i]] <- read.tree(list_files[i])
}
names(tree_list_iqr_rooted) <- STs

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
