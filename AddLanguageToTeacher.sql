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

	INSERT INTO TeachersLanguage(
        Teacher_ID,Language_ID
    )
    VALUES (
        @TeacherID,@LanguageID
    );
	PRINT 'New teacherLanguage added successfully.';
END
GO