CREATE PROCEDURE InsertTeam
    @p_TeamName VARCHAR(20),
    @p_TeamType VARCHAR(20),
    @p_DateFormed DATE
AS
BEGIN
    INSERT INTO Team (TeamName, TeamType, DateFormed)
    VALUES (@p_TeamName, @p_TeamType, @p_DateFormed);
END
GO

CREATE PROCEDURE InsertPerson
    @p_SSN INT,
    @p_Name VARCHAR(20),
    @p_Gender VARCHAR(20),
    @p_Profession VARCHAR(20),
    @p_MailingAddress VARCHAR(20),
    @p_EmailAddress VARCHAR(20),
    @p_PhoneNumber INT,
    @p_IsOnMailingList BIT
AS
BEGIN 
    -- Check if a person with the given SSN already exists
    IF NOT EXISTS (SELECT 1 FROM Person WHERE SSN = @p_SSN)
    BEGIN
        -- Insert the new person record if SSN does not exist
        INSERT INTO Person (SSN, Name, Gender, Profession, MailingAddress, EmailAddress, PhoneNumber, IsOnMailingList)
        VALUES (@p_SSN, @p_Name, @p_Gender, @p_Profession, @p_MailingAddress, @p_EmailAddress, @p_PhoneNumber, @p_IsOnMailingList);
    END
    ELSE
    BEGIN
        PRINT 'Warning: SSN already exists in the Person table.';
    END
END
GO


CREATE PROCEDURE InsertClient
    @p_SSN INT,
    @p_PhoneDoctor INT,
    @p_NameDoctor VARCHAR(20),
    @p_DateAssigned DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Person WHERE SSN = @p_SSN)
    BEGIN
        RAISERROR(13001, 16, 1) -- Raise error for JDBC to handle
    END
    -- Insert the client record, knowing that the SSN exists in Person table
    INSERT INTO Client (SSN, PhoneDoctor, NameDoctor, DateAssigned)
    VALUES (@p_SSN, @p_PhoneDoctor, @p_NameDoctor, @p_DateAssigned);    
END
GO

CREATE PROCEDURE InsertCares
    @p_SSN INT,
    @p_TeamName VARCHAR(20)
AS 
BEGIN
    INSERT INTO Cares(ClientSSN, TeamName)
    VALUES (@p_SSN, @p_TeamName)
END
GO


CREATE PROCEDURE InsertClientNeeds
    @p_ClientSSN INT,            -- Client's SSN
    @p_NeedName VARCHAR(20),     -- The name of the need
    @p_Importance INT           -- Importance of the need (0 to 10)
AS
BEGIN
    -- Insert the new need for the client into the ClientNeeds table
    INSERT INTO ClientNeeds (ClientSSN, NeedName, Importance)
    VALUES (@p_ClientSSN, @p_NeedName, @p_Importance);
END
GO

CREATE PROCEDURE InsertInsures
    @ClientSSN INT,
    @PolicyID INT
AS
BEGIN
    -- Insert the data into the Insures table
    INSERT INTO Insures (ClientSSN, PolicyID)
    VALUES (@ClientSSN, @PolicyID);
END
GO 

CREATE PROCEDURE InsertVolunteer
    @p_SSN INT,
    @p_DateJoined DATE,
    @p_TrainingLocation VARCHAR(20),
    @p_TrainingDate DATE
AS
BEGIN
    -- Insert the record into the Volunteer table
    INSERT INTO Volunteer (SSN, DateJoined, TrainingLocation, TrainingDate)
    VALUES (@p_SSN, @p_DateJoined, @p_TrainingLocation, @p_TrainingDate);
END
GO

CREATE PROCEDURE InsertServes
    @p_VolunteerSSN INT,
    @p_TeamName VARCHAR(20),
    @p_DateJoined DATE,
    @p_MonthlyHours DECIMAL(10, 2),
    @p_IsActive BIT,
    @p_IsLeader BIT
AS
BEGIN
    -- Check if the VolunteerSSN exists in the Person table
    IF NOT EXISTS (SELECT 1 FROM Person WHERE SSN = @p_VolunteerSSN)
    BEGIN
        RAISERROR('Volunteer with SSN %d does not exist in the Person table.', 16, 1, @p_VolunteerSSN);
        RETURN;
    END

    -- Check if the TeamName exists in the Team table
    IF NOT EXISTS (SELECT 1 FROM Team WHERE TeamName = @p_TeamName)
    BEGIN
        RAISERROR('Team %s does not exist in the Team table.', 16, 1, @p_TeamName);
        RETURN;
    END

    -- Insert the record into the Serves table
    INSERT INTO Serves (VolunteerSSN, TeamName, DateJoined, MonthlyHours, IsActive, IsLeader)
    VALUES (@p_VolunteerSSN, @p_TeamName, @p_DateJoined, @p_MonthlyHours, @p_IsActive, @p_IsLeader);

    PRINT 'Record inserted successfully into Serves table.';
END;
