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
CREATE PROCEDURE ChangeTeacherStatus
	@TeacherID INT,              
    @LanguageID INT,
	@Active BIT
AS
BEGIN
	SET NOCOUNT ON;

	IF @TeacherID IS NULL OR NOT EXISTS(SELECT 1 FROM Teachers where Teacher_ID = @TeacherID)
	BEGIN
		raiserror('Nauczyciel o podanym ID nie istnieje.', 16, 1);
	END

	IF @LanguageID IS NULL OR NOT EXISTS(SELECT 1 FROM Language where Language_ID = @LanguageID)
	BEGIN
		raiserror('Jêzyk o podanym ID nie istnieje.', 16, 1);
	END

	DECLARE @TeacherLID int = NULL
	SELECT @TeacherLID = (select Teacher_ID FROM TeachersLanguage where Teacher_ID = @TeacherID AND Language_ID = @LanguageID)

	IF @TeacherLID IS NULL
	BEGIN
		raiserror('Nie istnieje taki jêzyk przypisany dla danego nauczyciela.', 16, 1);
	END

	IF EXISTS(SELECT 1 FROM WebinarsVersion where TeacherLanguage_ID = @TeacherLID OR Translator_ID = @TeacherLID ) OR
	EXISTS(SELECT 1 FROM Moduls where TeacherLanguage_ID = @TeacherLID OR Translator_ID = @TeacherLID ) OR
	EXISTS(SELECT 1 FROM SubjectMeeting where TeacherLanguage_ID = @TeacherLID OR Translator_ID = @TeacherLID )
	BEGIN
		raiserror('Niedozwolone, nauczyciel ma wa¿ne spotkania.', 16, 1);
	END


	UPDATE TeachersLanguage
	SET 
		Active = @Active
	WHERE TeacherLanguage_ID = @TeacherLID;
	PRINT 'Status zosta³ zmieniony.';
END
