#####################################
# PART A OF THE TIDYVERSE LAB
#####################################
# Run these lines before you start! 
if(!require(pacman))install.packages("pacman")

pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggalt',
               'forcats', 'R.utils', 'png', 
               'grid', 'ggpubr', 'scales',
               'bbplot')
# install.packages('devtools')
devtools::install_github('bbc/bbplot')
library(tidyverse)
library(reshape2)

# Questions with a * require a student answer, which is usually code. 
# Questions with a (response only)* require a written comment, not code. 
# The default requirement is code if not otherwise specified.
###########
# Part I: Getting started
# 1. Run this line to make a copy of the tips dataset. The tips dataset is data
# about tips from restaurant patrons.
df <- tips

# 2. Run this to get a quick idea of the dataset.
# Notice!! there is nothing inside the parentheses for head(). 
# This is because the result from the pipe is automatically considered the first
# input to the next function. 
df %>% 
    head()

# 3*. Now pipe the dataset to the function "tally" to see how many rows there are. 
# Hint: this will look very similar, with "tally()" nothing in the parentheses.
df %>% 
  tally()
# 4*. Finally, do the same with the function "summary" and see what it gives.
df %>% summary()

# Notice how summary treats numeric and categorical variables differently. 

# Note: 
# Very often with tidyverse, you will get a result and just want to see the first 
# few lines to check your work.
# To do this, pipe your output to head() as above. it will be like: 
# df %>% 
#     some other command(s) %>% 
#     head()

# After you've checked that it's what you wanted, you can remove the %>% head(). 

# 5* (response only, no code) Based on the output from the summary command above, 
# make a guess about what each column of the dataset represents. 

# Write your response here (as a comment): 
# When the columns contain a  numeric/Quantitative value 
#(total_bill, tip, size)
# The summary function calculates the minimum, 1st quarter of the data,
#Median, Mean, 3rd quarter of the data and the Max of the data for the column
#The columns with the categorical values summarize the count of the occurance
#of each category

###########
# Part II: Trying out 1-2 of the functions at a time and piping to ggplot

## Subsetting
# 6*. Select only the total_bill column. Pipe the output to head() to show the first few. 
df %>% 
  select(total_bill)%>%
  head()

# 7*. Select both the total_bill and tip columns. Show the first few. 
df %>% 
  select(total_bill, tip)%>%
  head()

# 8*. Filter the dataframe to get all the rows with total_bill over $20. Show the first few. 
df %>% 
  filter(total_bill>=20.00)%>%
  head()

# 9 (code and response)*. Now modify your query so that you can answer the question: 
# How many total bills were over $20? 
# There are 97 total bills over $20.00
# Hint: use one of the first few functions we tried in Part I.
df %>% 
  filter(total_bill>=20.00)%>%
  tally()

# 10*. Modify the query above to get all the rows with total_bill over $20 on a Sunday.
# (Please copy and paste the query, and then modify it, so that you show the answer
# to each of these prompts.)
# Hint: You can filter twice. One easy way is to pipe output of one filter to the next filter. 
# Hint: Check equality with == (two equals signs).
# Hint: The text you're checking for equality must be in 'single' or "double" quotes.
df %>% 
  filter(total_bill>=20.00)%>%
  filter(day=="Sun")
  
  

## Summarizing
# 11*. Use summarize to find the mean of all the tips. 
df %>% 
  summarize(median_tip = median(tip,na.rm = TRUE))


# 12*. Use summarize to find the mean of the tips on Sundays.
# Hint: the two lines of code will be re-used from previous lines in this lab. 
# Hint: The order of the lines matters. 
df %>% 
  filter(day=="Sun")%>%
  summarize(median_Sun_tip = median(tip,na.rm = TRUE))

## Group by
# 13*. Use group_by to get the number of rows for each day. 
# Hint: make use of tally()
# Hint: check your work by looking at the output from summary() above
df %>% 
  group_by(day) %>% 
  tally()

# 14*. Now combine group_by and summarize to get the median total_bill for each day. 
df %>% 
  group_by(day) %>% 
  summarize(median_total_bill = median(total_bill,na.rm = TRUE))

# 15*. Update your code from above to name the relevant output column median_bill 
# (if not already done).
# Look at your result and notice how it is a dataframe that has two columns. 
df %>% 
  group_by(day) %>% 
  summarize(median_bill = median(total_bill,na.rm = TRUE))

## Mutate
# I've written this code for you, so just run it: 
# Use mutate to add a variable to your dataset representing the percentage 
# that the tip is of the total bill.
# Save the result back to the df variable to retain the change. 
# 16. Run this code.
df %>% 
    mutate(tip_percent = 100*tip/total_bill) -> df

#####
# Part III: Some slightly more complex combinations of commands

# First, notice what happens when we use the group_by command: 
# If we group_by(x), this gives us a row for each possible value of x. 
# BIG HINT: if "for each" is in the question you are asking, you probably want
# to use the group_by command. 

# For example, in #12, we wanted the number of rows FOR EACH day. We piped to 
# a group_by(day) before tallying. 

# In #13, we wanted a median tip FOR EACH day. Again, we piped to a group_by(day) 
# before finding this median. 

# Another way of thinking about this is that group_by(x) will collapse to one row
# for each value of x. 

# We can also use group_by(x,y) with two or more variables to get one row FOR EACH
# combination of these variables.

# 17 (response only)*. Describe what the following code does: 
df %>% 
    group_by(day,time) %>% 
    tally()

# Your answer: 
#The code above displays the row with each day, time 
#and total number for the day in alphabetical order using the day of the week 

# 18 (response only)*. Why are there 6 rows above instead of 8? i.e., Why is there no 
# row for Saturday lunch and Sunday lunch? (This may seem obvious to you, but it's
# not meant to be a trick question.)

# Your answer: 
#The group by function will only group days that have data.  In the case of 
#Saturday lunch and Sunday lunch there were no patrons on that day during that time

# 19*. Find the number of rows for each day and party size (party size means 
# number of people sitting at the table).
df %>% 
  group_by(day,size) %>% 
  tally()

# 20*. How could you use the group_by command to get the number of unique
# numeric values for the tip column? 
# This is a challenge, so feel free to ask on Slack. 
# Note: using group_by is REQUIRED for this question. (Yes, there are ways to 
# do this without using group_by. This problem is designed in this way to help 
# with a later challenge problem.)
df %>% 
  group_by(tip)%>% 
  summarize((count = n_distinct(tip)))
  

#####################################
# END OF PART A OF THE TIDYVERSE LAB
# Turn in all the code from #1-20 in the Canvas quiz entitled "tidyverse part A". 
# This is not an actual quiz, it's just the place to turn in this code. After you 
# turn it in, you will be able to see my solution. 
# PLEASE CHECK YOUR OWN WORK based on my solution before you move on to part B. 
# The code should yield the same result as my code (even if it doesn't match 
# exactly, which is ok). 
# The part B code will rely on understanding part A first. 
#####################################



#####################################
# PART B OF THE TIDYVERSE LAB
# After you complete this part, turn in all the code (part A and part B) as 
# specified in the lab assignment on Canvas. If your answer on any question of 
# part A did not work, it's ok to substitute the solution's answer. If your answer
# was different than the solution but gave the same result, no need to change it! 
# Sometimes there is more than one way to accomplish the same task.
#####################################


#####
# Part 4: Piping more straightforward commands to plots

# 21*. Earlier (#9), we filtered to obtain only the rows for Sunday with bills 
# over $20. Copy and paste that code here, then pipe it to a 
# histogram of the "tip" column to see the distribution of tips on Sundays for 
# bills over $20. Create this histogram with 4 bins. 
# Hint: you will NOT write ggplot(df, aes(...)) because the df is already piped in. 
# Instead, just write: 
# df %>% 
#   (other commands) %>% 
#   ggplot(aes(...)) etc.
# Title the histogram, "Distribution of Sunday tips for bills over $20, JL" 
# (but fill in your own initials for the JL)
# Feel free to style the plot with colors or themes (not required; this would be a typical exploratory
# analysis where only you will see it, so it doesn't have to be perfect).


# 22*. Earlier (#15), we found the median bill for every day of the week. 
# Copy and paste that code here. Then pipe this code to ggplot to create a bar 
# plot of median bill by day. Don't forget to title and label the plot.
# Hint: use geom_col


####
# Part 5: Challenge plots
# Now let's put together everything we learned for 3 challenges! 
# I will have hints posted on Canvas.

# 23*. You are curious who is the most generous percentage-wise when tipping. 
# a*. Find the mean tip percent for each day of the week and number of diners (size) for 
# **dinners only**. Rename this column with the name "generosity" representing 
# this mean tip percent.


# b*. Pipe this result to ggplot and create a heat map. Style and label the plot
# so that it looks good according to what we've learned. 
# (The days are alphabetized by default, but don't worry about that for the purpose
# of this lab). 


# c (response only)*. From the heat map, who stands out as most and least generous, percentage-wise?

# Your answer: 
# 


# 24*. You will notice the smoking variable in the tips dataset. It used to be 
# more common for smoking to be allowed in restaurants, and there was sometimes a 
# smoking and a non-smoking section. 
# As a restaurant server, is it better to work in the smoking vs. nonsmoking section 
# during dinner on different days of the week? 

# a*. Create a table of median tip_percent for smoking vs nonsmoking for each day of the week.
# Remove Thursday, since there were no smokers on Thursdays.
# The output is in "long" format even though it would look better "wide". Don't worry
# about that. 
# b*. Do the same comparison as in part a, but graphically: 
# Describe the differences in the tip percentage distributions by day of the week and smoking using a boxplot. 
# (Note: this will plot the whole distribution, not just the median.)
# This plot is a final result (explanatory), so style and label it appropriately. 
# Modify the theme. 
# c (response only)*. What is your finding? How does the plot give a better understanding than the median?

# a

# b

# c
# Your answer: 
#


# 25*. Use the ChickWeight data set. 
# a. Run this to see what the dataset looks like: 
ChickWeight %>% 
    head()
# Since that's pretty limited, run this also: 
ChickWeight %>% 
    tail()
# We want to find out which diet helps the chicks grow the best. 
# b*. Write code that will tell you the answer to this: 
# What is the median chick weight for each diet? 

# c*. We don't know if this tells the whole story. 
# The chicks grew, but it's possible that those in one diet were measured less often
# than those in another. 
# Let's look at some general exploratory analysis. Run code that answers: 

# i*. How many rows are there for each diet? 

# ii*. How many rows are there for each chick? 

# iii*. Write code that will help you answer the question: Was each chick only on 
# one of the diets? 

# iv (response only)*. Why are there multiple rows for each chick? In other words, 
# what is the purpose of having multiple rows per chick? What different information
# are we getting from these different rows?

# Your answer: 
# 

# v*. How many chicks were on each diet? (Keep in mind the answers above)


# d*. 
# Plot the trajectory of the median weight for each diet over time. 
# (Again, keep in mind the answers above in part c, and all we learned earlier in this lab.)


# e*. 
# Style the plot since this is a final result. Include units of grams and days as applicable.
# Include a title. Set the theme.

# f (response only)*. What is your conclusion? Did the medians for each diet in part (b) tell the
# whole story, or did the plot give a better understanding, and why? 

# Your answer: 
#