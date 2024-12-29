-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE EditCurrency
	@Currency_ID varchar(3),
	@ValueToPLN decimal(4,2)
AS
BEGIN
	IF not exists(SELECT 1 FROM Currency where Currency_ID = @Currency_ID)
	BEGIN
		raiserror('Waluta o takim ID nie istnieje.', 16, 1);
	END

	UPDATE Currency
		SET
			ValueToPLN = ISNULL(@ValueToPLN,ValueToPLN)
		WHERE Currency_ID = @Currency_ID;
	PRINT 'Wartoœæ waluty zosta³a zmieniona.';
END
GO
