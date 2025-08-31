# Netflix Data Analysis with SQL

Project Overview
This project provides an in-depth analysis of Netflix content data using SQL. The primary goal is to solve a series of business-related questions by writing efficient and well-structured SQL queries. The analysis covers various aspects of the Netflix catalog, including content types, ratings, country-wise distribution, and director/actor trends.

Files in this Repository
Netflix_data.csv: The core dataset containing information about movies and TV shows available on Netflix. This file includes attributes such as show_id, type, title, director, cast, country, date_added, release_year, rating, duration, genre, and description.

Netflix_Schemas.sql: This file contains the SQL DDL (Data Definition Language) to create the netflix_titles table. It defines the structure and data types for each column, preparing the database to receive the data from the CSV file.

Netflix-Business_Problems.sql: A list of 30 specific business questions that were the focus of the data analysis. These problems range from simple counts to more complex analyses of content trends and relationships.

Solutions_to_Netflix_Business_Problems.sql: The complete set of SQL queries that provide solutions to the 30 business problems listed in the Netflix-Business_Problems.sql file.

Key Business Questions and Insights
The analysis addressed a wide range of questions, including:

Content Distribution: What is the count and percentage split between movies and TV shows?

Top Producers: Which countries have the most content on Netflix? Who are the top 10 directors and actors with the most appearances?

Genre and Ratings: What is the most common rating for movies and TV shows? Which genres are most frequent?

Content Trends: What is the trend of content added to Netflix each year? How does the average duration differ between movies and TV shows?

Specific Queries: What is the longest movie in the dataset? What are the titles of all the movies released in a specific year?

How to Use this Project
To replicate this analysis, you can:

Set up a PostgreSQL database.

Run the Netflix_Schemas.sql file to create the netflix_titles table.

Import the data from Netflix_data.csv into the newly created table.

Execute the queries from Solutions_to_Netflix_Business_Problems.sql to get the results for each business problem.

This project can be a valuable starting point for anyone looking to practice their SQL skills on a real-world dataset.
