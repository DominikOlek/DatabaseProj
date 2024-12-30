SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddDetailOfCourse
	@Order_ID int,
	@User_ID int,
	@Course_ID int,
	@Tax decimal(4,2),
	@Discount decimal(3,2)= NULL,
	@Currency_ID varchar(3),
	@ConfirmDate date = NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;
		IF EXISTS( SELECT 1 FROM ModulsOwners where USER_ID = @User_ID AND Modul_ID IN (SELECT Modul_ID from Moduls where CourseVersion_ID = @Course_ID))
		BEGIN
			raiserror('U¿ytkownik jest ju¿ w posiadaniu tego kursu .', 16, 1);
		END
   
		IF NOT EXISTS(SELECT 1 FROM CourseVersions where CourseVersion_ID = @Course_ID) OR ( SELECT Available FROM CourseVersions where CourseVersion_ID = @Course_ID) = 0
		BEGIN
			raiserror('Ten kurs jest ju¿ niedostêpny .', 16, 1);
		END

		IF NOT EXISTS ( SELECT 1 FROM Currency where Currency_ID = @Currency_ID)
		BEGIN
			raiserror('Nie ma takiej waluty.', 16, 1);
		END

		IF (SELECT StartDate FROM CourseVersions where CourseVersion_ID = @Course_ID) < GETDATE()
		BEGIN
			raiserror('Ten kurs jest ju¿ niedostêpny.', 16, 1);
		END

		DECLARE @Cost decimal(8,2);
		SELECT @Cost = Price from CourseVersions where CourseVersion_ID = @Course_ID;

		INSERT INTO OrdersDetails(
			Order_ID,ConfirmDate,Cost,Status,Currency_ID,CurrencyValueToPLN,Discount,Tax
		) 
		VALUES(
			@Order_ID,ISNULL(@ConfirmDate,GETDATE()),@Cost,'Wait For Payment',@Currency_ID,(SELECT ValueToPLN from Currency where Currency_ID = @Currency_ID),@Discount,@Tax
		)

		INSERT INTO CourseOrders(
			Order_ID,Course_ID,Cost
		) 
		VALUES(
			@Order_ID,@Course_ID,@Cost
		)
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
