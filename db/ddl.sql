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

-- Insert sample users
INSERT INTO Users (UserName) VALUES
  ('User1'),
  ('User2'),
  ('User3');

-- Insert sample tasks
INSERT INTO Tasks (TaskName, TaskDescription, TaskScore, DatePublished, TaskType, DateExpire) VALUES
  ('Task1', 'Description for Task1', 100, '2024-03-01', 'daily', '2024-03-10'),
  ('Task2', 'Description for Task2', 150, '2024-03-02', 'long', '2024-03-15'),
  ('Task3', 'Description for Task3', 120, '2024-03-03', 'totd', NULL),
  ('Task4', 'Description for Task4', 200, '2024-03-04', 'daily', '2024-03-12'),
  ('Task5', 'Description for Task5', 180, '2024-03-05', 'long', '2024-03-20');

-- Insert sample scores
INSERT INTO Scores (UserID, TaskID, DateAchieved) VALUES
  (1, 1, '2024-03-02'),
  (1, 2, '2024-03-03'),
  (2, 3, '2024-03-02'),
  (3, 4, '2024-03-03'),
  (3, 5, '2024-03-04');

-- Insert more sample users
INSERT INTO Users (UserName) VALUES
  ('User4'),
  ('User5'),
  ('User6'),
  ('User7'),
  ('User8');

-- Insert more sample tasks
INSERT INTO Tasks (TaskName, TaskDescription, TaskScore, DatePublished, TaskType, DateExpire) VALUES
  ('Task6', 'Description for Task6', 120, '2024-03-06', 'daily', '2024-03-14'),
  ('Task7', 'Description for Task7', 180, '2024-03-07', 'long', '2024-03-18'),
  ('Task8', 'Description for Task8', 150, '2024-03-08', 'totd', NULL),
  ('Task9', 'Description for Task9', 200, '2024-03-09', 'daily', '2024-03-20'),
  ('Task10', 'Description for Task10', 160, '2024-03-10', 'long', '2024-03-25');

-- Insert more sample scores
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
