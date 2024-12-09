CREATE PROCEDURE [dbo].SetAttendanceModul
	@ModulID int,
	@UserID int,
	@Pass bit
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
        -- Rozpoczêcie transakcji
        BEGIN TRANSACTION;

		IF @ModulID IS NULL OR NOT EXISTS (SELECT 1 FROM Moduls WHERE Modul_ID = @ModulID)
		BEGIN
			PRINT 'Wrong modul.';
			RETURN;
		END

		IF @UserID IS NULL OR NOT EXISTS (SELECT 1 FROM Users WHERE User_ID = @UserID)
		BEGIN
			PRINT 'Wrong user.';
			RETURN;
		END

		IF NOT EXISTS(SELECT * FROM Orders ORD INNER JOIN OrdersDetails O ON O.Order_ID = ORD.Order_ID INNER JOIN CourseOrders CO ON CO.Order_ID=ORD.Order_ID WHERE ORD.User_ID = @UserID AND CO.Course_ID IN (SELECT CourseVersion_ID FROM Moduls WHERE Modul_ID = @ModulID))
		BEGIN
			PRINT 'Wrong user, who is no on list.';
			RETURN;
		END

		INSERT INTO ModulsOwners(
			Modul_ID,User_ID,Pass
		)
		VALUES (
			@ModulID,@UserID,@Pass
		);

		PRINT 'Attend is set.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
