SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ChangeStudentStatus
	@Study_ID int,
	@Student_ID varchar(6),
	@Status varchar(10),
	@EndDate date = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM StudentsToStudy where Student_ID = @Student_ID AND @Study_ID=@Study_ID)
	BEGIN
		raiserror('Student nie jest studentem tego kierunku.', 16, 1);
	END

	IF @Status not IN ('Active','Dean Leave','L4','InActive')
	BEGIN
		raiserror('Mo¿liwoœci statusu to: Active,InActive,Dean Leave,L4', 16, 1);
	END

	UPDATE StudentsToStudy
		SET
			Status = @Status,
			EndDate = ISNULL(@EndDate,EndDate)
		WHERE Student_ID = @Student_ID AND @Study_ID=@Study_ID

	PRINT 'Status zmieniono pomyœlnie pomyœlnie.';
END
GO
