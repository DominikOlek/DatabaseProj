CREATE PROCEDURE [dbo].AddNewCourse
	@CourseID int = NULL,
    @Title NVARCHAR(50)= NULL,
    @Description NVARCHAR(MAX) = NULL,
    @StartDate datetime,
	@EndDate datetime,
    @Price decimal(8,2)
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczêcie transakcji
        BEGIN TRANSACTION;

		IF @CourseID IS NULL AND @Title IS NULL
		BEGIN
			PRINT 'Wrong data, give title or id.';
			RETURN;
		END

		IF @StartDate>@EndDate OR @StartDate<GETDATE()
		BEGIN
			PRINT 'Wrong datatime';
			RETURN;
		END

		IF @CourseID IS NOT NULL AND EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @CourseID)
		BEGIN
			IF @Title IS NOT NULL OR @Description IS NOT NULL
			BEGIN
				UPDATE Courses
				SET 
					Title = ISNULL(@Title, Title),
					Description = ISNULL(@Description, Description)
				WHERE Course_ID = @CourseID;
			END

			INSERT INTO CourseVersions(
				StartDate,EndDate,Price
			)
			VALUES (
				@StartDate,@EndDate,@Price
			);
			PRINT 'CourseVersion already exists.';
			RETURN;
		END

		INSERT INTO Courses(
			Title,Description
		)
		VALUES (
			@Title,@Description
		);


		INSERT INTO CourseVersions(
			Course_ID,StartDate,EndDate,Price
		)
		VALUES (
			SCOPE_IDENTITY(),@StartDate,@EndDate,@Price
		);
		PRINT 'CourseVersion already exists.';

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
