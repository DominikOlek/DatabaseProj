-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE EditCourseVersion
	@CourseV_ID int,
    @StartDate datetime = NULL,
	@EndDate datetime = NULL,
    @Price decimal(8,2) = NULL,
	@Status varchar(10) = NULL,
	@Available BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM CourseVersion where CourseVersion_ID = @CourseV_ID)
	BEGIN
		raiserror('Kurs o podanym ID nie istnieje.', 16, 1);
	END

	IF @Status IS NOT NULL AND @Status NOT IN ('Active','Inactive','No For Buy')
		BEGIN
			raiserror('Mo¿liwe statusy to Active, Inactive, No For Buy.', 16, 1);
		END

	IF (@StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @StartDate>@EndDate) OR (@StartDate IS NOT NULL AND @StartDate > (select EndDate from CourseVersions WHERE CourseVersion_ID = @CourseV_ID)) OR (@EndDate IS NOT NULL AND @EndDate < (select StartDate from CourseVersions WHERE CourseVersion_ID = @CourseV_ID))
	BEGIN
		raiserror('Data modulu nie jest w zakresie.', 16, 1);
	END

	UPDATE CourseVersions
		SET 
			StartDate = ISNULL(@StartDate, StartDate),
			EndDate = ISNULL(@EndDate, EndDate),
			Price = ISNULL(@Price, Price),
			Available = ISNULL(@Available,Available),
			Status = ISNULL(@Status,Status)
		WHERE CourseVersion_ID = @CourseV_ID;
	PRINT 'Kurs zosta³ zaktualizowany pomyœlnie.';

END;
GO