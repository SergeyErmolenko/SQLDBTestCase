CREATE TABLE [dbo].[Store]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[Code] VARCHAR(64) NOT NULL UNIQUE,
	[Name] VARCHAR(50) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE()
)

GO

CREATE TRIGGER [dbo].[TriggerStoreUpdate]
    ON [dbo].[Store]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE sto SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN Store sto ON sto.Id = ins.Id;
    END