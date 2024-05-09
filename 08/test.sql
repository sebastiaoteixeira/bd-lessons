USE master;
GO

-- Restore Database from Backup File on Local Machine
RESTORE DATABASE p8g9
FROM DISK = '/home/sebastiao/Projects/uni/bd/bd-lessons/08/Aula8_Material/Aula8_Material/AdventureWorks2012.bak'
WITH MOVE '/home/sebastiao/Projects/uni/bd/bd-lessons/08/Aula8_Material/Aula8_Material/AdventureWorks2012_Data' TO 'C:\Data\p8g9.mdf',
     MOVE '/home/sebastiao/Projects/uni/bd/bd-lessons/08/Aula8_Material/Aula8_Material/AdventureWorks2012_Log' TO 'C:\Logs\p8g9_log.ldf',
     REPLACE;
GO