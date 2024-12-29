
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ActiveAccount
	@Email VARCHAR(50) = NULL

AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Users
	SET 
		ConfirmDataMg = 1
	WHERE Email = @Email;
	PRINT 'Aktywowano konto u¿ytkownika.';
END