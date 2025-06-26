-- Q1 Retieve the names of all tracks that have more than 1 billion streams
SELECT * FROM spotify
where stream > 1000000000

-- Q2List all album along with their respective artists
Select 
DISTINCT album, artist
FROM spotify
order by 1

-- Q3 Get the total number of comments for tracks where licenced = true
-- select distinct licenced from spotify
SELECT
sum(comments) as total_comments
FROM spotify
where licensed = 'true'

-- Q4 Find all tracks that belong to the album type single

SELECT * FROM spotify
where album_type = 'single'

-- Q5 Count the total number of tracks by each artist
SELECT
artist ,
count(*)as total_no_songs
from spotify
group by artist
order by 2

-- Q6 Calculate the average danceability of tracks in each album
SELECT
album,
avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

-- Q7 Find the top 5 tracks with the highest energy values  
SELECT
track,
MAX(energy)
FROM spotify
group by 1
order by 2 DESC
LIMIT 5

-- Q8 List all tracks along with their views and likes where official_video = true
SELECT
track,
sum(views) as total_views,
sum(likes) as total_likes
FROM spotify
where official_video = 'true'
group by 1
order by 2 desc
limit 5

-- Q9 For each album , calculate the views of all associated tracks
SELECT 
album,
track,
sum(views)
from spotify 
group by 1,2 
order by 3 desc

-- Q10 Retreve the track names that have been streamed on spotify more than youtube
SELECT * FROM
(Select
track,
COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0)as streamed_on_youtube,
COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0)as streamed_on_spotify
from spotify 
group by 1
)as t1
where 
streamed_on_spotify > streamed_on_youtube
AND
streamed_on_youtube<>0

-- Q11 Find the top 3 most viewed tracks for each artist using window functions
-- each artist and total view for each track
-- track with highest view for each artist (we need top)
-- dense rank
-- cte and filder rank <=3
WITH ranking_artist
as
(SELECT 
artist,
track,
sum(views) as total_view,
DENSE_RANK() over(partition by artist order by sum(views)desc)as rank
from spotify
group by 1,2
order by 1,3 desc
)
select* from ranking_artist
where rank<= 3

-- Q12 Write a query to find tracks where the liveness score is above the average
SELECT
track, artist,
liveness
from spotify
where liveness > (SELECT AVG (liveness)from spotify)

-- Q13 Use a with clause to calculate the difference between the highest and lowest energy vaues for tracks in each album
WITH cte
as
(select
album,
MAX(energy) as highest_energy,
MIN(energy) as lowest_energery
from spotify
group by 1
)
SELECT 
album,
highest_energy - lowest_energery as energy_diff
from cte
order by 2 desc