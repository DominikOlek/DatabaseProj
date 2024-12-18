USE [Projekt]
GO
/****** Object:  StoredProcedure [dbo].[AddNewWebinar]    Script Date: 09.12.2024 23:41:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AddNewWebinar]
	@WebinarID int = NULL,
    @Title NVARCHAR(50)= NULL,
    @Description NVARCHAR(MAX) = NULL,
    @DateOf datetime,
    @Link NVARCHAR(100) = NULL,
    @Price decimal(8,2),
    @TeacherL_ID int,
    @Translator_ID int = NULL
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczęcie transakcji
        BEGIN TRANSACTION;

		IF @WebinarID IS NULL AND @Title IS NULL
		BEGIN
			PRINT 'Wrong data, give title or id.';
			RETURN;
		END

		IF @DateOf<GETDATE()
		BEGIN
			PRINT 'Wrong datatime';
			RETURN;
		END

		IF @WebinarID IS NOT NULL AND EXISTS (SELECT 1 FROM Webinars WHERE Webinar_ID = @WebinarID)
		BEGIN
			IF @Title IS NOT NULL OR @Description IS NOT NULL
			BEGIN
				UPDATE Webinars
				SET 
					Title = ISNULL(@Title, Title),
					Description = ISNULL(@Description, Description)
				WHERE Webinar_ID = @WebinarID;
			END

			INSERT INTO WebinarsVersion(
				DateOf,Link,Price,TeacherLanguage_ID,Translator_ID
			)
			VALUES (
				@DateOf,@Link,@Price,@TeacherL_ID,@Translator_ID
			);
			PRINT 'WebinarVersion already exists.';
			RETURN;
		END

		INSERT INTO Webinars(
			Title,Description
		)
		VALUES (
			@Title,@Description
		);


		INSERT INTO WebinarsVersion(
			Webinar_ID,DateOf,Link,Price,TeacherLanguage_ID,Translator_ID
		)
		VALUES (	
			SCOPE_IDENTITY(),@DateOf,@Link,@Price,@TeacherL_ID,@Translator_ID
		);
		PRINT 'WebinarVersion already exists.';

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
