USE [IPL DATABASE];

SELECT * FROM dbo.ipl_matches;

SELECT * FROM dbo.ipl_ball_delivery;

-- TOTAL RECORDS IN ipl_matches table
SELECT COUNT(id) total_records from dbo.ipl_matches;

-- NO. OF MATCHES PLAYED IN EACH SEASON
SELECT season, 
       COUNT(id) Matches_Played
FROM dbo.ipl_matches
GROUP BY season
ORDER BY season DESC;

-- COUNT OF TEAMS WON BATTING FIRST
select COUNT(id) Teams_Won_Batting_First
FROM dbo.ipl_matches
WHERE won_by='Runs';

-- COUNT OF TEAMS WON BATTING SECOND
SELECT COUNT(id) Teams_Won_Batting_Second
FROM dbo.ipl_matches
WHERE won_by='Wickets';

-- NO. OF MATCHES TIED
SELECT COUNT(id) Tied_Matches
FROM dbo.ipl_matches
WHERE won_by='NoResults' OR won_by='SuperOver';

-- DETAILS OF TIED MATCHES
SELECT id,city,match_date,season,team1,team2,venue,won_by
FROM dbo.ipl_matches
WHERE won_by='NoResults' OR won_by='SuperOver';

-- MOST SUCCESSFUL TEAM
SELECT TOP 1 COUNT(id) Total_Matches_Won, winning_team
FROM dbo.ipl_matches
GROUP BY winning_team
ORDER BY Total_Matches_Won DESC;

-- TOTAL MATCHES PLAYED BY EACH TEAM
SELECT union_matches.team1 Team, SUM(union_matches.Total)Total_Matches_Played
FROM

(SELECT COUNT(id) Total,
team1 FROM dbo.ipl_matches
GROUP BY team1

UNION ALL

SELECT COUNT(id) Total,
team2 FROM dbo.ipl_matches
GROUP BY team2) union_matches

GROUP BY union_matches.team1
ORDER BY Total_Matches_Played DESC;

-- NO. OF TIMES EACH TEAM WINNING THE TOSS
SELECT toss_winner Team, COUNT(toss_winner) Number_of_Toss_wins
FROM dbo.ipl_matches
GROUP BY toss_winner
ORDER BY Number_of_Toss_wins DESC;

-- TOSS WINNING PERCENTAGE FOR EACH TEAM(TWP)
SELECT a.Team,a.Total_Matches_Played,b.Number_of_Toss_Wins, (b.Number_of_Toss_Wins*100/a.Total_Matches_Played) TWP
FROM
   (SELECT u.team1 Team, SUM(u.Total) Total_Matches_Played
    FROM
       (SELECT COUNT(id) Total,
        team1 FROM dbo.ipl_matches
        GROUP BY team1
        UNION ALL
        SELECT COUNT(id) Total,
        team2 FROM dbo.ipl_matches
        GROUP BY team2) u
    GROUP BY u.team1) a
INNER JOIN
     (SELECT toss_winner, COUNT(toss_winner) Number_of_Toss_wins
      FROM dbo.ipl_matches
      GROUP BY toss_winner) b
ON a.Team=b.toss_winner
ORDER BY TWP DESC;

-- TEAM WITH HIGHEST NUMBER OF WINS IN ANY GIVEN YEAR
SELECT winning_team,COUNT(id)No_of_Matches_win
FROM dbo.ipl_matches
WHERE YEAR(match_date)=2022
GROUP BY winning_team
ORDER BY No_of_Matches_win DESC;
