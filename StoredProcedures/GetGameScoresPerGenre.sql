/*List the month, year, average scores and average number of Gamesales for GENRE games released after YEAR grouped by month.
*/

DELIMITER //
DROP PROCEDURE IF EXISTS GetGameScoresPerGenre;
CREATE PROCEDURE GetGameScoresPerGenre(IN genre VARCHAR(20), IN year VARCHAR(5))
BEGIN

        IF EXISTS(SELECT genres FROM GameSales WHERE GameSales.genres = genre) THEN 
        WITH ALLSUBGAMES AS(
        SELECT * FROM GameSales GS WHERE GS.genres = genre AND GS.releaseDate <> "NULL"
        )

        SELECT count(AG.game) Totalgamesreleased, MONTHNAME(date(AG.releaseDate)) Monthofrelease, YEAR(date(AG.releaseDate)) Year,
         Round(Avg(AG.vgscore),2) Avgvgscore, Round(Avg(AG.userscore),3) Avguserscore, Round(Avg(AG.totalSales),3) AvgtotalSales, Round(Avg(AG.jpSales),3) AvgjpSales, Round(Avg(AG.naSales),3) AvgnaSales 
        FROM ALLSUBGAMES AG WHERE genres = 'Action' and YEAR(date(AG.releaseDate)) > year 
        group by Monthofrelease;
        

                
        ELSE SELECT 'Specified genre doesn''t exist, Please enter a valid genre' AS 'Error Message';
        END IF;

END //
DELIMITER ; 