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
CREATE PROCEDURE AddTeacherToModule
	@TeacherL_ID int,
	@Modul_ID int,
	@Role_ID int
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS (SELECT 1 FROM TeachersLanguage where TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			raiserror('Profil jêzykowy nauczyciela o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM Moduls where Modul_ID = @Modul_ID)
		BEGIN
			raiserror('Modu³ o podanym ID nie istnieje.', 16, 1);
		END

		IF NOT EXISTS (SELECT 1 FROM Roles where Role_ID = @Role_ID)
		BEGIN
			raiserror('Rola o podanym ID nie istnieje.', 16, 1);
		END

		INSERT INTO TeachersForModul(
			Teacher_ID,Modul_ID,Role_ID
		)
		VALUES (
			@TeacherL_ID,@Modul_ID,@Role_ID
		);

		PRINT 'Nauczyciel zosta³ dodany pomyœlnie do modu³u.';
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