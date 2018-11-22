# Microsoft SQL Express on Windows image

Fork of official [microsoft/mssql-server-windows-express](https://github.com/Microsoft/mssql-docker/blob/master/windows/mssql-server-windows-express/dockerfile)

**Workarounds for:**
* official dockerfile does not support Windows Server 1803 (track [304](https://github.com/Microsoft/mssql-docker/issues/304))
* no support for `Latin1_General_CI_AS` SQL Collation


## Differences to offical image:
* Windows server core 1803
* Images for specific collation. EG SQL_Latin1_General_CP1_CI_AS, Latin1_General_CI_AS
* Volume mount paths for user database files and database backups
* SQL Server instance name changed to `DOCKERSQL`


## Supported tags

* `latest`, `1803`, `2017-latest`, `2017-GA, SQL_Latin1_General_CP1_CI_AS`, `SQL_Latin1_General_CP1_CI_AS-1803`, `2017-latest-SQL_Latin1_General_CP1_CI_AS`, `2017-GA-SQL_Latin1_General_CP1_CI_AS`, `2017-GA-SQL_Latin1_General_CP1_CI_AS-1803` [Dockerfile](https://github.com/christianacca/dockerfiles/blob/master/mssql-server-windows-express/dockerfile)
* `Latin1_General_CI_AS`, `Latin1_General_CI_AS-1803`, `2017-latest-Latin1_General_CI_AS`, `2017-GA-Latin1_General_CI_AS`, `2017-GA-Latin1_General_CI_AS-1803` [Dockerfile](https://github.com/christianacca/dockerfiles/blob/master/mssql-server-windows-express/dockerfile)

