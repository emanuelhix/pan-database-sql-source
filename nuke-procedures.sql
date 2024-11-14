-- Drop procedures if they exist

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertTeam')
    DROP PROCEDURE InsertTeam;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertPerson')
    DROP PROCEDURE InsertPerson;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertClient')
    DROP PROCEDURE InsertClient;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertCares')
    DROP PROCEDURE InsertCares;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertClientNeeds')
    DROP PROCEDURE InsertClientNeeds;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertInsures')
    DROP PROCEDURE InsertInsures;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertVolunteer')
    DROP PROCEDURE InsertVolunteer;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'InsertServes')
    DROP PROCEDURE InsertServes;
GO
