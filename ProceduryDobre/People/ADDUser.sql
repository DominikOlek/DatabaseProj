-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE AddUser 
	@Name NVARCHAR(20),
    @LastName NVARCHAR(20),
    @Email NVARCHAR(50),
    @Password NVARCHAR(MAX),
    @PhoneNumber NVARCHAR(15) = NULL,
    @ConfirmDataMg BIT = 0,
    @Pesel NVARCHAR(11) = NULL,
	@ISO_Confirm BIT = 1,
	@PostalCode varchar(8),
	@Adress varchar(50),
	@City_ID int
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
		raiserror('U¿ytkownik o podanym emailu ju¿ istnieje.', 16, 1);
    END

    IF @Pesel IS NOT NULL AND EXISTS (SELECT 1 FROM Users WHERE Pesel = @Pesel)
    BEGIN
		raiserror('U¿ytkownik o podanym peselu ju¿ istnieje.', 16, 1);
    END

	IF NOT EXISTS (SELECT 1 FROM Cities WHERE City_ID = @City_ID)
    BEGIN
		raiserror('Nie dodano jeszcze takiego miasta.', 16, 1);
    END


    INSERT INTO Users(
        Name, LastName, Email, Password, PhoneNumber, 
        ConfirmDataMg, Pesel, ISO_Confirm
    )
    VALUES (
        @Name, @LastName, @Email, @Password, @PhoneNumber, 
        @ConfirmDataMg, @Pesel, @ISO_Confirm
    );


	INSERT INTO Adresses(
        User_ID,City_ID,PostalCode,Adress
    )
    VALUES (
        SCOPE_IDENTITY(),@City_ID,@PostalCode,@Adress
    );

    PRINT 'Dodano nowego u¿ytkownika pomyœlnie.';
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
