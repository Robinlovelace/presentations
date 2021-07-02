slides_html <- "2021-01-21-open-source-transport-tools.html"

# "print" HTML to PDF
pagedown::chrome_print("2021-01-21-open-source-transport-tools.html", output = "2021-01-21-open-source-transport-tools.pdf")

# how many pages?
pages <- pdftools::pdf_info("2021-01-21-open-source-transport-tools.pdf")$pages

# set filenames
filenames <- sprintf("slides/slides_%02d.png", 1:pages)

# create slides/ and convert PDF to PNG files
dir.create("slides")
pdftools::pdf_convert("2021-01-21-open-source-transport-tools.pdf", filenames = filenames)

# Template for markdown containing slide images
slide_images <- glue::glue("
---

![]({filenames}){{width=100%, height=100%}}
  
")
slide_images <- paste(slide_images, collapse = "\n")

# R Markdown -> powerpoint presentation source
md <- glue::glue("
---
output: powerpoint_presentation
---

{slide_images}
")

cat(md, file = "slides_powerpoint.Rmd")

# Render Rmd to powerpoint
rmarkdown::render("slides_powerpoint.Rmd")  ## powerpoint!
browseURL("slides_powerpoint.pptx")
