USE [HistoryExercise]
GO

CREATE TABLE [dbo].[Person](
[Id] [int] NOT NULL PRIMARY KEY Identity,
[Name] [nvarchar](50) NOT NULL
)
GO

CREATE TABLE [dbo].[PersonHistory](
[Id] [int] NOT NULL PRIMARY KEY Identity,
[PersonId] [int] NOT NULL,
[PersonName] [nvarchar](50) NOT NULL,
[PersonOperation] [nvarchar](50) NOT NULL
)
GO

CREATE TRIGGER [dbo].[trgCopyPersonHistory]
ON [dbo].[Person]
AFTER DELETE, UPDATE
AS
	INSERT INTO [dbo].[PersonHistory] (PersonId, PersonName, PersonOperation)
	SELECT Id, Name, 
			(CASE 
				WHEN EXISTS(SELECT * FROM INSERTED) THEN 'Updated'
				ELSE 'Deleted'
            End) as Operation
	FROM DELETED;
GO

INSERT INTO [dbo].[Person] (Name)
VALUES ('Dido'), ('Gosho'), ('Pesho');
GO

DELETE FROM [dbo].[Person] WHERE Name = 'Dido'
GO

UPDATE [dbo].[Person] SET Name = 'Gosho2' WHERE Name = 'Gosho'
GO

UPDATE [dbo].[Person] SET Name = 'Gosho3' WHERE Name = 'Gosho2'
GO
