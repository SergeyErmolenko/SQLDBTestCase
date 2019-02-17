CREATE TABLE [dbo].[Product]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[Code] VARCHAR(64) NOT NULL UNIQUE,
	[Name] VARCHAR(100) NOT NULL,
	[Price] DECIMAL(10, 2) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [CK_Product_Price] CHECK (Price > 0)
)

GO

CREATE TRIGGER [dbo].[TriggerProductUpdate]
    ON [dbo].[Product]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE pro SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN Product pro ON pro.Id = ins.Id;
    END
