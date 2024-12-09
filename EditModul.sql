CREATE PROCEDURE EditModul
	@ModulID int,
    @Title NVARCHAR(50) = NULL,
    @Description NVARCHAR(MAX) = NULL,
    @DateOf datetime = NULL,
    @Link NVARCHAR(100) = NULL,
    @Room NVARCHAR(10) = NULL,
	@Limit int = NULL,
	@ExpireDate date = NULL,
    @TeacherL_ID int = NULL,
    @Translator_ID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczêcie transakcji
        BEGIN TRANSACTION;

		IF @ModulID IS NULL OR NOT EXISTS (SELECT 1 FROM Moduls WHERE Modul_ID = @ModulID)
		BEGIN
			PRINT 'Wrong data.';
			RETURN;
		END

		DECLARE @CourseID int;
		SELECT @CourseID = (SELECT CourseVersion_ID FROM Moduls WHERE Modul_ID = @ModulID);

		IF @TeacherL_ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TeachersLanguage WHERE TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			PRINT 'Wrong teacher.';
			RETURN;
		END

		IF @DateOf IS NOT NULL AND (@DateOf<GETDATE() OR @DateOf > (select EndDate from CourseVersions WHERE CourseVersion_ID = @CourseID) OR @DateOf <(select StartDate from CourseVersions WHERE CourseVersion_ID = @CourseID))
		BEGIN
			PRINT 'Wrong datatime';
			RETURN;
		END

		UPDATE Moduls
		SET 
			Title = ISNULL(@Title, Title),
			Description = ISNULL(@Description, Description),
			DateOf = ISNULL(@DateOf, DateOf),
			TeacherLanguage_ID = ISNULL(@TeacherL_ID, TeacherLanguage_ID),
			Translator_ID = ISNULL(@Translator_ID, Translator_ID)
		WHERE Modul_ID = @ModulID;


		IF EXISTS(SELECT 1 FROM StationaryModulsC WHERE Modul_ID = @ModulID)
		BEGIN
			UPDATE StationaryModulsC
			SET 
				Room = ISNULL(@Room, Room),
				Limit = ISNULL(@Limit, Limit)
			WHERE Modul_ID = @ModulID;
		END

		IF EXISTS(SELECT 1 FROM RemoteModulsUnSynchronize WHERE Modul_ID = @ModulID)
		BEGIN
			IF @ExpireDate IS NOT NULL AND @DateOf IS NOT NULL AND @ExpireDate < @DateOf
			BEGIN
				RAISERROR('Error, dataof is latter than expire', 16, 1);
			END

			UPDATE RemoteModulsUnSynchronize
			SET 
				ExpireDate = ISNULL(@ExpireDate, ExpireDate),
				Link = ISNULL(@Link, Link)
			WHERE Modul_ID = @ModulID;
		END

		IF EXISTS(SELECT 1 FROM RemoteModulsSynchronize WHERE Modul_ID = @ModulID)
		BEGIN
			UPDATE RemoteModulsSynchronize
			SET 
				Link = ISNULL(@Link, Link)
			WHERE Modul_ID = @ModulID;
		END

		PRINT 'CourseModul already change.';

        COMMIT TRANSACTION;
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
