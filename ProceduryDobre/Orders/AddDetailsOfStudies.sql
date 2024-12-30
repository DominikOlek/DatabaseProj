SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddDetailOfStudy
	@Order_ID int,
	@User_ID int,
	@Study_ID int,
	@Tax decimal(4,2),
	@Discount decimal(3,2)= NULL,
	@Currency_ID varchar(3),
	@ConfirmDate date = NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;
		IF EXISTS(SELECT 1 FROM Students where User_ID=@User_ID) AND EXISTS( SELECT 1 FROM StudentsToStudy where Student_ID = (SELECT Student_ID FROM Students where User_ID=@User_ID) AND Study_ID = @Study_ID)
		BEGIN
			raiserror('U¿ytkownik jest ju¿ zapisany na ten kierunek .', 16, 1);
		END
   
		IF NOT EXISTS(SELECT 1 FROM StudiesYear where Study_ID = @Study_ID)
		BEGIN
			raiserror('Nie ma takiego kierunku studiów .', 16, 1);
		END

		IF NOT EXISTS ( SELECT 1 FROM Currency where Currency_ID = @Currency_ID)
		BEGIN
			raiserror('Nie ma takiej waluty.', 16, 1);
		END

		IF (SELECT StartYear FROM StudiesYear where Study_ID = @Study_ID) < GETDATE()
		BEGIN
			raiserror('Zapis na te studia jest ju¿ niemo¿liwy.', 16, 1);
		END

		DECLARE @Cost decimal(8,2);
		SELECT @Cost = Price from StudiesYear where Study_ID = @Study_ID;

		INSERT INTO OrdersDetails(
			Order_ID,ConfirmDate,Cost,Status,Currency_ID,CurrencyValueToPLN,Discount,Tax
		) 
		VALUES(
			@Order_ID,ISNULL(@ConfirmDate,GETDATE()),@Cost,'Wait For Payment',@Currency_ID,(SELECT ValueToPLN from Currency where Currency_ID = @Currency_ID),@Discount,@Tax
		)

		INSERT INTO StudiesOrders(
			Order_ID,Study_ID,Cost
		) 
		VALUES(
			@Order_ID,@Study_ID,@Cost
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
