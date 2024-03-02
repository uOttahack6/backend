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
    DatePublished DATE NOT NULL
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
INSERT INTO Tasks (TaskName, TaskDescription, TaskScore, DatePublished) VALUES
  ('Task1', 'Description for Task1', 100, '2024-03-01'),
  ('Task2', 'Description for Task2', 150, '2024-03-02'),
  ('Task3', 'Description for Task3', 120, '2024-03-03'),
  ('Task4', 'Description for Task4', 200, '2024-03-04'),
  ('Task5', 'Description for Task5', 180, '2024-03-05');

-- Insert sample scores
INSERT INTO Scores (UserID, TaskID, DateAchieved) VALUES
  (1, 1, '2024-03-02'),
  (1, 2, '2024-03-03'),
  (2, 3, '2024-03-02'),
  (3, 4, '2024-03-03'),
  (3, 5, '2024-03-04');
