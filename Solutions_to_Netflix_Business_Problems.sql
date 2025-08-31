-- Netflix Data Analysis using SQL :

-- Solutions of 30 Business Problems


-- 1. Count the number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*)
FROM netflix_titles
GROUP BY type;


-- 2. Find the most common rating for movies and TV shows
SELECT type, rating
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS total,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix_titles
    GROUP BY type, rating
) AS t1
WHERE ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix_titles
WHERE type = 'Movie' 
  AND release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix
SELECT * 
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix_titles
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;


-- 5. Identify the longest movie
SELECT * 
FROM netflix_titles
WHERE type = 'Movie'
  AND duration = (
      SELECT MAX(duration) 
      FROM netflix_titles 
      WHERE type = 'Movie'
  );


-- 6. Find content added in the last 5 years
SELECT *
FROM netflix_titles
WHERE TO_DATE(TRIM(date_added), 'FMMonth DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT * 
FROM netflix_titles
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix_titles
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;


-- 9. Count the number of content items in each genre
SELECT 
    UNNEST(STRING_TO_ARRAY(genre, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix_titles
GROUP BY genre;


-- 10. Find each year and the average numbers of content released by India on Netflix 
--     Return top 5 years with highest average content release
SELECT 
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::NUMERIC /
        (SELECT COUNT(show_id) FROM netflix_titles WHERE country = 'India')::NUMERIC * 100, 2
    ) AS avg_release
FROM netflix_titles
WHERE country = 'India' 
GROUP BY release_year
ORDER BY avg_release DESC
LIMIT 5;


-- 11. List all movies that are documentaries
SELECT * 
FROM netflix_titles
WHERE genre ILIKE '%Documentaries%';


-- 12. Find all content without a director
SELECT * 
FROM netflix_titles
WHERE director IS NULL OR director = '';


-- 13. Find how many movies actor 'Salman Khan' appeared in the last 10 years
SELECT * 
FROM netflix_titles
WHERE casts ILIKE '%Salman Khan%'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS appearances
FROM netflix_titles
WHERE country = 'India'
  AND casts IS NOT NULL
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;


-- 15. Categorize content as 'Bad' if description contains 'kill' or 'violence', else 'Good'
SELECT 
    category,
    type,
    COUNT(*) AS content_count
FROM (
    SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_titles
) AS categorized_content
GROUP BY category, type
ORDER BY type;


-- 16. Find the month with the highest number of releases
SELECT
    EXTRACT(MONTH FROM TO_DATE(TRIM(date_added), 'FMMonth DD, YYYY')) AS month,
    COUNT(*) AS total_releases
FROM netflix_titles
WHERE date_added IS NOT NULL AND TRIM(date_added) <> ''
GROUP BY month
ORDER BY total_releases DESC
LIMIT 1;


-- 17. Calculate the average duration of Movies vs TV Shows
SELECT 'Movie' AS type,
       AVG(CAST(REPLACE(duration, ' min', '') AS INT)) AS avg_duration
FROM netflix_titles
WHERE type = 'Movie' AND duration LIKE '%min'
UNION ALL
SELECT 'TV Show' AS type,
       AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT)) AS avg_duration
FROM netflix_titles
WHERE type = 'TV Show' AND duration LIKE '%Season%';


-- 18. Identify the top 10 directors with the most content on Netflix
SELECT director, COUNT(*) AS total_content
FROM netflix_titles
WHERE director IS NOT NULL AND director <> ''
GROUP BY director
ORDER BY total_content DESC
LIMIT 10;


-- 19. Find the most common genre combination
SELECT genre, COUNT(*) AS total
FROM netflix_titles
GROUP BY genre
ORDER BY total DESC
LIMIT 1;


-- 20. Find the first and latest year of content in the dataset
SELECT 
    MIN(release_year) AS first_year, 
    MAX(release_year) AS latest_year
FROM netflix_titles;


-- 21. Count how many content items were added after a certain date
SELECT COUNT(*) AS added_content
FROM netflix_titles
WHERE date_added IS NOT NULL
  AND TO_DATE(TRIM(date_added), 'FMMonth DD, YYYY') > DATE '2020-01-01';


-- 22. Find all content that has both ‘Kids’ and ‘Family’ genres
SELECT title, type
FROM netflix_titles
WHERE genre ILIKE '%Kids%' 
  AND genre ILIKE '%Family%';


-- 23. Calculate the percentage split between Movies vs TV Shows
SELECT type,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM netflix_titles), 2) AS percentage
FROM netflix_titles
GROUP BY type;


-- 24. Find the most frequent cast members overall
SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS appearances
FROM netflix_titles
WHERE casts IS NOT NULL AND casts <> ''
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;


-- 25. List the top 5 longest-running TV shows on Netflix
SELECT title, duration
FROM netflix_titles
WHERE type = 'TV Show'
ORDER BY CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT) DESC
LIMIT 5;


-- 26. Find the most recent content released from each country
SELECT country, MAX(release_year) AS latest_release
FROM netflix_titles
GROUP BY country;


-- 27. Analyze trend: Number of content items added per year
SELECT EXTRACT(YEAR FROM TO_DATE(TRIM(date_added), 'FMMonth DD, YYYY')) AS year,
       COUNT(*) AS total_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year
ORDER BY year;


-- 28. Find actors who frequently appear together
SELECT casts, COUNT(*) AS total_titles
FROM netflix_titles
WHERE casts LIKE '%,%'
GROUP BY casts
ORDER BY total_titles DESC;


-- 29. Identify countries that produce the most TV Shows (vs Movies)
SELECT country, type, COUNT(*) AS total_content
FROM netflix_titles
GROUP BY country, type
ORDER BY total_content DESC;


-- 30. Find the top 10 descriptions with the longest text
SELECT title, LENGTH(description) AS desc_length
FROM netflix_titles
ORDER BY desc_length DESC
LIMIT 10;


-- End of Report
