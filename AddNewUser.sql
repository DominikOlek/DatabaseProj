USE Projekt;
GO
CREATE PROCEDURE AddNewUser
    @Name NVARCHAR(20),
    @LastName NVARCHAR(20),
    @Email NVARCHAR(50),
    @Password NVARCHAR(MAX),
    @Adress NVARCHAR(50) = NULL,
    @PhoneNumber NVARCHAR(11) = NULL,
    @ConfirmDataMg BIT = 0,
    @Pesel NVARCHAR(11) = NULL,
    @Country_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie czy Email lub Pesel ju¿ istnieje w tabeli (dla unikalnoœci)
    IF EXISTS (SELECT 1 FROM Projekt.Users WHERE Email = @Email)
    BEGIN
        PRINT 'Error: Email already exists.';
        RETURN;
    END

    IF @Pesel IS NOT NULL AND EXISTS (SELECT 1 FROM Users WHERE Pesel = @Pesel)
    BEGIN
        PRINT 'Error: Pesel already exists.';
        RETURN;
    END

    -- Dodanie nowego u¿ytkownika
    INSERT INTO dbo.Users (
        Name, LastName, Email, Password, Adress, PhoneNumber, 
        ConfirmDataMg, Pesel, Country_ID
    )
    VALUES (
        @Name, @LastName, @Email, @Password, @Adress, @PhoneNumber, 
        @ConfirmDataMg, @Pesel, @Country_ID
    );

    PRINT 'New user added successfully.';
END;