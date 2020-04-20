library(fs)

a_class_seen_birds <- all_bird_details %>%
  mutate(mp3_url = paste0("https:", file)) %>%
  mutate(location = paste0("mp3/", filename)) %>%
  filter(quality == "A") %>%
  filter(bird_seen == "yes")

walk2(a_class_seen_birds$mp3_url, a_class_seen_birds$location, curl_exists)


curl_exists <- function(url, location) {
  #print(location)
  if(file_exists(location)){print("file exists")
    return()}
  
  try(curl_download(url, location, quiet = TRUE))
  
}

pbmapply(curl_exists, a_class_seen_birds$mp3_url, a_class_seen_birds$location)


# filter down to those birds with at least 1000 seconds of audio for training
thousand_secs <- a_class_seen_birds %>%
  group_by(name) %>%
  summarise(total_s = sum(length_s, na.rm = TRUE),
            n = n()) %>%
  ungroup() %>%
  filter(total_s >= 1000)

a_class_seen_thousand <- a_class_seen_birds %>%
  semi_join(thousand_secs) %>%
  mutate(dir_name = tolower(gsub(" ", "_", name)))

# find all duplicate mp3s and just remove them
dupe_mp3s <- a_class_seen_thousand %>%
  group_by(location) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  filter(n > 1)

final_birds <- a_class_seen_thousand %>%
  anti_join(dupe_mp3s)

