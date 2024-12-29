SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE RemoveTeacherForModul
	@TeacherL_ID int,
	@Modul_ID int
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM TeachersLanguage where TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			raiserror('TeacherLanguage o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM Moduls where Modul_ID = @Modul_ID)
		BEGIN
			raiserror('Modul o podanym ID nie istnieje.', 16, 1);
		END

	IF NOT EXISTS (SELECT 1 FROM TeachersForModul where Modul_ID =@Modul_ID and Teacher_ID != @TeacherL_ID)
	BEGIN
		raiserror('Nie dozwolone, poniewa¿ musi zostaæ chocia¿ jeden nauczyciel do modu³u.', 16, 1);
	END

	DELETE FROM TeachersForModul where Modul_ID =@Modul_ID and Teacher_ID = @TeacherL_ID;
	PRINT 'Usuniêto nauczyciela z kursu pomyœlnie';
END
GO
