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
CREATE PROCEDURE ADDAcademicTitle
	@Title varchar(20)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM AcademicTitles where Title = @Title)
	BEGIN
		raiserror('Taki tytu³ naukowy ju¿ istnieje.', 16, 1);
	END

	INSERT INTO AcademicTitles(Title) VALUES(@Title)
	PRINT 'Dodano nowy tytu³ naukowy.';
END
GO
