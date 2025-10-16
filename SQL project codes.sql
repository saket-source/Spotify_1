-- Table: public.spotify

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


select * from spotify 
limit 4

select min(duration_min) from spotify

select * from spotify
where duration_min = 0

delete from spotify
where duration_min = 0

select * from spotify
where views = 0

-- -------------------------
-- Data Analysis of Spotify
-- -------------------------

-- (1) Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * 
FROM spotify
WHERE stream > 1000000000

-- (2) List all albums along with their respective artists.

SELECT DISTINCT album
FROM spotify
ORDER BY 1

-- (3) Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) as total_licensed_comments
FROM spotify
WHERE licensed = TRUE

-- (4) Find all tracks that belong to the album type single.

SELECT *
FROM spotify
WHERE album_type = 'single'

-- (5) Count the total number of tracks by each artist.

SELECT artist, COUNT(track) AS number_of_songs
FROM spotify
GROUP BY artist 
ORDER BY 2 DESC


-- (6) Calculate the average danceability of tracks in each album.

SELECT 
	album,
	AVG(danceability)
FROM spotify
GROUP BY album
ORDER BY 2 DESC

-- (7) Find the top 5 tracks with the highest energy values.

SELECT track, MAX(energy) AS energy_values
FROM spotify
GROUP BY track
ORDER BY 2 DESC
LIMIT 5

-- (8) List all tracks along with their views and likes where official_video = TRUE.

SELECT 
	distinct track, 
	SUM(views) AS total_views, 
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE 
GROUP BY track
ORDER BY 2 DESC

-- (9) For each album, calculate the total views of all associated tracks.

SELECT 
	album, 
	SUM(views) AS total_views,
	track
FROM spotify
GROUP BY album, track
ORDER BY 2 DESC

-- (10) Retrieve the track names that have been streamed on Spotify more than YouTube.

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

-- (11) Find the top 3 most-viewed tracks for each artist using window functions.

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


-- (12) Write a query to find tracks where the liveness score is above the average.
                                    -- SELECT AVG(liveness) FROM spotify  -- (0.19)

SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)  


-- (13) Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte as
(SELECT  
	album,
	MAX(energy) higest_energy,
	MIN(energy) lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	higest_energy - lowest_energy as energy_diff
FROM cte































