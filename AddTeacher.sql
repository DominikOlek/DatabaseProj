CREATE PROCEDURE AddTeacher
	@User_ID INT,              
    @AcademicTitleID INT 
AS
BEGIN
	SET NOCOUNT ON;

	IF @User_ID IS NULL OR NOT EXISTS(SELECT 1 FROM Users where User_ID = @User_ID)
	BEGIN
		PRINT 'Wrong User_ID';
        RETURN;
	END

	IF @AcademicTitleID IS NULL OR NOT EXISTS(SELECT 1 FROM AcademicTitles where AcademicTitle_ID = @AcademicTitleID)
	BEGIN
		PRINT 'Wrong Title';
        RETURN;
	END

	INSERT INTO Teachers(
        User_ID,AcademicTitle
    )
    VALUES (
        @User_ID,@AcademicTitleID
    );
	PRINT 'New teacher added successfully.';
END
GO
