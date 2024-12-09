CREATE PROCEDURE UpdateUserData
    @User_ID INT,              
    @Name VARCHAR(20) = NULL,    
    @LastName VARCHAR(20) = NULL,
    @Email VARCHAR(50) = NULL,  
    @Password TEXT = NULL,      
    @Adress VARCHAR(50) = NULL, 
    @PhoneNumber VARCHAR(11) = NULL, 
    @ConfirmDataMg BIT = NULL,   
    @Pesel VARCHAR(11) = NULL,   
    @Country_ID INT = NULL       
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Users
    SET 
        Name = ISNULL(@Name, Name),
        LastName = ISNULL(@LastName, LastName),
        Email = ISNULL(@Email, Email),
        Password = ISNULL(@Password, Password),
        Adress = ISNULL(@Adress, Adress),
        PhoneNumber = ISNULL(@PhoneNumber, PhoneNumber),
        ConfirmDataMg = ISNULL(@ConfirmDataMg, ConfirmDataMg),
        Pesel = ISNULL(@Pesel, Pesel),
        Country_ID = ISNULL(@Country_ID, Country_ID)
    WHERE User_ID = @User_ID;
END;