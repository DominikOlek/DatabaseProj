SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddDetailOfPart
	@Order_ID int,
	@User_ID int,
	@Part_ID int,
	@Tax decimal(4,2),
	@Discount decimal(3,2)= NULL,
	@Currency_ID varchar(3),
	@ConfirmDate date = NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;
		IF EXISTS(SELECT 1 FROM Students where User_ID=@User_ID) AND (SELECT TOP 1 Meeting_ID  FROM SubjectMeeting where Part_ID = @Part_ID) IN ( SELECT Meeting_ID FROM SubjectMeetStudent where Student_ID = (SELECT Student_ID FROM Students where User_ID=@User_ID))
		BEGIN
			raiserror('Student jest ju¿ zapisany na ten zjazd.', 16, 1);
		END
		ELSE IF (SELECT Od.OrderDetails_ID from Orders as ORD INNER JOIN OrdersDetails as Od on Od.Order_ID = ORD.Order_ID where ORD.User_ID = @User_ID AND (ORD.Status='Confirm' or ORD.Status='Later Payment')) IN (Select Order_ID from OrderPart)
		BEGIN
			raiserror('U¿ytkownik jest ju¿ zapisany na ten zjazd.', 16, 1);
		END

		IF NOT EXISTS(SELECT 1 FROM OrderPart where Part_ID = @Part_ID)
		BEGIN
			raiserror('Nie ma takiego zjazdu.', 16, 1);
		END

		IF NOT EXISTS ( SELECT 1 FROM Currency where Currency_ID = @Currency_ID)
		BEGIN
			raiserror('Nie ma takiej waluty.', 16, 1);
		END

		IF (SELECT DateStart FROM StudyParts where Part_ID = @Part_ID) < GETDATE() or (SELECT Count(*) from OrderPart as OP INNER JOIN OrdersDetails as OD ON OD.OrderDetails_ID=OP.Order_ID where OP.Part_ID=@Part_ID AND (OD.Status='Confirm' or OD.Status='Later Payment')) >= (Select Limit from StudyParts where Part_ID=@Part_ID)
		BEGIN
			raiserror('Zapis na ten zjazd jest ju¿ niemo¿liwy.', 16, 1);
		END

		DECLARE @Cost decimal(8,2);

		IF EXISTS(SELECT 1 FROM Students where User_ID=@User_ID) AND EXISTS( SELECT 1 FROM StudentsToStudy where Student_ID = (SELECT Student_ID FROM Students where User_ID=@User_ID) AND Study_ID = (SELECT TOP 1 S.Study_ID  FROM SubjectMeeting as SM INNER JOIN Subjects as S on S.Subject_ID = SM.Subject_ID where SM.Part_ID = @Part_ID))
		BEGIN
			SELECT @Cost = PriceForStudents from StudyParts where Part_ID = @Part_ID;
		END
		ELSE
		BEGIN
			SELECT @Cost = PriceForOutsiders from StudyParts where Part_ID = @Part_ID;
		END

		INSERT INTO OrdersDetails(
			Order_ID,ConfirmDate,Cost,Status,Currency_ID,CurrencyValueToPLN,Discount,Tax
		) 
		VALUES(
			@Order_ID,ISNULL(@ConfirmDate,GETDATE()),@Cost,'Wait For Payment',@Currency_ID,(SELECT ValueToPLN from Currency where Currency_ID = @Currency_ID),@Discount,@Tax
		)

		INSERT INTO OrderPart(
			Order_ID,Part_ID,Price
		) 
		VALUES(
			@Order_ID,@Part_ID,@Cost
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
GO
