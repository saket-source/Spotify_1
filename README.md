# Spotify SQL Project and Query Optimization 
Project Category: Advanced

![spotify_logo](https://github.com/user-attachments/assets/2e12247e-d0b8-49f9-a64e-248c48d57ea9)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity, and optimizing query performance. The primary goals of the project are to practice SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Practice Questions

1. Retrieve the names of all tracks that have more than 1 billion streams.
   
```
SELECT * 	
	FROM spotify
WHERE stream > 1000000000;
```

2. List all albums along with their respective artists.

```
SELECT DISTINCT album
	FROM spotify
ORDER BY 1
```

3. List all tracks along with their views and likes where `official_video = TRUE`.
   
```
SELECT 
	DISTINCT track, 
	SUM(views) AS total_views, 
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE 
GROUP BY track
ORDER BY 2 DESC
```
   
4. For each album, calculate the total views of all associated tracks.
   
```
SELECT 
	album, 
	SUM(views) AS total_views,
	track
FROM spotify
GROUP BY album, track
ORDER BY 2 DESC
```
   
5. Retrieve the track names that have been streamed on Spotify more than YouTube.

```
SELECT * FROM
(SELECT 
	track,
	--most_played_on,
	COALESCE(SUM (CASE WHEN most_played_on = 'Youtube' THEN stream END),0)  as streamed_on_youtube,
	COALESCE(SUM (CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify	
FROM spotify
GROUP BY 1) as t1
WHERE streamed_on_spotify > streamed_on_youtube
	AND streamed_on_youtube <> 0
```

6. Find the top 3 most-viewed tracks for each artist using window functions.

```
WITH ranking_artist
AS
(SELECT 
	artist, 
	track, 
	SUM(views) as total_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3
```
   
7. Write a query to find tracks where the liveness score is above the average.

```
-- SELECT AVG(liveness) FROM spotify  -- (0.19)

SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
```

8. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
```
   
9. Find tracks where the energy-to-liveness ratio is greater than 1.2.

```
select 
	track,
	artist,
	(energy/liveness) as energy_to_liveness_ratio
from spotify
where (energy/liveness) > 1.2
```

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a Spotify data management. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

This project showcases SQL skills essential for database management and analysis.

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/saket-kumar-diwakar/)

Thank you for your interest in this project! and I look forward to connecting with you!

