SELECT  cmServers.ServerName, 
        HarServers.HarBroker, 
        HarServers.HarvestVersion, 
        HarServers.OracleDBConnection, 
        ServerDefinitions.OperatingSystem, 
        OracleDBs.OracleServer, 
        OracleDBs.OracleVersion, 
        OracleDBs.OracleDBConnector
        
FROM    ServerDefinitions,
        cmServers,
        OracleDBs
        
WHERE   (ServerDefinitions.ServerName=cmServers.ServerName AND
         cmServers.ServerName=HarServers.ServerName) OR
        (ServerDefinitions.ServerName=OracleDBs.OracleServer AND
         cmServers.ServerName=OracleDBs.OracleServer)

ORDER BY cmServers.ServerName;

/*
SELECT cmServers.ServerName, HarServers.ServerName, HarServers.HarBroker, HarServers.HarvestVersion, HarServers.OracleDBConnection, ServerDefinitions.OperatingSystem, OracleDBs.OracleServer, OracleDBs.OracleVersion, OracleDBs.OracleDBConnector
FROM ServerDefinitions, cmServers, HarServers, OracleDBs
WHERE (((cmServers.ServerName)=[HarServers].[ServerName]) AND ((ServerDefinitions.ServerName)=[cmServers].[ServerName])) OR (((cmServers.ServerName)=[OracleDBs].[OracleServer]) AND ((ServerDefinitions.ServerName)=[OracleDBs].[OracleServer]))
ORDER BY cmServers.ServerName;
*/