library(fs)

a_class_seen_birds <- all_bird_details %>%
  mutate(mp3_url = paste0("https:", file)) %>%
  mutate(location = paste0("mp3/", filename)) %>%
  filter(quality == "A") %>%
  filter(bird_seen == "yes")

walk2(a_class_seen_birds$mp3_url, a_class_seen_birds$location, curl_exists)


curl_exists <- function(url, location) {
  print(location)
  if(file_exists(location)){print("file exists")
    return()}
  
  try(curl_download(url, location, quiet = FALSE))
  
}
