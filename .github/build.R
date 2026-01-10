#!/usr/bin/env Rscript

# ---- Configuration ----
output_dir <- "dist"
tutorial_dir <- "tutorials"  # adjust if your .Rmd files live elsewhere

# ---- Setup ----
if (!dir.exists(output_dir)) {
	dir.create(output_dir, recursive = TRUE)
}

# Ensure required packages are installed
required_pkgs <- c("learnr", "rmarkdown", "fs")
missing_pkgs <- required_pkgs[!required_pkgs %in% rownames(installed.packages())]
if (length(missing_pkgs)) {
	install.packages(missing_pkgs, repos = "https://cloud.r-project.org")
}

library(learnr)
library(rmarkdown)
library(fs)

# ---- Find tutorials ----
tutorials <- dir_ls(
	path = tutorial_dir,
	glob = "*.Rmd"
)

if (length(tutorials) == 0) {
	stop("No learnr tutorials found.")
}

# ---- Render tutorials ----
for (tutorial in tutorials) {
	message("Rendering: ", tutorial)

	# render(
	# 	input = tutorial,
	# 	output_dir = output_dir,
	# 	clean = TRUE,
	# 	quiet = FALSE,
	# 	runtime = "shinyrmd"
	# )
	learnr::tutorial_static(tutorial, output_dir = output_dir)
}

# ---- Copy supporting assets (optional) ----
if (dir.exists("www")) {
	dir_copy("www", file.path(output_dir, "www"), overwrite = TRUE)
}

message("✔ Static site generated in ./dist")
