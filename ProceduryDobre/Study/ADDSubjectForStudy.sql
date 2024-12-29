SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddSubjectForStudy
	@StudyName_ID int,
	@Name varchar(30),
	@ECTS int,
	@NumberOfMeeting int,
	@Term int
AS
BEGIN
	SET NOCOUNT ON;

	IF @StudyName_ID IS NULL OR NOT EXISTS (SELECT 1 FROM Studies WHERE StudyName_ID = @StudyName_ID)
	BEGIN
		raiserror('Nie istnieje kierunek studiów o takim ID.', 16, 1);
	END

	INSERT INTO SubjectForStudy(
			StudyName_ID,Name,ECTS,NumberOfMeeting,Term
		)
		VALUES (
			@StudyName_ID,@Name,@ECTS,@NumberOfMeeting,@Term
		);
	END

	PRINT 'Modu³ kursu zosta³ utworzony pomyœlnie.';

END
GO
