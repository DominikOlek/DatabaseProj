SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SetPriceForOneMeet
	@Subject_ID int,
	@Price decimal(8,2)
AS
BEGIN
	SET NOCOUNT ON;
	IF @Subject_ID IS NULL OR NOT EXISTS (SELECT 1 FROM Subjects WHERE Subject_ID = @Subject_ID)
		BEGIN
			raiserror('Nie istnieje przedmiot studiów o takim ID.', 16, 1);
		END

	UPDATE Subjects
		SET 
			PriceForOneMeet = @Price
		WHERE Subject_ID = @Subject_ID;
	PRINT 'Przedmiot zosta³ zaktualizowany pomyœlnie.';
END
GO
