SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE InitalizeStudyYear
	@StudyName_ID int,
	@Price decimal(8,2),
	@StartYear varchar(9)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
        BEGIN TRANSACTION;

		IF @StudyName_ID IS NULL OR NOT EXISTS (SELECT 1 FROM Studies WHERE StudyName_ID = @StudyName_ID)
		BEGIN
			raiserror('Nie istnieje kierunek studiów o takim ID.', 16, 1);
		END

		IF @Price IS NULL OR @Price<0
		BEGIN
			raiserror('Cena wpisowego musi byæ >=0.', 16, 1);
		END

		INSERT INTO StudiesYear(
			StudyName_ID,Price,StartYear
		)
		VALUES (
			@StudyName_ID,@Price,@StartYear
		);

		DECLARE @Name varchar(30);
		DECLARE @ECTS int;
		DECLARE @NumberOfMeeting int;
		DECLARE @Term int;

		DECLARE Subjects CURSOR FOR
		SELECT Name,ECTS,NumberOfMeeting,Term
		FROM SubjectForStudy where StudyName_ID = @StudyName_ID;

		OPEN Subjects;

		FETCH NEXT FROM Subjects INTO @Name,@ECTS,@NumberOfMeeting,@Term

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO Subjects(Study_ID,Name,ECTS,NumberOfMeeting,Term,PriceForOneMeet)
			VALUES(@StudyName_ID,@Name,@ECTS,@NumberOfMeeting,@Term,NULL)

			FETCH NEXT FROM EmployeeCursor INTO @Name,@ECTS,@NumberOfMeeting,@Term
		END;

		CLOSE Subjects;
		DEALLOCATE Subjects;

	PRINT 'Instancja kierunku studiów, oraz przepisanie przedmiotów zosta³y dokonane pomyœlnie. Nie zapomnij ustawiæ ceny przedmiotów';

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
