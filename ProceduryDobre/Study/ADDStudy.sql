
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ADDStudy
	@Name NVARCHAR(50),
    @Description NVARCHAR(MAX) = NULL
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO Studies(
		Description,Name
	)
	VALUES (
		@Description,@Name
	);
	PRINT 'Kierunek studi�w zosta� utworzony pomy�lnie.';
END
GO
