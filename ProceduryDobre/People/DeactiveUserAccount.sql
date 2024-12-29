SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeactiveUser
	@User_ID int
AS
BEGIN
	SET NOCOUNT ON;

	IF @User_ID IS NULL OR NOT EXISTS(SELECT 1 FROM Users where User_ID = @User_ID)
	BEGIN
		raiserror('U¿ytkownik o podanym ID nie istnieje.', 16, 1);
	END

    UPDATE Users
		SET 
			ConfirmDataMg = 0
		WHERE User_ID = @User_ID;
	PRINT 'Konto zosta³ deaktywowane pomyœlnie.';
END
GO
