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
CREATE PROCEDURE ADDCity
	@Country_ID int,
	@CityName varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Cities where Country_ID = @Country_ID AND CityName=@CityName)
	BEGIN
		raiserror('Takie miasto ju¿ istnieje.', 16, 1);
	END

	IF NOT EXISTS(SELECT 1 FROM Countries where Country_ID = @Country_ID)
	BEGIN
		raiserror('Nie dodano jeszcze takiego kraju.', 16, 1);
	END

	INSERT INTO Cities(Country_ID,CityName) VALUES(@Country_ID,@CityName);
	PRINT 'Dodano miasto pomyœlnie.';
END
GO
