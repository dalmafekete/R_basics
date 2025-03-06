# Feladat 1: Scrapeld le az Economania blog bejegyzéseit 2021 és 2025 között: https://economaniablog.hu/
# Melyik blogger használta a legtöbbször az "egyenlőtlenség kifejezést (és hányszor)?

# Ehhez a következő információkra lesz szükség a honlapról:

# a blog posztok dátuma
# szerzője
# a posztok szövege

# Először nézzünk meg egy blog posztot:

economania_html_data <- read_html("https://economaniablog.hu/2025/02/25/egy-zoldrefestesi-botrany-egeszsegugyi-hatasai-karosanyag-kibocsatas-a-klimavaltozason-tul/")

post_date <- economania_html_data %>% 
  html_elements(".published-on .published")  %>% 
  html_text()

post_date

post_author <- economania_html_data %>% 
  html_elements(".byline a")  %>% 
  html_text()

post_author

post_text <- economania_html_data %>% 
  html_elements(".has-text-align-justify")  %>% 
  html_text()

post_text

# Ezután szedjük le a bejegyzésekhez tartozó linkeket
# Kezdjük az első 10-el:

economania_html_data_links <- read_html("https://economaniablog.hu/")

post_links <- economania_html_data_links %>% 
  html_elements(".entry-title a")  %>% 
  html_attr("href")

post_links

# Ha legörgetünk az oldal aljára találkozunk egy "Older posts" gombbal
# Nézzük meg, hogy a rákattintás után hogyan változik az oldal: https://economaniablog.hu/page/2/
# Az oldalszámok változtatásával végig tudunk iterálni az összes oldalon:

economania_link_list <- list()

# Mivel csak 2021-től kellenek a posztok, elég csak a 23. oldalig menni:

for (page_result in seq(from = 1, to = 23, by = 1)) 
{ link = paste0("https://economaniablog.hu/page/", 
                page_result, "/")
print(link)
economania_link_list <- append(economania_link_list, link)

}

# Ezután minden blog bejegyzéshez a linket le tudjuk szedni:

economania_article_links <- list()

for (link in economania_link_list) {
  
  print(link)
  
  economania_html_data <- read_html(link)
  
  article_links <- economania_html_data  %>% 
    html_elements(".entry-title a")  %>% 
    html_attr("href")
  
  economania_article_links <- append(economania_article_links, article_links)
  
}

# Végül pedig iteráljunk a linkeken, hogy megkapjuk mind a 230 bejegyzés infóit:

economania_database <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(economania_database) <- c('date', 'author', 'text')

for (link in economania_article_links) {
  
  print(link)
  
  html_data <- read_html(link)
  
  dates <- html_data  %>% 
    html_elements(".published-on .published")  %>% 
    html_text()
  
  author <- html_data  %>% 
    html_elements(".byline a")  %>% 
    html_text()
  
  text <- html_data  %>% 
    html_elements(".has-text-align-justify")  %>% 
    html_text2()
  
  all_text <- paste(text, collapse = " ")
  
  blogposts_data <- tibble(dates, author, all_text)
  
  economania_database <- rbind(economania_database, blogposts_data)}

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

# Feladat 2: Scrapeld le az "Értékesítés, kereskedelem" álláshirdetéseket Győr-Moson-Sopron 
# megyéből a  https://profession.hu oldalról
# Mennyi álláshirdetésnél van home office lehetőség?

# Először nézzünk meg egy álláshirdetést:

profession_html_data <- read_html("https://www.profession.hu/allas/ugyvezetoi-asszisztens-bardusch-bertextilia-kft-mosonmagyarovar-2590841?sessionId=b0733643adb4197010739dec32e41a02")

company <- profession_html_data %>% 
  html_element("h2.my-auto") %>% 
  html_text2()

company

adress <- profession_html_data %>% 
  html_element(".my-auto h2") %>% 
  html_text2()

adress

title <- profession_html_data %>% 
  html_element("#job-title") %>% 
  html_text()

title

salary_bonus <- profession_html_data %>% 
  html_element(".salaryBonus") %>% 
  html_text2()

salary_bonus

classification <- profession_html_data %>% 
  html_element(".classificationType") %>% 
  html_text2()

classification

equipment <- profession_html_data %>% 
  html_element(".equipments") %>% 
  html_text2()

equipment

criteria <- profession_html_data %>% 
  html_element("#adv-page__sidebar .lang") %>% 
  html_text2()

criteria

task <- profession_html_data %>% 
  html_elements("#tasks li") %>% 
  html_text2()

task

requirements <- profession_html_data %>% 
  html_elements("#requirements li") %>% 
  html_text2()

requirements

advantage <- profession_html_data %>% 
  html_elements("#other li") %>% 
  html_text2()

advantage

offer <- profession_html_data %>% 
  html_elements("#offer li") %>% 
  html_text2()

offer

# Gyűjtsük ki az állásokhoz tartozó linkeket az első oldalról:

profession_html_data <- read_html("https://www.profession.hu/allasok/ertekesites-kereskedelem/gyor-moson-sopron/1,7,31")

link <- profession_html_data %>% 
  html_elements(".ga-enhanced-event-click a") %>% 
  html_attr("href")

link

# Ezután pedig az összes oldalról:

profession_link_list <- list()

for (page_result in seq(from = 1, to = 7, by = 1)) 
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
    html_elements(".ga-enhanced-event-click a")  %>% 
    html_attr("href")
  
  profession_jobs_link <- append(profession_jobs_link, job_links)
  
}

# Az utolsó lépés végig iterálni az összes hirdetés lnikjén:

profession_database <- data.frame(matrix(ncol = 11, nrow = 0))
colnames(profession_database) <- c('company', 'adress', 'title', 'salary_bonus', 'classification', 'equipment', 'criteria', 'task', 'requirements', 'advantage', 'offer')

for (link in profession_jobs_link) {
  
  print(link)
  
  html_data <- read_html(link)
  
  company <- html_data %>% 
    html_element("h2.my-auto") %>% 
    html_text2()
  
  adress <- html_data %>% 
    html_element(".my-auto h2") %>% 
    html_text2()
  
  title <- html_data %>% 
    html_element("#job-title") %>% 
    html_text()
  
  salary_bonus <- html_data %>% 
    html_element(".salaryBonus") %>% 
    html_text2()
  
  classification <- html_data %>% 
    html_element(".classificationType") %>% 
    html_text2()
  
  equipment <- html_data %>% 
    html_element(".equipments") %>% 
    html_text2()
  
  criteria <- html_data %>% 
    html_element("#adv-page__sidebar .lang") %>% 
    html_text2()
  
  task <- html_data %>% 
    html_elements("#tasks li") %>% 
    html_text2()
  
  all_task <- paste(task, collapse = ", ")
  
  requirements <- html_data %>% 
    html_elements("#requirements li") %>% 
    html_text2()
  
  all_requirements <- paste(requirements, collapse = ", ")
  
  advantage <- html_data %>% 
    html_elements("#other li") %>% 
    html_text2()
  
  all_advantage <- paste(advantage, collapse = ", ")
  
  offer <- html_data %>% 
    html_elements("#offer li") %>% 
    html_text2()
  
  all_offer <- paste(offer, collapse = ", ")
  
  job_advertisements_data <- tibble(company, adress, title, salary_bonus, classification, equipment,
                                    criteria, all_task, all_requirements, all_advantage, all_offer)
  
  profession_database <- rbind(profession_database, job_advertisements_data)}

# Hány állásnál kritérium a német nyelv ismerete (bármilyen szinten)?

language_count = sum(str_count(profession_database$criteria, "Német"))
language_count

# Task 3: A Budesbank jegybanki beszédeit scrapeld le (elég az első 50 találatot)! 
# Ehhez használd a https://www.bundesbank.de/action/en/730564/bbksearch?query=*&hitsPerPageString=50&sort=bbksortdate+desc linket

# Először nézzünk meg egy beszédet - szükségünk lesz a dátumra, a szerzőre és a szövegre:

bundesbank_speeches_html_data <- read_html("https://www.bundesbank.de/en/press/speeches/annual-accounts-for-2024-951884")

date <- bundesbank_speeches_html_data %>% 
  html_element(".metadata__date") %>% 
  html_text()

date

authors <- bundesbank_speeches_html_data %>% 
  html_element(".metadata__authors") %>% 
  html_text2()

authors

text <- bundesbank_speeches_html_data %>% 
  html_elements(".Reden") %>% 
  html_text2()

text2 <- html_data %>% 
  html_elements(".richtext p") %>% 
  html_text2()

text2

# Most pedig gyűjtsük ki az egyes beszédekhez tartozó linkeket:

bundesbank_speeches_html_data <- read_html("https://www.bundesbank.de/action/en/730564/bbksearch?query=*&hitsPerPageString=50&sort=bbksortdate+desc")

links <- bundesbank_speeches_html_data %>% 
  html_elements(".resultlist .teasable__link") %>% 
  html_attr("href")

links

# Filterezzük az angol nyelvű  beszédeket:

filtered_speeches <- links[grepl("/en/", links)]

filtered_speeches_list <- as.list(filtered_speeches)

# Rakjuk elé a link első felét ("https://www.bundesbank.de"):

bundesbank_speeches_list <- paste0("https://www.bundesbank.de", filtered_speeches_list)
bundesbank_speeches_list <- as.list(bundesbank_speeches_list)

# Iteráljunk végig a beszédeken:

bundesbank_database <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(bundesbank_database) <- c('date', 'authors', 'text')

for (link in bundesbank_speeches_list) {
  
  print(link)
  
  html_data <- read_html(link)
  
  date <- html_data %>% 
    html_element(".metadata__date") %>% 
    html_text()
  
  authors <- html_data %>% 
    html_element(".metadata__authors") %>% 
    html_text2()
  
  text1 <- html_data %>% 
    html_elements(".Reden") %>% 
    html_text2()
  
  all_text <- paste(text1, collapse = " ")
  
  if (all_text == "") {
    
    text2 <- html_data %>% 
      html_elements(".richtext p") %>% 
      html_text2()
    
    all_text <- paste(text2[9:length(text2)], collapse = " ")
    
    speeches_data <- tibble(date, authors, all_text)
    
    bundesbank_database <- rbind(bundesbank_database, speeches_data)}
  
  else {
    
    speeches_data <- tibble(date, authors, all_text)
    
    bundesbank_database <- rbind(bundesbank_database, speeches_data)
  }
}

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

CB_ecb <- filter(CBS_dataset_v1.0, CentralBank == "European Central Bank")
