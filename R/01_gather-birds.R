library(tidyverse)
library(rvest)
library(httr)
library(curl)
library(pbapply)

pboptions(nout = 1000)

url <- "https://en.wikipedia.org/wiki/List_of_birds_of_Great_Britain"

all_birds <- read_html(url) %>%
  html_nodes('table.wikitable') %>%
  html_table() %>%
  bind_rows() %>%
  set_names(c("name","image", "status")) %>%
  mutate(latin_name = tolower(str_extract(str_extract(name, "(?:[(])[A-Za-z ]+"), "[A-Za-z ]+")),
         normal_name = str_extract(name, "^[A-Za-z ]+")) %>%
  mutate(xeno_canto_url = paste0("https://www.xeno-canto.org/api/2/recordings?query=", gsub(" ","+", latin_name)))


scrape_details <- function(url) {
  
  req <- httr::GET(url)
  
  cont <- content(req)
  
  bird_df <- tibble(
    type = cont$recordings %>% map_chr("type"),
    url = cont$recordings %>% map_chr(list("sono", "small")),
    file = cont$recordings %>% map_chr("file"),
    filename = cont$recordings %>% map_chr("file-name"),
    quality = cont$recordings %>% map_chr("q"),
    name = cont$recordings %>% map_chr("en"),
    bird_seen = cont$recordings %>% map_chr("bird-seen")
  )
  
  return(bird_df)
}


all_bird_details <- pblapply(all_birds$xeno_canto_url, scrape_details) %>% 
  bind_rows()


