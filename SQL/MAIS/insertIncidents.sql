INSERT INTO INCIDENT 
    ( EVENT_TIME,
      PUID,
      BAR_CODE,
      PLAYER_UNIT_TYPE,
      KEYS_DROPPED,
      [MAIS Controller],
      KEYS_TYPE,
      REPORTER,
      [PACU Status],
      Position,
      [Weather Conditions],
      [Antenna Moisture],
      [BIT failures],
      [Validate Errors],
      [Download Error],
      [Recovery Procedure],
      Notes)
SELECT
      Date/Time AS Expr1,
      PUID AS Expr2,
      [Bar Code] AS Expr3,
      [PU Type] AS Expr4,
      [Keys dropped] AS Expr5,
      [SW Version] AS Expr6,
      [Keys Red/Blue] AS Expr7,
      "UNKNOWN" AS Expr8,
      [PACU Status] AS Expr9,
      Position AS Expr10,
      [Weather Conditions] AS Expr11,
      [Antenna Moisture] AS Expr12,
      [BIT failures] AS Expr13,
      [Validate Errors] AS Expr14,
      [Download Error] AS Expr15,
      [Recovery Procedure] AS Expr16
FROM [outOfSyncIncidents];