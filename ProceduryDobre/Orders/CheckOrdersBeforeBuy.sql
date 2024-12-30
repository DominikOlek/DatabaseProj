SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE CheckOrderBeforeBuy
	@Order_ID int
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;

	DECLARE @User_ID int;
	SELECT  @User_ID = User_ID from Orders where Order_ID = @Order_ID;


	DECLARE @OrderDetails_ID int;
	DECLARE @Cost decimal(8,2);
    DECLARE AllDetails CURSOR FOR
    SELECT OrderDetails_ID FROM OrdersDetails where Order_ID = @Order_ID;

    OPEN AllDetails;

    FETCH NEXT FROM AllDetails INTO @OrderDetails_ID;

    WHILE @@FETCH_STATUS = 0
    BEGIN        
		IF EXISTS( SELECT 1 FROM WebinarOrders where Order_ID = @OrderDetails_ID)
		BEGIN

			DECLARE @Webinar_ID int;
			SELECT  @Webinar_ID = WebinarVersion_ID from WebinarOrders where Order_ID = @Order_ID;

			IF EXISTS( SELECT 1 FROM OwnerWebinars where USER_ID = @User_ID AND WebinarVersion_ID = @Webinar_ID)
			or (NOT EXISTS(SELECT 1 FROM WebinarsVersion where WebinarVersion_ID = @Webinar_ID) OR ( SELECT Available FROM WebinarsVersion where WebinarVersion_ID = @Webinar_ID) = 0)
			or ((select Status from OrdersDetails where OrderDetails_ID = @OrderDetails_ID) != 'Later Payment' and (SELECT DateOf FROM WebinarsVersion where WebinarVersion_ID = @Webinar_ID) < GETDATE())
			BEGIN
				EXEC [dbo].[DeleteOrderDetails] @OrderDetails_ID=@OrderDetails_ID;
			END
			ELSE
			BEGIN

				SELECT @Cost = Price from WebinarsVersion where WebinarVersion_ID = @Webinar_ID;
				UPDATE WebinarOrders SET
					Cost = @Cost
				WHERE Order_ID = @OrderDetails_ID
				UPDATE OrdersDetails SET
					Cost = @Cost,
					Status= 'Wait For Confirm',
					CurrencyValueToPLN = (SELECT ValueToPLN FROM Currency WHERE Currency_ID = Currency_ID)
				WHERE OrderDetails_ID = @OrderDetails_ID
			END
		END
		ELSE IF EXISTS( SELECT 1 FROM CourseOrders where Order_ID = @OrderDetails_ID)
		BEGIN

			DECLARE @Course_ID int;
			SELECT  @Course_ID = Course_ID from CourseOrders where Order_ID = @Order_ID;

			IF EXISTS( SELECT 1 FROM ModulsOwners where USER_ID = @User_ID AND Modul_ID IN (SELECT Modul_ID from Moduls where CourseVersion_ID = @Course_ID))
			or ( NOT EXISTS(SELECT 1 FROM CourseVersions where CourseVersion_ID = @Course_ID) OR ( SELECT Available FROM CourseVersions where CourseVersion_ID = @Course_ID) = 0)
			or ((select Status from OrdersDetails where OrderDetails_ID = @OrderDetails_ID) != 'Later Payment' and (SELECT StartDate FROM CourseVersions where CourseVersion_ID = @Course_ID) < GETDATE())
			BEGIN
				EXEC [dbo].[DeleteOrderDetails] @OrderDetails_ID=@OrderDetails_ID;
			END
			ELSE
			BEGIN

				SELECT @Cost = Price from CourseVersions where CourseVersion_ID = @Course_ID;
				UPDATE CourseOrders SET
					Cost = @Cost
				WHERE Order_ID = @OrderDetails_ID
				UPDATE OrdersDetails SET
					Cost = @Cost,
					Status= 'Wait For Confirm',
					CurrencyValueToPLN = (SELECT ValueToPLN FROM Currency WHERE Currency_ID = Currency_ID)
				WHERE OrderDetails_ID = @OrderDetails_ID
			END
		END
		ELSE IF EXISTS( SELECT 1 FROM StudiesOrders where Order_ID = @OrderDetails_ID)
		BEGIN
			DECLARE @Study_ID int;
			SELECT  @Study_ID = Study_ID from StudiesOrders where Order_ID = @Order_ID;

			IF EXISTS(SELECT 1 FROM Students where User_ID=@User_ID) AND EXISTS( SELECT 1 FROM StudentsToStudy where Student_ID = (SELECT Student_ID FROM Students where User_ID=@User_ID) AND Study_ID = @Study_ID)
			or (NOT EXISTS(SELECT 1 FROM StudiesYear where Study_ID = @Study_ID))
			or ((select Status from OrdersDetails where OrderDetails_ID = @OrderDetails_ID) != 'Later Payment' and ((SELECT StartYear FROM StudiesYear where Study_ID = @Study_ID) < GETDATE()))
			BEGIN
				EXEC [dbo].[DeleteOrderDetails] @OrderDetails_ID=@OrderDetails_ID;
			END
			ELSE
			BEGIN

				SELECT @Cost = Price from StudiesYear where Study_ID = @Study_ID;
				UPDATE StudiesOrders SET
					Cost = @Cost
				WHERE Order_ID = @OrderDetails_ID
				UPDATE OrdersDetails SET
					Cost = @Cost,
					Status= 'Wait For Confirm',
					CurrencyValueToPLN = (SELECT ValueToPLN FROM Currency WHERE Currency_ID = Currency_ID)
				WHERE OrderDetails_ID = @OrderDetails_ID
			END

		END
		ELSE IF EXISTS( SELECT 1 FROM OrderPart where Order_ID = @OrderDetails_ID)
		BEGIN
			DECLARE @Part_ID int;
			SELECT  @Part_ID = Part_ID from OrderPart where Order_ID = @Order_ID;

			IF EXISTS(SELECT 1 FROM Students where User_ID=@User_ID) AND (SELECT TOP 1 Meeting_ID  FROM SubjectMeeting where Part_ID = @Part_ID) IN ( SELECT Meeting_ID FROM SubjectMeetStudent where Student_ID = (SELECT Student_ID FROM Students where User_ID=@User_ID))
			or(SELECT Od.OrderDetails_ID from Orders as ORD INNER JOIN OrdersDetails as Od on Od.Order_ID = ORD.Order_ID where ORD.User_ID = @User_ID AND (ORD.Status='Confirm' or ORD.Status='Later Payment')) IN (Select Order_ID from OrderPart)
			or (NOT EXISTS(SELECT 1 FROM OrderPart where Part_ID = @Part_ID))
			or (((select Status from OrdersDetails where OrderDetails_ID = @OrderDetails_ID) != 'Later Payment' and  (SELECT DateStart FROM StudyParts where Part_ID = @Part_ID) < GETDATE() ) or (SELECT Count(*) from OrderPart as OP INNER JOIN OrdersDetails as OD ON OD.OrderDetails_ID=OP.Order_ID where OP.Part_ID=@Part_ID AND (OD.Status='Confirm' or OD.Status='Later Payment')) >= (Select Limit from StudyParts where Part_ID=@Part_ID))
			BEGIN
				EXEC [dbo].[DeleteOrderDetails] @OrderDetails_ID=@OrderDetails_ID;
			END
			ELSE
			BEGIN
				UPDATE OrdersDetails SET
					Status= 'Wait For Confirm',
					CurrencyValueToPLN = (SELECT ValueToPLN FROM Currency WHERE Currency_ID = Currency_ID)
				WHERE OrderDetails_ID = @OrderDetails_ID
			END
		END

        FETCH NEXT FROM AllDetails INTO @OrderDetails_ID;
    END;

    CLOSE AllDetails;
    DEALLOCATE AllDetails;

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
