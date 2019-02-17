CREATE TABLE [dbo].[AdditionalProductParameter]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[Code] VARCHAR(64) NOT NULL UNIQUE,
	[Name] VARCHAR(128) NOT NULL,
	[DataTypeId] BIGINT NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[CreatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_AdditionalProductParameter_DataType] FOREIGN KEY ([DataTypeId]) REFERENCES [DataType]([Id])
)

GO

CREATE TRIGGER [dbo].[TriggerAdditionalProductParameterParameterUpdate]
    ON [dbo].[AdditionalProductParameter]
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE app SET UpdatedOn = GETDATE()
		FROM inserted ins 
		INNER JOIN AdditionalProductParameter app ON app.Id = ins.Id;
    END	