SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SetLaterPayment
	@OrderDetails_ID int
AS
BEGIN
	SET NOCOUNT ON;

    IF (SELECT Status from OrdersDetails where OrderDetails_ID=@OrderDetails_ID) != 'Wait For Payment'
	BEGIN
		raiserror('Tego zamówienia ju¿ nie mo¿na edytowaæ.', 16, 1);
	END

	UPDATE OrdersDetails 
	SET
		Status='Later Payment'
	WHERE OrderDetails_ID=@OrderDetails_ID

	PRINT'Zmieniono status pomyœlnie';
END
GO
