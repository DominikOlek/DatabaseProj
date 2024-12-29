SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddModuleToCourse
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
    @MainTeacher_ID int
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION;

		IF @ISONLINEASYNC =1 AND @ISONLINESYNC =1
		BEGIN
			raiserror('Spotkanie nie mo¿e byæ asnychroniczne i synchroniczne jednoczeœnie.', 16, 1);
		END

		IF @CourseID IS NULL OR NOT EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @CourseID)
		BEGIN
			raiserror('Nie istnieje kurs o takim ID.', 16, 1);
		END

		IF @MainTeacher_ID IS NULL OR NOT EXISTS (SELECT * FROM TeachersLanguage where TeacherLanguage_ID = @MainTeacher_ID)
		BEGIN
			raiserror('Nie istnieje nauczyciel o takim ID.', 16, 1);
		END

		DECLARE @RoleID int;
		IF NOT EXISTS (SELECT Role_ID from Roles where RoleName = 'leading')
		BEGIN
			INSERT INTO Roles(RoleName) values('leading');
		END
		SELECT @RoleID = Role_ID from Roles where RoleName = 'leading';

		IF @DateOf<GETDATE() OR @DateOf > (select EndDate from CourseVersions WHERE CourseVersion_ID = @CourseID) OR @DateOf <(select StartDate from CourseVersions WHERE CourseVersion_ID = @CourseID)
		BEGIN
			raiserror('Data nie jest w poprawnym zakresie.', 16, 1);
		END

		INSERT INTO Moduls(
			DateOf,Description,Title
		)
		VALUES (
			@DateOf,@Description,@Title
		);

		DECLARE @ModulID int;
		SELECT @ModulID = SCOPE_IDENTITY();

		INSERT INTO TeachersForModul(
			Teacher_ID, Modul_ID,Role_ID
		)
		VALUES (
			@MainTeacher_ID,@ModulID,@RoleID
		);

		IF @ISOFFLINE = 1
		BEGIN
			IF @Room IS NULL
			BEGIN
				raiserror('Nie podano numeru pokoju.', 16, 1);
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
				raiserror('Nie podano daty wygaœniêcia.', 16, 1);
			END

			IF @ExpireDate < @DateOf
			BEGIN
				raiserror('Data nie jest w poprawnym zakresie.', 16, 1);
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
				raiserror('Nie podano linku do modu³u.', 16, 1);
			END

			INSERT INTO RemoteModulsSynchronize(
				Modul_ID,Link
			)
			VALUES (
				@ModulID,@Link
			);
		END

		PRINT 'Modu³ kursu zosta³ utworzony pomyœlnie.';

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

