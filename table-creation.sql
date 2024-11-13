CREATE TABLE Person(
    SSN INT,
    Name VARCHAR(20),
    Gender VARCHAR(20),
    Profession VARCHAR(20),
    MailingAddress VARCHAR(20),
    EmailAddress VARCHAR(20),
    PhoneNumber INT CHECK (PhoneNumber >= 0), 
    IsOnMailingList BIT,
    PRIMARY KEY (SSN)
);

CREATE TABLE InsurancePolicy(
    PolicyID INT,
    ProviderName VARCHAR(20),
    ProviderAddress VARCHAR(20),
    InsuranceType VARCHAR(15),
    PRIMARY KEY (PolicyID),
);

CREATE TABLE Team(
    TeamName VARCHAR(20),
    TeamType VARCHAR(20),
    DateFormed DATE,
    PRIMARY KEY (TeamName)
);

/* Specializations of Person */
/* ----------------- */

CREATE TABLE Volunteer(
    SSN INT, 
    DateJoined DATE,
    TrainingLocation VARCHAR(20),
    TrainingDate DATE,
    PRIMARY KEY(SSN),
    FOREIGN KEY (SSN) REFERENCES Person(SSN),
);

Create Table Employee(
    SSN INT, 
    Salary DECIMAL(10, 2) CHECK (Salary >= 0),
    MaritalStatus VARCHAR(20),
    HireDate DATE,
    PRIMARY KEY(SSN),
    FOREIGN KEY (SSN) REFERENCES Person(SSN),
);

CREATE TABLE Client(
    SSN INT,
    PhoneDoctor INT CHECK (PhoneDoctor >= 0), 
    NameDoctor VARCHAR(20),
    DateAssigned DATE,
    PRIMARY KEY(SSN),
    FOREIGN KEY (SSN) REFERENCES Person(SSN),
);

CREATE TABLE Donor(
    SSN INT,
    IsAnonymous BIT,
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Person(SSN),
);

/* Relationship Sets */
/* ----------------- */
/* Relationships between Weak Sets */ 

CREATE TABLE EmergencyContact(
    PersonSSN INT,
    Name VARCHAR(20),
    /* The phone number is considered to be the discriminator. */
    /* It's feasible that two contacts could have the same name. A phone number will not be the same, however. */
    PhoneNumber INT CHECK (PhoneNumber >= 0), 
    Relationship VARCHAR(20), 
    PRIMARY KEY (PersonSSN, PhoneNumber),
    FOREIGN KEY (PersonSSN) REFERENCES PERSON(SSN)
);

CREATE TABLE ClientNeeds(
    ClientSSN INT NOT NULL,
    /* The name of the need is considered to be the discriminator. */
    NeedName VARCHAR(20),
    Importance INT CHECK(Importance >= 0 AND Importance <= 10),
    /* For each client, no two needs should have the same name. */
    PRIMARY KEY (ClientSSN, NeedName),
    FOREIGN KEY (ClientSSN) REFERENCES Client(SSN),
)

/* Currently, there is no way to uniquely identify an expense. */
/* This table allows multiple entries of an expense for each employee. */
CREATE TABLE Expense(
    EmployeeSSN INT NOT NULL,
    Amount DECIMAL(10, 2),
    ExpenseDescription VARCHAR(100),
    FOREIGN KEY (EmployeeSSN) REFERENCES Employee(SSN),
)

-- Table for Donation with composite primary key on DonorSSN and DonoDate
CREATE TABLE Donation (
    DonorSSN INT,
    Amount DECIMAL(10, 2),
    DonoType VARCHAR(5),  -- Type of donation
    Campaign VARCHAR(20),
    DonoDate DATE,
    FOREIGN KEY (DonorSSN) REFERENCES Donor(SSN),
    PRIMARY KEY (DonorSSN, DonoDate)  
);

CREATE TABLE CheckDonation (
    CheckNumber INT,     
    DonorSSN INT,        
    DonoDate DATE,   
    PRIMARY KEY (DonorSSN, DonoDate, CheckNumber),
    CONSTRAINT fk_donation FOREIGN KEY (DonorSSN, DonoDate)  
        REFERENCES Donation (DonorSSN, DonoDate)
);

CREATE TABLE CardDonation (
    CardNumber INT,      
    DonorSSN INT,       
    DonoDate DATE,     
    PRIMARY KEY (DonorSSN, DonoDate, CardNumber),  
    CONSTRAINT fk_donation FOREIGN KEY (DonorSSN, DonoDate)  
        REFERENCES Donation (DonorSSN, DonoDate)
);

/* Relationships between Strong Sets */

CREATE TABLE Insures(
    ClientSSN INT, -- NOT NULL, The Relationship is many to many.
    PolicyID INT,
    PRIMARY KEY (ClientSSN, PolicyID),
    FOREIGN KEY (ClientSSN) REFERENCES Client(SSN),
    FOREIGN KEY (PolicyID) REFERENCES InsurancePolicy(PolicyID),
);

CREATE TABLE Cares(
    ClientSSN INT NOT NULL,
    TeamName VARCHAR(20) NOT NULL,
    PRIMARY KEY(ClientSSN, TeamName),
    FOREIGN KEY (ClientSSN) REFERENCES Client(SSN),
    FOREIGN KEY (TeamName) REFERENCES Team(TeamName),
);

CREATE TABLE Serves(
    VolunteerSSN INT, 
    TeamName VARCHAR(20),
    DateJoined DATE,
    MonthlyHours DECIMAL(10, 2) CHECK (MonthlyHours >= 0),
    IsActive BIT,
    IsLeader BIT,
    PRIMARY KEY (VolunteerSSN, TeamName),
    FOREIGN KEY (VolunteerSSN) REFERENCES Volunteer(SSN),
    FOREIGN KEY (TeamName) REFERENCES Team(TeamName),
    /* Ensures that no volunteer is a leader of more than one team. */
    CONSTRAINT is_leader UNIQUE (VolunteerSSN, IsLeader)
);

/*
CREATE TABLE Leads(
    /* Volunteers only lead one team. */
    VolunteerSSN INT UNIQUE,
    PRIMARY KEY (VolunteerSSN),
    FOREIGN KEY (VolunteerSSN) REFERENCES Volunteer(SSN),
    FOREIGN KEY (TeamName) REFERENCES Team(TeamName),
);
*/

CREATE TABLE Reports(
    EmployeeSSN INT,
    TeamName VARCHAR(20) NOT NULL,
    ReportDate DATE NOT NULL, 
    ContentDescription VARCHAR(100),
    PRIMARY KEY (EmployeeSSN, TeamName),
    FOREIGN KEY (EmployeeSSN) REFERENCES Employee(SSN),
    FOREIGN KEY (TeamName) REFERENCES Team(TeamName),
    /* Assumption: A report will not be made on the same date for the same team to the same employee. */
    /* CONSTRAINT unique_report UNIQUE (TeamName, EmployeeSSN, ReportDate), */
);