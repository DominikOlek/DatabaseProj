CREATE PROCEDURE EditWebinarVersion 
	@WebinarID int,
    @DateOf datetime =NULL,
    @Link NVARCHAR(100) = NULL,
	@Length int = NULL,
    @Price decimal(8,2) = NULL,
	@Available bit = NULL,
	@Status varchar(10) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @WebinarID IS NULL OR NOT EXISTS (SELECT 1 FROM WebinarsVersion WHERE WebinarVersion_ID = @WebinarID)
		BEGIN
			raiserror('Webinar o podanym ID nie istnieje.', 16, 1);
		END

	IF @Status IS NOT NULL AND @Status NOT IN ('Active','Inactive','No For Buy')
		BEGIN
			raiserror('Mo¿liwe statusy to Active, Inactive, No For Buy.', 16, 1);
		END

	IF @DateOf<GETDATE()
		BEGIN
			raiserror('Data modulu nie jest w zakresie.', 16, 1);
		END

	IF @Length<=0
		BEGIN
			raiserror('D³ugoœæ trwania nieprawid³owa.', 16, 1);
		END

	UPDATE WebinarsVersion
    SET 
        DateOf = ISNULL(@DateOf, DateOf),
        Link = ISNULL(@Link, Link),
        Price = ISNULL(@Price, Price),
        Length = ISNULL(@Length, Length),
        Available = ISNULL(@Available, Available),
		Status = ISNULL(@Status,Status)
    WHERE WebinarVersion_ID = @WebinarID;

	PRINT 'Dane webinaru zosta³y zaktualizowane.';
END
GO
