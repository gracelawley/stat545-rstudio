# STAT545-UBC-2016 Topics List

library(readr)
library(dplyr)
library(commonmark)
library(xml2)

#topics_url <- "https://raw.githubusercontent.com/STAT545-UBC/STAT545-UBC.github.io/master/topics.md"
topics_url <- "https://raw.githubusercontent.com/gracelawley/STAT545-UBC-2016/master/topics.md"

topics_xml <- read_lines(topics_url) %>% 
  markdown_xml() %>% 
  read_xml()

ubc_title <- topics_xml %>% 
  xml_find_all(xpath = ".//d1:link") %>% 
  xml_text()

ubc_ref <- topics_xml %>% 
  xml_find_all(xpath = ".//d1:link") %>% 
  xml_attr("destination")


stat545_ubc_topics <- tibble(
  ubc_title,
  ubc_ref
)


write_csv(stat545_ubc_topics, "time-travel/ubc-2016_ref-links.csv")

