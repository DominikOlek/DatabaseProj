SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ADDStudyParts
	@DateStart datetime,
	@DateEnd datetime,
	@PriceForStudents decimal(8,2),
	@PriceForOutsiders decimal(8,2),
	@Limit int
AS
BEGIN
	SET NOCOUNT ON;

	IF @DateStart >= @DateEnd
	BEGIN
		raiserror('B³êdnie zdefiniowany okres.', 16, 1);
	END

	INSERT INTO StudyParts(
		DateStart,DateEnd,PriceForOutsiders,PriceForStudents,Limit
	)
	VALUES (
		@DateStart,@DateEnd,@PriceForOutsiders,@PriceForStudents,@Limit
	);
	
END
GO
