SELECT DISTINCT WebApps.WebAppName, WebApps.WebServerName, WebServers.WebServerURL, WebServers.WebServerPort, WebServers.WebFilesLocation, WebApps.WebAppLocation, HarServers.HarBroker, WebApps.HarBrokerConnection, cmServers.ServerName, ServerDefinitions.OperatingSystem, OracleDBs.OracleVersion
FROM cmServers, ServerDefinitions, HarServers, OracleDBs, WebServers, WebApps
WHERE (((WebApps.WebServerName)=[WebServers].[WebServerName]) AND ((HarServers.HarBroker)=[WebApps].[HarBrokerConnection]) AND ((cmServers.ServerName)=[HarServers].[ServerName]) AND ((ServerDefinitions.ServerName)=[WebApps].[ServerName]))
ORDER BY cmServers.ServerName;
