CREATE TRIGGER [dbo].[CheckLimitInPart]
ON [dbo].[SubjectMeeting]
AFTER INSERT
AS
BEGIN
	Declare @ID int;
	Select @ID = i.Part_ID FROM inserted i;
	IF (Select Limit from StudyParts where Part_ID=@ID)>= (SELECT MIN(Limit) from StationaryMeet as Stat INNER JOIN SubjectMeeting AS Met ON Met.Meeting_ID = Stat.Meeting_ID where Met.Part_ID = @ID)
	BEGIN
		Update StudyParts
			Set
				Limit = (SELECT MIN(Limit) from StationaryMeet as Stat INNER JOIN SubjectMeeting AS Met ON Met.Meeting_ID = Stat.Meeting_ID where Met.Part_ID = @ID)
			where Part_ID=@ID

		PRINT 'Zmieniono limit dla podanego zjazdu aby nie przekracza³ limitu sali';
	END
END;