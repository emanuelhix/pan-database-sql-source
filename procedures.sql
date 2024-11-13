CREATE PROCEDURE InsertTeam
    @p_TeamName VARCHAR(20),
    @p_TeamType VARCHAR(20),
    @p_DateFormed DATE
AS
BEGIN
    INSERT INTO Team (TeamName, TeamType, DateFormed)
    SELECT @p_TeamName, @p_TeamType, @p_DateFormed;
END;
