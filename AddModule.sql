CREATE PROCEDURE [dbo].AddModulsToCourse
	@CourseID int,
    @Title NVARCHAR(50),
    @Description NVARCHAR(MAX) = NULL,
    @DateOf datetime,
	@ISOFFLINE BIT,
	@ISONLINESYNC BIT,
	@ISONLINEASYNC BIT,
    @Link NVARCHAR(100) = NULL,
    @Room NVARCHAR(10) = NULL,
	@Limit int = NULL,
	@ExpireDate date = NULL,
    @TeacherL_ID int,
    @Translator_ID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczêcie transakcji
        BEGIN TRANSACTION;

		IF @ISONLINEASYNC =1 AND @ISONLINESYNC =1
		BEGIN
			PRINT 'Wrong data.';
			RETURN;
		END

		IF @CourseID IS NULL OR NOT EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @CourseID)
		BEGIN
			PRINT 'Wrong data.';
			RETURN;
		END

		IF @TeacherL_ID IS NULL OR NOT EXISTS (SELECT 1 FROM TeachersLanguage WHERE TeacherLanguage_ID = @TeacherL_ID)
		BEGIN
			PRINT 'Wrong teacher.';
			RETURN;
		END

		IF @DateOf<GETDATE() OR @DateOf > (select EndDate from CourseVersions WHERE CourseVersion_ID = @CourseID) OR @DateOf <(select StartDate from CourseVersions WHERE CourseVersion_ID = @CourseID)
		BEGIN
			PRINT 'Wrong datatime';
			RETURN;
		END

		INSERT INTO Moduls(
			DateOf,Description,Title,TeacherLanguage_ID,Translator_ID
		)
		VALUES (
			@DateOf,@Description,@Title,@TeacherL_ID,@Translator_ID
		);

		DECLARE @ModulID int;
		SELECT @ModulID = SCOPE_IDENTITY();

		IF @ISOFFLINE = 1
		BEGIN
			IF @Room IS NULL
			BEGIN
				RAISERROR('Error, no room', 16, 1);
			END

			INSERT INTO StationaryModulsC(
				Modul_ID,Room,Limit
			)
			VALUES (
				@ModulID,@Room,@Limit
			);
		END

		IF @ISONLINEASYNC = 1
		BEGIN
			IF @Link IS NULL or @ExpireDate IS NULL
			BEGIN
				RAISERROR('Error, no data', 16, 1);
			END

			IF @ExpireDate < @DateOf
			BEGIN
				RAISERROR('Error, dataof is latter than expire', 16, 1);
			END

			INSERT INTO RemoteModulsUnSynchronize(
				Modul_ID,Link,ExpireDate
			)
			VALUES (
				@ModulID,@Link,@ExpireDate
			);
		END

		IF @ISONLINESYNC = 1
		BEGIN
			IF @Link IS NULL
			BEGIN
				RAISERROR('Error, no data', 16, 1);
			END

			INSERT INTO RemoteModulsSynchronize(
				Modul_ID,Link
			)
			VALUES (
				@ModulID,@Link
			);
		END

		PRINT 'CourseModul already exists.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
