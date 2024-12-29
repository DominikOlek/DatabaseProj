SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ADDCurrency
	@Currency_ID varchar(3),
	@CurrencySymbol char(4),
	@ValueToPLN decimal(4,2)
AS
BEGIN
	INSERT INTO Currency(Currency_ID,CurrencySymbol,ValueToPLN) VALUES (@Currency_ID,@CurrencySymbol,@ValueToPLN)

	PRINT 'Dodano walutê pomyœlnie.';
END
GO
