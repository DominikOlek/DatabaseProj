SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeactivateWebinar
	@WebinarID int
AS
BEGIN
	SET NOCOUNT ON;
	IF @WebinarID IS NULL OR NOT EXISTS (SELECT 1 FROM WebinarsVersion WHERE WebinarVersion_ID = @WebinarID)
		BEGIN
			raiserror('Webinar o podanym ID nie istnieje.', 16, 1);
		END

	IF EXISTS(SELECT 1 FROM WebinarOrders where WebinarVersion_ID = @WebinarID)
	BEGIN
		PRINT 'Webinar ma aktywne zamówienia. Status ustawiono na No for Buy';
		UPDATE WebinarsVersion
		SET 
			Available = 0,
			Status = 'No For Buy'
		WHERE WebinarVersion_ID = @WebinarID;
	END

	UPDATE WebinarsVersion
    SET 
        Available = 0,
		Status = 'Inactive'
    WHERE WebinarVersion_ID = @WebinarID;

	PRINT 'Webinar zosta³ deaktywowany.';
END
GO
