SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EditUser
	@User_ID int,
	@Name NVARCHAR(20) = NULL,
    @LastName NVARCHAR(20)= NULL,
    @Password NVARCHAR(MAX)= NULL,
    @PhoneNumber NVARCHAR(15) = NULL,
	@ISO_Confirm BIT = NULL,
	@PostalCode varchar(8)= NULL,
	@Adress varchar(50)= NULL,
	@City_ID int= NULL
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;

	IF @User_ID IS NULL OR NOT EXISTS(SELECT 1 FROM Users where User_ID = @User_ID)
	BEGIN
		raiserror('U¿ytkownik o podanym ID nie istnieje.', 16, 1);
	END

	IF NOT EXISTS (SELECT 1 FROM Cities WHERE City_ID = @City_ID)
    BEGIN
		raiserror('Nie dodano jeszcze takiego miasta.', 16, 1);
    END

	UPDATE Users
		SET 
			Name = ISNULL(@Name, Name),
			LastName = ISNULL(@LastName, LastName),
			Password = ISNULL(@Password, Password),
			PhoneNumber = ISNULL(@PhoneNumber,PhoneNumber),
			ISO_Confirm = ISNULL(@ISO_Confirm,ISO_Confirm)
		WHERE User_ID = @User_ID;


	UPDATE Adresses
		SET
			City_ID = ISNULL(@City_ID,City_ID),
			PostalCode = ISNULL(@PostalCode, PostalCode),
			Adress = ISNULL(@Adress, Adress)
		WHERE User_ID = @User_ID;

    PRINT 'Zaktualizowano dane u¿ytkownika pomyœlnie.';
	COMMIT TRANSACTION;
	END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
