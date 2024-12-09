CREATE PROCEDURE ActiveAccount
	@Email VARCHAR(50) = NULL

AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Users
    SET 
        ConfirmDataMg = 1
    WHERE Email = @Email;
END
GO
