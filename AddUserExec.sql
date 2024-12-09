USE [Projekt]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[AddNewUser]
		@Name = N'Dominik',
		@LastName = N'Oleksy',
		@Email = N'ww@wp.pl',
		@Password = N'asdasd123ca',
		@Adress = N'Klecza Górna Pagórek 92',
		@PhoneNumber = N'992005882',
		@Country_ID = 1

SELECT	'Return Value' = @return_value

GO
