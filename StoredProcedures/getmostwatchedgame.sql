/*1. whats the most viewed game in twitch during the peak covid cases month in the country and continent in the input year tg
*/



DELIMITER //
DROP PROCEDURE IF EXISTS getmostwatchedgame;
CREATE PROCEDURE getmostwatchedgame(
  IN p_year INT,
  IN p_continent VARCHAR(255),
  IN p_country VARCHAR(255)
)
BEGIN
  IF EXISTS(SELECT location FROM CovidData WHERE LOWER(continent) = LOWER(p_continent) AND lower(CovidData.location) = lower(p_country)) THEN 
  SELECT 
    game Mostwatchedgame
  FROM TwitchGames
  WHERE
  game <> 'Just Chatting' and 
    year = p_year AND
    month = (SELECT T.MOH FROM (SELECT MONTH(dateofdata) MOH, SUM(new_cases) TCNEW FROM CovidData WHERE YEAR(dateofdata) = p_year and LOWER(continent) = LOWER(p_continent) AND
    LOWER(location) = LOWER(p_country) GROUP BY MOH ORDER BY TCNEW DESC LIMIT 1)T)
  ORDER BY
    hoursWatched DESC
  LIMIT 1;
  ELSE SELECT 'Specified country is not in that continent, Please enter a valid country' AS 'Error Message';
  END IF;
END //
DELIMITER ; 