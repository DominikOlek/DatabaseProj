SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE PayForOrders
	@Order_ID int,
	@PaymentNumber varchar(50),
	@AdvancedPaymentDetails ListOfAdvance READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @OrderDetails_ID INT;
	DECLARE @Value decimal(8,2);
	DECLARE @User_ID int;
	DECLARE @ID int;

	SELECT @User_ID = User_ID FROM Orders where Order_ID = @Order_ID;

	DECLARE Advances CURSOR FOR
	SELECT Order_ID,Value
	FROM @AdvancedPaymentDetails;

	OPEN Advances;

	FETCH NEXT FROM Advances INTO @OrderDetails_ID, @Value;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (Select Status from OrdersDetails where Order_ID = @Order_ID AND OrderDetails_ID = @OrderDetails_ID) != 'Wait For Confirm'
		BEGIN
			raiserror('To zamówienie nie mog³o zostaæ op³acone', 16, 1);	
		END

		IF NOT EXISTS (Select 1 from OrdersDetails where Order_ID = @Order_ID AND OrderDetails_ID = @OrderDetails_ID)
		BEGIN
			raiserror('Zamówienie podane w liœcie kursów nie jest z tego koszyka', 16, 1);	
		END

		IF @Value < (Select Cost from CourseOrders where Order_ID = @OrderDetails_ID)
		BEGIN
			UPDATE OrdersDetails
				SET
					ConfirmDate = GETDATE(),
					Status = 'Advanced Payment'
				WHERE OrderDetails_ID = @OrderDetails_ID

			INSERT INTO CourseAdvance(
				Value,DateOf
			)
			VALUES (
				@Value,GETDATE()
			)
		END

		FETCH NEXT FROM Advances INTO @OrderDetails_ID, @Value;
	END;

	CLOSE Advances;
	DEALLOCATE Advances;

	DECLARE AllDetails CURSOR FOR
    SELECT OrderDetails_ID FROM OrdersDetails where Order_ID = @Order_ID;

    OPEN AllDetails;

    FETCH NEXT FROM AllDetails INTO @OrderDetails_ID;

    WHILE @@FETCH_STATUS = 0
    BEGIN   
		IF (Select Status from OrdersDetails where Order_ID = @Order_ID AND OrderDetails_ID = @OrderDetails_ID) NOT IN ('Wait For Confirm','Later Payment','Advanced Payment')
		BEGIN
			raiserror('To zamówienie nie mog³o zostaæ op³acone', 16, 1);	
		END


		IF @OrderDetails_ID NOT IN (SELECT Order_ID FROM @AdvancedPaymentDetails)
		BEGIN
			UPDATE OrdersDetails
				SET
					ConfirmDate = GETDATE(),
					Status = 'Confirm'
				WHERE OrderDetails_ID = @OrderDetails_ID

			IF EXISTS( SELECT 1 FROM WebinarOrders where Order_ID = @OrderDetails_ID)
			BEGIN
				INSERT INTO OwnerWebinars(User_ID,WebinarVersion_ID,ExpireDate)
				VALUES(@User_ID,(SELECT WebinarVersion_ID FROM WebinarOrders where Order_ID=@OrderDetails_ID),DATEADD(DAY,30,GETDATE()));
			END

			ELSE IF EXISTS( SELECT 1 FROM CourseOrders where Order_ID = @OrderDetails_ID)
			BEGIN
				
				DECLARE AllModuls CURSOR FOR
				SELECT Modul_ID
				FROM Moduls where CourseVersion_ID=(SELECT Course_ID FROM CourseOrders where Order_ID = @OrderDetails_ID );

				OPEN AllModuls;

				FETCH NEXT FROM AllModuls INTO @ID;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO ModulsOwners(User_ID,Modul_ID,Pass)
					VALUES(@User_ID,@ID,0);

					FETCH NEXT FROM AllModuls INTO @ID;
				END;

				CLOSE AllModuls;
				DEALLOCATE AllModuls;
			END
			ELSE IF EXISTS( SELECT 1 FROM StudiesOrders where Order_ID = @OrderDetails_ID)
			BEGIN
				
				IF NOT EXISTS (SELECT 1 from Students where User_ID = @User_ID)
				BEGIN
					DECLARE @NewID VARCHAR(6);
					SELECT @NewID = RIGHT('000000' + CAST(ISNULL(MAX(CAST(SUBSTRING(Student_ID, 4, LEN(Student_ID)) AS INT)), 0) + 1 AS VARCHAR), 6)
					FROM Students;

					INSERT INTO Students(Student_ID,User_ID,EndDate,Status)
					VALUES(@NewID,@User_ID,DATEADD(YEAR,3,YEAR(GETDATE())),'Student')
				END
				ELSE
				BEGIN
					UPDATE Students
						SET
							EndDate=DATEADD(YEAR,3,YEAR(GETDATE())),
							Status='Student'
						where User_ID = @User_ID
				END

				INSERT INTO StudentsToStudy(Study_ID,Student_ID,Status,EndDate)
				VALUES((select Study_ID from StudiesOrders where Order_ID = @OrderDetails_ID),(select Student_ID from Students where User_ID = @User_ID),DATEADD(YEAR,3,YEAR(GETDATE())),'Student')

			END
			ELSE IF EXISTS( SELECT 1 FROM OrderPart where Order_ID = @OrderDetails_ID) AND EXISTS(SELECT 1 FROM Students where User_ID=@User_ID) AND (SELECT TOP 1 Meeting_ID  FROM SubjectMeeting where Part_ID = (Select Part_ID from OrderPart where Order_ID = @OrderDetails_ID)) IN ( SELECT Meeting_ID FROM SubjectMeetStudent where Student_ID = (SELECT Student_ID FROM Students where User_ID=@User_ID))
			BEGIN
				DECLARE AllMeeting CURSOR FOR
				SELECT Meeting_ID
				FROM SubjectMeeting where Part_ID=(SELECT Part_ID FROM OrderPart where Order_ID = @OrderDetails_ID );

				OPEN AllMeeting;

				FETCH NEXT FROM AllMeeting INTO @ID;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO SubjectMeetStudent(Meeting_ID,Student_ID,Present)
					VALUES(@ID,(SELECT Student_ID from Students where User_ID = @User_ID),0);

					FETCH NEXT FROM AllMeeting INTO @ID;
				END;

				CLOSE AllMeeting;
				DEALLOCATE AllMeeting;
			END

		END



		FETCH NEXT FROM AllDetails INTO @OrderDetails_ID;
    END;

    CLOSE AllDetails;
    DEALLOCATE AllDetails;

	IF NOT EXISTS (SELECT 1 FROM @AdvancedPaymentDetails)
	BEGIN
		UPDATE Orders
			SET
				OrderDate = GETDATE(),
				Finalize=1,
				Status = 'Confirm',
				PaymentNumber=@PaymentNumber
			WHERE Order_ID = @Order_ID

		RETURN 0
	END

	RETURN 1
END
GO
