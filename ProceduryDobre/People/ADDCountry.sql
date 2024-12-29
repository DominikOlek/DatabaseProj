SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ADDCountry
	@CountryName varchar(15),
	@PhoneDirect varchar(2) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Countries where CountryName = @CountryName)
	BEGIN
		raiserror('Taki kraj ju¿ istnieje.', 16, 1);
	END

	INSERT INTO Countries(CountryName,PhoneDirect) VALUES(@CountryName,@PhoneDirect);
	PRINT 'Dodano kraj pomyœlnie.';
END
GO
