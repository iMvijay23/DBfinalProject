/*1. whats are the top most viewed games in twitch during the peak covid cases month in the input year tg
*/



DELIMITER //
DROP PROCEDURE IF EXISTS gettopwatchedgames;
CREATE PROCEDURE gettopwatchedgames(
  IN p_year INT
)
BEGIN
  IF EXISTS(SELECT total_cases FROM CovidData WHERE YEAR(dateofdata) = p_year) THEN 
  
  SELECT 
    game Topwatchedgames
  FROM TwitchGames
  WHERE
  game <> 'Just Chatting' and 
    year = p_year AND
    month = (SELECT T.MOH FROM (SELECT MONTH(dateofdata) MOH, SUM(new_cases) TCNEW FROM CovidData WHERE YEAR(dateofdata) = p_year GROUP BY MOH ORDER BY TCNEW DESC LIMIT 1)T)
  ORDER BY
    hoursWatched DESC
  LIMIT 20;
  ELSE SELECT 'Specified year is not valid, Please enter a valid year' AS 'Error Message';
  END IF;
END //
DELIMITER ; 