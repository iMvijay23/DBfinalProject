/*Get the individual top channel for each language which has been watched the most*/

DELIMITER //
DROP PROCEDURE IF EXISTS GETTOPCHANNELSBYLANGUAGE ;
CREATE PROCEDURE GETTOPCHANNELSBYLANGUAGE()
  BEGIN
    DECLARE LANGNAME VARCHAR(50) DEFAULT "";
    DECLARE FINISHED INTEGER DEFAULT 0;
    DECLARE CURRENT_RECORD CURSOR FOR
    SELECT T3.*
    FROM   (
                           SELECT DISTINCT(TW.language)
                           FROM            TwitchWatched TW)T3;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET FINISHED = 1;
    OPEN CURRENT_RECORD;
    main_loop:
    LOOP
      FETCH CURRENT_RECORD
      INTO  LANGNAME;
      
      IF FINISHED = 1 THEN
        LEAVE MAIN_LOOP;
      END IF;

      SELECT     TWITCHWATCHED1.CL1 channel,
                 TWITCHWATCHED1.WT1 watchTime ,
                 PRICETYPES.L2      language
      FROM       (
                          SELECT   TW.channel        CL1,
                                   Max(TW.watchTime) WT1
                          FROM     TwitchWatched TW
                          WHERE    TW.language = LANGNAME
                          GROUP BY TW.channel ) TWITCHWATCHED1
      INNER JOIN
                 (
                          SELECT   T2.channel   CL2,
                                   T2.watchTime WT2,
                                   T2.language  L2
                          FROM     TwitchWatched T2
                          WHERE    T2.language = LANGNAME
                          GROUP BY T2.channel,
                                   T2.watchTime ) PRICETYPES
      ON         PRICETYPES.CL2 = TWITCHWATCHED1.CL1
      AND        PRICETYPES.WT2 = TWITCHWATCHED1.WT1
      ORDER BY   TWITCHWATCHED1.WT1 DESC
      LIMIT      1 ;
      
      SET FINISHED = 0;
    END LOOP;
    CLOSE CURRENT_RECORD;
  END //
  DELIMITER ;