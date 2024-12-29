SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddStudentIntern
	@Study_ID int,
	@Student_ID varchar(6),
	@Term int,
	@StartDate date,
	@Place varchar(50),
	@Description varchar(MAX),
	@NumberOfAttend int
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM Students where Student_ID = @Student_ID)
	BEGIN
		raiserror('Student o podanym numerze nie istnieje.', 16, 1);
	END

	IF NOT EXISTS(SELECT 1 FROM StudiesYear where @Study_ID = @Study_ID)
	BEGIN
		raiserror('Kierunek studiów o podanym numerze nie istnieje.', 16, 1);
	END

	IF NOT EXISTS(SELECT 1 FROM StudentsToStudy where Study_ID = @Study_ID and Student_ID=@Student_ID)
	BEGIN
		raiserror('Ten student nie jest studentem tego kierunku.', 16, 1);
	END

	IF (SELECT COUNT(*) FROM Intern where Study_ID = @Study_ID and Student_ID=@Student_ID and Term = @Term GROUP BY Student_ID) >= 2
	BEGIN
		raiserror('Ten student ma ju¿ wystarczaj¹c¹ iloœæ praktyk.', 16, 1);
	END

	INSERT INTO Intern(
		Study_ID,Student_ID,Term,StartDate,Place,Description,NumberOfAttend
	)VALUES(
		@Study_ID,@Student_ID,@Term,@StartDate,@Place,@Description,@NumberOfAttend
	)
    
	PRINT 'Dodano wpis o praktykach pomyœlnie.';
END
GO
