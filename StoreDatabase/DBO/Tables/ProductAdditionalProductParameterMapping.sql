CREATE TABLE [dbo].[ProductAdditionalProductParameterMapping]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[ProductId] BIGINT NOT NULL,
	[AdditionalProductParameterId] BIGINT NOT NULL,
	[Value] VARCHAR(MAX) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_ProductAdditionalProductParameterMapping_Product] FOREIGN KEY ([ProductId]) REFERENCES [Product]([Id]),
	CONSTRAINT [FK_ProductAdditionalProductParameterMapping_AdditionalProductParameterMapping] FOREIGN KEY ([AdditionalProductParameterId]) REFERENCES [AdditionalProductParameter]([Id])
)

GO

CREATE TRIGGER [dbo].[TriggerProductAdditionalProductParameterMappingMappingUpdate]
    ON [dbo].[ProductAdditionalProductParameterMapping]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE pap SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN ProductAdditionalProductParameterMapping pap ON pap.Id = ins.Id;
    END
