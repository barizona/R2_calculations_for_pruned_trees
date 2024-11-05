#xxxxxxxxxxxxxxxxxxxxxxxx
# Root-to-tip plot and R2 value -------------------------------------------
#xxxxxxxxxxxxxxxxxxxxxxxx

roottotip_v2 <- function(tree, date, rate = NA, permTest = 10000, showFig = T, 
          colored = T, showPredInt = "gamma", showText = T, showTree = T) 
{
    require("BactDating")
    require("ape")
    if (!is.rooted(tree)) 
        warning("Warning: roottotip was called on an unrooted input tree. Consider using initRoot first.\n")
    if (sum(tree$edge.length) < 5) 
        warning("Warning: input tree has small branch lengths. Make sure branch lengths are in number of substitutions (NOT per site).\n")
    if (!is.null(names(date))) 
        date = findDates(tree, date)
    if (var(date, na.rm = T) == 0 && is.na(rate)) {
        warning("Warning: All dates are identical.\n")
        return(list(rate = NA, ori = NA, pvalue = NA))
    }
    n = length(date)
    ys = leafDates(tree)
    if (is.na(rate)) {
        res = lm(ys ~ date)
    }
    else {
        res = lm(I(ys - rate * date) ~ 1)
        res$coefficients = c(res$coefficients, rate)
    }
    ori = -coef(res)[1]/coef(res)[2]
    rate = coef(res)[2]
    r2 = summary(res)$r.squared
    correl = cor(date, ys, use = "complete.obs")
    pvalue = 0
    for (i in 1:permTest) {
        date2 = sample(date, n, replace = F)
        correl2 = cor(date2, ys, use = "complete.obs")
        if (correl2 >= correl) 
            pvalue = pvalue + 1/permTest
    }
    if (rate < 0) {
        warning("The linear regression suggests a negative rate.")
    }
    if (showFig == F) 
        return(list(rate = rate, ori = ori, pvalue = pvalue))
    old.par = par(no.readonly = T)
    par(xpd = NA, oma = c(0, 0, 2, 0))
    if (colored) {
        normed = (date - min(date, na.rm = T))/(max(date, na.rm = T) - 
                                                    min(date, na.rm = T))
        cols = grDevices::rgb(ifelse(is.na(normed), 0, normed), 
                              ifelse(is.na(normed), 0.5, 0), 1 - ifelse(is.na(normed), 
                                                                        1, normed), 0.5)
    }
    else cols = "black"
    if (showTree) {
        par(mfrow = c(1, 2))
        plot(tree, show.tip.label = F)
        if (colored) 
            tiplabels(col = cols, pch = 19)
        axisPhylo(1, backward = F)
    }
    plot(date, ys, col = cols, xlab = ifelse(showText, "Sampling date", 
                                             ""), ylab = ifelse(showText, "Root-to-tip distance", 
                                                                ""), xaxs = "i", yaxs = "i", pch = 19, ylim = c(0, max(ys)), 
         xlim = c(ifelse(rate > 0, ori, min(date, na.rm = T)), 
                  max(date, na.rm = T)))
    par(xpd = F)
    abline(res, lwd = 2)
    if (rate < 0) {
        par(old.par)
        return(list(rate = rate, ori = ori, pvalue = pvalue))
    }
    xs = seq(ori, max(date, na.rm = T), 0.1)
    plim = 0.05
    if (showPredInt == "poisson") {
        # lines(xs, qpois(plim/2, (xs - ori) * rate), lty = "dashed")
        # lines(xs, qpois(1 - plim/2, (xs - ori) * rate), lty = "dashed")
    }
    if (showPredInt == "gamma") {
        # lines(xs, qgamma(plim/2, shape = (xs - ori) * rate, scale = 1), 
        #       lty = "dashed")
        # lines(xs, qgamma(1 - plim/2, shape = (xs - ori) * rate, 
        #                  scale = 1), lty = "dashed")
    }
    if (showText) {
        if (pvalue == 0) 
            mtext(sprintf("Rate=%.2e,MRCA=%.2f,R2=%.2f,p<%.2e", 
                          rate, ori, r2, 1/permTest), outer = TRUE, cex = 1.5)
        else mtext(sprintf("Rate=%.2e,MRCA=%.2f,R2=%.2f,p=%.2e", 
                           rate, ori, r2, pvalue), outer = TRUE, cex = 1.5)
    }
    par(old.par)
    return(c(r2 = r2, pvalue = pvalue, MRCA = unname(ori)))
}


#xxxxxxxxxxxxxxxxxxxxxxxx
# Run bactdate for all trees ----------------------------------------------
#xxxxxxxxxxxxxxxxxxxxxxxx

# Main function for parallel processing
run_bactdate_parallel <- function(tree_list = tree_list_CPA_PSFA_unrooted,
                                  date_tab = date_tab_full, 
                                  output_fig_dir = "output/CPA+PSFA_pruned_bactdate/",
                                  num_cores = 8) 
{
    require(tidyverse)
    require(BactDating)
    require(foreach)
    require(doParallel)
    require(ape)  # Load ape globally
    
    # Set up parallelization
    cl <- makeCluster(num_cores)
    registerDoParallel(cl)
    
    # Ensure required packages and custom function are loaded on each worker
    clusterEvalQ(cl, {
        library(tidyverse)
        library(BactDating)
        library(ape)  # Load ape for each worker
    })
    
    # Export custom function and any required variables to each worker
    clusterExport(cl, varlist = c("roottotip_v2"))
    
    # Run bactdate in parallel
    result_list <- foreach(i = names(tree_list), .combine = 'list') %dopar% {
        
        tree <- tree_list[[i]]
        
        date_vec <- date_tab %>% 
            filter(label %in% tree$tip.label) %>%
            arrange(match(label, tree$tip.label)) %>%
            pull(`Sample collection date decimal`)
        
        # Perform dating
        dated_tree <- bactdate(tree = tree,
                               date = date_vec,
                               updateRoot = TRUE,
                               model = "arc",
                               nbIts = 1000)
        
        tree <- dated_tree$inputtree  # updating tree
        
        # Root-to-tip plot
        png(paste0(output_fig_dir, i, "_rooted_R2T_plot.png"), 
            width = 10, height = 6, 
            units = "in", res = 300)
        
        # Call roottotip_v2 function
        r2 <- roottotip_v2(tree, date_vec)
        
        # add i to r2
        r2 <- c(label = i, r2)
        
        dev.off()
        
        r2  # Return r2 for each iteration
    }
    
    stopCluster(cl)
    
    # tibble from the list
    result_list %>% bind_rows() %>% 
        # convert all columns as numeric except label
        mutate(across(-label, as.numeric)) %>% 
        write_tsv(paste0(output_fig_dir, "r2_values.tsv"))
    
}



#xxxxxxxxxxxxxxxxxxxxx
# Plot a phylogenetic trees and colour the pruned tip branches -------
#xxxxxxxxxxxxxxxxxxxxx

plotting_tree_colouring_pruned <- function(tree_list_full = tree_list_unpruned_unrooted, 
                                           tree_list_pruned = tree_list_treeshrink_v1_unrooted,
                                           output_fig_dir = "output/treeshrink_v1_pruned_unrooted/") {
    require(tidyverse)
    require(ape) # drop.tip
    require(treeio) # as_tibble, as.treedata
    require(ggtree) # ggtree
    
    for(i in names(tree_list_pruned)) {
        tree_full <- tree_list_full[[i]] %>% 
            unroot()
        
        tree_pruned <- tree_list_pruned[[i]] %>% 
            unroot()
        
        # Find tips that are present in phy1 but pruned from phy2
        pruned_tips <- setdiff(tree_full$tip.label,
                               tree_pruned$tip.label) 
        
        # add node names to tree_full
        # delete node labels to regenerate them
        tree_full$node.label <- NULL
        # convert tree to tibble
        tree_tab <- tree_full %>% 
            as_tibble() %>% 
            # create Node names
            mutate(label = case_when(is.na(label) ~ paste0("N", node),
                                     .default = label))
        
        # convert tibble to phy
        tree_full <- tree_tab %>% 
            as.phylo()
        
        # indicate if pruned
        tree_full <- drop.tip(tree_full, pruned_tips) %>% 
            as_tibble() %>% 
            mutate(pruned = "No") %>%
            select(label, pruned) %>%
            left_join(tree_tab, .) %>% 
            mutate(pruned = ifelse(is.na(pruned), "Yes", pruned)) %>% 
            as.treedata()
        
        
        #xxxxxx
        # * Tree plot ----
        #xxxxxx
        p <- tree_full %>% 
            ggtree(aes(color = pruned), 
                   layout = "equal_angle",
                   size = 0.5) +
            scale_color_manual(values = c("Yes" = "firebrick1", "No" = "black")) +
            theme(legend.position = "bottom")
        
        # saving the tree plot to png and pdf
        ggsave(plot = p, filename = paste0(output_fig_dir, i, "_original_vs_pruned_tree.png"), 
               width = 8, height = 8)
    }
}























