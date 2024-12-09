CREATE PROCEDURE EditWebinarVersion 
	@WebinarID int,
    @DateOf datetime =NULL,
    @Link NVARCHAR(100) = NULL,
    @Price decimal(8,2) = NULL,
    @TeacherL_ID int = NULL,
    @Translator_ID int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @WebinarID IS NULL OR NOT EXISTS (SELECT 1 FROM WebinarsVersion WHERE WebinarVersion_ID = @WebinarID)
		BEGIN
			PRINT 'Wrong data, WebinarID.';
			RETURN;
		END

	IF @DateOf<GETDATE()
	BEGIN
		PRINT 'Wrong datatime';
		RETURN;
	END

	UPDATE WebinarsVersion
    SET 
        DateOf = ISNULL(@DateOf, DateOf),
        Link = ISNULL(@Link, Link),
        Price = ISNULL(@Price, Price),
        Translator_ID = ISNULL(@TeacherL_ID, Translator_ID),
        TeacherLanguage_ID = ISNULL(@Translator_ID, TeacherLanguage_ID)
    WHERE WebinarVersion_ID = @WebinarID;
END
GO
