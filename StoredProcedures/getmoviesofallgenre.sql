/*Get movie recommendations which have are released after the input year for all genres of top 2 highest ratings*/

DELIMITER //
DROP PROCEDURE IF EXISTS getmoviesofall ;
CREATE PROCEDURE getmoviesofall(IN P_YEAR INT)
  BEGIN


  

    DECLARE LANGNAME VARCHAR(50) DEFAULT "";
    DECLARE FINISHED INTEGER DEFAULT 0;
    DECLARE CURRENT_RECORD CURSOR FOR
    SELECT T3.*
    FROM   (
                           SELECT DISTINCT(TW.genres)
                           FROM       TitleInfo     TW)T3;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET FINISHED = 1;
    OPEN CURRENT_RECORD;
    main_loop:
    LOOP
      FETCH CURRENT_RECORD
      INTO  LANGNAME;
      
      IF FINISHED = 1 THEN
        LEAVE MAIN_LOOP;
      END IF;
    
      select t2.originalTitle,rt1.averageRating,t2.startYear,t2.genres,t2.type from 
    (select ay.* from (select t1.tconst tconst, t1.originalTitle, t1.startYear, t1.type, t1.genres from TitleInfo t1 where t1.startYear > P_YEAR
                         AND  INSTR(LOWER(genres),LOWER(LANGNAME) ) > 0) ay)t2
    INNER JOIN 
    (SELECT rt.averageRating, rt.tconst from Ratings rt)rt1
    on rt1.tconst = t2.tconst
    ORDER by rt1.averageRating desc limit 20;

      SET FINISHED = 0;
    END LOOP;
    CLOSE CURRENT_RECORD;
  END //
  DELIMITER ;