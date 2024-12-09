-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-12-08 15:52:45.29

-- tables
-- Table: AcademicTitles
CREATE TABLE AcademicTitles (
    AcademicTitle_ID int  NOT NULL,
    Title varchar(20)  NOT NULL,
    CONSTRAINT AcademicTitles_pk PRIMARY KEY  (AcademicTitle_ID)
);

-- Table: Countries
CREATE TABLE Countries (
    Country_ID int  NOT NULL,
    CountryName varchar(15)  NOT NULL,
    PhoneDirect varchar(2)  NOT NULL,
    CONSTRAINT Countries_pk PRIMARY KEY  (Country_ID)
);

-- Table: CourseOrders
CREATE TABLE CourseOrders (
    Order_ID int  NOT NULL,
    Course_ID int  NOT NULL,
    FinalDate datetime  NOT NULL,
    Cost decimal(8,2)  NOT NULL DEFAULT 0,
    CONSTRAINT check_1 CHECK (Cost>=0),
    CONSTRAINT CourseOrders_pk PRIMARY KEY  (Order_ID)
);

-- Table: CourseOrdersParts
CREATE TABLE CourseOrdersParts (
    OrderParts_ID int  NOT NULL,
    Order_ID int  NOT NULL,
    Cost decimal(8,2)  NOT NULL DEFAULT 0,
    DateOf datetime  NOT NULL,
    Status bit  NOT NULL DEFAULT 'Wait For Payment',
    CONSTRAINT check_1 CHECK (Cost >= 0 AND YEAR(DateOf) > 2023),
    CONSTRAINT CourseOrdersParts_pk PRIMARY KEY  (OrderParts_ID)
);

-- Table: CourseVersions
CREATE TABLE CourseVersions (
    CourseVersion_ID int  NOT NULL,
    Course_ID int  NOT NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    CONSTRAINT check_1 CHECK (StartDate < EndDate AND Price >= 0),
    CONSTRAINT CourseVersions_pk PRIMARY KEY  (CourseVersion_ID)
);

-- Table: Courses
CREATE TABLE Courses (
    Course_ID int  NOT NULL,
    Title varchar(50)  NOT NULL,
    Description text  NULL,
    CONSTRAINT check_1 CHECK (LEN(Title) > 3),
    CONSTRAINT Courses_pk PRIMARY KEY  (Course_ID)
);

-- Table: Currency
CREATE TABLE Currency (
    Currency_ID varchar(3)  NOT NULL,
    CurrencySymbol char(4)  NOT NULL,
    ValueToPLN decimal(4,2)  NOT NULL DEFAULT 1,
    CONSTRAINT "Check" CHECK (LEN(CurrencySymbol)=1 AND ValueToPLN > 0),
    CONSTRAINT Currency_pk PRIMARY KEY  (Currency_ID)
);

-- Table: Grades
CREATE TABLE Grades (
    Grade_ID int  NOT NULL,
    Grade varchar(5)  NOT NULL,
    CONSTRAINT Grades_pk PRIMARY KEY  (Grade_ID)
);

-- Table: Intern
CREATE TABLE Intern (
    Practic_ID int  NOT NULL,
    Study_ID int  NOT NULL,
    Student_ID varchar(6)  NOT NULL,
    Term int  NOT NULL,
    StartDate date  NOT NULL,
    Place varchar(50)  NULL,
    Description text  NULL,
    NumberOfAttend int  NULL DEFAULT 0,
    CONSTRAINT check_1 CHECK (YEAR(StartDate) > 2023 AND NumberOfAttend >= 0 AND NumberOfAttend <= 14 AND LEN(Place) >0),
    CONSTRAINT Intern_pk PRIMARY KEY  (Practic_ID)
);

-- Table: Language
CREATE TABLE Language (
    Language_ID int  NOT NULL,
    Language varchar(15)  NOT NULL,
    CONSTRAINT Language_pk PRIMARY KEY  (Language_ID)
);

-- Table: Moduls
CREATE TABLE Moduls (
    Modul_ID int  NOT NULL,
    CourseVersion_ID int  NOT NULL,
    DateOf datetime  NOT NULL,
    Title varchar(50)  NOT NULL,
    Description text  NULL,
    TeacherLanguage_ID int  NOT NULL,
    Translator_ID int  NULL,
    CONSTRAINT check_1 CHECK (LEN(Title) > 3 AND YEAR(DateOf) > 2023),
    CONSTRAINT Moduls_pk PRIMARY KEY  (Modul_ID)
);

-- Table: ModulsOwners
CREATE TABLE ModulsOwners (
    User_ID int  NOT NULL,
    Modul_ID int  NOT NULL,
    Pass bit  NOT NULL DEFAULT 0,
    CONSTRAINT ModulsOwners_pk PRIMARY KEY  (User_ID,Modul_ID)
);

-- Table: OrderPart
CREATE TABLE OrderPart (
    Order_ID int  NOT NULL,
    Part_ID int  NOT NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    CONSTRAINT check_1 CHECK (Price >= 0),
    CONSTRAINT OrderPart_pk PRIMARY KEY  (Order_ID,Part_ID)
);

-- Table: Orders
CREATE TABLE Orders (
    Order_ID int  NOT NULL,
    User_ID int  NOT NULL,
    OrderDate date  NOT NULL,
    Cost decimal(8,2)  NOT NULL,
    Confirm bit  NOT NULL DEFAULT 0,
    Status varchar(20)  NOT NULL DEFAULT 'Wait For Payment',
    Currency_ID varchar(3)  NOT NULL DEFAULT 'PLN',
    CONSTRAINT "Check" CHECK (LEN(Currency_ID) = 3 AND LEN(Status) >1 AND Cost>=0 AND YEAR(OrderDate) >= 2024),
    CONSTRAINT Orders_pk PRIMARY KEY  (Order_ID)
);

-- Table: OwnerWebinars
CREATE TABLE OwnerWebinars (
    User_ID int  NOT NULL,
    WebinarVersion_ID int  NOT NULL,
    ExpireDate date  NOT NULL,
    CONSTRAINT OwnerWebinars_pk PRIMARY KEY  (User_ID,WebinarVersion_ID)
);

-- Table: RemoteMeet
CREATE TABLE RemoteMeet (
    Meeting_ID int  NOT NULL,
    Link varchar(50)  NOT NULL,
    CONSTRAINT RemoteMeet_pk PRIMARY KEY  (Meeting_ID)
);

-- Table: RemoteModulsSynchronize
CREATE TABLE RemoteModulsSynchronize (
    Modul_ID int  NOT NULL,
    Link varchar(50)  NOT NULL,
    CONSTRAINT RemoteModulsSynchronize_pk PRIMARY KEY  (Modul_ID)
);

-- Table: RemoteModulsUnSynchronize
CREATE TABLE RemoteModulsUnSynchronize (
    Modul_ID int  NOT NULL,
    Link varchar(50)  NOT NULL,
    ExpireDate date  NOT NULL,
    CONSTRAINT RemoteModulsUnSynchronize_pk PRIMARY KEY  (Modul_ID)
);

-- Table: StationaryMeet
CREATE TABLE StationaryMeet (
    Meeting_ID int  NOT NULL,
    Room varchar(10)  NOT NULL,
    Limit int  NOT NULL,
    CONSTRAINT StationaryMeet_pk PRIMARY KEY  (Meeting_ID)
);

-- Table: StationaryModulsC
CREATE TABLE StationaryModulsC (
    Modul_ID int  NOT NULL,
    Room varchar(10)  NOT NULL,
    Limit int  NULL,
    CONSTRAINT StationaryModulsC_pk PRIMARY KEY  (Modul_ID)
);

-- Table: Students
CREATE TABLE Students (
    Student_ID varchar(6)  NOT NULL,
    User_ID int  NOT NULL,
    EndDate date  NOT NULL,
    Status varchar(25)  NOT NULL DEFAULT 'Study',
    CONSTRAINT check_1 CHECK (YEAR(EndDate) >= 2023),
    CONSTRAINT Students_pk PRIMARY KEY  (Student_ID)
);

-- Table: StudentsToStudy
CREATE TABLE StudentsToStudy (
    Study_ID int  NOT NULL,
    Student_ID varchar(6)  NOT NULL,
    Status varchar(10)  NOT NULL DEFAULT 'Study',
    EndDate date  NOT NULL,
    CONSTRAINT StudentsToStudy_pk PRIMARY KEY  (Study_ID,Student_ID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudyName_ID int  NOT NULL,
    Description text  NOT NULL,
    Name varchar(50)  NOT NULL,
    CONSTRAINT check_1 CHECK (LEN(Name) > 3),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudyName_ID)
);

-- Table: StudiesOrders
CREATE TABLE StudiesOrders (
    Order_ID int  NOT NULL,
    Study_ID int  NOT NULL,
    Cost decimal(8,2)  NOT NULL DEFAULT 0,
    CONSTRAINT check_1 CHECK (Cost >= 0),
    CONSTRAINT StudiesOrders_pk PRIMARY KEY  (Order_ID)
);

-- Table: StudiesYear
CREATE TABLE StudiesYear (
    Study_ID int  NOT NULL,
    StudyName_ID int  NOT NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    StartYear varchar(9)  NOT NULL,
    CONSTRAINT check_1 CHECK (YEAR(StartYear) > 2023),
    CONSTRAINT StudiesYear_pk PRIMARY KEY  (Study_ID)
);

-- Table: StudyParts
CREATE TABLE StudyParts (
    Part_ID int  NOT NULL,
    DateStart datetime  NOT NULL,
    DateEnd datetime  NOT NULL,
    PriceForStudents decimal(8,2)  NOT NULL DEFAULT 0,
    PriceForOutsiders decimal(8,2)  NULL DEFAULT 0,
    CONSTRAINT check_1 CHECK (PriceForStudents >= 0 AND PriceForOutsiders >=0 AND DateEnd > DateStart),
    CONSTRAINT StudyParts_pk PRIMARY KEY  (Part_ID)
);

-- Table: SubjectEndStudents
CREATE TABLE SubjectEndStudents (
    Subject_ID int  NOT NULL,
    Student_ID varchar(6)  NOT NULL,
    ExamGrade_ID int  NULL,
    LessonGrade_ID int  NULL,
    EndGrade_ID int  NULL,
    LessonGradeList text  NOT NULL,
    CONSTRAINT SubjectEndStudents_pk PRIMARY KEY  (Subject_ID,Student_ID)
);

-- Table: SubjectForStudy
CREATE TABLE SubjectForStudy (
    ExampleSubject_ID int  NOT NULL,
    StudyName_ID int  NOT NULL,
    Name varchar(30)  NOT NULL,
    ECTS int  NULL DEFAULT 0,
    NumberOfMeeting int  NULL DEFAULT 1,
    Term int  NULL DEFAULT 1,
    CONSTRAINT check_1 CHECK (ECTS >=0 AND ECTS < 50 AND NumberOfMeeting >= 1 AND Term > 0),
    CONSTRAINT SubjectForStudy_pk PRIMARY KEY  (ExampleSubject_ID)
);

-- Table: SubjectMeetStudent
CREATE TABLE SubjectMeetStudent (
    Meeting_ID int  NOT NULL,
    Student_ID varchar(6)  NOT NULL,
    Present bit  NOT NULL DEFAULT 1,
    CONSTRAINT SubjectMeetStudent_pk PRIMARY KEY  (Meeting_ID,Student_ID)
);

-- Table: SubjectMeeting
CREATE TABLE SubjectMeeting (
    Meeting_ID int  NOT NULL,
    Subject_ID int  NOT NULL,
    Date int  NOT NULL,
    Description text  NULL,
    TeacherLanguage_ID int  NOT NULL,
    Translator_ID int  NULL,
    Part_ID int  NOT NULL,
    CONSTRAINT check_1 CHECK (YEAR(Date) >= 2023 ),
    CONSTRAINT SubjectMeeting_pk PRIMARY KEY  (Meeting_ID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    Subject_ID int  NOT NULL,
    Study_ID int  NOT NULL,
    Name varchar(30)  NOT NULL,
    ECTS int  NOT NULL,
    NumberOfMeeting int  NOT NULL,
    Term int  NOT NULL,
    PriceForOneMeet decimal(8,2)  NULL,
    CONSTRAINT check_1 CHECK (ECTS >=0 AND NumberOfMeeting >= 1 AND Term > 0 AND PriceForOneMeet >= 0),
    CONSTRAINT Subjects_pk PRIMARY KEY  (Subject_ID)
);

-- Table: Teachers
CREATE TABLE Teachers (
    Teacher_ID int  NOT NULL,
    Name varchar(20)  NOT NULL,
    LastName varchar(20)  NOT NULL,
    AcademicTitle int  NOT NULL,
    CONSTRAINT Teachers_pk PRIMARY KEY  (Teacher_ID)
);

-- Table: TeachersLanguage
CREATE TABLE TeachersLanguage (
    TeacherLanguage_ID int  NOT NULL,
    Language_ID int  NOT NULL,
    Teacher_ID int  NOT NULL,
    CONSTRAINT TeachersLanguage_pk PRIMARY KEY  (TeacherLanguage_ID)
);

-- Table: Users
CREATE TABLE Users (
    User_ID int  NOT NULL,
    Name varchar(20)  NOT NULL,
    LastName varchar(20)  NOT NULL,
    Email varchar(50)  NOT NULL,
    Password text  NOT NULL,
    Adress varchar(50)  NULL,
    PhoneNumber varchar(11)  NULL,
    ConfirmDataMg bit  NULL DEFAULT 0,
    Pesel varchar(11)  NULL,
    Country_ID int  NOT NULL,
    CONSTRAINT Email UNIQUE (Email),
    CONSTRAINT Pesel UNIQUE (Pesel),
    CONSTRAINT check_1 CHECK (LEN(Pesel)=11 AND LEN(PhoneNumber) >= 9 AND PhoneNumber NOT LIKE '%[^0-9]%' AND Pesel NOT LIKE '%[^0-9]%' AND CHARINDEX('@',Email) > 0),
    CONSTRAINT User_ID PRIMARY KEY  (User_ID)
);

-- Table: WebinarOrders
CREATE TABLE WebinarOrders (
    Order_ID int  NOT NULL,
    WebinarVersion_ID int  NULL,
    Cost decimal(8,2)  NOT NULL,
    CONSTRAINT check_1 CHECK (Cost >= 0),
    CONSTRAINT WebinarOrders_pk PRIMARY KEY  (Order_ID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    Webinar_ID int  NOT NULL,
    Title varchar(50)  NOT NULL,
    Description text  NULL,
    CONSTRAINT check_1 CHECK (LEN(Title) > 3),
    CONSTRAINT Webinars_pk PRIMARY KEY  (Webinar_ID)
);

-- Table: WebinarsVersion
CREATE TABLE WebinarsVersion (
    WebinarVersion_ID int  NOT NULL,
    Webinar_ID int  NOT NULL,
    DateOf datetime  NOT NULL,
    Link varchar(100)  NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    TeacherLanguage_ID int  NOT NULL,
    Translator_ID int  NULL,
    CONSTRAINT check_1 CHECK (Price >=0),
    CONSTRAINT WebinarsVersion_pk PRIMARY KEY  (WebinarVersion_ID)
);

-- foreign keys
-- Reference: AcademicTitles_Teachers (table: Teachers)
ALTER TABLE Teachers ADD CONSTRAINT AcademicTitles_Teachers
    FOREIGN KEY (AcademicTitle)
    REFERENCES AcademicTitles (AcademicTitle_ID)
    ON UPDATE  CASCADE;

-- Reference: CourseOrderToParts (table: CourseOrdersParts)
ALTER TABLE CourseOrdersParts ADD CONSTRAINT CourseOrderToParts
    FOREIGN KEY (Order_ID)
    REFERENCES CourseOrders (Order_ID);

-- Reference: CourseToVersion (table: CourseVersions)
ALTER TABLE CourseVersions ADD CONSTRAINT CourseToVersion
    FOREIGN KEY (Course_ID)
    REFERENCES Courses (Course_ID);

-- Reference: CurrencyToOrder (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT CurrencyToOrder
    FOREIGN KEY (Currency_ID)
    REFERENCES Currency (Currency_ID)
    ON UPDATE  CASCADE;

-- Reference: LessonGradeToGrades (table: SubjectEndStudents)
ALTER TABLE SubjectEndStudents ADD CONSTRAINT LessonGradeToGrades
    FOREIGN KEY (LessonGrade_ID)
    REFERENCES Grades (Grade_ID);

-- Reference: ModulStationaryToModul (table: Moduls)
ALTER TABLE Moduls ADD CONSTRAINT ModulStationaryToModul
    FOREIGN KEY (Modul_ID)
    REFERENCES StationaryModulsC (Modul_ID);

-- Reference: ModuleToVersion (table: Moduls)
ALTER TABLE Moduls ADD CONSTRAINT ModuleToVersion
    FOREIGN KEY (CourseVersion_ID)
    REFERENCES CourseVersions (CourseVersion_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: ModulsOwners_Users (table: ModulsOwners)
ALTER TABLE ModulsOwners ADD CONSTRAINT ModulsOwners_Users
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: OrderToCours (table: CourseOrders)
ALTER TABLE CourseOrders ADD CONSTRAINT OrderToCours
    FOREIGN KEY (Order_ID)
    REFERENCES Orders (Order_ID);

-- Reference: OrderToPart (table: OrderPart)
ALTER TABLE OrderPart ADD CONSTRAINT OrderToPart
    FOREIGN KEY (Order_ID)
    REFERENCES Orders (Order_ID);

-- Reference: OrderToStudy (table: StudiesOrders)
ALTER TABLE StudiesOrders ADD CONSTRAINT OrderToStudy
    FOREIGN KEY (Order_ID)
    REFERENCES Orders (Order_ID);

-- Reference: OrderToWebinar (table: WebinarOrders)
ALTER TABLE WebinarOrders ADD CONSTRAINT OrderToWebinar
    FOREIGN KEY (Order_ID)
    REFERENCES Orders (Order_ID);

-- Reference: OwnersToModul (table: ModulsOwners)
ALTER TABLE ModulsOwners ADD CONSTRAINT OwnersToModul
    FOREIGN KEY (Modul_ID)
    REFERENCES Moduls (Modul_ID);

-- Reference: PartToMeeting (table: SubjectMeeting)
ALTER TABLE SubjectMeeting ADD CONSTRAINT PartToMeeting
    FOREIGN KEY (Part_ID)
    REFERENCES StudyParts (Part_ID)
    ON UPDATE  CASCADE;

-- Reference: RemoteModulsSynchronizeToModul (table: Moduls)
ALTER TABLE Moduls ADD CONSTRAINT RemoteModulsSynchronizeToModul
    FOREIGN KEY (Modul_ID)
    REFERENCES RemoteModulsSynchronize (Modul_ID);

-- Reference: RemoteModulsUnSynchronizeToModul (table: Moduls)
ALTER TABLE Moduls ADD CONSTRAINT RemoteModulsUnSynchronizeToModul
    FOREIGN KEY (Modul_ID)
    REFERENCES RemoteModulsUnSynchronize (Modul_ID);

-- Reference: RemoteToMeeting (table: SubjectMeeting)
ALTER TABLE SubjectMeeting ADD CONSTRAINT RemoteToMeeting
    FOREIGN KEY (Meeting_ID)
    REFERENCES RemoteMeet (Meeting_ID);

-- Reference: StationaryToMeeting (table: SubjectMeeting)
ALTER TABLE SubjectMeeting ADD CONSTRAINT StationaryToMeeting
    FOREIGN KEY (Meeting_ID)
    REFERENCES StationaryMeet (Meeting_ID);

-- Reference: StudentToInterns (table: Intern)
ALTER TABLE Intern ADD CONSTRAINT StudentToInterns
    FOREIGN KEY (Student_ID)
    REFERENCES Students (Student_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: StudentToMeeting (table: SubjectMeetStudent)
ALTER TABLE SubjectMeetStudent ADD CONSTRAINT StudentToMeeting
    FOREIGN KEY (Student_ID)
    REFERENCES Students (Student_ID);

-- Reference: StudentToStudy (table: StudentsToStudy)
ALTER TABLE StudentsToStudy ADD CONSTRAINT StudentToStudy
    FOREIGN KEY (Student_ID)
    REFERENCES Students (Student_ID);

-- Reference: Students_SubjectEndStudents (table: SubjectEndStudents)
ALTER TABLE SubjectEndStudents ADD CONSTRAINT Students_SubjectEndStudents
    FOREIGN KEY (Student_ID)
    REFERENCES Students (Student_ID);

-- Reference: Students_Users (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Users
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: StudiesToOrder (table: StudiesOrders)
ALTER TABLE StudiesOrders ADD CONSTRAINT StudiesToOrder
    FOREIGN KEY (Study_ID)
    REFERENCES StudiesYear (Study_ID);

-- Reference: StudiesToSubject (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT StudiesToSubject
    FOREIGN KEY (Study_ID)
    REFERENCES StudiesYear (Study_ID)
    ON UPDATE  CASCADE;

-- Reference: StudiesToYear (table: StudiesYear)
ALTER TABLE StudiesYear ADD CONSTRAINT StudiesToYear
    FOREIGN KEY (StudyName_ID)
    REFERENCES Studies (StudyName_ID);

-- Reference: StudiesYearToStudent (table: StudentsToStudy)
ALTER TABLE StudentsToStudy ADD CONSTRAINT StudiesYearToStudent
    FOREIGN KEY (Study_ID)
    REFERENCES StudiesYear (Study_ID);

-- Reference: StudyPartsToOrder (table: OrderPart)
ALTER TABLE OrderPart ADD CONSTRAINT StudyPartsToOrder
    FOREIGN KEY (Part_ID)
    REFERENCES StudyParts (Part_ID);

-- Reference: StudyToInterns (table: Intern)
ALTER TABLE Intern ADD CONSTRAINT StudyToInterns
    FOREIGN KEY (Study_ID)
    REFERENCES StudiesYear (Study_ID)
    ON UPDATE  CASCADE;

-- Reference: SubjectEndStudents_Grades (table: SubjectEndStudents)
ALTER TABLE SubjectEndStudents ADD CONSTRAINT SubjectEndStudents_Grades
    FOREIGN KEY (EndGrade_ID)
    REFERENCES Grades (Grade_ID);

-- Reference: SubjectEndStudents_Subjects (table: SubjectEndStudents)
ALTER TABLE SubjectEndStudents ADD CONSTRAINT SubjectEndStudents_Subjects
    FOREIGN KEY (Subject_ID)
    REFERENCES Subjects (Subject_ID);

-- Reference: SubjectExamStudents_Grades (table: SubjectEndStudents)
ALTER TABLE SubjectEndStudents ADD CONSTRAINT SubjectExamStudents_Grades
    FOREIGN KEY (ExamGrade_ID)
    REFERENCES Grades (Grade_ID);

-- Reference: SubjectForStudy_Studies (table: SubjectForStudy)
ALTER TABLE SubjectForStudy ADD CONSTRAINT SubjectForStudy_Studies
    FOREIGN KEY (StudyName_ID)
    REFERENCES Studies (StudyName_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: SubjectMeetingToStudent (table: SubjectMeetStudent)
ALTER TABLE SubjectMeetStudent ADD CONSTRAINT SubjectMeetingToStudent
    FOREIGN KEY (Meeting_ID)
    REFERENCES SubjectMeeting (Meeting_ID);

-- Reference: SubjectToMeeting (table: SubjectMeeting)
ALTER TABLE SubjectMeeting ADD CONSTRAINT SubjectToMeeting
    FOREIGN KEY (Subject_ID)
    REFERENCES Subjects (Subject_ID)
    ON DELETE  CASCADE;

-- Reference: TeachLangToMeeting (table: SubjectMeeting)
ALTER TABLE SubjectMeeting ADD CONSTRAINT TeachLangToMeeting
    FOREIGN KEY (TeacherLanguage_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON UPDATE  CASCADE;

-- Reference: TeachLangToModul (table: Moduls)
ALTER TABLE Moduls ADD CONSTRAINT TeachLangToModul
    FOREIGN KEY (TeacherLanguage_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON UPDATE  CASCADE;

-- Reference: TeachLangToWebinar (table: WebinarsVersion)
ALTER TABLE WebinarsVersion ADD CONSTRAINT TeachLangToWebinar
    FOREIGN KEY (TeacherLanguage_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON UPDATE  CASCADE;

-- Reference: TeachersLanguage_Language (table: TeachersLanguage)
ALTER TABLE TeachersLanguage ADD CONSTRAINT TeachersLanguage_Language
    FOREIGN KEY (Language_ID)
    REFERENCES Language (Language_ID)
    ON UPDATE  CASCADE;

-- Reference: TeachersLanguage_Teachers (table: TeachersLanguage)
ALTER TABLE TeachersLanguage ADD CONSTRAINT TeachersLanguage_Teachers
    FOREIGN KEY (Teacher_ID)
    REFERENCES Teachers (Teacher_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TranslatorLangToMeeting (table: SubjectMeeting)
ALTER TABLE SubjectMeeting ADD CONSTRAINT TranslatorLangToMeeting
    FOREIGN KEY (Translator_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON UPDATE  CASCADE;

-- Reference: TranslatorLangToModul (table: Moduls)
ALTER TABLE Moduls ADD CONSTRAINT TranslatorLangToModul
    FOREIGN KEY (Translator_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON UPDATE  CASCADE;

-- Reference: TranslatorLangToWebinar (table: WebinarsVersion)
ALTER TABLE WebinarsVersion ADD CONSTRAINT TranslatorLangToWebinar
    FOREIGN KEY (Translator_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON UPDATE  CASCADE;

-- Reference: UserToOrders (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT UserToOrders
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: UserToWebOwner (table: OwnerWebinars)
ALTER TABLE OwnerWebinars ADD CONSTRAINT UserToWebOwner
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: Users_Countries (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_Countries
    FOREIGN KEY (Country_ID)
    REFERENCES Countries (Country_ID)
    ON DELETE  SET NULL 
    ON UPDATE  CASCADE;

-- Reference: VersionToCourseOrder (table: CourseOrders)
ALTER TABLE CourseOrders ADD CONSTRAINT VersionToCourseOrder
    FOREIGN KEY (Course_ID)
    REFERENCES CourseVersions (CourseVersion_ID);

-- Reference: VersionToWebinarOrder (table: WebinarOrders)
ALTER TABLE WebinarOrders ADD CONSTRAINT VersionToWebinarOrder
    FOREIGN KEY (WebinarVersion_ID)
    REFERENCES WebinarsVersion (WebinarVersion_ID)
    ON DELETE  SET NULL 
    ON UPDATE  CASCADE;

-- Reference: VersionToWebinarOwner (table: OwnerWebinars)
ALTER TABLE OwnerWebinars ADD CONSTRAINT VersionToWebinarOwner
    FOREIGN KEY (WebinarVersion_ID)
    REFERENCES WebinarsVersion (WebinarVersion_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: WebinarToVersion (table: WebinarsVersion)
ALTER TABLE WebinarsVersion ADD CONSTRAINT WebinarToVersion
    FOREIGN KEY (Webinar_ID)
    REFERENCES Webinars (Webinar_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- End of file.

INSERT INTO Currency
VALUES ('PLN','zł',1);
