library(readr)
library(dplyr)
library(commonmark)
library(xml2)
library(rvest)
library(purrr)
library(stringr)
library(tidyr)

chapter_files <- list.files(path = ".", pattern = "[[:digit:]]{2}_.*\\.Rmd") %>% 
  discard(~ .x == "40_references.Rmd") 


# helper-functions --------------------------------------------------------
get_chapter_html <- function(rmd_path){
  chapter_html <- read_lines(rmd_path) %>% 
    markdown_html() %>% 
    read_html()
  return(chapter_html)
}

get_html_h1 <- function(chapter_html){
  html_h1 <- chapter_html %>% 
    html_nodes("h1") %>% 
    xml_text()
  return(html_h1)
}


get_ubc_refs <- function(chapter_html){
  ubc_ref <- chapter_html %>% 
    html_nodes(xpath = '//comment()[contains(., "Original content")]') %>% 
    xml_text() %>% 
    map(str_extract, "http.*$") %>% 
    flatten_chr()
  return(ubc_ref)
}



# Convert the chapter Rmd's to html format --------------------------------
chapter_html <- map(chapter_files, get_chapter_html)


# Pull out the ubc ref links ----------------------------------------------
ubc_refs <- chapter_html %>% 
  map(get_ubc_refs) %>% 
  flatten_chr()


# Get the chapter headers -------------------------------------------------

## add these chapters + refs in manually
## these are missed b/c they are level 2 headers, adding manually as a shortcut (change this later)
add_manually <- c("Draw the rest of the owl, a pep talk for building off simple examples {#draw-the-owl}",
                  "Make browsing your GitHub repos more rewarding {#github-browsability}")

chapter_headers <- chapter_html %>% 
  map(get_html_h1) %>% 
  flatten_chr() %>% 
  discard(!str_detect(., "#")) %>%   # only keep ones with manual ref label 
  append(add_manually)
  
# Assemble the master refs data frame -------------------------------------

## skip these chapters b/c they don't have an ubc ref, do so manually b/c quickest for now
skip_these <- c("Tidy data", "R graphics landscape", "Write your first R package", "More example pipelines", 
                "Short random things", "Deprecated")

refs_df <- tibble(chapter_headers) %>% 
  separate(chapter_headers, into = c("chapter", "bookdown_ref"), sep = " (?=\\{)") %>% 
  filter(!chapter %in% skip_these) %>% 
  filter(!str_detect(bookdown_ref, "shiny-overview")) %>% # also skip this chapter 
  mutate(ubc_ref = ubc_refs,
         bookdown_ref_clean = str_extract(bookdown_ref, "(?<=#).*(?=\\})"))


#write_csv(refs_df, "time-travel/reboot-ubc-ref-mappings.csv")

# Create entries to add to bookdown-ref-links.md ------------------------------

links_md <- refs_df %>% 
  select(bookdown_ref_clean, bookdown_ref) %>% 
  mutate(bookdown_ref_clean = str_c("[", bookdown_ref_clean, "]"),
         bookdown_ref = str_extract(bookdown_ref, "#.*(?=\\})")) %>% 
  transmute(entry = str_c(bookdown_ref_clean, bookdown_ref, sep = ": "))


#write_lines(links_md$entry, "time-travel/bookdown-ref-links.md")
