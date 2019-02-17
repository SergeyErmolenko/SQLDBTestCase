CREATE TABLE [dbo].[Sale]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[StoreId] BIGINT NOT NULL,
	[OperationDate] DATETIME NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_Sale_Store] FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id])
)

GO

CREATE TRIGGER [dbo].[TriggerSaleUpdate]
    ON [dbo].[Sale]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE sal SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN Sale sal ON sal.Id = ins.Id;
    END
