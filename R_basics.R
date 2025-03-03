# This is a chunk with code. You'll notice that in code chunks, when I have something
# to say that I don't want R to treat as code, I'll put a # symbol in front of it.
# These non-code bits are called "comments", and they're helpful when you want to
# describe what's going on in your code. Use them often!

# To run a chunk, you can hit the "run" button, or put your cursor inside
# the chunk and then hit CTRL + ENTER (CMD + ENTER on a Mac)

1+3

# A string is surrounded by either single quotation marks, or double quotation marks:
# "hello" is the same as 'hello'

print("Welcome to R!")

# The output of the code will print below the chunk. You should see the text
# "Welcome to R!" print below ⇊⇊⇊ once this chunk has been run.


# Running this block will pull up the documentation page for the print() function

?print()

# In R, you can store data in a variable by using "<-" (Alt + -)


#Rules for R variables are:

#A variable name must start with a letter and can be a combination of letters, digits, period(.)
#and underscore(_). If it starts with period(.), it cannot be followed by a digit.
#A variable name cannot start with a number or underscore (_)
#Variable names are case-sensitive (age, Age and AGE are three different variables)
#Reserved words cannot be used as variables (TRUE, FALSE, NULL, if...)
# variable anything you want as long as it's not already the name of something else.
# I find that a short phrase (without spaces) is generally best.

textToPrint <- "this is some text to print"

# If you give R the name of a variable, it will print whatever is in that variable

textToPrint

# Note that capitalization does matter! This line will generate an error becuase 
# there is nothing called "texttoprint"

texttoprint

# The nchar() function tells you the number of characters in a variable

nchar(textToPrint)
class(textToPrint)

#You can also concatenate, or join, two or more elements, by using the paste() function.

text1 <- "R is"
text2 <- "awesome"

paste(text1, text2)

# Use the grepl() function to check if a character or a sequence of 
# characters are present in a string:

str <- "Hello World!"

grepl("H", str)
grepl("Hello", str)
grepl("X", str)

# Let's create some numeric variables:

hoursPerDay <- 24
daysPerWeek <- 7

# We can check to make sure that these actually are numeric:

class(hoursPerDay)
class(daysPerWeek)

# Since this is numeric data, we can do math with it! 
# "*" is the symbol for multiplication

hoursPerWeek <- hoursPerDay * daysPerWeek
hoursPerWeek

# Important! Just becuase something is a *number* doesn't mean R thinks it's numeric!

a <- 6
b <- "6"

# this will get you the error "non-numeric argument to binary operator", becuase 
# b isn't numeric, even though it's a number!

a * b

# You can change character data to numeric data using the as.numeric() function.
# This will let you do math with it again. :)

a * as.numeric(b)

# You often need to know if an expression is true or false.
# You can evaluate any expression in R, and get one of two answers, TRUE or FALSE:

10 > 9    # TRUE because 10 is greater than 9
10 == 9   # FALSE because 10 is not equal to 9
10 < 9    # FALSE because 10 is greater than 9

# Miscellaneous operators are used to manipulate data:

x <- 1:10
12 %in% x

#--------------------------------------------------------------------------------------------------------

# In programming, a vector is list of data that is all of the same data type
# To combine the list of items to a vector, use the c() function and separate the items by a comma:

listOfNumbers <- c(1,5,91,42,107)
listOfNumbers

# Becuase this is a numeric vector, we can do math on it! When you do math to a vector,
# it happens to every number in the vector. (If you're familiar with matrix 
# mutiplication, it's the same thing as multiplying a 1x1 matrix by a 1xN matrix.)

# Multiply every number in the vector by 5:
5 * listOfNumbers

# Add one to every number in the vector:
listOfNumbers + 1

# Get the first item from "listOfNumbers":
listOfNumbers[1]

# To create a vector with numerical values in a sequence, use the : operator:

numbers <- 1:10
numbers

# Vector of strings

fruits <- c("banana", "apple", "orange")
fruits

# To find out how many items a vector has, use the length() function:
  
length(fruits)
  
# To change the value of a specific item, refer to the index number:

fruits[1] <- "pear"
fruits

# To repeat vectors, use the rep() function:

repeat_each <- rep(c(1,2,3), each = 3)
repeat_each

# Repeat the sequence of the vector:

repeat_times <- rep(c(1,2,3), times = 3)
repeat_times

# To make bigger or smaller steps in a sequence, use the seq() function:

numbers <- seq(from = 0, to = 100, by = 20)
numbers

#--------------------------------------------------------------------------------------------------------

# A list is a collection of data which is ordered and changeable.
# To create a list, use the list() function:

thislist <- list("apple", "banana", "cherry")
thislist

# You can access the list items by referring to its index number, inside brackets:

thislist[1]

# To find out if a specified item is present in a list, use the %in% operator:

"apple" %in% thislist

# To add an item to the end of the list, use the append() function:

append(thislist, "orange")
thislist

# To add an item to the right of a specified index, add "after=index number" in the append() function:

append(thislist, "orange", after = 2)

# You can also remove list items:

thislist <- list("apple", "banana", "cherry")
newlist <- thislist[-1]
newlist

# There are several ways to join two or more lists:

list1 <- list("a", "b", "c")
list2 <- list(1,2,3)
list3 <- c(list1,list2)
list3

#--------------------------------------------------------------------------------------------------------

# "if statement" is written with the if keyword, and it is used to specify a 
# block of code to be executed if a condition is TRUE:

a <- 33
b <- 200

if (b > a) {
  print("b is greater than a")
}

# Else if keyword is R's way of saying "if the previous conditions were not 
# true, then try this condition"
# Else keyword catches anything which isn't caught by the preceding conditions:

if (b > a) {
  print("b is greater than a")
} else if (a == b) {
  print("a and b are equal")
} else {
  print("a is greater than b")
}

# You can also have if statements inside if statements, this is called nested if statements:

x <- 41

if (x > 10) {
  print("Above ten")
  if (x > 20) {
    print("and also above 20!")
  } else {
    print("but not above 20.")
  }
} else {
  print("below 10.")
}

# The & symbol is a logical operator, and is used to combine conditional statements:

a <- 200
b <- 33
c <- 500

if (a > b & c > a) {
  print("Both conditions are true")
}

# The | symbol (or) is a logical operator, and is used to combine conditional statements:

if (a > b | a > c) {
  print("At least one of the conditions is true")
}

# Feladat 1: Írj egy kódot, amely ellenőrzi, hogy egy adott szám páros vagy 
# páratlan, és ennek megfelelő üzenetet ír ki!

number <- 7 

# Feladat 2: Írj egy kódot, amely osztályozza a hőmérsékletet az alábbi 
# szabályok szerint:

# Ha a hőmérséklet 0 fok alatt van, írja ki: "Fagyos idő"
# Ha 0 és 20 fok között van, írja ki: "Hűvös idő"
# Ha 20 fok vagy felette van, írja ki: "Meleg idő"

homerseklet <- 15 

#--------------------------------------------------------------------------------------------------------

# Loops can execute a block of code as long as a specified condition is reached.
# R has two loop commands:
# while loops
# for loops

# While loop can execute a set of statements as long as a condition is TRUE:

i <- 1
while (i < 6) {
  print(i)
  i <- i + 1
}

# For loop is used for iterating over a sequence:

for (x in 1:10) {
  print(x)
}

# With the for loop we can execute a set of statements, once for each item in a vector, array, list:

fruits <- list("apple", "banana", "cherry")

for (x in fruits) {
  print(x)
}

# If .. else combined with a for loop:

dice <- 1:6

for(x in dice) {
  if (x == 6) {
    print(paste("The dice number is", x, "Yahtzee!"))
  } else {
    print(paste("The dice number is", x, "Not Yahtzee"))
  }
}

# Feladat 3: Írj egy kódot, ami egy adott n számig összeadja az összes 
# pozitív egész számot, és kiírja az eredményt!

n <- 10  

# Feladat 4: Írj egy kódot, amely egy adott n számig külön összegyűjti a 
# páros és páratlan számokat két külön vektorba.

n <- 15  # A számok határa

#--------------------------------------------------------------------------------------------------------

# Data Frames are data displayed in a format as a table. 
# Use the data.frame() function to create a data frame:

data_frame <- data.frame (
  Name = c("Anna", "Levente", "Lina"),
  Age = c(10, 15, 12),
  City = c("Budapet", "Gyula", "Szeged")
)

data_frame

# Or use the tibble() function to create a data frame:

data_frame <- tibble (
  Name = c("Anna", "Levente", "Lina"),
  Age = c(10, 15, 12),
  City = c("Budapet", "Gyula", "Szeged")
)

data_frame

# Use the summary() function to summarize the data from a data frame:

summary(data_frame)

# We can use single brackets [ ], double brackets [[ ]] or $ to access columns from a data frame:

data_frame[1]
data_frame[["City"]]
data_frame$Age

# Use the rbind() function to add new rows in a data frame:

New_row_DF <- rbind(data_frame, c("Paula", 11, "Sopron"))
New_row_DF

# Use the cbind() function to add new columns in a data frame:

New_col_DF <- cbind(data_frame, Country = c("Hungary", "Hungary", "Hungary"))
New_col_DF

# Use the rbind() function to combine two or more data frames in R vertically:

data_frame2 <- data.frame (
  Name = c("Szabolcs", "Imre"),
  Age = c(17, 18),
  City = c("Debrecen", "Paks")
)

New_data_frame <- rbind(data_frame, data_frame2)
New_data_frame

#--------------------------------------------------------------------------------------------------------

# tidyverse and dplyr packages installation and usage:

install.packages("tidyverse")
install.packages("dplyr")
library(tidyverse)
library(dplyr)

# Import files:

library(readxl)
BIS_research_papers <- read_excel("BIS_research_papers.xlsx")

# If we want to keep only a few of the variables we can use the select() function:

mydata <- tibble(iris)
my_filtered_data <- select(mydata, Sepal.Length, Species)

# Let's do this with pipe operator (Ctrl + Shift + M). In this case we don’t specify which
# data object we use in the select() function since in gets that from the previous pipe:

my_filtered_data <- mydata %>% select(Sepal.Length, Species)

# Using filter():

my_filtered_data <- mydata %>%
  filter(Sepal.Width > 3) %>%
  select(Sepal.Length, Species)

# Using group_by():

grouped_data <- mydata %>%
  group_by(Species) %>%
  summarize(mean_sepal_length = mean(Sepal.Length))

# Add new column by using mutate():

new_mydata <- mydata %>%
  mutate(avg_length = (Sepal.Length + Petal.Length)/2)

# Use count():

mydata %>%
  filter(Sepal.Width == 3) %>%
  count(Species, sort = TRUE)

# Use colnames() to rename a column:

colnames(mydata)[2] <- "s_width"

# Use subset() to extract rows and columns based on specified conditions:

my_data_subset <- subset(mydata, Species == 'setosa')

my_data_subset <- subset(mydata, Sepal.Length == '5' | Petal.Length == '5')

# lapply() and sapply() function helps us in applying functions on list objects 
# and returns a list object of the same length. The lapply() function takes a list, 
# vector, or data frame as input and gives output in the form of a list object. 
# The sapply() function gives output in the form of an array or matrix object

names <- c("ferenc", "lenke","janka", 
           "evelin","levente") 
names

new_names <- lapply(names, toupper) 
new_names

new_names <- sapply(names, toupper) 
new_names

# Dropping rows with a specific string:

dropped_rows <- mydata[-grep("vir", mydata$Species), ]

# To remove a character in an R data frame column, we can use gsub() function 
# which will replace the character with blank:

my_data_2 <- filter(mydata, Species == "setosa")
my_data_2$Species <- gsub("osa","",as.character(my_data_2$Species))


# Feladat 5: Az alábbi adatbázisban számold ki az átlagfizetést, valamint
# szűrd le a 30 év alatti dolgozókat.

company <- data.frame(
  Nev = c("Kovács Anna", "Nagy Péter", "Szabó László", "Tóth Eszter", "Varga Bence"),
  Kor = c(28, 35, 22, 40, 26),
  Fizetes = c(450000, 520000, 380000, 600000, 410000),
  Osztaly = c("IT", "HR", "IT", "Marketing", "HR")
)

# Feladat 6: Az alábbi adatbázisban a subset() függvénnyel listázd ki 
# az "IT" osztály dolgozóit, majd a grepl() függvénnyel pedig listázd  ki
# a "Kovács" vezetéknevű dolgozókat!

company <- data.frame(
  Nev = c("Kovács Anna", "Nagy Péter", "Szabó László", "Tóth Eszter", "Kovács Bence"),
  Kor = c(28, 35, 22, 40, 26),
  Fizetes = c(450000, 520000, 380000, 600000, 410000),
  Osztaly = c("IT", "HR", "IT", "Marketing", "IT")
)

#--------------------------------------------------------------------------------------------------------

# Often we need to create our own function to automate the performance of a particular task. 
# To declare a user-defined function in R, we use the keyword function. The syntax is as follows:

# function_name <- function(parameters){
#   function body 
# }

hello_world <- function(){
  print('Hello, World!')
}

hello_world()

# Let's write a function with arguments:

sum_function <- function(x, y){
  number <- x + y
  return(number)
}

sum_function(5,6)

# Feladat 7: Készíts egy kereses() függvényt, amely megkeresi egy szöveg 
# előfordulásait egy karaktervektorban.

# A függvény első paramétere a keresendő szó.
# A második paraméter egy vektor, amelyben keresünk.
# A függvény azokat az elemeket adja vissza, amelyek tartalmazzák a keresett szót.



