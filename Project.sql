create database Intenshala_Project;

use Intenshala_Project;

-- 1. Create a table named ‘matches’ with appropriate data types for columns
create table matches (
match_id INT AUTO_INCREMENT primary key,
city varchar(100),
match_date INT not null,
player_of_match varchar(100),
venue varchar(100) not null,
neutral_venue int,
team_1 varchar(30) not null,
team_2 varchar(30) not null,
toss_winner varchar(100) not null,
toss_decision varchar(100) not null,
winner varchar(100) not null,
result varchar(50),
result_margin varchar(45),
eliminator varchar(100) not null,
method varchar(100) not null,
umpire1 varchar(100) not null,
umpire2 varchar(100) not null);

-- 2. Create a table named ‘deliveries’ with appropriate data types for columns
CREATE TABLE deliveries (
    match_id INT, 
    innings INT NOT NULL,
    overs INT NOT NULL,
    ball INT NOT NULL,
    batsman VARCHAR(100) NOT NULL,
    non_striker VARCHAR(100) NOT NULL,
    bowler VARCHAR(100) NOT NULL,
    batsman_runs int,
    extra_runs int,
    total_runs int,
    is_wicket int,
    dismissal_kind VARCHAR(100) NOT NULL,
    player_dismissed VARCHAR(100) NOT NULL,
    fielder VARCHAR(100) NOT NULL,
    extras_type varchar(100),
    batting_team VARCHAR(100) NOT NULL,
    bowling_team VARCHAR(100) NOT NULL
);
    
-- 3. Import data from csv file ’IPL_matches.csv’ attached in resources to the table ‘matches’ which was created in Q1
insert into matches
select *
from ipl_matches;

-- 4. Import data from csv file ’IPL_Ball.csv’ attached in resources to the table ‘deliveries’ which was created in Q2
INSERT INTO deliveries
SELECT *
FROM ipl_ball;

-- 5. Select the top 20 rows of the deliveries table after ordering them by id, inning, over, ball in ascending order.
select * from deliveries
order by match_id,innings,overs,ball
limit 20;

-- 6. Select the top 20 rows of the matches table.
select * from matches 
order by result_margin desc
limit 20;

-- 7. Fetch data of all the matches played on 2nd May 2013 from the matches table.
select * from matches
where match_date = '02-05-2013';

-- 8. Fetch data of all the matches where the result mode is ‘runs’ and margin of victory is more than 100 runs.
select count(*) from matches 
where result = 'runs' and result_margin > 100
order by result_margin;

-- 9. Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.
select * from matches 
where result = 'tie' 
order by match_id desc; 

-- 10.Get the count of cities that have hosted an IPL match.
select count(distinct city) as 'cities that have hosted an IPL match'
from matches;

/* 11.Create table deliveries_v02 with all the columns of the table ‘deliveries’ and an additional column ball_result containing values boundary, 
dot or other depending on the total_run (boundary for >= 4, dot for 0 and other for any other number)
(Hint 1 : CASE WHEN statement is used to get condition based results)
(Hint 2: To convert the output data of select statement into a table, you can use a subquery. Create table table_name as [entire select statement]. */
Create table deliveries_v02
select *,
case
    when total_runs >= 4 then 'Boundary'
    when total_runs = 0 then 'Dot'
    else 'Other'
    end as 'Ball Result'
from deliveries;

-- 12. Write a query to fetch the total number of boundaries and dot balls from the deliveries_v02 table.
select `Ball Result`,count(`Ball Result`) as 'Result'
from deliveries_v02
where `Ball Result` = 'boundary' or `Ball Result` = 'dot'
group by `Ball Result`;

/* 13. Write a query to fetch the total number of boundaries scored by each team from the deliveries_v02 table 
and order it in descending order of the number of boundaries scored.*/
select batting_team, count(`Ball Result`) as result
from deliveries_v02
where `Ball Result`='boundary'
group by batting_team
order by result desc;

-- 14. Write a query to fetch the total number of dot balls bowled by each team and order it in descending order of the total number of dot balls bowled.
select bowling_team, count(`Ball Result`) as result
from deliveries_v02
where `Ball Result`='dot'
group by bowling_team
order by result desc;

-- 15. Write a query to fetch the total number of dismissals by dismissal kinds where dismissal kind is not NA
SELECT dismissal_kind, COUNT(dismissal_kind) AS Total_Dismissal
FROM deliveries_v02
WHERE dismissal_kind != 'NA'
GROUP BY dismissal_kind;


-- 16. Write a query to get the top 5 bowlers who conceded maximum extra runs from the deliveries table
select bowler , max(extra_runs) as Extra_Runs
from deliveries_v02
group by bowler
order by extra_runs desc
limit 5;

/* 17. Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table and 
two additional column (named venue and match_date) of venue and date from table matches */
CREATE TABLE deliveries_v03 AS
SELECT dv.*, m.venue, m.match_date
FROM deliveries_v02 AS dv
INNER JOIN matches AS m ON dv.match_id = m.match_id;

-- 18. Write a query to fetch the total runs scored for each venue and order it in the descending order of total runs scored.
select venue, sum(total_runs) as runs
from deliveries_v03
group by venue
order by sum(total_runs) desc;

-- 19. Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending order of total runs scored.
select match_date, venue, sum(total_runs) as Total_runs
from deliveries_v03
where venue = 'Eden Gardens'
group by venue, match_date
order by total_runs desc;

ALTER TABLE deliveries_v03 CHANGE COLUMN match_date matchdate DATE;


/* 20. Get unique team1 names from the matches table, you will notice that there are two entries for Rising Pune Supergiant 
one with Rising Pune Supergiant and another one with Rising Pune Supergiants.  
Your task is to create a matches_corrected table with two additional columns team1_corr and team2_corr containing team names
with replacing Rising Pune Supergiants with Rising Pune Supergiant. Now analyse these newly created columns.*/
create table matches_corrected as
select *, team_1 as team1_corr , 
team_2 as team2_corr 
from matches;

update matches_corrected
set team1_corr = replace(team_1,'Rising Pune Supergiants','Rising Pune Supergiant'),
	team2_corr = replace(team_2,'Rising Pune Supergiants','Rising Pune Supergiant');

select distinct team1_corr from matches_corrected;

/* 21. Create a new table deliveries_v04 with the first column as ball_id containing information of match_id, inning, 
over and ball separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball) and rest of the columns same as deliveries_v03)*/
create table deliveries_v04 as
select concat(match_id,'-',innings,'-',overs,'-',ball) as ball_id ,
match_id,innings,overs,ball,batsman,non_striker,bowler,batsman_runs,extra_runs,total_runs,is_wicket,dismissal_kind,
player_dismissed,fielder,extras_type,batting_team,bowling_team,`Ball Result`,venue,match_date
from deliveries_v03;

-- 22. Compare the total count of rows and total count of distinct ball_id in deliveries_v04;
select count(ball_id) as total_ball_id, 
count(distinct ball_id) as distinct_ball_id
from deliveries_v04;


/* 23. SQL Row_Number() function is used to sort and assign row numbers to data rows in the presence of multiple groups. 
For example, to identify the top 10 rows which have the highest order amount in each region, we can use row_number to 
assign row numbers in each group (region) with any particular order (decreasing order of order amount) 
and then we can use this new column to apply filters. 
Using this knowledge, solve the following exercise. You can use hints to create an additional column of row number.


Create table deliveries_v05 with all columns of deliveries_v04 and an additional column for row number partition over ball_id. 
(HINT : Syntax to add along with other columns,  row_number() over (partition by ball_id) as r_num)*/
create table deliveries_v05 as 
select *,
(select row_number() over(partition by ball_id) as r) as r_num 
from deliveries_v04;

/* 24. Use the r_num created in deliveries_v05 to identify instances where ball_id is repeating. 
(HINT : select * from deliveries_v05 WHERE r_num=2;) */
select * from deliveries_v05 WHERE r_num=2;

/* 25. Use subqueries to fetch data of all the ball_id which are repeating. 
(HINT: SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);*/
SELECT * FROM deliveries_v05 
WHERE ball_id 
in (select BALL_ID from deliveries_v05 WHERE r_num=2);