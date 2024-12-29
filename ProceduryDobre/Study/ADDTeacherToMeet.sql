SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddTeacherToMeeting
	@TeacherL_ID int,
	@Meeting_ID int,
	@Role_ID int
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM TeachersLanguage where TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			raiserror('Profil jêzykowy nauczyciela o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM SubjectMeeting where Meeting_ID = @Meeting_ID)
		BEGIN
			raiserror('Spotkanie o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM Roles where Role_ID = @Role_ID)
		BEGIN
			raiserror('Rola o podanym ID nie istnieje.', 16, 1);
		END

		INSERT INTO TeachersForMeeting(
			Teacher_ID,Meeting_ID,Role_ID
		)
		VALUES (
			@TeacherL_ID,@Meeting_ID,@Role_ID
		);

		PRINT 'Nauczyciel zosta³ dodany pomyœlnie do spotkania.';
	END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END
GO
