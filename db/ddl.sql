-- Create Users table
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL
);

-- Create Tasks table
CREATE TABLE Tasks (
    TaskID SERIAL PRIMARY KEY,
    TaskName VARCHAR(50) NOT NULL,
    TaskDescription TEXT,
    TaskScore INT NOT NULL,
    DatePublished DATE NOT NULL,
    TaskType VARCHAR(50),
    DateExpire DATE

);

-- Create Scores table with reference to Tasks
CREATE TABLE Scores (
    ScoreID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    TaskID INT REFERENCES Tasks(TaskID),
    DateAchieved DATE NOT NULL
);

CREATE VIEW Leaderboard AS
    SELECT Users.UserID, UserName, COALESCE(SUM(TaskScore), 0) AS TotalScore
    FROM Users
    LEFT JOIN Scores ON Users.UserID = Scores.UserID
    LEFT JOIN Tasks ON Scores.TaskID = Tasks.TaskID
    GROUP BY Users.UserID, UserName
    ORDER BY TotalScore DESC;

-- Insert sample users for sustainability game
INSERT INTO Users (UserName) VALUES
('GreenPlayer1'),
('EcoChampion2'),
('EcoWarrior3');

-- Insert sample sustainability tasks
INSERT INTO Tasks (TaskName, TaskDescription, TaskScore, DatePublished, TaskType, DateExpire) VALUES
('RecycleQuest1', 'Complete a recycling challenge', 100, '2024-03-01', 'daily', '2024-03-10'),
('EnergySaverQuest2', 'Reduce energy consumption for a day', 150, '2024-03-02', 'long', '2024-03-15'),
('GreenCommuteQuest3', 'Use eco-friendly transportation today', 120, '2024-03-03', 'totd', NULL),
('ZeroWasteQuest4', 'Achieve a day with zero waste', 200,'2024-03-03', 'daily', '2024-03-12'),
('SustainableMealQuest5', 'Prepare a sustainable meal', 180, '2024-03-03','long', '2024-03-20');

-- Insert sample scores for sustainability game
INSERT INTO Scores (UserID, TaskID, DateAchieved) VALUES
  (1, 1, '2024-03-02'),
  (1, 2, '2024-03-03'),
  (2, 3, '2024-03-02'),
  (3, 4, '2024-03-03'),
  (3, 5, '2024-03-04');

-- Insert more sample users for sustainability game
INSERT INTO Users (UserName) VALUES
('NatureGuardian4'),
('EcoEnthusiast5'),
('SustainableExplorer6'),
('EcoAdvocate7'),
('GreenActivist8');

-- Insert more sample sustainability tasks
INSERT INTO Tasks (TaskName, TaskDescription, TaskScore, DatePublished, TaskType, DateExpire) VALUES
('WaterConservationQuest6', 'Conserve water for a day', 120, '2024-03-03', 'daily', '2024-03-14'),
('GreenTransportQuest7', 'Promote green transportation', 180, '2024-03-03', 'long', '2024-03-18'),
('EcoAwarenessQuest8', 'Spread eco-awareness today', 150,'2024-03-07', 'totd', NULL),
('RenewableEnergyQuest9', 'Support renewable energy sources', 200,'2024-03-07', 'daily', '2024-03-20'),
('EcoFriendlyChallenge10', 'Engage in an eco-friendly challenge', 160,'2024-03-07', 'long', '2024-03-25');

-- Insert more sample scores for sustainability game
INSERT INTO Scores (UserID, TaskID, DateAchieved) VALUES
  (1, 6, '2024-03-07'),
  (1, 7, '2024-03-08'),
  (2, 8, '2024-03-07'),
  (3, 9, '2024-03-08'),
  (3, 10, '2024-03-09'),
  (4, 1, '2024-03-06'),
  (4, 2, '2024-03-07'),
  (5, 3, '2024-03-08'),
  (5, 4, '2024-03-09'),
  (5, 5, '2024-03-10');


--LeaderboardUpdateTrigger
CREATE OR REPLACE FUNCTION notify_leaderboard_update()
RETURNS TRIGGER AS $$
BEGIN
  -- Notify the leaderboard update to a channel named 'leaderboard_update'
  PERFORM pg_notify('leaderboard_update', '');

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER scores_update_trigger
AFTER INSERT OR UPDATE OR DELETE
ON Scores
FOR EACH ROW
EXECUTE FUNCTION notify_leaderboard_update();
