-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-12-28 12:55:31.878

-- tables
-- Table: AcademicTitles
CREATE TABLE AcademicTitles (
    AcademicTitle_ID int  NOT NULL IDENTITY(1, 1),
    Title varchar(20)  NOT NULL,
    CONSTRAINT AcademicTitles_pk PRIMARY KEY  (AcademicTitle_ID)
);

-- Table: Adresses
CREATE TABLE Adresses (
    User_ID int  NOT NULL,
    City_ID int  NOT NULL,
    PostalCode varchar(8)  NOT NULL,
    Adress varchar(50)  NOT NULL,
    CONSTRAINT Adresses_pk PRIMARY KEY  (User_ID)
);

-- Table: Cities
CREATE TABLE Cities (
    City_ID int  NOT NULL,
    Country_ID int  NOT NULL,
    CityName varchar(30)  NOT NULL,
    CONSTRAINT Cities_pk PRIMARY KEY  (City_ID)
);

-- Table: Countries
CREATE TABLE Countries (
    Country_ID int  NOT NULL,
    CountryName varchar(15)  NOT NULL,
    PhoneDirect varchar(2)  NOT NULL,
    CONSTRAINT Countries_pk PRIMARY KEY  (Country_ID)
);

-- Table: CourseAdvance
CREATE TABLE CourseAdvance (
    Order_ID int  NOT NULL,
    Value decimal(8,2)  NOT NULL DEFAULT 0,
    DateOf datetime  NOT NULL,
    CONSTRAINT COPC CHECK (Value >= 0 AND YEAR(DateOf) > 2023),
    CONSTRAINT CourseAdvance_pk PRIMARY KEY  (Order_ID)
);

-- Table: CourseOrders
CREATE TABLE CourseOrders (
    Order_ID int  NOT NULL,
    Course_ID int  NOT NULL,
    Cost decimal(8,2)  NOT NULL DEFAULT 0,
    CONSTRAINT COC CHECK (Cost>=0),
    CONSTRAINT CourseOrders_pk PRIMARY KEY  (Order_ID)
);

-- Table: CourseVersions
CREATE TABLE CourseVersions (
    CourseVersion_ID int  NOT NULL IDENTITY(1, 1),
    Course_ID int  NOT NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Available bit  NOT NULL DEFAULT 0,
    Status varchar(10)  NULL,
    CONSTRAINT CVC CHECK (StartDate < EndDate AND Price >= 0),
    CONSTRAINT CourseVersions_pk PRIMARY KEY  (CourseVersion_ID)
);

-- Table: Courses
CREATE TABLE Courses (
    Course_ID int  NOT NULL IDENTITY(1, 1),
    Title varchar(50)  NOT NULL,
    Description text  NULL,
    CONSTRAINT CourC CHECK (LEN(Title) > 3),
    CONSTRAINT Courses_pk PRIMARY KEY  (Course_ID)
);

-- Table: Currency
CREATE TABLE Currency (
    Currency_ID varchar(3)  NOT NULL,
    CurrencySymbol char(4)  NOT NULL,
    ValueToPLN decimal(4,2)  NOT NULL DEFAULT 1,
    CONSTRAINT CC CHECK (LEN(CurrencySymbol)>=1 AND ValueToPLN > 0),
    CONSTRAINT Currency_pk PRIMARY KEY  (Currency_ID)
);

-- Table: Grades
CREATE TABLE Grades (
    Grade_ID int  NOT NULL IDENTITY(1, 1),
    Grade varchar(5)  NOT NULL,
    CONSTRAINT Grades_pk PRIMARY KEY  (Grade_ID)
);

-- Table: Intern
CREATE TABLE Intern (
    Practic_ID int  NOT NULL IDENTITY(1, 1),
    Study_ID int  NOT NULL,
    Student_ID varchar(6)  NOT NULL,
    Term int  NOT NULL,
    StartDate date  NOT NULL,
    Place varchar(50)  NULL,
    Description text  NULL,
    NumberOfAttend int  NULL DEFAULT 0,
    CONSTRAINT IC CHECK (YEAR(StartDate) > 2023 AND NumberOfAttend >= 0 AND NumberOfAttend <= 14 AND LEN(Place) >0),
    CONSTRAINT Intern_pk PRIMARY KEY  (Practic_ID)
);

-- Table: Language
CREATE TABLE Language (
    Language_ID int  NOT NULL IDENTITY(1, 1),
    Language varchar(15)  NOT NULL,
    CONSTRAINT Language_pk PRIMARY KEY  (Language_ID)
);

-- Table: Moduls
CREATE TABLE Moduls (
    Modul_ID int  NOT NULL IDENTITY(1, 1),
    CourseVersion_ID int  NOT NULL,
    DateOf datetime  NOT NULL,
    Title varchar(50)  NOT NULL,
    Description text  NULL,
    CONSTRAINT MC CHECK (LEN(Title) > 3 AND YEAR(DateOf) > 2023),
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
    CONSTRAINT OPC CHECK (Price >= 0),
    CONSTRAINT OrderPart_pk PRIMARY KEY  (Order_ID,Part_ID)
);

-- Table: Orders
CREATE TABLE Orders (
    Order_ID int  NOT NULL IDENTITY(1, 1),
    User_ID int  NOT NULL,
    OrderDate date  NOT NULL,
    Finalize bit  NOT NULL DEFAULT 0,
    Status varchar(20)  NOT NULL DEFAULT 'Wait For Payment',
    PaymentNumber varchar(50)  NULL,
    CONSTRAINT ORDC CHECK (LEN(Status) >1 AND YEAR(OrderDate) >= 2024 AND Status IN ('Wait For Payment','Wait For Confirm','Confirm','Later Payment','Advanced Payment')),
    CONSTRAINT Orders_pk PRIMARY KEY  (Order_ID)
);

-- Table: OrdersDetails
CREATE TABLE OrdersDetails (
    OrderDetails_ID int  NOT NULL IDENTITY(1, 1),
    Order_ID int  NOT NULL,
    ConfirmDate date  NOT NULL,
    Cost decimal(8,2)  NOT NULL,
    Status varchar(20)  NOT NULL DEFAULT 'Wait For Payment',
    Currency_ID varchar(3)  NOT NULL DEFAULT 'PLN',
    CurrencyValueToPLN decimal(4,2)  NOT NULL DEFAULT 1,
    Discount decimal(3,2)  NULL,
    Tax decimal(4,2)  NOT NULL,
    CONSTRAINT ORDDC CHECK (LEN(Currency_ID) = 3 AND LEN(Status) >1 AND Cost>=0 AND YEAR(ConfirmDate) >= 2024 AND Status IN ('Wait For Payment','Wait For Confirm','Confirm','Later Payment','Advanced Payment')),
    CONSTRAINT OrdersDetails_pk PRIMARY KEY  (OrderDetails_ID)
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
    Link varchar(100)  NOT NULL,
    CONSTRAINT RemoteModulsSynchronize_pk PRIMARY KEY  (Modul_ID)
);

-- Table: RemoteModulsUnSynchronize
CREATE TABLE RemoteModulsUnSynchronize (
    Modul_ID int  NOT NULL,
    Link varchar(100)  NOT NULL,
    ExpireDate date  NOT NULL,
    CONSTRAINT RemoteModulsUnSynchronize_pk PRIMARY KEY  (Modul_ID)
);

-- Table: Roles
CREATE TABLE Roles (
    Role_ID int  NOT NULL,
    RoleName varchar(30)  NOT NULL,
    CONSTRAINT check_1 CHECK (LEN(RoleName) > 0),
    CONSTRAINT Roles_pk PRIMARY KEY  (Role_ID)
);

-- Table: StationaryMeet
CREATE TABLE StationaryMeet (
    Meeting_ID int  NOT NULL,
    Room varchar(10)  NOT NULL,
    Limit int  NOT NULL,
    CONSTRAINT SMSC CHECK (Limit >=0),
    CONSTRAINT StationaryMeet_pk PRIMARY KEY  (Meeting_ID)
);

-- Table: StationaryModulsC
CREATE TABLE StationaryModulsC (
    Modul_ID int  NOT NULL,
    Room varchar(10)  NOT NULL,
    Limit int  NULL,
    CONSTRAINT SMCC CHECK (Limit >= 0),
    CONSTRAINT StationaryModulsC_pk PRIMARY KEY  (Modul_ID)
);

-- Table: Students
CREATE TABLE Students (
    Student_ID varchar(6)  NOT NULL,
    User_ID int  NOT NULL,
    EndDate date  NOT NULL,
    Status varchar(25)  NOT NULL DEFAULT 'Study',
    CONSTRAINT StudC CHECK (YEAR(EndDate) >= 2023),
    CONSTRAINT Students_pk PRIMARY KEY  (Student_ID)
);

-- Table: StudentsToStudy
CREATE TABLE StudentsToStudy (
    Study_ID int  NOT NULL,
    Student_ID varchar(6)  NOT NULL,
    Status varchar(10)  NOT NULL DEFAULT 'Study',
    EndDate date  NOT NULL,
    CONSTRAINT StSC CHECK (YEAR(EndDate) > 2023 AND Status IN ('Active','Dean Leave','L4')),
    CONSTRAINT StudentsToStudy_pk PRIMARY KEY  (Study_ID,Student_ID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudyName_ID int  NOT NULL IDENTITY(1, 1),
    Description text  NOT NULL,
    Name varchar(50)  NOT NULL,
    CONSTRAINT SC CHECK (LEN(Name) > 3),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudyName_ID)
);

-- Table: StudiesOrders
CREATE TABLE StudiesOrders (
    Order_ID int  NOT NULL,
    Study_ID int  NOT NULL,
    Cost decimal(8,2)  NOT NULL DEFAULT 0,
    CONSTRAINT SOC CHECK (Cost >= 0),
    CONSTRAINT StudiesOrders_pk PRIMARY KEY  (Order_ID)
);

-- Table: StudiesYear
CREATE TABLE StudiesYear (
    Study_ID int  NOT NULL IDENTITY(1, 1),
    StudyName_ID int  NOT NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    StartYear varchar(9)  NOT NULL,
    CONSTRAINT SYC CHECK (YEAR(StartYear) > 2023),
    CONSTRAINT StudiesYear_pk PRIMARY KEY  (Study_ID)
);

-- Table: StudyParts
CREATE TABLE StudyParts (
    Part_ID int  NOT NULL IDENTITY(1, 1),
    DateStart datetime  NOT NULL,
    DateEnd datetime  NOT NULL,
    PriceForStudents decimal(8,2)  NOT NULL DEFAULT 0,
    PriceForOutsiders decimal(8,2)  NULL DEFAULT 0,
    Limit int  NOT NULL,
    CONSTRAINT SPartC CHECK (Limit > 0 AND PriceForStudents >= 0 AND PriceForOutsiders >=0 AND DateEnd > DateStart),
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
    ExampleSubject_ID int  NOT NULL IDENTITY(1, 1),
    StudyName_ID int  NOT NULL,
    Name varchar(30)  NOT NULL,
    ECTS int  NULL DEFAULT 0,
    NumberOfMeeting int  NULL DEFAULT 1,
    Term int  NULL DEFAULT 1,
    CONSTRAINT SFSC CHECK (Term < 30 AND Term >= 0 AND ECTS >=0 AND ECTS < 50 AND NumberOfMeeting >= 1 AND Term > 0),
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
    Meeting_ID int  NOT NULL IDENTITY(1, 1),
    Subject_ID int  NOT NULL,
    Date int  NOT NULL,
    Description text  NULL,
    Part_ID int  NOT NULL,
    CONSTRAINT SubMC CHECK (YEAR(Date) >= 2023 ),
    CONSTRAINT SubjectMeeting_pk PRIMARY KEY  (Meeting_ID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    Subject_ID int  NOT NULL IDENTITY(1, 1),
    Study_ID int  NOT NULL,
    Name varchar(30)  NOT NULL,
    ECTS int  NOT NULL,
    NumberOfMeeting int  NOT NULL,
    Term int  NOT NULL,
    PriceForOneMeet decimal(8,2)  NULL,
    CONSTRAINT SubC CHECK (Term < 30 AND Term >= 0 AND ECTS >=0 AND NumberOfMeeting >= 1 AND Term > 0 AND PriceForOneMeet >= 0),
    CONSTRAINT Subjects_pk PRIMARY KEY  (Subject_ID)
);

-- Table: Teachers
CREATE TABLE Teachers (
    Teacher_ID int  NOT NULL IDENTITY(1, 1),
    User_ID int  NOT NULL,
    AcademicTitle int  NOT NULL,
    CONSTRAINT Teachers_pk PRIMARY KEY  (Teacher_ID)
);

-- Table: TeachersForMeeting
CREATE TABLE TeachersForMeeting (
    Teacher_ID int  NOT NULL,
    Meeting_ID int  NOT NULL,
    Role_ID int  NOT NULL,
    CONSTRAINT TeachersForMeeting_pk PRIMARY KEY  (Teacher_ID,Meeting_ID)
);

-- Table: TeachersForModul
CREATE TABLE TeachersForModul (
    Teacher_ID int  NOT NULL,
    Modul_ID int  NOT NULL,
    Role_ID int  NOT NULL,
    CONSTRAINT TeachersForModul_pk PRIMARY KEY  (Teacher_ID,Modul_ID)
);

-- Table: TeachersForWebinar
CREATE TABLE TeachersForWebinar (
    Teacher_ID int  NOT NULL,
    WebinarVerion_ID int  NOT NULL,
    Role_ID int  NOT NULL,
    CONSTRAINT TeachersForWebinar_pk PRIMARY KEY  (Teacher_ID,WebinarVerion_ID)
);

-- Table: TeachersLanguage
CREATE TABLE TeachersLanguage (
    TeacherLanguage_ID int  NOT NULL IDENTITY(1, 1),
    Language_ID int  NOT NULL,
    Teacher_ID int  NOT NULL,
    Status varchar(15)  NOT NULL,
    CONSTRAINT StatusCheck CHECK (Status IN ('Active', 'Vacation', 'Maternity','Retired','L4')),
    CONSTRAINT TeachersLanguage_pk PRIMARY KEY  (TeacherLanguage_ID)
);

-- Table: Users
CREATE TABLE Users (
    User_ID int  NOT NULL IDENTITY(1, 1),
    Name varchar(20)  NOT NULL,
    LastName varchar(20)  NOT NULL,
    Email varchar(50)  NOT NULL,
    Password text  NOT NULL,
    Adress_ID varchar(50)  NULL,
    PhoneNumber varchar(15)  NULL,
    ConfirmDataMg bit  NULL DEFAULT 0,
    Pesel varchar(11)  NULL,
    City_ID int  NOT NULL,
    ISO_Confirm bit  NOT NULL DEFAULT 0,
    CONSTRAINT Email UNIQUE (Email),
    CONSTRAINT Pesel UNIQUE (Pesel),
    CONSTRAINT UC CHECK (LEN(Pesel)=11 AND LEN(PhoneNumber) >= 5 AND PhoneNumber NOT LIKE '%[^0-9]%' AND Pesel NOT LIKE '%[^0-9]%' AND CHARINDEX('@',Email) > 0),
    CONSTRAINT User_ID PRIMARY KEY  (User_ID)
);

-- Table: WebinarOrders
CREATE TABLE WebinarOrders (
    Order_ID int  NOT NULL,
    WebinarVersion_ID int  NULL,
    Cost decimal(8,2)  NOT NULL DEFAULT 0,
    CONSTRAINT WOC CHECK (Cost >= 0),
    CONSTRAINT WebinarOrders_pk PRIMARY KEY  (Order_ID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    Webinar_ID int  NOT NULL IDENTITY(1, 1),
    Title varchar(50)  NOT NULL,
    Description text  NULL,
    CONSTRAINT WC CHECK (LEN(Title) > 3),
    CONSTRAINT Webinars_pk PRIMARY KEY  (Webinar_ID)
);

-- Table: WebinarsVersion
CREATE TABLE WebinarsVersion (
    WebinarVersion_ID int  NOT NULL IDENTITY(1, 1),
    Webinar_ID int  NOT NULL,
    DateOf datetime  NOT NULL,
    Length int  NOT NULL DEFAULT 0,
    Link varchar(100)  NULL,
    Price decimal(8,2)  NOT NULL DEFAULT 0,
    Available bit  NOT NULL DEFAULT 0,
    Status varchar(10)  NOT NULL DEFAULT 'Active',
    CONSTRAINT WVC CHECK (Price >=0 AND Status IN ('Active','Inactive','No For Buy')),
    CONSTRAINT WebinarsVersion_pk PRIMARY KEY  (WebinarVersion_ID)
);

-- foreign keys
-- Reference: AcademicTitles_Teachers (table: Teachers)
ALTER TABLE Teachers ADD CONSTRAINT AcademicTitles_Teachers
    FOREIGN KEY (AcademicTitle)
    REFERENCES AcademicTitles (AcademicTitle_ID)
    ON UPDATE  CASCADE;

-- Reference: Adresses_Users (table: Adresses)
ALTER TABLE Adresses ADD CONSTRAINT Adresses_Users
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: Cities_Adresses (table: Adresses)
ALTER TABLE Adresses ADD CONSTRAINT Cities_Adresses
    FOREIGN KEY (City_ID)
    REFERENCES Cities (City_ID)
    ON UPDATE  CASCADE;

-- Reference: Cities_Countries (table: Cities)
ALTER TABLE Cities ADD CONSTRAINT Cities_Countries
    FOREIGN KEY (Country_ID)
    REFERENCES Countries (Country_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: CourseOrderToParts (table: CourseAdvance)
ALTER TABLE CourseAdvance ADD CONSTRAINT CourseOrderToParts
    FOREIGN KEY (Order_ID)
    REFERENCES CourseOrders (Order_ID);

-- Reference: CourseToVersion (table: CourseVersions)
ALTER TABLE CourseVersions ADD CONSTRAINT CourseToVersion
    FOREIGN KEY (Course_ID)
    REFERENCES Courses (Course_ID);

-- Reference: CurrencyToOrder (table: OrdersDetails)
ALTER TABLE OrdersDetails ADD CONSTRAINT CurrencyToOrder
    FOREIGN KEY (Currency_ID)
    REFERENCES Currency (Currency_ID)
    ON UPDATE  CASCADE;

-- Reference: DetailsToOrder (table: OrdersDetails)
ALTER TABLE OrdersDetails ADD CONSTRAINT DetailsToOrder
    FOREIGN KEY (Order_ID)
    REFERENCES Orders (Order_ID);

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
    REFERENCES OrdersDetails (OrderDetails_ID);

-- Reference: OrderToPart (table: OrderPart)
ALTER TABLE OrderPart ADD CONSTRAINT OrderToPart
    FOREIGN KEY (Order_ID)
    REFERENCES OrdersDetails (OrderDetails_ID);

-- Reference: OrderToStudy (table: StudiesOrders)
ALTER TABLE StudiesOrders ADD CONSTRAINT OrderToStudy
    FOREIGN KEY (Order_ID)
    REFERENCES OrdersDetails (OrderDetails_ID);

-- Reference: OrderToWebinar (table: WebinarOrders)
ALTER TABLE WebinarOrders ADD CONSTRAINT OrderToWebinar
    FOREIGN KEY (Order_ID)
    REFERENCES OrdersDetails (OrderDetails_ID);

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

-- Reference: Roles_TeachersForModul (table: TeachersForModul)
ALTER TABLE TeachersForModul ADD CONSTRAINT Roles_TeachersForModul
    FOREIGN KEY (Role_ID)
    REFERENCES Roles (Role_ID)
    ON UPDATE  CASCADE;

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

-- Reference: TeachersForMeeting_Roles (table: TeachersForMeeting)
ALTER TABLE TeachersForMeeting ADD CONSTRAINT TeachersForMeeting_Roles
    FOREIGN KEY (Role_ID)
    REFERENCES Roles (Role_ID)
    ON UPDATE  CASCADE;

-- Reference: TeachersForMeeting_SubjectMeeting (table: TeachersForMeeting)
ALTER TABLE TeachersForMeeting ADD CONSTRAINT TeachersForMeeting_SubjectMeeting
    FOREIGN KEY (Meeting_ID)
    REFERENCES SubjectMeeting (Meeting_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TeachersForMeeting_TeachersLanguage (table: TeachersForMeeting)
ALTER TABLE TeachersForMeeting ADD CONSTRAINT TeachersForMeeting_TeachersLanguage
    FOREIGN KEY (Teacher_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TeachersForModul_Moduls (table: TeachersForModul)
ALTER TABLE TeachersForModul ADD CONSTRAINT TeachersForModul_Moduls
    FOREIGN KEY (Modul_ID)
    REFERENCES Moduls (Modul_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TeachersForModul_TeachersLanguage (table: TeachersForModul)
ALTER TABLE TeachersForModul ADD CONSTRAINT TeachersForModul_TeachersLanguage
    FOREIGN KEY (Teacher_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TeachersForWebinar_Roles (table: TeachersForWebinar)
ALTER TABLE TeachersForWebinar ADD CONSTRAINT TeachersForWebinar_Roles
    FOREIGN KEY (Role_ID)
    REFERENCES Roles (Role_ID)
    ON UPDATE  CASCADE;

-- Reference: TeachersForWebinar_TeachersLanguage (table: TeachersForWebinar)
ALTER TABLE TeachersForWebinar ADD CONSTRAINT TeachersForWebinar_TeachersLanguage
    FOREIGN KEY (Role_ID)
    REFERENCES TeachersLanguage (TeacherLanguage_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TeachersForWebinar_WebinarsVersion (table: TeachersForWebinar)
ALTER TABLE TeachersForWebinar ADD CONSTRAINT TeachersForWebinar_WebinarsVersion
    FOREIGN KEY (WebinarVerion_ID)
    REFERENCES WebinarsVersion (WebinarVersion_ID)
    ON DELETE  CASCADE 
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

-- Reference: Teachers_Users (table: Teachers)
ALTER TABLE Teachers ADD CONSTRAINT Teachers_Users
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: UserToOrders (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT UserToOrders
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

-- Reference: UserToWebOwner (table: OwnerWebinars)
ALTER TABLE OwnerWebinars ADD CONSTRAINT UserToWebOwner
    FOREIGN KEY (User_ID)
    REFERENCES Users (User_ID);

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
    ON UPDATE  CASCADE;

-- Reference: WebinarToVersion (table: WebinarsVersion)
ALTER TABLE WebinarsVersion ADD CONSTRAINT WebinarToVersion
    FOREIGN KEY (Webinar_ID)
    REFERENCES Webinars (Webinar_ID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- End of file.
