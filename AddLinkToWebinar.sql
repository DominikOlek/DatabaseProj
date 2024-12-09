CREATE PROCEDURE AddLinkToWebinar
	@WebinarID int,
	@Link NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE WebinarsVersion
    SET 
        Link = @Link
    WHERE Webinar_ID = @WebinarID;
END
GO
