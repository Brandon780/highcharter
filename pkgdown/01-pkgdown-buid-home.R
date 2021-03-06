# Important is:
# remotes::install_github("r-lib/pkgdown@v1.3.0", force = TRUE, upgrade = "never")
# remotes::install_github("r-lib/pkgdown", force = TRUE, upgrade = "never")
# The actual dev version of pkgdown don't detect index.Rmd as a homepage
# 
# pkgdown:::build_home_index
try(fs::file_delete("docs/extra.css"))
fs::file_copy("pkgdown/extra.css", new_path = "docs/extra.css")

pkgdown::build_home()

try(fs::file_delete("pkgdown/index.html"))

rmarkdown::render("pkgdown/index.Rmd")

title <- '<div id="brand" class="page-header"><img src="logo.png" width ="15%"/> h|1i|0g|3h|2c|1h|2a|1r|3t|2e|1r|2{rpackage}</div>'

index <- read_lines("docs/index.html")

indx1 <- which(str_detect(index, "<div class=\"contents col-md-9\">"))
indx1

indx2 <- which(str_detect(index, "id=\"installation\""))
indx2


index_new <- read_lines("pkgdown/index.html")

scripts <- str_subset(index_new, "index_files")
scripts <- str_subset(scripts, "bootstrap|jquery|tabsets|highlightjs", negate = TRUE)
scripts

index_new1 <- which(str_detect(index_new, "<p>Highcharter"))
index_new1

index_new2 <- which(str_detect(index_new, "<span></span>"))
index_new2

index_final <- c(
  index[1:indx1],
  scripts,
  title,
  index_new[index_new1:index_new2],
  index[indx2:length(index)]
)

writeLines(index_final, "docs/index.html")

try(fs::file_delete("docs/index_files/"))

fs::file_move("pkgdown/index_files/", "docs/")


pkgdown::preview_site()
