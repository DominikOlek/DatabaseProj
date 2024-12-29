SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddTeacherLanguage
	@LanguageID int,
	@TeacherID int
AS
BEGIN
	SET NOCOUNT ON;
	IF @TeacherID IS NULL OR NOT EXISTS(SELECT 1 FROM Teachers where Teacher_ID = @TeacherID)
	BEGIN
		raiserror('Nauczyciel o podanym ID nie istnieje.', 16, 1);
	END

	IF @LanguageID IS NULL OR NOT EXISTS(SELECT 1 FROM Language where Language_ID = @LanguageID)
	BEGIN
		raiserror('J�zyk o podanym ID nie istnieje.', 16, 1);
	END

	INSERT INTO TeachersLanguage(
        Language_ID,Teacher_ID,Active
    )
    VALUES (
        @LanguageID,@TeacherID,1
    );

	PRINT 'Profil z j�zykiem danego nauczyciela zosta� dodany pomy�lnie.';
END
GO
