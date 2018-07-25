# todo: use SqlServer module to create the json to pass to be used by the start.ps1

$dbDataFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016XP\MSSQL\DATA\TestDb.mdf'
$sql = "dbcc checkprimaryfile (N'$dbDataFilePath' , 2)"
(sqlcmd -Q $sql -S localhost\sql2016xp | ? { $_ -like 'Database name*' })