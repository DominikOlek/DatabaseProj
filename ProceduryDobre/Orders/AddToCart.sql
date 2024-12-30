SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE AddToCart 
	@Order_ID INT =NULL,
	@User_ID INT,
	@OrderDate date = NULL,
	@Webinar_ID INT,
	@Course_ID INT,
	@Study_ID INT,
	@StudyPart_ID INT,
	@Tax decimal(4,2),
	@Discount decimal(3,2) = NULL,
	@Currency_ID varchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRANSACTION;
		
		IF @Order_ID IS NULL
		BEGIN
			INSERT INTO Orders(
				User_ID,OrderDate,Finalize,Status,PaymentNumber
			) 
			VALUES(
				@User_ID,ISNULL(@OrderDate,GETDATE()),0,'Wait For Payment',NULL
			)
			SELECT @Order_ID = SCOPE_IDENTITY();
		END

		IF @Webinar_ID IS NOT NULL
		BEGIN
			EXEC [dbo].[AddDetailOfWebinar] @Order_ID = @Order_ID,@User_ID = @User_ID,@Webinar_ID =@Webinar_ID,@Tax =@Tax,@Discount =@Discount,@Currency_ID =@Currency_ID,@ConfirmDate = @OrderDate;
		END
		ELSE IF @Course_ID IS NOT NULL
		BEGIN
			EXEC [dbo].[AddDetailOfCourse] @Order_ID = @Order_ID,@User_ID = @User_ID,@Course_ID =@Course_ID,@Tax =@Tax,@Discount =@Discount,@Currency_ID =@Currency_ID,@ConfirmDate = @OrderDate;
		END
		ELSE IF @Study_ID IS NOT NULL
		BEGIN
			EXEC [dbo].[AddDetailOfStudy] @Order_ID = @Order_ID,@User_ID = @User_ID,@Study_ID =@Study_ID,@Tax =@Tax,@Discount =@Discount,@Currency_ID =@Currency_ID,@ConfirmDate = @OrderDate;
		END
		ELSE IF @StudyPart_ID IS NOT NULL
		BEGIN
			EXEC [dbo].[AddDetailOfPart] @Order_ID = @Order_ID,@User_ID = @User_ID,@Part_ID =@StudyPart_ID,@Tax =@Tax,@Discount =@Discount,@Currency_ID =@Currency_ID,@ConfirmDate = @OrderDate;
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
