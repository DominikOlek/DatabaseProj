SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddSubjectMeeting
	@Subject_ID INT,
	@Date datetime,
	@Description varchar(MAX),
	@Part_ID int,
	@ISOFFLINE BIT,
	@ISONLINE BIT,
	@Link NVARCHAR(50) = NULL,
    @Room NVARCHAR(10) = NULL,
	@Limit int = NULL,
    @MainTeacher_ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
        BEGIN TRANSACTION;
			IF @Part_ID is null or @Date > (select DateEnd from StudyParts WHERE Part_ID = @Part_ID) or  @Date < (select DateStart from StudyParts WHERE Part_ID = @Part_ID) 
			BEGIN
				raiserror('B³êdnie podany ID zjazdu.', 16, 1);
			END

			DECLARE @Study_ID int;
			SELECT @Study_ID = Study_ID from Subjects where Subject_ID=@Subject_ID;

			IF EXISTS (SELECT 1 FROM SubjectMeeting AS SB where Part_ID = @Part_ID and @Study_ID NOT IN (SELECT Study_ID from Subjects where Subject_ID=SB.Subject_ID))
			BEGIN
				raiserror('B³êdnie podany ID zjazdu. Ten zjazd nie dotyczy siê tego kierunku studiów', 16, 1);
			END

			IF @Subject_ID IS NULL OR NOT EXISTS (SELECT 1 FROM Subjects WHERE Subject_ID = @Subject_ID)
			BEGIN
				raiserror('Nie istnieje przedmiot studiów o takim ID.', 16, 1);
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

			INSERT INTO SubjectMeeting(
				Date,Description,Part_ID
			)
			VALUES (
				@Date,@Description,@Part_ID
			);

			DECLARE @MeetingID int;
			SELECT @MeetingID = SCOPE_IDENTITY();

			INSERT INTO TeachersForMeeting(
				Teacher_ID, Meeting_ID,Role_ID
			)
			VALUES (
				@MainTeacher_ID,@MeetingID,@RoleID
			);

			IF @ISOFFLINE = 1
			BEGIN
				IF @Room IS NULL
				BEGIN
					raiserror('Nie podano numeru pokoju.', 16, 1);
				END

				INSERT INTO StationaryMeet(
					Meeting_ID,Room,Limit
				)
				VALUES (
					@MeetingID,@Room,@Limit
				);
			END

			IF @ISONLINE = 1
			BEGIN
				IF @Link IS NULL
				BEGIN
					raiserror('Nie podano linku do modu³u.', 16, 1);
				END

				INSERT INTO RemoteMeet(
					Meeting_ID,Link
				)
				VALUES (
					@MeetingID,@Link
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
GO
