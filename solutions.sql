CREATE TABLE netflix_shows (
    show_id VARCHAR(50) PRIMARY KEY,
    type VARCHAR(20),
    title VARCHAR(255),
    director VARCHAR(255),
    casts VARCHAR(1000),
    country VARCHAR(15),
    date_added DATE,
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);
ALTER TABLE netflix_shows
ALTER COLUMN country TYPE TEXT;
select * from netflix_shows

-- business problems 

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

SELECT type, COUNT(*) AS count
FROM netflix_shows
GROUP BY type;

--2. Find the most common rating for movies and TV shows

SELECT type, rating, COUNT(*) AS count
FROM netflix_shows
GROUP BY type, rating
ORDER BY type, count DESC;

--3. List all movies released in a specific year (e.g., 2020)
SELECT title, director, casts, country, release_year, rating, duration, listed_in, description
FROM netflix_shows
WHERE type = 'Movie' AND release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT country, COUNT(*) AS count
FROM netflix_shows
GROUP BY country
ORDER BY count DESC
LIMIT 5;

--5. Identify the longest movie
SELECT title, duration
FROM netflix_shows
WHERE type = 'Movie'
ORDER BY duration DESC
LIMIT 1;

--6. Find content added in the last 5 years
SELECT title
FROM netflix_shows
WHERE date_added >= NOW() - INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT title
FROM netflix_shows
WHERE director = 'Rajiv Chilaka';

--8. List all TV shows with more than 5 seasons
SELECT title
FROM netflix_shows
WHERE type = 'TV Show' AND CAST(SUBSTRING(duration FROM '^[0-9]+') AS INT) > 5;


--9. Count the number of content items in each genre
SELECT listed_in AS genre, COUNT(*) AS count
FROM netflix_shows
GROUP BY genre;

--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT release_year, AVG(count) AS avg_content
FROM (
    SELECT release_year, COUNT(*) AS count
    FROM netflix_shows
    WHERE country = 'India'
    GROUP BY release_year
) AS yearly_counts
GROUP BY release_year
ORDER BY avg_content DESC
LIMIT 5;


--11. List all movies that are documentaries
SELECT title
FROM netflix_shows
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';

--12. Find all content without a director
SELECT title
FROM netflix_shows
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!


SELECT COUNT(*)
FROM netflix_shows
WHERE type = 'Movie' AND LOWER("casts") LIKE '%salman khan%' AND release_year >= EXTRACT(YEAR FROM NOW()) - 10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT unnest(string_to_array(casts, ', ')) AS actor, COUNT(*) AS count
FROM netflix_shows
WHERE type = 'Movie' AND country = 'India'
GROUP BY actor
ORDER BY count DESC
LIMIT 10;

--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE 
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category, 
    COUNT(*) AS count
FROM netflix_shows
GROUP BY category;


