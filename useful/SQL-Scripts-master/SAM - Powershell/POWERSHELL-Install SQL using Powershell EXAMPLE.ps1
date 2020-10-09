# Reference
# http://dutchdatadude.com/automatically-building-a-microsoft-bi-machine-using-powershell-installing-sql-server-post-10/

Start-Process $setupFile -NoNewWindow -Wait -ArgumentList "/ACTION=INSTALL /IACCEPTSQLSERVERLICENSETERMS /Q /INSTANCENAME=MSSQLSERVER /ERRORREPORTING=1 /SQMREPORTING=1 /AGTSVCACCOUNT=$sqlagentAccountNameFQ /AGTSVCPASSWORD=$Password /ASSVCACCOUNT=$ssasAccountNameFQ /ASSVCPASSWORD=$Password /ASSERVERMODE=MULTIDIMENSIONAL /ASSYSADMINACCOUNTS=$global:currentUserName /SQLSVCACCOUNT=$sqldbAccountNameFQ /SQLSVCPASSWORD=$Password /SQLSYSADMINACCOUNTS=$global:currentUserName /FILESTREAMLEVEL=1 /ISSVCACCOUNT=$ssisAccountNameFQ /ISSVCPASSWORD=$Password /RSINSTALLMODE=DefaultNativeMode /RSSVCACCOUNT=$ssrsAccountNameFQ /RSSVCPASSWORD=$Password /FEATURES=$featuresPass1"
Write-Log -Verbose  "SQL Server Installation Pass 1 completed: SQL, AS Multidimensional, RS Native, Data QUality Client, DQS IS, MDS, TOOLS, FullText, FileStreaming"
Start-Process $setupFile -NoNewWindow -Wait -ArgumentList "/ACTION=INSTALL /IACCEPTSQLSERVERLICENSETERMS /Q /INSTANCENAME=TABULAR /ERRORREPORTING=1 /SQMREPORTING=1 /ASSVCACCOUNT=$ssasAccountNameFQ /ASSVCPASSWORD=$Password /ASSERVERMODE=TABULAR /ASSYSADMINACCOUNTS=$global:currentUserName /FEATURES=$featuresPass2"
Write-Log -Verbose  "SQL Server Installation Pass 2 completed: RS SharePoint, AS Tabular"
