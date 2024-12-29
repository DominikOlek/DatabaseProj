SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddNewCourse
	@CourseID int = NULL,
    @Title NVARCHAR(50)= NULL,
    @Description NVARCHAR(MAX) = NULL,
    @StartDate datetime,
	@EndDate datetime,
    @Price decimal(8,2),
	@Status varchar(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION;

		IF @CourseID IS NULL AND @Title IS NULL
		BEGIN
			raiserror('Musisz podaæ tytu³ lub ID Kursu.', 16, 1);
		END

		IF @StartDate>@EndDate OR @EndDate < GETDATE()
		BEGIN
			raiserror('Data nie jest w poprawnym zakresie.', 16, 1);
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
				StartDate,EndDate,Price,Available,Status
			)
			VALUES (
				@StartDate,@EndDate,@Price,1,@Status
			);
			PRINT 'Wersja kursu zosta³a dodana.';
			RETURN;
		END

		INSERT INTO Courses(
			Title,Description
		)
		VALUES (
			@Title,@Description
		);


		INSERT INTO CourseVersions(
			Course_ID,StartDate,EndDate,Price,Available,Status
		)
		VALUES (
			SCOPE_IDENTITY(),@StartDate,@EndDate,@Price,1,@Status
		);
		PRINT 'Wersja kursu i Kurs zosta³y dodane.';

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