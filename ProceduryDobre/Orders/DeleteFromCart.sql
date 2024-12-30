SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE DeleteOrderDetails 
	@OrderDetails_ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;
		IF (SELECT Status FROM OrdersDetails where OrderDetails_ID = @OrderDetails_ID) != 'Wait For Payment'
		BEGIN
			raiserror('Tego zamówienia nie mo¿na usun¹æ z bazy.', 16, 1);
		END

		IF EXISTS( SELECT 1 FROM WebinarOrders where Order_ID = @OrderDetails_ID)
		BEGIN
			DELETE FROM WebinarOrders where Order_ID = @OrderDetails_ID
		END

		ELSE IF EXISTS( SELECT 1 FROM CourseOrders where Order_ID = @OrderDetails_ID)
		BEGIN
			DELETE FROM CourseOrders where Order_ID = @OrderDetails_ID
		END
		ELSE IF EXISTS( SELECT 1 FROM StudiesOrders where Order_ID = @OrderDetails_ID)
		BEGIN
			DELETE FROM StudiesOrders where Order_ID = @OrderDetails_ID
		END
		ELSE IF EXISTS( SELECT 1 FROM OrderPart where Order_ID = @OrderDetails_ID)
		BEGIN
			DELETE FROM OrderPart where Order_ID = @OrderDetails_ID
		END

		DECLARE @OrderID int;
		SELECT @OrderID = Order_ID from OrdersDetails where OrderDetails_ID = @OrderDetails_ID;

		DELETE FROM OrdersDetails where Order_ID = @OrderDetails_ID

		IF NOT EXISTS(SELECT 1 FROM OrdersDetails where OrderDetails_ID = @OrderDetails_ID)
		BEGIN
			DELETE FROM Orders where Order_ID = @OrderID
		END
	COMMIT TRANSACTION;
	END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END
GO
