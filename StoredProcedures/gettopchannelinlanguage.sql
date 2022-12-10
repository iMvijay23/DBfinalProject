/*Get the individual top channel according to followers for given language */

DELIMITER //
DROP PROCEDURE IF EXISTS gettopchannelinlanguage;
CREATE PROCEDURE gettopchannelinlanguage(IN p_language VARCHAR(255))
BEGIN
    SELECT     TWITCHWATCHED1.CL1 channel,
                 TWITCHWATCHED1.WT1 followers ,
                 PRICETYPES.L2      language
      FROM       (
                          SELECT   TW.channel        CL1,
                                   Max(TW.followers) WT1
                          FROM     TwitchWatched TW
                          WHERE    TW.language = p_language
                          GROUP BY TW.channel ) TWITCHWATCHED1
      INNER JOIN
                 (
                          SELECT   T2.channel   CL2,
                                   T2.followers WT2,
                                   T2.language  L2
                          FROM     TwitchWatched T2
                          WHERE    T2.language = p_language
                          GROUP BY T2.channel,
                                   T2.watchTime ) PRICETYPES
      ON         PRICETYPES.CL2 = TWITCHWATCHED1.CL1
      AND        PRICETYPES.WT2 = TWITCHWATCHED1.WT1
      ORDER BY   TWITCHWATCHED1.WT1 DESC
      LIMIT      1 ;
END //
DELIMITER ; 