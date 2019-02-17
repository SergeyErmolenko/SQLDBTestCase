CREATE TABLE [dbo].[StoreAdditionalStoreParameterMapping]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[StoreId] BIGINT NOT NULL,
	[AdditionalStoreParameterId] BIGINT NOT NULL,
	[Value] VARCHAR(MAX) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_StoreAdditionalStoreParameterMapping_Store] FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id]),
	CONSTRAINT [FK_StoreAdditionalStoreParameterMapping_AdditionalStoreParameterMapping] FOREIGN KEY ([AdditionalStoreParameterId]) REFERENCES [AdditionalStoreParameter]([Id])
)

GO

CREATE TRIGGER [dbo].[TriggerStoreAdditionalStoreParameterMappingUpdate]
    ON [dbo].[StoreAdditionalStoreParameterMapping]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE sap SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN StoreAdditionalStoreParameterMapping sap ON sap.Id = ins.Id;
    END