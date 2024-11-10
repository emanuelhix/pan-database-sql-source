CREATE TABLE Person(
    SSN INT PRIMARY KEY,
    Name VARCHAR(20),
    Gender VARCHAR(20),
    Profession VARCHAR(20),
    MailingAddress VARCHAR(20),
    EmailAddress VARCHAR(20),
    PhoneNumber INT,
    IsOnMailingList INT CHECK (IsOnMailingList >= 0 AND IsOnMailingList <= 1),
);

CREATE TABLE EmergencyContact(
    PersonSSN INT,
    Name VARCHAR(20),
    PhoneNumber INT,
    Relationship VARCHAR(20), 
    PRIMARY KEY (PersonSSN, PhoneNumber),
    FOREIGN KEY (PersonSSN) REFERENCES PERSON(SSN)
);