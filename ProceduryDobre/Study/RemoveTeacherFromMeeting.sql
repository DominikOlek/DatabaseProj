SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE RemoveTeacherForMeeting
	@TeacherL_ID int,
	@Meeting_ID int
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM TeachersLanguage where TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			raiserror('TeacherLanguage o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM SubjectMeeting where Meeting_ID = @Meeting_ID)
		BEGIN
			raiserror('Spotkanie o podanym ID nie istnieje.', 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM TeachersForMeeting where Meeting_ID =@Meeting_ID and Teacher_ID != @TeacherL_ID)
	BEGIN
		raiserror('Nie dozwolone, poniewa¿ musi zostaæ chocia¿ jeden nauczyciel do spotkania.', 16, 1);
	END

	DELETE FROM TeachersForMeeting where Meeting_ID =@Meeting_ID and Teacher_ID = @TeacherL_ID;
	PRINT 'Usuniêto nauczyciela z spoktania pomyœlnie';
END
GO
