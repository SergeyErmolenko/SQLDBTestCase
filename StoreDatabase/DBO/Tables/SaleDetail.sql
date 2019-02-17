CREATE TABLE [dbo].[SaleDetail]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[SaleId] BIGINT NOT NULL,
	[ProductId] BIGINT NOT NULL,
	[Quantity] DECIMAL(10, 2) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [CK_SaleDetail_Quantity] CHECK (Quantity > 0)
)

GO

CREATE TRIGGER [dbo].[TriggerSaleDetailUpdate]
    ON [dbo].[SaleDetail]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE sd SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN SaleDetail sd ON sd.Id = ins.Id;
    END
