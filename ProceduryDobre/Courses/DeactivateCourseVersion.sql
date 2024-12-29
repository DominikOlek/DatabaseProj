SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeactivateCourseVersion
	@CourseVersion_ID int
AS
BEGIN
	SET NOCOUNT ON;
	IF @CourseVersion_ID IS NULL OR NOT EXISTS (SELECT 1 FROM CourseVersions WHERE CourseVersion_ID = @CourseVersion_ID)
		BEGIN
			raiserror('Kurs o podanym ID nie istnieje.', 16, 1);
		END

	IF EXISTS(SELECT 1 FROM CourseOrders where Course_ID = @CourseVersion_ID)
	BEGIN
		PRINT 'Kurs ma aktywne zamówienia. Status ustawiono na No for Buy';
		UPDATE CourseVersions
		SET 
			Available = 0,
			Status = 'No For Buy'
		WHERE CourseVersion_ID = @CourseVersion_ID;
	END

	RETURN

	UPDATE CourseVersions
    SET 
        Available = 0,
		Status = 'Inactive'
    WHERE CourseVersion_ID = @CourseVersion_ID;

	PRINT 'Kurs zosta³ deaktywowany.';

END
GO