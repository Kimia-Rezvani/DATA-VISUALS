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

library(plotly)
library(hrbrthemes)
library(gapminder)
library(viridis)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(fields)


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
df %>% 
  summary()
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
# 
# JL answer: 
# total_bill is the restaurant bill for a given group of people dining
# tip is the tip they gave at the restaurant
# sex is the sex of the person who paid
# smoker is whether the diners were smoking
# day is the day of the week
# time is which meal they ate (lunch or dinner)
# size is the number of people in that party (the number of people dining at that table together)
# reference page: 
# https://vincentarelbundock.github.io/Rdatasets/doc/reshape2/tips.html

###########
# Part II: Trying out 1-2 of the functions at a time and piping to ggplot

## Subsetting
# 6*. Select only the total_bill column. Pipe the output to head() to show the first few. 
df %>% 
  select(total_bill) %>% 
  head()

# 7*. Select both the total_bill and tip columns. Show the first few. 
df %>% 
  select(total_bill,tip) %>% 
  head()

# 8*. Filter the dataframe to get all the rows with total_bill over $20. Show the first few. 
df %>% 
  filter(total_bill > 20) %>% 
  head()

# 9 (code and response)*. Now modify your query so that you can answer the question: 
# How many total bills were over $20? 
# Hint: use one of the first few functions we tried in Part I.
df %>% 
  filter(total_bill > 20) %>% 
  tally()
# 97 total bills

# 10*. Modify the query above to get all the rows with total_bill over $20 on a Sunday.
# (Please copy and paste the query, and then modify it, so that you show the answer
# to each of these prompts.)
# Hint: You can filter twice. One easy way is to pipe output of one filter to the next filter. 
# Hint: Check equality with == (two equals signs).
# Hint: The text you're checking for equality must be in 'single' or "double" quotes.
df %>% 
  filter(total_bill > 20) %>% 
  filter(day=='Sun')
## Summarizing
# 11*. Use summarize to find the mean of all the tips. 
df %>% 
  summarize(mean(tip))

# 12*. Use summarize to find the mean of the tips on Sundays.
# Hint: the two lines of code will be re-used from previous lines in this lab. 
# Hint: The order of the lines matters. 
df %>% 
  filter(day=='Sun') %>% 
  summarize(sunday_mean_tip = mean(tip))

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
  summarize(median(total_bill))

# 15*. Update your code from above to name the relevant output column median_bill 
# (if not already done).
# Look at your result and notice how it is a dataframe that has two columns. 
df %>% 
  group_by(day) %>% 
  summarize(median_bill = median(total_bill))

## Mutate
# I've written this code for you, so just run it: 
# Use mutate to add a variable to your dataset representing the percentage 
# that the tip is of the total bill.
# Save the result back to the df variable to retain the change. 
# 16. Run this code.
df %>% 
  mutate(tip_percent = 100*tip/total_bill) -> df

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
#
# JL answer: This code gives the number of rows for every combination of day
# of the week and meal.

# 18 (response only)*. Why are there 6 rows above instead of 8? i.e., Why is there no 
# row for Saturday lunch and Sunday lunch? (This may seem obvious to you, but it's
# not meant to be a trick question.)

# Your answer: 
#
# JL answer: Because there are no data points for Saturday lunch and Sunday lunch. 
# We can check this based on the answer to #13. There are 87 Saturday rows and 
# 87 Saturday rows with dinner. Therefore there are no Saturday rows with lunch.
# Any combinations that we don't see in #17 are not in the dataset. For example, 
# we also see no breakfast for any day of the week, because this dataset does not
# have breakfast data.

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

# JL answer: The goal here is to use group_by to collapse the data into one row
# for each point. Here we want one row for each unique value of tip. We can do that
# using something like: 
df %>% 
  group_by(tip) %>% 
  tally() # intermediate answer
# Notice that this solution also gives us the count of each unique tip value. We 
# don't need this information. We could have used any aggregating function, e.g. mean: 
df %>% 
  group_by(tip) %>% 
  summarize(mean(total_bill)) # another (weird) intermediate answer
# Again, we don't need this mean(total_bill) value. It is extra information that 
# we are just going to ignore. This is just an example showing that we want to 
# group_by(tip) for this case, and then aggregate in some way. (Note: I would just
# use tally() in this case. There is no need for more complicated calculations. :) )

# Going back to the start of this solution, there are two resulting values: the
# unique value of tip, and the n (the total from tallying). We actually only need 
# the first column: 
df %>% 
  group_by(tip) %>% 
  tally() %>% 
  select(tip) # intermediate answer

# Now we have just the unique values of tip. We can count them by counting the rows: 
df %>% 
  filter(total_bill > 20) %>% 
  filter(day=='Sun')%>% 
  group_by(tip) %>% 
  tally() %>% 
  select(tip) %>% 
  tally() # option 1 final answer

# Selecting made it clearer why it didn't matter that we tallied the data, even 
# though we didn't need that tally. However, note that the following solution also works
# without a select, because it's counting the whole rows, which is equivalent: 
df %>% 
  group_by(tip) %>% 
  tally() %>% 
  tally() # option 2 final answer
# The first tally is tallying the number of rows for that specific tip. 
# The second tally is tallying the number of rows from the previous results, which
# has one row for each tip. Thus, it is the number of unique tip values.

# Why this strange exercise? When you reach a point in the analysis where you are
# thinking, "I just want all the unique x's" or "I just want *one* row FOR EACH x", 
# consider doing a group_by(), and then using a tally to aggregate (even if you don't
# ultimately need that tally).
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
df %>% 
  filter(total_bill > 20) %>% 
  filter(day=='Sun')%>% 
  group_by(tip) %>% 
  select(tip) %>% 
  summarize(tip, n=n())%>% 
  
  ggplot(aes(x=tip), y=n) + 
  geom_histogram(bins=4, colour = "white", fill = "#1380A1")+
  geom_hline(yintercept = 0, size = 1, colour="#333333") +
  bbc_style() +
  theme(axis.title = element_text(size = 16))+
  labs(title="Distribution of Sunday tips for bills over $20, KR",x="Tip(US $)",y="Count") +
  theme_minimal() 




# 22*. Earlier (#15), we found the median bill for every day of the week. 
# Copy and paste that code here. Then pipe this code to ggplot to create a bar 
# plot of median bill by day. Don't forget to title and label the plot.
# Hint: use geom_col
df %>% 
  group_by(day) %>% 
  summarize(median_bill = median(total_bill))%>% 

ggplot(aes(x=fct_reorder(day,median_bill),y=median_bill)) + 
  geom_col(fill="lightblue") + 
  bbc_style() +
  theme(axis.title = element_text(size = 16))+
  labs(title="Median Bill per Day, KR",x="Day of Week",y="Median Bill (US $)") +
  theme_minimal() 
####
# Part 5: Challenge plots
# Now let's put together everything we learned for 3 challenges! 
# I will have hints posted on Canvas.

# 23*. You are curious who is the most generous percentage-wise when tipping. 
# a*. Find the mean tip percent for each day of the week and number of diners (size) for 
# **dinners only**. Rename this column with the name "generosity" representing 
# this mean tip percent.
df%>% 
  head()

df%>% 
  filter(time!="Lunch")%>% 
  group_by(day, size)%>% 
  summarize(generosity = median(tip_percent,na.rm = TRUE),
            n = n())
  


# b*. Pipe this result to ggplot and create a heat map. Style and label the plot
# so that it looks good according to what we've learned. 
# (The days are alphabetized by default, but don't worry about that for the purpose
# of this lab). 

df%>% 
  filter(time!="Lunch")%>% 
  group_by(day,size)%>% 
  summarize(generosity = median(tip_percent,na.rm = TRUE),
            n = n())%>% 

ggplot( aes(x=day, y=size, fill=generosity))+
  geom_tile()+
  scale_fill_distiller(palette = "BuGn")+
  theme(axis.title = element_text(size = 16))+
  ggtitle("Median Tip Percent by Size & Day, KR") +
  xlab("Day of the Week") +
  ylab("Size of Dinner Party")+
  scale_y_discrete(expand=c(0, 0))+
  theme(# Hide panel borders and remove grid lines
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Change axis line
    axis.line = element_line(color = "black")
  ) +
  theme_classic()

 
  

# c (response only)*. From the heat map, who stands out as most and least generous, percentage-wise?

# Your answer: 
# A dinner party size of one on Saturday


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

df%>% 
  filter(day!="Thur")%>% 
  group_by(day,smoker)%>% 
  select(tip_percent)%>% 
  summarize(generosity = median(tip_percent,na.rm = TRUE),
            n = n())

# box plot

df%>% 
  filter(day!="Thur")%>% 
  group_by(day,smoker)%>% 
  select(tip_percent)%>% 

 ggplot(aes(x = day, y = tip_percent))+
geom_boxplot(
  aes(fill = smoker),
  position = position_dodge(0.9))+
  scale_fill_manual(values = c("#76ff7a", "#ffcc00"))+
  labs(title="Median Tip Percent Per Day smoker v. Non Smoker, KR", x = "Day of the Week", y = "Tip Percent")+
  theme_minimal()

#violin
df%>% 
  filter(day!="Thur")%>% 
  group_by(day,smoker)%>% 
  select(tip_percent)%>% 

ggplot( aes(x = day, y = tip_percent,
                 color = smoker)) +
  labs(x = "Day of the Week", y = "Median Tip Percent of Bill") +
  scale_color_brewer(palette = "Set2")+
  geom_violin(fill = "gray80", size = 1, alpha = .5) +
  geom_jitter(alpha = .25, width = .3) +
  coord_flip()+
  theme_modern_rc()




# c
# Your answer: 
#The plotting the data in a heat map makes the data easier to interpret
#The best median tip percentage is on Friday night with smoking patrons. 


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
ChickWeight %>% 
  group_by(Diet,weight)%>% 
  select(weight, Diet)%>%
  tally()%>%
  summarize(median_weight= median(weight,na.rm = TRUE),
            n = n())
 
# c*. We don't know if this tells the whole story. 
# The chicks grew, but it's possible that those in one diet were measured less often
# than those in another. 
# Let's look at some general exploratory analysis. Run code that answers: 

# i*. How many rows are there for each diet? 

ChickWeight %>% 
  group_by(Diet)%>% 
  select(Diet)%>%
  tally()
  
# ii*. How many rows are there for each chick?
ChickWeight %>% 
  group_by(Chick)%>% 
  select(Chick)%>%
  tally()%>%
  arrange(desc(Chick))

# iii*. Write code that will help you answer the question: Was each chick only on 
# one of the diets? 
#yes
ChickWeight %>% 
  group_by(Chick,Diet)%>%
  tally()%>%
  select(Chick)%>%
  tally()
  


# iv (response only)*. Why are there multiple rows for each chick? In other words, 
# what is the purpose of having multiple rows per chick? What different information
# are we getting from these different rows?

# Your answer: 
# The multiple rows is the amount of time or duration the chick is on the diet.

# v*. How many chicks were on each diet? (Keep in mind the answers above)
ChickWeight %>% 
  group_by(Diet, Chick)%>%
  tally()%>%
  select(Diet)%>%
  tally()

#Diet    Chicks(total)
#1        20
#2        10
#3        10
#4        10

# d*. 
# Plot the trajectory of the median weight for each diet over time. 
# (Again, keep in mind the answers above in part c, and all we learned earlier in this lab.)

ChickWeight %>% 
  group_by(Diet, Time)%>% 
  summarize(median_weight= median(weight,na.rm = TRUE),
            n = n())%>% 
  ggplot( aes(x = Time, y = median_weight, colour = Diet)) +
  geom_line()

# e*. 
# Style the plot since this is a final result. Include units of grams and days as applicable.
# Include a title. Set the theme.

ChickWeight %>% 
  
  group_by(Diet, Time)%>% 
  summarize(median_weight= median(weight,na.rm = TRUE),
            n = n())%>% 
  ggplot( aes(x = Time, y = median_weight,colour = Diet)) +
  geom_line()+
  xlab("Days on Diet") +
  ylab("Median Weight(grams)")+
  scale_colour_manual(values = c("#FAAB18", "#1380A1","#990000", "#588300")) +
  labs(subtitle = "Median Weight of Diet Over Time, KR")+
  theme_cleveland()+
  theme(
    panel.background = element_rect(fill = "#e9ffdb",
                                    colour = "#e9ffdb",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "white"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "white")
  )

  


# f (response only)*. What is your conclusion? Did the medians for each diet in part (b) tell the
# whole story, or did the plot give a better understanding, and why? 

# Your answer: The trends was a lot more clear in the plot created in e
#The plot visualized the trend the diet easier to follow and just looking at the 
#numeric data one would just think diet 4 would yield the highest median weight
#Visualizing the data it is clear to see that diet 3 in fact yields an exponential
#increase in the median weight.
