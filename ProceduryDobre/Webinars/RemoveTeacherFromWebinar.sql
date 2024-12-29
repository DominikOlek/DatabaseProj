SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE RemoveTeacherForWebinar
	@TeacherL_ID int,
	@Webinar_ID int
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM TeachersLanguage where TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			raiserror('TeacherLanguage o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM WebinarsVersion where WebinarVersion_ID = @Webinar_ID)
		BEGIN
			raiserror('WebinarsVersion o podanym ID nie istnieje.', 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM TeachersForWebinar where WebinarVersion_ID =@Webinar_ID and Teacher_ID != @TeacherL_ID)
	BEGIN
		raiserror('Nie dozwolone, poniewa¿ musi zostaæ chocia¿ jeden nauczyciel do webinaru.', 16, 1);
	END

	DELETE FROM TeachersForWebinar where WebinarVersion_ID =@Webinar_ID and Teacher_ID = @TeacherL_ID;
	PRINT 'Usuniêto nauczyciela z kursu pomyœlnie';
END
GO
