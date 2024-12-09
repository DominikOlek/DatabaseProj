USE [Projekt]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[UpdateUserData]
		@User_ID = 3,
		@Name = N'Dawid'

SELECT	'Return Value' = @return_value

GO
