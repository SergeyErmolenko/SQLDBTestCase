CREATE TABLE [dbo].[PriceRange]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[Code] VARCHAR(64) NOT NULL UNIQUE DEFAULT NEWID(),
	[Name] VARCHAR(100) NOT NULL,
	[PriceLow] DECIMAL(10, 2) NOT NULL,
	[PriceHigh] DECIMAL(10, 2) NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE()
)

GO

CREATE TRIGGER [dbo].[TriggerPriceRangeUpdate]
    ON [dbo].[PriceRange]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE pr SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN PriceRange pr ON pr.Id = ins.Id;
    END