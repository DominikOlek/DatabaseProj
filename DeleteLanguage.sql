CREATE PROCEDURE AddLanguageToTeacher
	@TeacherID INT,              
    @LanguageID INT 
AS
BEGIN
	SET NOCOUNT ON;

	IF @TeacherID IS NULL OR NOT EXISTS(SELECT 1 FROM Teachers where Teacher_ID = @TeacherID)
	BEGIN
		PRINT 'Wrong Teacher_ID';
        RETURN;
	END

	IF @LanguageID IS NULL OR NOT EXISTS(SELECT 1 FROM Language where Language_ID = @LanguageID)
	BEGIN
		PRINT 'Wrong Language';
        RETURN;
	END

	DECLARE @TeacherLID int = NULL
	SELECT @TeacherLID = (select Teacher_ID FROM TeachersLanguage where Teacher_ID = @TeacherID AND Language_ID = @LanguageID)

	IF @TeacherLID IS NULL
	BEGIN
		PRINT 'Wrong IDs';
        RETURN;
	END

	IF EXISTS(SELECT 1 FROM WebinarsVersion where TeacherLanguage_ID = @TeacherLID OR Translator_ID = @TeacherLID ) OR
	EXISTS(SELECT 1 FROM Moduls where TeacherLanguage_ID = @TeacherLID OR Translator_ID = @TeacherLID ) OR
	EXISTS(SELECT 1 FROM SubjectMeeting where TeacherLanguage_ID = @TeacherLID OR Translator_ID = @TeacherLID )
	BEGIN
		PRINT 'This teacher have a meetings';
        RETURN;
	END


	DELETE FROM TeachersLanguage WHERE TeacherLanguage_ID = @TeacherLID
	PRINT 'TeacherLanguage delete successfully.';
END
GO