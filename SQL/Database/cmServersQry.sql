SELECT 	cmServers.ServerName, 
		ServerDefinitions.OperatingSystem, 
		WebServers.WebServerName, 
		WebServers.WebServerURL, 
		WebServers.WebServerPort, 
		WebServers.WebFilesLocation, 
		WebApps.WebAppName, 
		WebApps.WebAppLocation, 
		WebApps.HarBrokerConnection
FROM 	cmServers,
		ServerDefinitions,
		WebServers,
		WebApps
WHERE	
		ServerDefinitions.ServerName=cmServers.ServerName AND
		cmServers.ServerName=WebServers.WebServerName AND
		WebApps.WebServerName=WebServers.WebServerName
		
ORDER BY cmServers.ServerName;



/*
HarAgents, ((cmServers INNER JOIN (WebApps INNER JOIN WebServers ON WebApps.WebServerName = WebServers.WebServerName) ON cmServers.ServerName = WebServers.ServerName) INNER JOIN (HarServers INNER JOIN OracleDBs ON HarServers.OracleDBConnection = OracleDBs.OracleDBConnector) ON (WebApps.HarBrokerConnection = HarServers.HarBroker) AND (cmServers.ServerName = HarServers.ServerName)) INNER JOIN ServerDefinitions ON cmServers.ServerName = ServerDefinitions.ServerName
ORDER BY cmServers.ServerName;
*/