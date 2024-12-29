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
CREATE PROCEDURE EditModul
@ModulID int,
    @Title NVARCHAR(50) = NULL,
    @Description NVARCHAR(MAX) = NULL,
    @DateOf datetime = NULL,
    @Link NVARCHAR(100) = NULL,
    @Room NVARCHAR(10) = NULL,
	@Limit int = NULL,
	@ExpireDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczêcie transakcji
        BEGIN TRANSACTION;

		IF @ModulID IS NULL OR NOT EXISTS (SELECT 1 FROM Moduls WHERE Modul_ID = @ModulID)
		BEGIN
			raiserror('Modul o podanym ID nie istnieje.', 16, 1);
		END

		DECLARE @CourseID int;
		SELECT @CourseID = (SELECT CourseVersion_ID FROM Moduls WHERE Modul_ID = @ModulID);

		IF @DateOf IS NOT NULL AND (@DateOf<GETDATE() OR @DateOf > (select EndDate from CourseVersions WHERE CourseVersion_ID = @CourseID) OR @DateOf <(select StartDate from CourseVersions WHERE CourseVersion_ID = @CourseID))
		BEGIN
			raiserror('Data modulu nie jest w zakresie.', 16, 1);
		END

		UPDATE Moduls
		SET 
			Title = ISNULL(@Title, Title),
			Description = ISNULL(@Description, Description),
			DateOf = ISNULL(@DateOf, DateOf)
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
				raiserror('Data modulu nie jest w zakresie.', 16, 1);
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

		PRINT 'CourseModul zosta³ zmieniony.';

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