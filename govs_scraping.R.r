library(tidyverse)
library(rvest)
library(lubridate)
library(ggalt)

url <- "https://en.wikipedia.org/wiki/List_of_Governors_of_California_by_age"

govs <- url %>%
    read_html() %>%
    html_nodes("table") %>%
    html_table(header = NA) %>%
    as.data.frame()

govs$Age.at.inauguration <- NULL
govs$Age.at.endof.term <- NULL
govs$Length.ofretirement <- NULL
govs$Lifespan <- NULL

colnames(govs)[1] <- c("rank_by_age")
colnames(govs)[3] <- c("num_in_office")

govs <- head(govs,40)

govs$Date.of.birth <- gsub("\\[.*","",govs$Date.of.birth)

govs$num_in_office <- as.numeric(govs$num_in_office)

govs$Date.of.birth <- mdy(govs$Date.of.birth)
govs$Date.of.inauguration <- mdy(govs$Date.of.inauguration)
govs$End.ofterm <- mdy(govs$End.ofterm)
govs$Date.of.death <- mdy(govs$Date.of.death)

govs$Date.of.death <- case_when(is.na(govs$Date.of.death) == TRUE ~ Sys.Date(), TRUE ~ govs$Date.of.death)



govs %>%
  ggplot(aes(y = reorder(Governor, num_in_office), x = Date.of.birth, xend = Date.of.death, color = num_in_office)) +
  geom_dumbbell( size_x = 2, size_xend = 2, size = 1.35) +
    labs(title = "The overlapping lives of California governors",
         x = "Year",
         y = "") +
    theme_classic(base_family = "Helvetica") + theme(legend.position = "none") + theme(plot.title = element_text(hjust = 0.5))

