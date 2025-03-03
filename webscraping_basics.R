# We first need to install and import the necessary packages:

install.packages("rvest")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("tm")
install.packages("writexl")

library(rvest)
library(tidyverse)
library(dplyr)
library(tm)
library(writexl)

# In order to start parsing through a web page, we first need to request that data from 
# the computer server that contains it with the read_html() function:

html_data <- read_html("https://www.portfolio.hu/kereses?q=infl%C3%A1ci%C3%B3&a=&df=2024-12-01&dt=2024-12-31&c=gazdasag&page=1")

# The read_html() function returns a list object that contains the tree-like structure:

html_data

# In order to capture the title, we need to use the html_element() and html_text() 
# functions to retrieve the text we want:

html_data  %>% 
html_element(".col-md-8 h3 a")  %>% 
html_text()

# It's working, but we only see the first title from the webpage. If we want to scrape 
# all the titles, we need to use the html_elements() function:

titles <- html_data  %>% 
  html_elements(".col-md-8 h3 a")  %>% 
  html_text()

titles

# Now capture the authors:

authors <- html_data  %>% 
  html_elements(".col-md-8 .author")  %>% 
  html_text()

authors

# And the first paragraph of the article:

text <- html_data  %>% 
  html_elements(".col-md-8 p")  %>% 
  html_text2()

text

# Let's make a data frame from these informations:

portfolio_inflation_data <- data_frame(titles, authors, text)

# Usually the first page of the informations isn't enough, we want to use all the results of the search.
# To this, we need to create a list, which contains all the links of the result pages we want to scrape

portfolio_link_list <- list()

for (page_result in seq(from = 1, to = 7, by = 1)) 
{ link = paste0("https://www.portfolio.hu/kereses?q=infl%C3%A1ci%C3%B3&a=&df=2024-12-01&dt=2024-12-31&c=gazdasag&page=", 
                   page_result)
  print(link)
  portfolio_link_list <- append(portfolio_link_list, link)
 
}

# Now that we have a list of links, we can iterate through them to get all the articles, but first
# we need to create a data frame with empty values:

portfolio_inflation_database <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(portfolio_inflation_database) <- c('titles', 'authors', 'text')

for (link in portfolio_link_list) {
  
  print(link)
  
  html_data <- read_html(link)
  
  titles <- html_data  %>% 
    html_elements(".col-md-8 h3 a")  %>% 
    html_text()
  
  authors <- html_data  %>% 
    html_elements(".col-md-8 .author")  %>% 
    html_text()
  
  text <- html_data  %>% 
    html_elements(".col-md-8 p")  %>% 
    html_text2()
  
  portfolio_inflation_data <- tibble(titles, authors, text)
  
  portfolio_inflation_database <- rbind(portfolio_inflation_database, portfolio_inflation_data)}

# If we want to analyze the articles text about inflation, we need the full text 
# and not only the first paragraph
# To get this, we need to collect all the links from the titles:

telex_html_data <- read_html("https://telex.hu/archivum?term=&filters={%22and_tags%22:[%22infl%C3%A1ci%C3%B3%22],%22superTags%22:[],%22authors%22:[],%22title%22:[]}&oldal=1")

article_links <- telex_html_data  %>% 
  html_elements(".list__item__title")  %>% 
  html_attr("href")

article_links

# Let's do this with the first 100 pages:

telex_link_list <- list()

for (page_result in seq(from = 1, to = 8, by = 1)) 
{ link = paste0("https://telex.hu/archivum?term=&filters={%22and_tags%22:[%22infl%C3%A1ci%C3%B3%22],%22superTags%22:[],%22authors%22:[],%22title%22:[]}&oldal=", 
                page_result)
print(link)
telex_link_list <- append(telex_link_list, link)

}

telex_article_link <- list()

for (link in telex_link_list) {
  
  print(link)
  
  telex_html_data <- read_html(link)
  
  article_links <- telex_html_data  %>% 
    html_elements(".list__item__title")  %>% 
    html_attr("href")
  
  telex_article_link <- append(telex_article_link, article_links)
  
}

# We can see, that the "https://telex.hu" part is missing from the links

telex_article_links <- paste0("https://telex.hu", telex_article_link)
telex_article_link <- as.list(telex_article_links)

# Now iterate through the article links to get the first 80 articles titles, authors and full texts
# If you get an error related to the connection ("Error in open.connection(x, "rb"): cannot open 
# the connection") you can handle it by using Sys.sleep()

telex_inflation_database <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(telex_inflation_database) <- c('titles', 'authors', 'text')

for (link in telex_article_link) {
  
  print(link)
  
  Sys.sleep(5)
  
  html_data <- read_html(link)
  
  try(titles <- html_data  %>% 
    html_elements("h1")  %>% 
    html_text())
  
  try(authors <- html_data  %>% 
    html_elements(".author__name")  %>% 
    html_text())
  
  try(all_authors <- paste(authors, collapse = " , "))
  
  try(text <- html_data  %>% 
    html_elements(".article-html-content p")  %>% 
    html_text2())
  
  try(full_text <- paste(text, collapse = " "))
  
  try(telex_inflation_data <- tibble(titles, all_authors, full_text))
  
  try(telex_inflation_database <- rbind(telex_inflation_database, telex_inflation_data))}


# Let's try to find out the 10 most common words (except inflation):

# We need the hungarian stop words

stop_words <- stopwords("hu") 
stop_words

# Data cleaning

frequent_words_df <- telex_inflation_database %>%
  mutate(
    text = tolower(full_text)) %>%
  pull(text) %>%  
  paste(collapse = " ") %>%  
  strsplit(split = "\\s+") %>%  
  unlist() %>%
  tibble(words = .) %>%
  filter(!(words %in% stop_words)) %>%  
  filter(!grepl("infláció", words, ignore.case = TRUE)) %>% 
  filter(!grepl("is", words, ignore.case = TRUE)) %>% 
  filter(!grepl("–", words, ignore.case = TRUE)) %>% 
  filter(!grepl("ha", words, ignore.case = TRUE)) %>% 
  count(words, sort = TRUE) %>% 
  head(10)  

print(frequent_words_df)

#--------------------------------------------------------------------------------------------

# Feladat 1: Scrapeld le a LinkedIn magyarországi álláshirdetései közül a budapesti
# data scientist állásokat!
# Hány darab kezdő szintű (Entry level) állás van az adatbázis szerint?

# Először az oldalon található álláshirdetések id-ját kell kigyűjteni:

html_data <- read_html("https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobPostings/search?keywords=Data%20Scientist&geoId=106079947&currentJobId=4004376361&start=0")

link <- linkedin_html_data %>% 
  html_elements(".job-search-card") %>% 
  html_attr("data-entity-urn")

link

# Most pedig az összes oldalról szedjük ki az id-kat:

linkedin_link_list <- list()

for (page_result in seq(from = 0, to = 130, by = 10)) 
{ link = paste0("https://www.linkedin.com/jobs-guest/jobs/api/seeMoreJobPostings/search?keywords=Data%20Scientist&geoId=106079947&currentJobId=4004376361&start=", 
                page_result )
print(link)
linkedin_link_list <- append(linkedin_link_list, link)

}

linkedin_jobs_link <- list()

for (link in linkedin_link_list) {
  
  print(link)
  
  linkedin_html_data <- read_html(link)
  
  job_links <- linkedin_html_data  %>% 
    html_elements(".job-search-card")  %>% 
    html_attr("data-entity-urn")
  
  linkedin_jobs_link <- append(linkedin_jobs_link, job_links)
  
}

# Látjuk, hogy nem csak a számot szedtük le, hanem van előtte szöveg.
# Szedjük ki az id-kat:

job_ids <- sub("urn:li:jobPosting:([0-9]+).*", "\\1", linkedin_jobs_link)
print(job_ids)

# A részletes álláshirdetéseket a következő linken keresztül tudjuk elérni:
# "https://www.linkedin.com/jobs-guest/jobs/api/jobPosting/{}"

# Nézzünk meg egy álláshirdetést részletesebben:

job_html_data <- read_html("https://www.linkedin.com/jobs-guest/jobs/api/jobPosting/4149707538")

title <- job_html_data %>% 
  html_element(".topcard__title") %>% 
  html_text()

title

company <- job_html_data %>% 
  html_element(".topcard__flavor--black-link") %>% 
  html_text2()

company

level <- job_html_data %>% 
  html_element(".description__job-criteria-text--criteria") %>% 
  html_text2()

level

description <- job_html_data %>% 
  html_element(".relative.overflow-hidden") %>% 
  html_text2()

description

# Hozzunk létre az id-khoz tartozó linkeket:

linkedin_id_job_list <- list()

for (id in job_ids) 
{ link = paste0("https://www.linkedin.com/jobs-guest/jobs/api/jobPosting/", 
                id )
print(link)

linkedin_id_job_list <- append(linkedin_id_job_list, link)

}

# Most pedig szedjük ki az infókat az összes állás linkjéből:

linkedin_database <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(linkedin_database) <- c('title', 'company', 'level', 'description')

for (link in linkedin_id_job_list) {
  
  Sys.sleep(5)
  
  print(link)
  
  html_data <- read_html(link)
  
  title <- html_data %>% 
    html_element(".topcard__title") %>% 
    html_text()
  
  company <- html_data %>% 
    html_element(".topcard__flavor--black-link") %>% 
    html_text2()
  
  level <- html_data %>% 
    html_element(".description__job-criteria-text--criteria") %>% 
    html_text2()
  
  description <- html_data %>% 
    html_element(".relative.overflow-hidden") %>% 
    html_text2()
  
  jobs_data <- tibble(title, company, level, description)
  
  linkedin_database <- rbind(linkedin_database, jobs_data)}

# Hány darab kezdő szintű (Entry level) állás van az adatbázis szerint?

entry_level_count = sum(str_count(linkedin_database$level, "Entry level"))
entry_level_count

#--------------------------------------------------------------------------------------------

# Feladat 2: Scrapeld le az "Értékesítés, kereskedelem" álláshirdetéseket Győr-Moson-Sopron 
# megyéből a  https://profession.hu oldalról
# Mennyi álláshirdetésnél van home office lehetőség?

# Először nézzünk meg egy álláshirdetést:

profession_html_data <- read_html("https://www.profession.hu/allas/ugyvezetoi-asszisztens-bardusch-bertextilia-kft-mosonmagyarovar-2590841?sessionId=b0733643adb4197010739dec32e41a02")

company <- profession_html_data %>% 
  html_element("") %>% 
  html_text2()

company

adress <- profession_html_data %>% 
  html_element("") %>% 
  html_text2()

adress

title <- html_data %>% 
  html_element("") %>% 
  html_text()

title

salary_bonus <- profession_html_data %>% 
  html_element("") %>% 
  html_text2()

salary_bonus

classification <- profession_html_data %>% 
  html_element("") %>% 
  html_text2()

classification

equipment <- profession_html_data %>% 
  html_element("") %>% 
  html_text2()

equipment

criteria <- profession_html_data %>% 
  html_element("") %>% 
  html_text2()

criteria

task <- profession_html_data %>% 
  html_elements("") %>% 
  html_text2()

task

requirements <- profession_html_data %>% 
  html_elements("") %>% 
  html_text2()

requirements

advantage <- profession_html_data %>% 
  html_elements("") %>% 
  html_text2()

advantage

offer <- profession_html_data %>% 
  html_elements("") %>% 
  html_text2()

offer

# Gyűjtsük ki az állásokhoz tartozó linkeket az első oldalról:

profession_html_data <- read_html("https://www.profession.hu/allasok/ertekesites-kereskedelem/gyor-moson-sopron/1,7,31")

link <- profession_html_data %>% 
  html_elements("") %>% 
  html_attr("href")

link

# Ezután pedig az összes oldalról:

profession_link_list <- list()

for (page_result in seq(from = , to = , by = )) 
{ link = paste0("https://www.profession.hu/allasok/ertekesites-kereskedelem/gyor-moson-sopron/", 
                page_result, ",7,31" )
print(link)
profession_link_list <- append(profession_link_list, link)

}

profession_jobs_link <- list()

for (link in profession_link_list) {
  
  print(link)
  
  profession_html_data <- read_html(link)
  
  job_links <- profession_html_data  %>% 
    html_elements("")  %>% 
    html_attr("href")
  
  profession_jobs_link <- append(profession_jobs_link, job_links)
  
}

# Az utolsó lépés végig iterálni az összes hirdetés linkjén:

profession_database <- data.frame(matrix(ncol = 11, nrow = 0))
colnames(profession_database) <- c('company', 'adress', 'title', 'salary_bonus', 'classification', 'equipment', 'criteria', 'task', 'requirements', 'advantage', 'offer')

for (link in profession_jobs_link) {
  
  print(link)
  
  html_data <- read_html(link)
  
  company <- html_data %>% 
    html_element("") %>% 
    html_text2()
  
  adress <- html_data %>% 
    html_element("") %>% 
    html_text2()
  
  title <- html_data %>% 
    html_element("") %>% 
    html_text()
  
  salary_bonus <- html_data %>% 
    html_element("") %>% 
    html_text2()
  
  classification <- html_data %>% 
    html_element("") %>% 
    html_text2()
  
  equipment <- html_data %>% 
    html_element("") %>% 
    html_text2()
  
  criteria <- html_data %>% 
    html_element("") %>% 
    html_text2()
  
  task <- html_data %>% 
    html_elements("") %>% 
    html_text2()
  
  all_task <- paste(task, collapse = ", ")
  
  requirements <- html_data %>% 
    html_elements("") %>% 
    html_text2()
  
  all_requirements <- paste(requirements, collapse = ", ")
  
  advantage <- html_data %>% 
    html_elements("") %>% 
    html_text2()
  
  all_advantage <- paste(advantage, collapse = ", ")
  
  offer <- html_data %>% 
    html_elements("") %>% 
    html_text2()
  
  all_offer <- paste(offer, collapse = ", ")
  
  job_advertisements_data <- tibble(company, adress, title, salary_bonus, classification, equipment,
                                    criteria, all_task, all_requirements, all_advantage, all_offer)
  
  profession_database <- rbind(profession_database, job_advertisements_data)}

# Hány állásnál kritérium a német nyelv ismerete (bármilyen szinten)?

language_count = sum(str_count(profession_database$criteria, "Német"))
language_count

#--------------------------------------------------------------------------------------------

# Feladat 3: Scrapeld le az Economania blog bejegyzéseit 2021 és 2025 között: https://economaniablog.hu/
# Melyik blogger használta a legtöbbször az "egyenlőtlenség kifejezést (és hányszor)?

# Ehhez a következő információkra lesz szükség a honlapról:

# a blog posztok dátuma
# szerzője
# a posztok szövege

# Először nézzünk meg egy blog posztot:

economania_html_data <- read_html("https://economaniablog.hu/2025/02/25/egy-zoldrefestesi-botrany-egeszsegugyi-hatasai-karosanyag-kibocsatas-a-klimavaltozason-tul/")

# Ezután szedjük le a bejegyzésekhez tartozó linkeket
# Kezdjük az első 10-el:

economania_html_data_links <- read_html("https://economaniablog.hu/")

# Ha legörgetünk az oldal aljára találkozunk egy "Older posts" gombbal
# Nézzük meg, hogy a rákattintás után hogyan változik az oldal: https://economaniablog.hu/page/2/
# Az oldalszámok változtatásával végig tudunk iterálni az összes oldalon.
# Mivel csak 2021-től kellenek a posztok, elég csak a 23. oldalig menni:



# Ezután minden blog bejegyzéshez a linket le tudjuk szedni:



# Végül pedig iteráljunk a linkeken, hogy megkapjuk mind a 230 bejegyzés infóit:

economania_database <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(economania_database) <- c('date', 'author', 'text')

# A kérdés megválaszolásához adatmanipulációra van szükség:

install.packages("stringi")
library(stringi)

economania_data <- economania_database  %>% 
  mutate(
    clean_text = tolower(all_text))

result <- economania_data %>%
  mutate(words_count = str_count(clean_text, "egyenlőtlenség")) %>%
  group_by(author) %>%
  summarise(word_count = sum(words_count))
  
result <- result %>% 
  filter(word_count > 0)

result

#--------------------------------------------------------------------------------------------

# Feladat 4: A Budesbank jegybanki beszédeit scrapeld le (elég az első 50 találatot)! 
# Ehhez használd a https://www.bundesbank.de/action/en/730564/bbksearch?query=*&hitsPerPageString=50&sort=bbksortdate+desc linket

# Először nézzünk meg egy beszédet - szükségünk lesz a dátumra, a szerzőre és a szövegre:

bundesbank_speeches_html_data <- read_html("https://www.bundesbank.de/en/press/speeches/introductory-statement-951882")

# Most pedig gyűjtsük ki az egyes beszédekhez tartozó linkeket:

bundesbank_speeches_html_data <- read_html("https://www.bundesbank.de/action/en/730564/bbksearch?query=*&hitsPerPageString=50&sort=bbksortdate+desc")

links <- bundesbank_speeches_html_data %>% 
  html_elements(".resultlist .teasable__link") %>% 
  html_attr("href")

links

# Az látszik, hogy nem minden beszéd van angolul.
# Filterezzük az angol nyelvű  beszédeket:

filtered_speeches <- links[grepl("/en/", links)]

filtered_speeches_list <- as.list(filtered_speeches)

# Ezután rakjuk elé a linkek első felét ("https://www.bundesbank.de"):

bundesbank_speeches_list <- paste0("https://www.bundesbank.de", filtered_speeches_list)
bundesbank_speeches_list <- as.list(bundesbank_speeches_list)

# Iteráljunk végig a beszédeken:



# Készítsünk egy szófelhőt a leggyakrabban előforduló szavakból:

install.packages("wordcloud")
install.packages("RColorBrewer")
library(wordcloud)
library(RColorBrewer)

# Szövegek egyesítése egyetlen karakterláncba

text_data <- paste(bundesbank_database$all_text, collapse = " ")

# Szöveg átalakítása korpusz formátumba

corpus <- Corpus(VectorSource(text_data))

# Szöveg előfeldolgozása (kisbetűsítés, írásjelek és stopwords eltávolítása)

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("en"))  # Angol stopwords használata

# Szavak előfordulásának számolása

dtm <- TermDocumentMatrix(corpus)
matrix <- as.matrix(dtm)
word_freqs <- sort(rowSums(matrix), decreasing = TRUE)
df <- data.frame(word = names(word_freqs), freq = word_freqs)

# Szófelhő generálása

set.seed(1234)  # Reprodukálhatóság érdekében

wordcloud(words = df$word, freq = df$freq, min.freq = 3,
          max.words = 70, random.order = FALSE, rot.per = 0.15, 
          scale = c(2.5, 0.5), 
          colors = brewer.pal(8, "Paired"))

