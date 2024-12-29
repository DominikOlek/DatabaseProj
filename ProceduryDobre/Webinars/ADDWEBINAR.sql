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
CREATE PROCEDURE [dbo].[AddNewWebinar]
	@WebinarID int = NULL,
    @Title NVARCHAR(50)= NULL,
    @Description NVARCHAR(MAX) = NULL,
    @DateOf datetime,
	@Length int,
    @Link NVARCHAR(100) = NULL,
    @Price decimal(8,2),
    @TeacherL_ID int,
	@Available bit = 1,
	@Status varchar(10) = 'Active',
	@MainTeacher int
AS
BEGIN
SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczêcie transakcji
        BEGIN TRANSACTION;

		IF @WebinarID IS NULL AND @Title IS NULL
		BEGIN
			raiserror('Musisz podaæ tytu³ lub ID Webinaru.', 16, 1);
		END

		IF @DateOf<GETDATE()
		BEGIN
			raiserror('Data modulu nie jest w zakresie.', 16, 1);
		END

		IF @Length<=0
		BEGIN
			raiserror('D³ugoœæ trwania nieprawid³owa.', 16, 1);
		END

		IF @MainTeacher IS NULL OR NOT EXISTS (SELECT * FROM TeachersLanguage where TeacherLanguage_ID = @MainTeacher)
		BEGIN
			raiserror('Nie istnieje nauczyciel o podanym ID.', 16, 1);
		END

		DECLARE @RoleID int;
		IF NOT EXISTS (SELECT Role_ID from Roles where RoleName = 'leading')
		BEGIN
			INSERT INTO Roles(RoleName) values('leading');
		END
		SELECT @RoleID = Role_ID from Roles where RoleName = 'leading';



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
				DateOf,Link,Price,Length,Available,Status
			)
			VALUES (
				@DateOf,@Link,@Price,@Length,@Available,@Status
			);

			INSERT INTO TeachersForWebinar(
				Teacher_ID, WebinarVersion_ID,Role_ID
			)
			VALUES (
				@MainTeacher,SCOPE_IDENTITY(),@RoleID
			);

			PRINT 'WebinarVersion zosta³ utworzony.';
			RETURN;
		END

		INSERT INTO Webinars(
			Title,Description
		)
		VALUES (
			@Title,@Description
		);


		INSERT INTO WebinarsVersion(
			DateOf,Link,Price,Length,Available,Status
		)
		VALUES (
			@DateOf,@Link,@Price,@Length,@Available,@Status
		);

		INSERT INTO TeachersForWebinar(
			Teacher_ID, WebinarVersion_ID,Role_ID
		)
		VALUES (
			@MainTeacher,SCOPE_IDENTITY(),@RoleID
		);
		PRINT 'WebinarVersion i Webinar zosta³y utworzone.';

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
GO
