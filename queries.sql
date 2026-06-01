-- ================================
-- DATABASE
-- ================================
CREATE DATABASE IF NOT EXISTS event_db;
USE event_db;

-- ================================
-- TABLES
-- ================================

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL
);

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    city VARCHAR(100) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status ENUM('upcoming','completed','cancelled'),
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);

CREATE TABLE Sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    title VARCHAR(200) NOT NULL,
    speaker_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    registration_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    resource_type ENUM('pdf','image','link'),
    resource_url VARCHAR(255) NOT NULL,
    uploaded_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- ================================
-- SAMPLE DATA
-- ================================

INSERT INTO Users VALUES
(1,'Alice Johnson','alice@example.com','New York','2024-12-01'),
(2,'Bob Smith','bob@example.com','Los Angeles','2024-12-05'),
(3,'Charlie Lee','charlie@example.com','Chicago','2024-12-10'),
(4,'Diana King','diana@example.com','New York','2025-01-15'),
(5,'Ethan Hunt','ethan@example.com','Los Angeles','2025-02-01');

INSERT INTO Events VALUES
(1,'Tech Innovators Meetup','Tech event','New York','2025-06-10 10:00:00','2025-06-10 16:00:00','upcoming',1),
(2,'AI & ML Conference','AI event','Chicago','2025-05-15 09:00:00','2025-05-15 17:00:00','completed',3),
(3,'Frontend Bootcamp','Frontend training','Los Angeles','2025-07-01 10:00:00','2025-07-03 16:00:00','upcoming',2);

INSERT INTO Sessions VALUES
(1,1,'Opening Keynote','Dr Tech','2025-06-10 10:00:00','2025-06-10 11:00:00'),
(2,1,'Future of Web','Alice Johnson','2025-06-10 11:15:00','2025-06-10 12:30:00'),
(3,2,'AI Healthcare','Charlie Lee','2025-05-15 09:30:00','2025-05-15 11:00:00'),
(4,3,'HTML5 Intro','Bob Smith','2025-07-01 10:00:00','2025-07-01 12:00:00');

INSERT INTO Registrations VALUES
(1,1,1,'2025-05-01'),
(2,2,1,'2025-05-02'),
(3,3,2,'2025-04-30'),
(4,4,2,'2025-04-28'),
(5,5,3,'2025-06-15');

INSERT INTO Feedback VALUES
(1,3,2,4,'Great insights!','2025-05-16'),
(2,4,2,5,'Very informative','2025-05-16'),
(3,2,1,3,'Could be better','2025-06-11');

INSERT INTO Resources VALUES
(1,1,'pdf','link1','2025-05-01 10:00:00'),
(2,2,'image','link2','2025-04-20 09:00:00'),
(3,3,'link','link3','2025-06-25 15:00:00');

-- ================================
-- QUERIES (Exercises)
-- ================================

-- 1
SELECT u.full_name, e.title
FROM Users u
JOIN Registrations r ON u.user_id=r.user_id
JOIN Events e ON r.event_id=e.event_id
WHERE e.status='upcoming' AND u.city=e.city;

-- 2
SELECT e.title, AVG(f.rating)
FROM Events e JOIN Feedback f ON e.event_id=f.event_id
GROUP BY e.event_id HAVING COUNT(*)>=1;

-- 3
SELECT * FROM Users
WHERE user_id NOT IN (SELECT user_id FROM Registrations);

-- 4
SELECT event_id, COUNT(*) 
FROM Sessions
WHERE TIME(start_time) BETWEEN '10:00:00' AND '12:00:00'
GROUP BY event_id;

-- 5
SELECT city, COUNT(*) FROM Users GROUP BY city;

-- 6
SELECT event_id, COUNT(*) FROM Resources GROUP BY event_id;

-- 7
SELECT * FROM Feedback WHERE rating<3;

-- 8
SELECT e.title, COUNT(s.session_id)
FROM Events e LEFT JOIN Sessions s ON e.event_id=s.event_id
WHERE e.status='upcoming'
GROUP BY e.event_id;

-- 9
SELECT organizer_id, COUNT(*) FROM Events GROUP BY organizer_id;

-- 10
SELECT e.title FROM Events e
LEFT JOIN Feedback f ON e.event_id=f.event_id
WHERE f.event_id IS NULL;

-- 11
SELECT registration_date, COUNT(*) FROM Users GROUP BY registration_date;

-- 12
SELECT event_id FROM Sessions
GROUP BY event_id
ORDER BY COUNT(*) DESC LIMIT 1;

-- 13
SELECT e.city, AVG(f.rating)
FROM Events e JOIN Feedback f ON e.event_id=f.event_id
GROUP BY e.city;

-- 14
SELECT event_id, COUNT(*) FROM Registrations
GROUP BY event_id ORDER BY COUNT(*) DESC LIMIT 3;

-- 15
SELECT * FROM Sessions s1 JOIN Sessions s2
ON s1.event_id=s2.event_id
AND s1.session_id<>s2.session_id;

-- 16
SELECT * FROM Users
WHERE registration_date >= CURDATE()-INTERVAL 30 DAY
AND user_id NOT IN (SELECT user_id FROM Registrations);

-- 17
SELECT speaker_name, COUNT(*) FROM Sessions
GROUP BY speaker_name HAVING COUNT(*)>1;

-- 18
SELECT e.title FROM Events e
LEFT JOIN Resources r ON e.event_id=r.event_id
WHERE r.event_id IS NULL;

-- 19
SELECT e.title, COUNT(r.registration_id), AVG(f.rating)
FROM Events e
LEFT JOIN Registrations r ON e.event_id=r.event_id
LEFT JOIN Feedback f ON e.event_id=f.event_id
WHERE e.status='completed'
GROUP BY e.event_id;

-- 20
SELECT u.full_name,
COUNT(DISTINCT r.event_id),
COUNT(DISTINCT f.feedback_id)
FROM Users u
LEFT JOIN Registrations r ON u.user_id=r.user_id
LEFT JOIN Feedback f ON u.user_id=f.user_id
GROUP BY u.user_id;

-- 21
SELECT user_id, COUNT(*) FROM Feedback
GROUP BY user_id ORDER BY COUNT(*) DESC LIMIT 5;

-- 22
SELECT user_id, event_id, COUNT(*)
FROM Registrations
GROUP BY user_id,event_id HAVING COUNT(*)>1;

-- 23
SELECT MONTH(registration_date), COUNT(*)
FROM Registrations GROUP BY MONTH(registration_date);

-- 24
SELECT event_id,
AVG(TIMESTAMPDIFF(MINUTE,start_time,end_time))
FROM Sessions GROUP BY event_id;

-- 25
SELECT e.title FROM Events e
LEFT JOIN Sessions s ON e.event_id=s.event_id
WHERE s.event_id IS NULL;