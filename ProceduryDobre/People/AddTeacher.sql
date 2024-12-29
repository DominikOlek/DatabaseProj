SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddTeacher
	@User_ID int,
	@AcademicTitle_ID int,
	@Status varchar(15)='Active'
AS
BEGIN
	IF @User_ID IS NULL OR NOT EXISTS(SELECT 1 FROM Users where User_ID = @User_ID)
	BEGIN
		raiserror('U¿ytkownik o podanym ID nie istnieje.', 16, 1);
	END

	IF @AcademicTitle_ID IS NULL OR NOT EXISTS(SELECT 1 FROM AcademicTitles where AcademicTitle_ID = @AcademicTitle_ID)
	BEGIN
		raiserror('Nie istnieje tytu³ naukowy o podanym ID.', 16, 1);
	END

	INSERT INTO Teachers(
        User_ID,AcademicTitle,Status
    )
    VALUES (
        @User_ID,@AcademicTitle_ID,@Status
    );

	PRINT 'Nauczyciel zosta³ dodany pomyœlnie.';
END
GO
