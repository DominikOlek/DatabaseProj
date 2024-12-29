SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE UpdateSubjectForStudy
	@SubjectForStudy_ID int,
	@Name varchar(30) = NULL,
	@ECTS int = NULL,
	@NumberOfMeeting int = NULL,
	@Term int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @SubjectForStudy_ID IS NULL OR NOT EXISTS (SELECT 1 FROM SubjectForStudy WHERE ExampleSubject_ID = @SubjectForStudy_ID)
		BEGIN
			raiserror('Nie istnieje przedmiot studiów o takim ID.', 16, 1);
		END

	UPDATE SubjectForStudy
		SET 
			Name = ISNULL(@Name, Name),
			ECTS = ISNULL(@ECTS, ECTS),
			NumberOfMeeting = ISNULL(@NumberOfMeeting, NumberOfMeeting),
			Term = ISNULL(@Term,Term)
		WHERE ExampleSubject_ID = @SubjectForStudy_ID;
	PRINT 'Przedmiot zosta³ zaktualizowany pomyœlnie.';
END
GO
