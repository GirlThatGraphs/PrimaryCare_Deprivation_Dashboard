
library(rvest)
library(dplyr)
library(xml2)


  
  
  #Specifying the url for desired website to be scraped
  url <- paste("https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice")

#Reading the HTML code from the website
webpage <- read_html(url)

#Using CSS selectors to scrape the rankings section
web_data_html <- html_nodes(webpage,'.cta__button')

#Converting the ranking data to text
web_data <- html_text(web_data_html)%>% 
  gsub("Patients Registered at a GP Practice, ", "", .) %>% 
  gsub("Patients Registered at a GP Practice - ", "", .)
  
  web_data_short <-  data.frame(web_data) %>% 
  filter(grepl('April|July|October|January', web_data),
         !grepl('\n', web_data)) %>% 
    head(1) %>% 
    pull() %>% 
    gsub(" ", "-", .) %>% 
    tolower()


  
#Specifying the url for desired website to be scraped
url2 <- paste(url,web_data_short, sep = "/")

#Reading the HTML code from the website
webpage2 <- read_html(url2)

#Using CSS selectors to scrape the rankings section
web_data_html2 <- html_nodes(webpage2,'.nhsd-a-box-link')[8] 

web_data2 <- xml_attrs(web_data_html2[[1]]) %>% 
  data.frame() %>% 
  head(1) %>% 
  pull()


temp <- tempfile()
download.file(web_data2,temp)
data1 <- unz(temp, "gp-reg-pat-prac-lsoa-all.csv")
data <- read.table(data1,
                   sep=",",
                   header = TRUE)
unlink(temp)







