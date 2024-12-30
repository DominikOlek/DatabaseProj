CREATE VIEW STUDY_MEETINGS_PRESENCE_LIST AS
SELECT SMS.Meeting_ID AS 'Study Meeting ID', SM.Date, U.Name, U.LastName, SMS.Student_ID,SMS.Present
FROM SubjectMeetStudent AS SMS
INNER JOIN SubjectMeeting as SM ON SM.Meeting_ID=SMS.Meeting_ID
INNER JOIN Students as S ON S.Student_ID = SMS.Student_ID
INNER JOIN Users as U ON U.User_ID = S.User_ID
GROUP BY SMS.Meeting_ID, SM.Date, U.Name, U.LastName,SMS.Student_ID, SMS.Present