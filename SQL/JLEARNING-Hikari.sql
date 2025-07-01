-- Create and use the JLEARNING database
CREATE DATABASE JLEARNING;
DROP DATABASE IF EXISTS JLEARNING;
USE JLEARNING;


select * from UserAccount
	-- Update UserAccount table
CREATE TABLE UserAccount (
    userID VARCHAR(10) PRIMARY KEY CHECK (userID REGEXP '^U[0-9]{3}$') , 
    username VARCHAR(255) NOT NULL,
    fullName VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Student', 'Teacher', 'Admin', 'Coordinator')),
    registrationDate DATE DEFAULT (CURRENT_DATE),
    profilePicture VARCHAR(255),
    phone VARCHAR(20),
    birthDate DATE 
);

ALTER TABLE UserAccount
ADD COLUMN isActive BOOLEAN DEFAULT 1;

select * from UserAccount
INSERT INTO UserAccount (userID, fullName, username, email, password, role, profilePicture, phone, birthDate, registrationDate) VALUES
('U018', 'Nguyễn Văn A', 'a123', 'a123@gmail.com', 'password123', 'Student', '18.jpg', '0900000001', '1990-01-01', '2025-01-10'),
('U019', 'Nguyễn Văn B', 'b123', 'b123@gmail.com', 'password123', 'Teacher', '19.jpg', '0900000002', '1988-02-02', '2025-01-22'),
('U020', 'Nguyễn Văn C', 'c123', 'c123@gmail.com', 'password123', 'Student', '20.jpg', '0900000003', '1991-03-03', '2025-02-05'),
('U021', 'Nguyễn Văn D', 'd123', 'd123@gmail.com', 'password123', 'Coordinator', '21.jpg', '0900000004', '1992-04-04', '2025-02-15'),
('U022', 'Nguyễn Văn E', 'e123', 'e123@gmail.com', 'password123', 'Admin', '22.jpg', '0900000005', '1989-05-05', '2025-02-28'),
('U023', 'Nguyễn Văn F', 'f123', 'f123@gmail.com', 'password123', 'Student', '23.jpg', '0900000006', '1993-06-06', '2025-03-03'),
('U024', 'Nguyễn Văn G', 'g123', 'g123@gmail.com', 'password123', 'Teacher', '24.jpg', '0900000007', '1987-07-07', '2025-03-10'),
('U025', 'Nguyễn Văn H', 'h123', 'h123@gmail.com', 'password123', 'Student', '25.jpg', '0900000008', '1994-08-08', '2025-03-22'),
('U026', 'Nguyễn Văn I', 'i123', 'i123@gmail.com', 'password123', 'Coordinator', '26.jpg', '0900000009', '1995-09-09', '2025-04-01'),
('U027', 'Nguyễn Văn J', 'j123', 'j123@gmail.com', 'password123', 'Admin', '27.jpg', '0900000010', '1996-10-10', '2025-04-10'),
('U028', 'Nguyễn Văn K', 'k123', 'k123@gmail.com', 'password123', 'Student', '28.jpg', '0900000011', '1997-11-11', '2025-04-18'),
('U029', 'Nguyễn Văn L', 'l123', 'l123@gmail.com', 'password123', 'Teacher', '29.jpg', '0900000012', '1998-12-12', '2025-04-25'),
('U030', 'Nguyễn Văn M', 'm123', 'm123@gmail.com', 'password123', 'Student', '30.jpg', '0900000013', '1999-01-01', '2025-05-02'),
('U031', 'Nguyễn Văn N', 'n123', 'n123@gmail.com', 'password123', 'Student', '31.jpg', '0900000014', '1985-02-02', '2025-05-10'),
('U032', 'Nguyễn Văn O', 'o123', 'o123@gmail.com', 'password123', 'Teacher', '32.jpg', '0900000015', '1986-03-03', '2025-05-18'),
('U033', 'Nguyễn Văn P', 'p123', 'p123@gmail.com', 'password123', 'Coordinator', '33.jpg', '0900000016', '1987-04-04', '2025-05-20'),
('U034', 'Nguyễn Văn Q', 'q123', 'q123@gmail.com', 'password123', 'Admin', '34.jpg', '0900000017', '1988-05-05', '2025-05-25'),
('U035', 'Nguyễn Văn R', 'r123', 'r123@gmail.com', 'password123', 'Student', '35.jpg', '0900000018', '1990-06-06', '2025-01-05'),
('U036', 'Nguyễn Văn S', 's123', 's123@gmail.com', 'password123', 'Teacher', '36.jpg', '0900000019', '1991-07-07', '2025-02-12'),
('U037', 'Nguyễn Văn T', 't1234', 't1234@gmail.com', 'password123', 'Student', '37.jpg', '0900000020', '1992-08-08', '2025-03-25');

-- Update Student table
CREATE TABLE Student (
    studentID VARCHAR(10)  PRIMARY KEY check (studentID REGEXP '^S[0-9]{3}$'), -- Removed computed column
    userID VARCHAR(10) UNIQUE,
    enrollmentDate DATE DEFAULT (CURRENT_DATE),
    vote INT DEFAULT 0,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID) ON DELETE CASCADE
);

-- Update Teacher table
CREATE TABLE Teacher (
    teacherID VARCHAR(10) PRIMARY KEY check (teacherID REGEXP '^T[0-9]{3}$'),
    userID VARCHAR(10) UNIQUE NOT NULL,
    specialization VARCHAR(255),
    experienceYears INT CHECK (experienceYears >= 0),
    FOREIGN KEY (userID) REFERENCES UserAccount(userID) ON DELETE CASCADE
);

-- Update  Courses table 
CREATE TABLE Courses (
    courseID VARCHAR(10) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    fee DECIMAL(10, 2) DEFAULT 0.00,
    duration INT,
    imageUrl varchar(500) NULL,
    startDate DATE,
    endDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    CONSTRAINT CHK_CourseID_Prefix CHECK (courseID REGEXP '^CO[0-9]{3}$'),
    CONSTRAINT CHK_Course_Dates CHECK (endDate >= startDate)
);
-- Update Course_Enrollments table
CREATE TABLE Course_Enrollments (
    enrollmentID varchar(10) primary key check (enrollmentID REGEXP '^E[0-9]{3}$'),
    studentID VARCHAR(10) NOT NULL,
    courseID VARCHAR(10) NOT NULL,
    enrollmentDate DATE DEFAULT (CURRENT_DATE),
    completionDate DATE,
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);
select count(*) from Course_Enrollments where  courseID = "CO001" ;
-- Create Course_Reviews table
CREATE TABLE Course_Reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    courseID VARCHAR(10) NOT NULL,
    userID VARCHAR(10) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    reviewText TEXT,
    reviewDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);
-- Create course_info table (from Hikari)
CREATE TABLE course_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(10) NOT NULL,
    overview TEXT NOT NULL,
    objectives TEXT NOT NULL,
    level_description TEXT NOT NULL,
    tuition_info TEXT NOT NULL,
    duration VARCHAR(100) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(courseID) ON DELETE CASCADE,
    INDEX idx_course_info_course_id (course_id)
);

-- Create commitments table (from Hikari)
CREATE TABLE commitments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(10) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(500) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    display_order INT DEFAULT 1,
    FOREIGN KEY (course_id) REFERENCES Courses(courseID) ON DELETE CASCADE,
    INDEX idx_commitments_course_id (course_id)
);

-- Create roadmap table (from Hikari)
CREATE TABLE roadmap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(10) NOT NULL,
    step_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(500) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(courseID) ON DELETE CASCADE,
    INDEX idx_roadmap_course_id (course_id)
);
-- Create Topic table
CREATE TABLE Topic (
    topicID VARCHAR(10) PRIMARY KEY CHECK (topicID REGEXP '^TP[0-9]{3}$'),
    courseID VARCHAR(10) NOT NULL,
    topicName VARCHAR(100) NOT NULL,
    description TEXT,
    orderIndex INT NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID) ON DELETE CASCADE,
    UNIQUE KEY unique_course_order (courseID, orderIndex),
    UNIQUE KEY unique_course_topic (courseID, topicName)
);
-- Update Lesson table
CREATE TABLE Lesson (
    id INT AUTO_INCREMENT PRIMARY KEY,

    topicID VARCHAR(10) NOT NULL,
    topicName VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    mediaUrl VARCHAR(500),
    duration INT,
    isCompleted BOOLEAN DEFAULT false,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (topicID) REFERENCES Topic(topicID) ON DELETE CASCADE
);

-- Create Progress table
CREATE TABLE Progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentID VARCHAR(10) NOT NULL,
    enrollmentID varchar(10) NOT NULL,
    lessonID INT NOT NULL,
    completionStatus VARCHAR(20) NOT NULL DEFAULT 'in progress' CHECK (completionStatus IN ('complete', 'in progress')),
    startDate DATE,
    endDate DATE,
    score DECIMAL(5, 2),
    feedback VARCHAR(500),
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (enrollmentID) REFERENCES Course_Enrollments(enrollmentID),
    FOREIGN KEY (lessonID) REFERENCES Lesson(id)
);
-- Create Document table
CREATE TABLE Document (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lessonID INT ,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    fileUrl VARCHAR(500),
    uploadDate DATETIME DEFAULT NOW(),
    uploadedBy VARCHAR(10),
    FOREIGN KEY (lessonID) REFERENCES Lesson(id),
    FOREIGN KEY (uploadedBy) REFERENCES Teacher(teacherID)
);

-- Create Exercise table (renamed from 'exercise' to avoid reserved keyword)
CREATE TABLE Exercise (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lessonID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    dueDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (lessonID) REFERENCES Lesson(id)
);

-- Create Tests table
CREATE TABLE Test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jlptLevel VARCHAR(10) NOT NULL CHECK (jlptLevel IN ('N5', 'N4', 'N3', 'N2', 'N1')),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    totalMarks INT CHECK (totalMarks >= 0),
    totalQuestions INT CHECK (totalQuestions >= 0),
    dueDate DATE,
    isActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE Assignment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    topicID VARCHAR(10) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    totalMarks INT CHECK (totalMarks >= 0),
    totalQuestions INT CHECK (totalQuestions >= 0),
    dueDate DATE,
    isActive BOOLEAN DEFAULT TRUE,

    -- Liên kết với Topic
    FOREIGN KEY (topicID) REFERENCES Topic(topicID) ON DELETE CASCADE
);
-- Create Question table
CREATE TABLE Question (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assignmentID INT,
    testID INT,
    questionText TEXT NOT NULL,
    optionA VARCHAR(255),
    optionB VARCHAR(255),
    optionC VARCHAR(255),
    optionD VARCHAR(255),
    correctOption CHAR(1) CHECK (correctOption IN ('A', 'B', 'C', 'D')),
    essayAnswer TEXT,
    mark INT DEFAULT 1 CHECK (mark >= 0),

    FOREIGN KEY (assignmentID) REFERENCES Assignment(id) ON DELETE CASCADE,
    FOREIGN KEY (testID) REFERENCES Test(id) ON DELETE CASCADE,

    -- Đảm bảo chỉ liên kết một loại test
    CHECK (
        (assignmentID IS NOT NULL AND testID IS NULL) OR
        (assignmentID IS NULL AND testID IS NOT NULL)
    )
);


-- Create Payment table
CREATE TABLE Payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentID VARCHAR(10) NOT NULL,
    enrollmentID VARCHAR(10) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentMethod VARCHAR(50),
    paymentStatus VARCHAR(20) NOT NULL CHECK (paymentStatus IN ('Cancel', 'Pending', 'Complete')),
    paymentDate DATETIME DEFAULT NOW(),
    transactionID VARCHAR(100),
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (enrollmentID) REFERENCES Course_Enrollments(enrollmentID)
);
-- Create updated Class table (as per requested modifications)
CREATE TABLE Class (
    classID VARCHAR(10) PRIMARY KEY CHECK (classID REGEXP '^CL[0-9]{3}$'),
    courseID VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    teacherID VARCHAR(10) NOT NULL,
    numberOfStudents INT DEFAULT 0 CHECK (numberOfStudents >= 0),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
    FOREIGN KEY (teacherID) REFERENCES Teacher(teacherID)
);

-- Create Class_Students table for class-student relationships
CREATE TABLE Class_Students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    classID VARCHAR(10) NOT NULL,
    studentID VARCHAR(10) NOT NULL,
    joinDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (classID) REFERENCES Class(classID),
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    CONSTRAINT UC_Class_Student UNIQUE (classID, studentID)
);

-- Create Lesson_Reviews table for lesson review process
CREATE TABLE Lesson_Reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lessonID INT NOT NULL,
    reviewerID VARCHAR(10) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    reviewText TEXT,
    reviewStatus VARCHAR(20) NOT NULL CHECK (reviewStatus IN ('Pending', 'Approved', 'Rejected')),
    reviewDate DATETIME DEFAULT NOW(),
    FOREIGN KEY (lessonID) REFERENCES Lesson(id),
    FOREIGN KEY (reviewerID) REFERENCES UserAccount(userID)
);

-- Create Test_Reviews table for test review process
CREATE TABLE Test_Reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    testID INT NOT NULL,
    reviewerID VARCHAR(10) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    reviewText TEXT,
    reviewStatus VARCHAR(20) NOT NULL CHECK (reviewStatus IN ('Pending', 'Approved', 'Rejected')),
    reviewDate DATETIME DEFAULT NOW(),
    FOREIGN KEY (testID) REFERENCES Test(id),
    FOREIGN KEY (reviewerID) REFERENCES UserAccount(userID)
);
-- Create Announcement table
CREATE TABLE Announcement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    postedDate DATETIME DEFAULT NOW(),
    postedBy VARCHAR(10),
    FOREIGN KEY (postedBy) REFERENCES UserAccount(userID)
);

-- Create Discount table
CREATE TABLE Discount (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    courseID VARCHAR(10) NOT NULL,
    discountPercent INT CHECK (discountPercent BETWEEN 0 AND 100),
    startDate DATE,
    endDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
	CONSTRAINT CHK_Discount_Dates CHECK (endDate >= startDate)

);

-- Create Cart table
CREATE TABLE Cart (
    cartID INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) NOT NULL,
    totalAmount DECIMAL(10, 2) DEFAULT 0.00,
    discountCodeApplied VARCHAR(50),
    discountAmount DECIMAL(10, 2) DEFAULT 0.00,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID) ON DELETE CASCADE,
    CONSTRAINT UC_Cart_User UNIQUE (userID) -- Ensure one cart per user
);

-- Create CartItem table
CREATE TABLE CartItem (
    cartItemID INT AUTO_INCREMENT PRIMARY KEY,
    cartID INT NOT NULL,
    courseID VARCHAR(10) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 1),
    priceAtTime DECIMAL(10, 2) NOT NULL,
    discountApplied DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (cartID) REFERENCES Cart(cartID) ON DELETE CASCADE,
    FOREIGN KEY (courseID) REFERENCES Courses(courseID) ON DELETE CASCADE,
    CONSTRAINT UC_Cart_Course UNIQUE (cartID, courseID) -- Ensure one course per cart
);
-- Create ForumPost table
CREATE TABLE ForumPost (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    postedBy VARCHAR(10) NOT NULL,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(50),
    viewCount INT DEFAULT 0,
    voteCount INT DEFAULT 0,
    picture VARCHAR(500),
    FOREIGN KEY (postedBy) REFERENCES UserAccount(userID)
);

-- Create ForumComment table
CREATE TABLE ForumComment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    postID INT NOT NULL,
    commentText TEXT NOT NULL,
    commentedBy VARCHAR(10) NOT NULL,
    commentedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    voteCount INT DEFAULT 0,
    FOREIGN KEY (postID) REFERENCES ForumPost(id) ON DELETE CASCADE,
    FOREIGN KEY (commentedBy) REFERENCES UserAccount(userID)
);

-- Create ForumCommentVote table

CREATE TABLE ForumCommentVote (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commentID INT,
    postID INT,
    userID VARCHAR(10) NOT NULL,
    voteValue INT NOT NULL,
    voteDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (commentID) REFERENCES ForumComment(id) ON DELETE CASCADE,
    FOREIGN KEY (postID) REFERENCES ForumPost(id) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID),
    CONSTRAINT UC_Comment_User UNIQUE (commentID, postID, userID),
    CONSTRAINT chk_vote_value CHECK (voteValue IN (1, -1))
);


-- Add the new unique constraint
ALTER TABLE ForumCommentVote
ADD CONSTRAINT UC_Comment_Or_Post_User UNIQUE (commentID, postID, userID);
-- Create UserActivityScore table

-- Create updated UserActivityScore table
CREATE TABLE UserActivityScore (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) NOT NULL,
    weeklyComments INT DEFAULT 0,
    weeklyVotes INT DEFAULT 0,
    monthlyComments INT DEFAULT 0,
    monthlyVotes INT DEFAULT 0,
    totalComments INT DEFAULT 0,
    totalVotes INT DEFAULT 0,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);
DELIMITER //

-- Trigger for new comments
CREATE TRIGGER UpdateCommentScores
AFTER INSERT ON ForumComment
FOR EACH ROW
BEGIN
    DECLARE weekStart DATE;
    DECLARE monthStart DATE;
    SET weekStart = DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY);
    SET monthStart = DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY);

    INSERT INTO UserActivityScore (userID, weeklyComments, monthlyComments, totalComments)
    VALUES (NEW.commentedBy, 0, 0, 0)
    ON DUPLICATE KEY UPDATE
        weeklyComments = weeklyComments + (CASE WHEN NEW.commentedDate >= weekStart THEN 1 ELSE 0 END),
        monthlyComments = monthlyComments + (CASE WHEN NEW.commentedDate >= monthStart THEN 1 ELSE 0 END),
        totalComments = totalComments + 1;
END //

--- Trigger for new votes
CREATE TRIGGER UpdateVoteScores
AFTER INSERT ON ForumCommentVote
FOR EACH ROW
BEGIN
    DECLARE weekStart DATE;
    DECLARE monthStart DATE;
    SET weekStart = DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY);
    SET monthStart = DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY);

    INSERT INTO UserActivityScore (userID, weeklyVotes, monthlyVotes, totalVotes)
    VALUES (NEW.userID, 0, 0, 0)
    ON DUPLICATE KEY UPDATE
        weeklyVotes = weeklyVotes + (CASE WHEN NEW.voteDate >= weekStart THEN NEW.voteValue ELSE 0 END),
        monthlyVotes = monthlyVotes + (CASE WHEN NEW.voteDate >= monthStart THEN NEW.voteValue ELSE 0 END),
        totalVotes = totalVotes + NEW.voteValue;
END //

-- Trigger for vote removal (if a vote is deleted)
CREATE TRIGGER UpdateVoteRemovalScores
AFTER DELETE ON ForumCommentVote
FOR EACH ROW
BEGIN
    DECLARE weekStart DATE;
    DECLARE monthStart DATE;
    SET weekStart = DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY);
    SET monthStart = DATE_SUB(CURDATE(), INTERVAL DAYOFMONTH(CURDATE()) - 1 DAY);

    UPDATE UserActivityScore
    SET
        weeklyVotes = weeklyVotes - (CASE WHEN OLD.voteDate >= weekStart THEN OLD.voteValue ELSE 0 END),
        monthlyVotes = monthlyVotes - (CASE WHEN OLD.voteDate >= monthStart THEN OLD.voteValue ELSE 0 END),
        totalVotes = totalVotes - OLD.voteValue
    WHERE userID = OLD.userID;
END //

DELIMITER ;

DELIMITER //

-- Procedure to reset weekly scores
CREATE PROCEDURE ResetWeeklyScores()
BEGIN
    UPDATE UserActivityScore
    SET weeklyComments = 0, weeklyVotes = 0;
END //

-- Procedure to reset monthly scores
CREATE PROCEDURE ResetMonthlyScores()
BEGIN
    UPDATE UserActivityScore
    SET monthlyComments = 0, monthlyVotes = 0;
END //

DELIMITER ;


-- Create TestTopScorer table
CREATE TABLE TestTopScorer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    testID INT NOT NULL,
    userID VARCHAR(10) NOT NULL,
    score INT CHECK (score >= 0),
    takenDate DATETIME DEFAULT NOW(),
    FOREIGN KEY (testID) REFERENCES Test(id),
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);

-- Create Achievements table
CREATE TABLE Achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) NOT NULL,
    achievementType VARCHAR(50) NOT NULL CHECK (achievementType IN ('TopActiveUser', 'HighTestScorer')),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    achievedDate DATE DEFAULT (CURRENT_DATE),
    relatedID INT,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);
CREATE TABLE PostViews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) NOT NULL,
    postID INT NOT NULL,
    viewedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID) ON DELETE CASCADE,
    FOREIGN KEY (postID) REFERENCES ForumPost(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_post (userID, postID)
);

-- Create Trigger EnsureJLPTOnly
DELIMITER //
CREATE TRIGGER EnsureJLPTOnly
AFTER INSERT ON TestTopScorer
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Tests t
        WHERE t.id = NEW.testID AND t.testType != 'JLPT'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TestTopScorer chỉ lưu điểm cho bài test JLPT!';
    END IF;
END //
DELIMITER ;

-- Create Procedure AddTopActiveUserAchievements
DELIMITER //
CREATE PROCEDURE AddTopActiveUserAchievements()
BEGIN
    INSERT INTO Achievements (userID, achievementType, title, description, achievedDate, relatedID)
    SELECT 
        userID,
        'TopActiveUser',
        CONCAT('Top ', ranking, ' Người Chăm Chỉ Tháng ', MONTH(NOW()), '/', YEAR(NOW())),
        CONCAT('Đứng top ', ranking, ' người dùng hoạt động tích cực nhất tháng ', MONTH(NOW()), '/', YEAR(NOW()), ' với ', totalComments, ' bình luận và ', totalVotes, ' lượt vote'),
        NOW(),
        NULL
    FROM UserActivityScore
    WHERE ranking <= 5
    ORDER BY ranking ASC
    LIMIT 5;
END //
DELIMITER ;

-- Create Trigger AddHighTestScorerAchievement
DELIMITER //
CREATE TRIGGER AddHighTestScorerAchievement
AFTER INSERT ON TestTopScorer
FOR EACH ROW
BEGIN
    INSERT INTO Achievements (userID, achievementType, title, description, achievedDate, relatedID)
    SELECT 
        NEW.userID,
        'HighTestScorer',
        CONCAT('Điểm Cao JLPT ', t.jlptLevel),
        CONCAT('Đạt điểm ', NEW.score, ' trong bài test JLPT ', t.jlptLevel, ' vào ngày ', DATE_FORMAT(NEW.takenDate, '%d/%m/%Y')),
        CURRENT_DATE,
        NEW.id
    FROM Tests t
    WHERE t.id = NEW.testID
    AND NEW.score >= 90
    AND t.testType = 'JLPT';
END //
DELIMITER ;
-- Create chat_messages table
CREATE TABLE chat_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id VARCHAR(10) NOT NULL,
    receiver_id VARCHAR(10) NOT NULL,
    imageUrl VARCHAR(500) NULL,
    content TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES UserAccount(userID) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES UserAccount(userID) ON DELETE CASCADE
);
ALTER TABLE UserAccount
ADD COLUMN resetToken VARCHAR(255),
ADD COLUMN resetTokenExpiry DATETIME,
ADD COLUMN otp VARCHAR(6),
ADD COLUMN otpExpiry DATETIME,
ADD COLUMN sessionId VARCHAR(255);


ALTER TABLE Document ADD COLUMN imageUrl varchar(500) NULL ; 

ALTER TABLE Document
ADD COLUMN classID varchar(10) NULL,
ADD CONSTRAINT FK_Document_Class FOREIGN KEY (classID) REFERENCES Class(classID) ON DELETE SET NULL;

-- INSERT DATA FOR JLEARNING DATABASE

-- 1. UserAccount (15 records)
INSERT INTO UserAccount (userID, fullName, username, email, password, role, profilePicture, phone, birthDate) VALUES
    ('U001', 'Trần Đình Qúy', 'quy123', 'quy123@gmail.com', 'password123', 'Student', '1.jpg', '0901234567', '1990-01-15'),
    ('U002', 'Trần Văn Tùng', 'tung123', 'tung123@gmail.com', 'password123', 'Teacher', '2.jpg', '0987654321', '1985-05-20'),
    ('U003', 'Lê Quốc Hùng', 'hung123', 'hung@gmail.com', 'password123', 'Student', '3.jpg', '0912345678', '1980-09-10'),
    ('U004', 'Phan Nguyễn Gia Huy', 'huy123', 'huy@gmail.com', 'password123', 'Coordinator', '4.jpg', '0923456789', '1992-12-25'),
    ('U005', 'Vũ Lê Duy', 'duy123', 'duy@gmail.com', 'password123', 'Admin', '5.jpg', '0934567890', '1988-07-30'),
    ('U006', 'Lê Thu Trang', 'trang123', 'trang@gmail.com', 'password123', 'Student', '6.jpg', '0945678901', '1995-03-12'),
    ('U007', 'Bùi Thị Nhi', 'nhi123', 'nhi@gmail.com', 'password123', 'Teacher', '7.jpg', '0956789012', '1983-11-08'),
    ('U008', 'Nguyen Thanh Tam', 'tam123', 'tam@gmail.com', 'password123', 'Student', '8.jpg', '0967890123', '1998-06-22'),
    ('U009', 'Hoàng Văn Minh', 'minh123', 'minh@gmail.com', 'password123', 'Student', '9.jpg', '0978901234', '1997-02-14'),
    ('U010', 'Trần Thị Hoa', 'hoa123', 'hoa@gmail.com', 'password123', 'Teacher', '10.jpg', '0989012345', '1986-09-18'),
    ('U011', 'Võ Thị Thu', 'thu123', 'thu@gmail.com', 'password123', 'Student', '11.jpg', '0990123456', '1999-04-18'),
    ('U012', 'Đỗ Văn Khoa', 'khoa123', 'khoa@gmail.com', 'password123', 'Student', '12.jpg', '0901234568', '1996-08-07'),
    ('U013', 'Bùi Thị Linh', 'linh123', 'linh@gmail.com', 'password123', 'Student', '13.jpg', '0912345679', '1994-12-03'),
    ('U014', 'Ngô Văn Đức', 'duc123', 'duc@gmail.com', 'password123', 'Student', '14.jpg', '0923456780', '1993-10-15'),
    ('U015', 'Lý Thị An', 'an123', 'an@gmail.com', 'password123', 'Student', '15.jpg', '0934567891', '1991-05-28'),
    ('U016', 'Cao Thị Yến', 'yen123', 'yen@gmail.com', 'password123', 'Teacher', '16.jpg', '0945678902', '1982-03-25'),
    ('U017', 'Đinh Văn Sơn', 'son123', 'son@gmail.com', 'password123', 'Teacher', '17.jpg', '0956789013', '1984-07-12');
    
    

-- 2. Student (10 records)
INSERT INTO Student (studentID, userID, enrollmentDate, vote) VALUES
    ('S001', 'U001', '2024-01-15', 5),
    ('S002', 'U003', '2024-02-20', 8),
    ('S003', 'U006', '2024-03-10', 12),
    ('S004', 'U008', '2024-04-05', 3),
    ('S005', 'U009', '2024-05-12', 7),
    ('S006', 'U011', '2024-06-18', 15),
    ('S007', 'U012', '2024-07-22', 4),
    ('S008', 'U013', '2024-08-08', 9),
    ('S009', 'U014', '2024-09-14', 6),
    ('S010', 'U015', '2024-10-25', 11);

-- 3. Teacher (5 records)
INSERT INTO Teacher (teacherID, userID, specialization, experienceYears) VALUES
    ('T001', 'U002', 'Ngữ pháp tiếng Nhật', 8),
    ('T002', 'U007', 'Kanji và Từ vựng', 5),
    ('T003', 'U010', 'Hội thoại tiếng Nhật', 12),
    ('T004', 'U016', 'JLPT N1-N2', 10),
    ('T005', 'U017', 'Văn hóa Nhật Bản', 6);

-- 4. Courses (10 records)
INSERT INTO Courses (courseID, title, description, fee, duration, startDate, endDate, isActive) VALUES
    ('CO001', 'Tiếng Nhật Cơ Bản N5', 'Khóa học tiếng Nhật cho người mới bắt đầu', 2000000.00, 120, '2024-01-15', '2024-05-15', FALSE), -- Kết thúc
    ('CO002', 'Tiếng Nhật Trung Cấp N4', 'Khóa học tiếng Nhật trình độ trung cấp', 2500000.00, 150, '2024-02-01', '2024-07-01', FALSE), -- Kết thúc
    ('CO003', 'Tiếng Nhật Cao Cấp N3', 'Khóa học tiếng Nhật trình độ cao cấp', 3000000.00, 180, '2024-03-01', '2024-09-01', FALSE), -- Kết thúc
    ('CO004', 'JLPT N2 Luyện Thi', 'Khóa học luyện thi JLPT N2', 3500000.00, 200, '2024-04-01', '2024-11-01', FALSE), -- Kết thúc
    ('CO005', 'JLPT N1 Chuyên Sâu', 'Khóa học chuyên sâu cho JLPT N1', 4000000.00, 240, '2024-05-01', '2024-12-01', FALSE), -- Kết thúc
    ('CO006', 'Kanji Mastery', 'Khóa học chuyên về Kanji', 1800000.00, 100, '2025-05-01', '2025-08-01', TRUE), -- Đang diễn ra
    ('CO007', 'Hội Thoại Thực Tế', 'Khóa học hội thoại tiếng Nhật thực tế', 2200000.00, 80, '2025-06-01', '2025-08-15', TRUE), -- Sắp bắt đầu
    ('CO008', 'Văn Hóa Nhật Bản', 'Tìm hiểu văn hóa và xã hội Nhật Bản', 1500000.00, 60, '2025-07-01', '2025-09-01', TRUE), -- Tương lai
    ('CO009', 'Tiếng Nhật Thương Mại', 'Tiếng Nhật cho môi trường công việc', 3200000.00, 160, '2025-06-15', '2025-11-15', TRUE), -- Đang diễn ra
    ('CO010', 'Luyện Nghe N3-N2', 'Khóa học chuyên luyện kỹ năng nghe', 1900000.00, 90, '2025-06-20', '2025-09-20', TRUE); -- Đang diễn ra

-- 5. Course_Enrollments (10 records)
INSERT INTO Course_Enrollments (enrollmentID, studentID, courseID, enrollmentDate, completionDate) VALUES
    ('E001', 'S001', 'CO001', '2024-01-15', NULL),
    ('E002', 'S002', 'CO002', '2024-02-20', NULL),
    ('E003', 'S003', 'CO001', '2024-03-10', NULL),
    ('E004', 'S004', 'CO003', '2024-04-05', NULL),
    ('E005', 'S005', 'CO002', '2024-05-12', NULL),
    ('E006', 'S006', 'CO004', '2024-06-18', NULL),
    ('E007', 'S007', 'CO003', '2024-07-22', NULL),
    ('E008', 'S008', 'CO005', '2024-08-08', NULL),
    ('E009', 'S009', 'CO001', '2024-09-14', NULL),
    ('E010', 'S010', 'CO006', '2024-10-25', NULL);
-- 6. Course_Reviews (10 records)
INSERT INTO Course_Reviews (courseID, userID, rating, reviewText, reviewDate) VALUES
    ('CO001', 'U001', 5, 'Khóa học rất hay, giảng viên nhiệt tình', '2024-05-25'),
    ('CO002', 'U003', 4, 'Nội dung phong phú, cần thêm bài tập', '2024-06-10'),
    ('CO001', 'U006', 5, 'Phù hợp cho người mới bắt đầu', '2024-05-28'),
    ('CO003', 'U008', 4, 'Khóa học chất lượng cao', '2024-07-15'),
    ('CO002', 'U009', 3, 'Tốc độ hơi nhanh với tôi', '2024-06-20'),
    ('CO004', 'U001', 5, 'Chuẩn bị thi JLPT rất tốt', '2024-08-01'),
    ('CO003', 'U003', 4, 'Giảng viên giải thích rõ ràng', '2024-07-20'),
    ('CO005', 'U006', 5, 'Khóa học chuyên sâu và hữu ích', '2024-09-01'),
    ('CO001', 'U008', 4, 'Bài học được sắp xếp logic', '2024-05-30'),
    ('CO006', 'U009', 5, 'Học Kanji hiệu quả', '2024-09-15');
INSERT INTO Topic (topicID, courseID, topicName, description, orderIndex) VALUES
    -- Topics for CO001 (Tiếng Nhật Cơ Bản N5)
    ('TP001', 'CO001', 'Hiragana', 'Học bảng chữ cái Hiragana cơ bản và nâng cao', 1),
    ('TP002', 'CO001', 'Katakana', 'Học bảng chữ cái Katakana và từ vựng ngoại lai', 2),
    ('TP003', 'CO001', 'Số đếm', 'Học cách đếm số từ 1-100 và ứng dụng', 3),
    ('TP004', 'CO001', 'Chào hỏi', 'Các cụm từ chào hỏi và giới thiệu bản thân', 4),
    ('TP005', 'CO001', 'Kanji cơ bản', 'Học 50 chữ Kanji đầu tiên cho N5', 5),

    -- Topics for CO002 (Tiếng Nhật Trung Cấp N4)
    ('TP006', 'CO002', 'Kanji N4', 'Học Kanji trình độ N4', 1),
    ('TP007', 'CO002', 'Ngữ pháp N4', 'Các cấu trúc ngữ pháp cơ bản N4', 2),
    ('TP008', 'CO002', 'Hội thoại', 'Luyện hội thoại thực tế trong cuộc sống', 3),
    ('TP009', 'CO002', 'Từ vựng N4', 'Từ vựng thiết yếu cho trình độ N4', 4),

    -- Topics for CO003 (Tiếng Nhật Cao Cấp N3)
    ('TP010', 'CO003', 'Ngữ pháp N3', 'Ngữ pháp nâng cao cho trình độ N3', 1),
    ('TP011', 'CO003', 'Kanji N3', 'Kanji phức tạp trình độ N3', 2),
    ('TP012', 'CO003', 'Đọc hiểu N3', 'Luyện kỹ năng đọc hiểu văn bản', 3),

    -- Topics for CO004 (JLPT N2 Luyện Thi)
    ('TP013', 'CO004', 'Ngữ pháp N2', 'Ngữ pháp phức tạp cho N2', 1),
    ('TP014', 'CO004', 'Viết luận N2', 'Kỹ năng viết luận cho kỳ thi N2', 2),
    ('TP015', 'CO004', 'Đọc hiểu N2', 'Đọc hiểu văn bản phức tạp', 3),
    ('TP016', 'CO004', 'Nghe hiểu N2', 'Luyện kỹ năng nghe cho N2', 4),

    -- Topics for CO005 (JLPT N1 Chuyên Sâu)
    ('TP017', 'CO005', 'Ngữ pháp N1', 'Ngữ pháp cao cấp nhất N1', 1),
    ('TP018', 'CO005', 'Kanji N1', 'Kanji phức tạp nhất N1', 2),
    ('TP019', 'CO005', 'Văn bản học thuật', 'Đọc hiểu văn bản học thuật', 3),

    -- Topics for CO006 (Kanji Mastery)
    ('TP020', 'CO006', 'Kanji cơ bản', 'Kanji từ N5 đến N4', 1),
    ('TP021', 'CO006', 'Kanji nâng cao', 'Kanji từ N3 đến N1', 2),
    ('TP022', 'CO006', 'Cách nhớ Kanji', 'Phương pháp ghi nhớ Kanji hiệu quả', 3),

    -- Topics for CO007 (Hội Thoại Thực Tế)
    ('TP023', 'CO007', 'Hội thoại hàng ngày', 'Giao tiếp trong cuộc sống hàng ngày', 1),
    ('TP024', 'CO007', 'Hội thoại công việc', 'Giao tiếp trong môi trường làm việc', 2),

    -- Topics for CO008 (Văn Hóa Nhật Bản)
    ('TP025', 'CO008', 'Lịch sử Nhật Bản', 'Tìm hiểu lịch sử và truyền thống', 1),
    ('TP026', 'CO008', 'Văn hóa đương đại', 'Văn hóa Nhật Bản hiện đại', 2),

    -- Topics for CO009 (Tiếng Nhật Thương Mại)
    ('TP027', 'CO009', 'Keigo (Kính ngữ)', 'Ngôn ngữ lịch sự trong công việc', 1),
    ('TP028', 'CO009', 'Email kinh doanh', 'Viết email và văn bản công việc', 2),
    ('TP029', 'CO009', 'Thuyết trình', 'Kỹ năng thuyết trình bằng tiếng Nhật', 3),

    -- Topics for CO010 (Luyện Nghe N3-N2)
    ('TP030', 'CO010', 'Nghe cơ bản', 'Luyện nghe âm thanh và từ vựng', 1),
    ('TP031', 'CO010', 'Nghe nâng cao', 'Nghe hiểu hội thoại phức tạp', 2);
-- 7. Lesson (10 records)
INSERT INTO Lesson (topicID, topicName, title, description, mediaUrl, duration, isActive) VALUES
-- Khóa học CO001 - Tiếng Nhật Cơ Bản N5
('TP001', 'Hiragana', 'Giới thiệu bảng chữ cái Hiragana', 'Học 46 ký tự Hiragana cơ bản', 'lesson01_hiragana_intro.mp4', 45, TRUE),
('TP001', 'Hiragana', 'Hiragana Nâng Cao', 'Ôn tập và mở rộng bảng chữ cái Hiragana với dakuten và handakuten', 'lesson02_hiragana_advanced.mp4', 70, TRUE),
('TP002', 'Katakana', 'Giới thiệu bảng chữ cái Katakana', 'Học 46 ký tự Katakana cơ bản', 'lesson03_katakana_intro.mp4', 45, TRUE),
('TP002', 'Katakana', 'Katakana với từ vựng ngoại lai', 'Áp dụng Katakana vào từ vựng ngoại lai', 'lesson04_katakana_loanwords.mp4', 50, TRUE),
('TP003', 'Số đếm', 'Số đếm từ 1-10', 'Học cách đếm số cơ bản', 'lesson05_numbers_basic.mp4', 30, TRUE),
('TP003', 'Số đếm', 'Số đếm từ 11-100', 'Mở rộng khả năng đếm số', 'lesson06_numbers_extended.mp4', 40, TRUE),
('TP004', 'Chào hỏi', 'Chào hỏi cơ bản', 'Các cụm từ chào hỏi hàng ngày', 'lesson07_greetings.mp4', 35, TRUE),
('TP004', 'Chào hỏi', 'Giới thiệu bản thân', 'Cách giới thiệu tên, tuổi, quê quán', 'lesson08_self_introduction.mp4', 40, TRUE),
('TP005', 'Kanji cơ bản', 'Kanji đầu tiên - Số', 'Học Kanji biểu thị số từ 1-10', 'lesson09_kanji_numbers.mp4', 55, TRUE),
('TP005', 'Kanji cơ bản', 'Kanji cơ bản - Thời gian', 'Kanji về ngày, tháng, năm', 'lesson10_kanji_time.mp4', 60, TRUE),

-- Khóa học CO002 - Tiếng Nhật Trung Cấp N4
('TP006', 'Kanji', 'Kanji N4 - Nhóm 1', 'Học 50 Kanji đầu tiên của N4', 'lesson11_kanji_n4_group1.mp4', 80, TRUE),
('TP006', 'Kanji', 'Kanji Cấp Độ 2', 'Học 50 Kanji tiếp theo', 'lesson12_kanji_level2.mp4', 95, TRUE),
('TP007', 'Ngữ pháp N4', 'Ngữ pháp N4 - Phần 1', 'Các cấu trúc ngữ pháp cơ bản N4', 'lesson13_grammar_n4_part1.mp4', 75, TRUE),
('TP007', 'Ngữ pháp N4', 'Ngữ pháp N4 - Phần 2', 'Các cấu trúc ngữ pháp nâng cao N4', 'lesson14_grammar_n4_part2.mp4', 85, TRUE),
('TP008', 'Hội thoại', 'Hội Thoại Du Lịch', 'Giao tiếp khi đi du lịch', 'lesson15_travel_conversation.mp4', 60, TRUE),
('TP008', 'Hội thoại', 'Hội thoại mua sắm', 'Giao tiếp khi mua sắm', 'lesson16_shopping_conversation.mp4', 55, TRUE),
('TP009', 'Từ vựng N4', 'Từ vựng N4 - Gia đình', 'Từ vựng về gia đình và người thân', 'lesson17_vocabulary_family.mp4', 45, TRUE),
('TP009', 'Từ vựng N4', 'Từ vựng N4 - Công việc', 'Từ vựng về nghề nghiệp', 'lesson18_vocabulary_jobs.mp4', 50, TRUE),

-- Khóa học CO003 - Tiếng Nhật Cao Cấp N3
('TP010', 'Ngữ pháp', 'Ngữ Pháp ない-form', 'Cách chia động từ dạng ない', 'lesson19_negative_form.mp4', 80, TRUE),
('TP010', 'Ngữ pháp', 'Ngữ pháp N3 - Điều kiện', 'Các cấu trúc điều kiện trong tiếng Nhật', 'lesson20_conditional_grammar.mp4', 90, TRUE),
('TP011', 'Kanji N3', 'Kanji N3 - Nhóm 1', 'Kanji phức tạp đầu tiên của N3', 'lesson21_kanji_n3_group1.mp4', 100, TRUE),
('TP011', 'Kanji N3', 'Kanji N3 - Nhóm 2', 'Tiếp tục học Kanji N3', 'lesson22_kanji_n3_group2.mp4', 95, TRUE),
('TP012', 'Đọc hiểu N3', 'Đọc hiểu văn bản ngắn', 'Luyện đọc hiểu đoạn văn ngắn', 'lesson23_reading_short.mp4', 70, TRUE),
('TP012', 'Đọc hiểu N3', 'Đọc hiểu văn bản dài', 'Luyện đọc hiểu bài văn dài', 'lesson24_reading_long.mp4', 85, TRUE),

-- Khóa học CO004 - JLPT N2 Luyện Thi
('TP013', 'Ngữ pháp N2', 'Ngữ pháp N2 - Cấu trúc phức tạp', 'Các cấu trúc ngữ pháp phức tạp của N2', 'lesson25_n2_complex_grammar.mp4', 120, TRUE),
('TP014', 'Viết luận', 'Viết Luận N2 Phần 2', 'Luyện viết luận nâng cao JLPT N2', 'lesson26_essay_writing.mp4', 130, TRUE),
('TP015', 'Đọc hiểu N2', 'Đọc hiểu N2 - Văn bản học thuật', 'Đọc hiểu các bài văn học thuật', 'lesson27_academic_reading.mp4', 110, TRUE),
('TP016', 'Nghe hiểu N2', 'Nghe hiểu N2 - Hội thoại', 'Luyện nghe hội thoại phức tạp', 'lesson28_listening_conversation.mp4', 90, TRUE),

-- Khóa học CO005 - JLPT N1 Chuyên Sâu
('TP017', 'Ngữ pháp N1', 'Ngữ pháp N1 - Cấp độ cao nhất', 'Ngữ pháp phức tạp nhất của N1', 'lesson29_n1_advanced_grammar.mp4', 150, TRUE),
('TP018', 'Kanji N1', 'Kanji N1 - Phức tạp nhất', 'Kanji khó nhất trong JLPT', 'lesson30_n1_difficult_kanji.mp4', 140, TRUE),

-- Khóa học CO006 - Kanji Mastery
('TP020', 'Kanji cơ bản', 'Kanji N5-N4 tổng hợp', 'Ôn tập toàn bộ Kanji N5-N4', 'lesson31_kanji_n5_n4_review.mp4', 100, TRUE),
('TP021', 'Kanji nâng cao', 'Kanji N3-N1 chuyên sâu', 'Kanji cao cấp với nhiều âm đọc', 'lesson32_advanced_kanji.mp4', 120, TRUE),

-- Khóa học CO007 - Hội Thoại Thực Tế
('TP023', 'Hội thoại hàng ngày', 'Giao tiếp tại nhà hàng', 'Hội thoại khi đi ăn', 'lesson33_restaurant_conversation.mp4', 45, TRUE),
('TP024', 'Hội thoại công việc', 'Phỏng vấn xin việc', 'Cách trả lời phỏng vấn bằng tiếng Nhật', 'lesson34_job_interview.mp4', 60, TRUE),

-- Khóa học CO008 - Văn Hóa Nhật Bản
('TP025', 'Lịch sử Nhật Bản', 'Lịch sử Nhật Bản cổ đại', 'Tìm hiểu lịch sử Nhật từ thời cổ đại', 'lesson35_ancient_history.mp4', 55, TRUE),
('TP026', 'Văn hóa đương đại', 'Văn hóa pop Nhật Bản', 'Anime, manga và văn hóa đại chúng', 'lesson36_pop_culture.mp4', 50, TRUE),

-- Khóa học CO009 - Tiếng Nhật Thương Mại
('TP027', 'Keigo (Kính ngữ)', 'Keigo cơ bản', 'Các hình thức kính ngữ cơ bản', 'lesson37_basic_keigo.mp4', 80, TRUE),
('TP028', 'Email kinh doanh', 'Viết email công việc', 'Cách viết email chuyên nghiệp', 'lesson38_business_email.mp4', 70, TRUE),

-- Khóa học CO010 - Luyện Nghe N3-N2
('TP030', 'Nghe cơ bản', 'Nghe từ vựng N3', 'Luyện nghe từ vựng trình độ N3', 'lesson39_n3_vocabulary_listening.mp4', 60, TRUE),
('TP031', 'Nghe nâng cao', 'Nghe tin tức', 'Luyện nghe tin tức tiếng Nhật', 'lesson40_news_listening.mp4', 75, TRUE);


-- 10. Exercise (10 records)
INSERT INTO Exercise (lessonID, title, description, dueDate, isActive) VALUES
    (1, 'Bài Tập Hiragana', 'Viết và đọc các ký tự Hiragana', '2024-01-25', TRUE),
    (2, 'Bài Tập Katakana', 'Viết và đọc các ký tự Katakana', '2024-01-28', TRUE),
    (3, 'Luyện Đếm Số', 'Bài tập về số đếm 1-10', '2024-01-30', TRUE),
    (4, 'Thực Hành Chào Hỏi', 'Bài tập hội thoại chào hỏi', '2024-02-02', TRUE),
    (5, 'Nhận Biết Kanji', 'Bài tập nhận biết 50 Kanji', '2024-02-10', TRUE);

-- 14. Class (3 records - incomplete in original, adjusted to match available IDs)
-- Insert data into Class table (4 classes, each with 5 students)
INSERT INTO Class (classID, courseID, name, teacherID, numberOfStudents)
VALUES 
    ('CL001', 'CO001', N'Tiếng Nhật Cơ Bản N5 - 01', 'T001', 5),
    ('CL002', 'CO001', N'Tiếng Nhật Cơ Bản N5 - 02', 'T001', 5),
    ('CL003', 'CO002', N'Tiếng Nhật Trung Cấp N4 - 01', 'T002', 5),
    ('CL004', 'CO002', N'Tiếng Nhật Trung Cấp N4 - 02', 'T002', 5);

-- Insert data into Class_Students table (20 records based on provided Class data)
INSERT INTO Class_Students (classID, studentID, joinDate)
VALUES 
    ('CL001', 'S001', '2024-01-20'),
    ('CL001', 'S002', '2024-02-05'),
    ('CL001', 'S003', '2024-01-25'),
    ('CL001', 'S004', '2024-03-10'),
    ('CL001', 'S005', '2024-02-15'),
    ('CL002', 'S006', '2024-04-05'),
    ('CL002', 'S007', '2024-03-20'),
    ('CL002', 'S008', '2024-05-10'),
    ('CL002', 'S009', '2024-01-30'),
    ('CL002', 'S010', '2024-06-05'),
    ('CL003', 'S001', '2024-01-20'),
    ('CL003', 'S002', '2024-02-05'),
    ('CL003', 'S003', '2024-01-25'),
    ('CL003', 'S004', '2024-03-10'),
    ('CL003', 'S005', '2024-02-15'),
    ('CL004', 'S006', '2024-04-05'),
    ('CL004', 'S007', '2024-03-20'),
    ('CL004', 'S008', '2024-05-10'),
    ('CL004', 'S009', '2024-01-30'),
    ('CL004', 'S010', '2024-06-05');

-- Insert sample data into Lesson_Reviews (5 records for demonstration)
INSERT INTO Lesson_Reviews (lessonID, reviewerID, rating, reviewText, reviewStatus, reviewDate)
VALUES 
    (1, 'U004', 4, N'Bài học Hiragana rõ ràng, cần thêm bài tập thực hành.', 'Pending', '2025-06-17 16:11:00'),
    (2, 'U005', 5, N'Bài Katakana rất chi tiết, tài liệu hỗ trợ tốt.', 'Approved', '2025-06-17 16:11:00'),
    (5, 'U004', 3, N'Bài Kanji cần thêm ví dụ sử dụng thực tế.', 'Rejected', '2025-06-17 16:11:00'),
    (8, 'U005', 4, N'Bài kính ngữ phù hợp, cần thêm video minh họa.', 'Pending', '2025-06-17 16:11:00'),
    (10, 'U004', 5, N'Bài viết luận N2 rất hữu ích cho luyện thi.', 'Approved', '2025-06-17 16:11:00');

-- 15. Announcement (10 records)
INSERT INTO Announcement (title, content, postedDate, postedBy) VALUES
    ('Khai Giảng Khóa N5 Tháng 2', 'Thông báo khai giảng khóa học tiếng Nhật N5 vào ngày 1/2/2024', '2024-01-25', 'U004'),
    ('Lịch Thi JLPT Tháng 7', 'Kỳ thi JLPT tháng 7/2024 sẽ được tổ chức vào ngày 7/7/2024', '2024-05-15', 'U005'),
    ('Chương Trình Giảm Học Phí', 'Giảm 20% học phí cho học viên đăng ký sớm', '2024-01-10', 'U004'),
    ('Thay Đổi Lịch Học', 'Lịch học lớp N3-C chuyển từ 19h sang 20h', '2024-03-05', 'U005'),
    ('Kết Quả Thi Thử N2', 'Kết quả bài thi thử N2 đã được công bố', '2024-04-20', 'U004'),
    ('Nghỉ Lễ Tết Nguyên Đán', 'Trung tâm nghỉ từ 8/2 đến 15/2/2024', '2024-02-01', 'U005'),
    ('Workshop Văn Hóa Nhật', 'Tổ chức workshop về văn hóa Nhật Bản', '2024-06-01', 'U004'),
    ('Thi Thử JLPT Miễn Phí', 'Tổ chức thi thử JLPT miễn phí cho học viên', '2024-05-01', 'U005'),
    ('Khai Giảng Lớp Hội Thoại', 'Khai giảng lớp luyện hội thoại tiếng Nhật', '2024-07-01', 'U004'),
    ('Thông Báo Bảo Trì Hệ Thống', 'Hệ thống sẽ bảo trì từ 2h-4h sáng ngày 15/6', '2024-06-10', 'U005');

    INSERT INTO Announcement (title, content, postedDate, postedBy) VALUES
    ('Khai Giảng Khóa N5 Tháng 6', 'Thông báo khai giảng khóa học tiếng Nhật N5 vào ngày 25/06/2025', '2025-06-25', 'U004');

-- 16. Discount (7 records - incomplete in original, adjusted to match available courseIDs)
INSERT INTO Discount (code, courseID, discountPercent, startDate, endDate, isActive) VALUES
    ('NEWBIE2024', 'CO001', 20, '2024-01-01', '2024-03-31', TRUE),
    ('SUMMER2024', 'CO002', 15, '2024-06-01', '2024-08-31', TRUE),
    ('JLPTN3SALE', 'CO003', 25, '2024-04-01', '2024-06-30', TRUE),
    ('EARLYBIRD', 'CO004', 30, '2024-03-01', '2024-04-30', TRUE),
    ('PREMIUM2024', 'CO005', 10, '2024-05-01', '2024-12-31', TRUE),
    ('KANJI50', 'CO006', 40, '2024-06-01', '2024-07-31', TRUE),
    ('SPEAKING', 'CO007', 20, '2024-07-01', '2024-08-31', TRUE);
    
INSERT INTO ForumPost (title, content, postedBy, createdDate, category, viewCount, voteCount, picture)
VALUES
    ('Cách học Hiragana hiệu quả', 'Mọi người chia sẻ kinh nghiệm học Hiragana nhanh nhé!', 'U001', '2024-01-20 15:35:00', 'Ngữ pháp', 150, 10, 'uploads/hiragana.jpg'),
    ('Luyện thi N5 cần bao lâu?', 'Mình mới bắt đầu học, muốn thi N5 sau 6 tháng có được không?', 'U003', '2024-02-05 15:35:00', 'N5', 89, 5, NULL),
    ('Kanji khó nhớ quá!', 'Có ai có mẹo gì để nhớ Kanji lâu không ạ?', 'U006', '2024-02-15 15:35:00', 'Kanji', 234, 15, 'uploads/kanji.jpg'),
    ('Kinh nghiệm thi JLPT N3', 'Vừa thi N3 xong, chia sẻ một số kinh nghiệm', 'U008', '2024-03-01 15:35:00', 'N3', 167, 8, NULL),
    ('Phần nghe trong JLPT', 'Phần nghe của JLPT có khó không các bạn?', 'U009', '2024-03-10 15:35:00', 'Kinh nghiệm thi', 98, 3, 'uploads/listening.jpg'),
    ('Sách học tiếng Nhật hay', 'Giới thiệu một số cuốn sách học tiếng Nhật tốt', 'U001', '2024-03-20 15:35:00', 'Tài liệu', 145, 7, NULL),
    ('Văn hóa Nhật Bản thú vị', 'Chia sẻ về văn hóa Nhật mà mình biết được', 'U003', '2024-04-01 15:35:00', 'Văn hóa', 201, 12, 'uploads/culture.jpg'),
    ('Lỗi thường gặp khi học', 'Những lỗi mà người mới học thường mắc phải', 'U006', '2024-04-15 15:35:00', 'Ngữ pháp', 87, 4, NULL),
    ('Ứng dụng học tiếng Nhật', 'Các app học tiếng Nhật trên điện thoại', 'U008', '2024-05-01 15:35:00', 'Công cụ', 156, 6, 'uploads/apps.jpg'),
    ('Chuẩn bị cho N2', 'Bắt đầu chuẩn bị thi N2, cần lưu ý gì?', 'U009', '2024-05-10 15:35:00', 'N2', 78, 2, NULL);

-- 18. ForumComment (10 records)
INSERT INTO ForumComment (postID, commentText, commentedBy, commentedDate, voteCount) VALUES
    (1, 'Mình học bằng cách viết nhiều lần, rất hiệu quả!', 'U002', '2024-01-21', 5),
    (1, 'Nên học theo thứ tự a-ka-sa-ta-na...', 'U004', '2024-01-22', 3),
    (2, '6 tháng hơi gấp đấy, nên học 8-10 tháng cho chắc', 'U005', '2024-02-06', 7),
    (3, 'Mình dùng flashcard, rất hay!', 'U007', '2024-02-16', 4),
    (4, 'Cảm ơn bạn đã chia sẻ, rất hữu ích!', 'U010', '2024-03-02', 8),
    (5, 'Phần nghe khó nhất là nghe nhanh và phát âm âm thanh', 'U002', '2024-03-11', 6),
    (6, 'Mina no Nihongo rất tốt cho người mới bắt đầu', 'U004', '2024-03-21', 9),
    (7, 'Văn hóa cúi chào rất thú vị và lịch sự', 'U005', '2024-04-02', 2),
    (8, 'Lỗi chia động từ là phổ biến nhất', 'U007', '2024-04-16', 5);
    

-- Insert updated data
INSERT INTO UserActivityScore (userID, weeklyComments, weeklyVotes, monthlyComments, monthlyVotes, totalComments, totalVotes)
VALUES
    ('U001', 5, 3, 10, 5, 15, 10),
    ('U002', 3, 2, 7, 3, 10, 5),
    ('U003', 2, 1, 5, 2, 8, 3),
    ('U004', 4, 3, 8, 4, 12, 7),
    ('U005', 1, 1, 3, 1, 5, 2),
    ('U006', 6, 4, 12, 8, 20, 15),
    ('U007', 2, 2, 5, 3, 7, 4),
    ('U008', 3, 2, 6, 4, 9, 6),
    ('U009', 4, 3, 7, 5, 11, 8),
    ('U010', 2, 1, 4, 2, 6, 3);



-- Insert some sample data for testing
INSERT INTO PostViews (userID, postID, viewedDate) VALUES
('U001', 1, '2024-01-21 10:30:00'),
('U001', 3, '2024-02-16 14:20:00'),
('U003', 1, '2024-01-22 09:15:00'),
('U003', 2, '2024-02-06 16:45:00'),
('U006', 4, '2024-03-02 11:30:00');

    INSERT INTO chat_messages (sender_id, receiver_id, content, timestamp) VALUES
    ('U001', 'U003', 'Chào thầy, em có thắc mắc về bài tập Hiragana', '2024-01-20 10:00:00'),
    ('U002', 'U001', 'Em cứ luyện viết nhiều lần sẽ quen thôi!', '2024-01-20 10:05:00'),
    ('U003', 'U006', 'Bạn học Kanji thế nào mà nhanh thế?', '2024-02-15 15:30:00'),
    ('U006', 'U003', 'Mình dùng flashcard, rất hiệu quả!', '2024-02-15 15:35:00');

INSERT INTO course_info (course_id, overview, objectives, level_description, tuition_info, duration) VALUES
    ('CO001', 'Khóa học tiếng Nhật cơ bản dành cho người mới bắt đầu.', 'Hiểu và sử dụng bảng chữ cái Hiragana, Katakana, từ vựng và ngữ pháp cơ bản.', 'Trình độ N5 dành cho người mới học.', 'Học phí: 2,000,000 VNĐ (bao gồm tài liệu).', '120 giờ'),
    ('CO002', 'Khóa học tiếng Nhật trung cấp nâng cao kỹ năng ngôn ngữ.', 'Nắm vững ngữ pháp N4, mở rộng từ vựng và giao tiếp thực tế.', 'Trình độ N4, phù hợp với người đã biết cơ bản.', 'Học phí: 2,500,000 VNĐ (bao gồm tài liệu).', '150 giờ'),
    ('CO003', 'Khóa học tiếng Nhật cao cấp dành cho người muốn thi N3.', 'Hiểu ngữ pháp phức tạp, đọc hiểu văn bản và giao tiếp nâng cao.', 'Trình độ N3, dành cho người đã qua N4.', 'Học phí: 3,000,000 VNĐ (bao gồm tài liệu).', '180 giờ'),
    ('CO004', 'Khóa luyện thi JLPT N2 chuyên sâu.', 'Chuẩn bị kỹ năng nghe, đọc, viết và ngữ pháp cho kỳ thi N2.', 'Trình độ N2, phù hợp với người đã qua N3.', 'Học phí: 3,500,000 VNĐ (bao gồm tài liệu và bài thi thử).', '200 giờ'),
    ('CO005', 'Khóa học chuyên sâu cho JLPT N1.', 'Luyện tập ngữ pháp cao cấp, văn bản học thuật và kỹ năng nghe N1.', 'Trình độ N1, dành cho người có kinh nghiệm tiếng Nhật.', 'Học phí: 4,000,000 VNĐ (bao gồm tài liệu chuyên sâu).', '240 giờ'),
    ('CO006', 'Khóa học chuyên về Kanji từ cơ bản đến nâng cao.', 'Học và ghi nhớ hơn 1,000 chữ Kanji từ N5 đến N1.', 'Tất cả trình độ, tập trung vào Kanji.', 'Học phí: 1,800,000 VNĐ (bao gồm flashcard).', '100 giờ'),
    ('CO007', 'Khóa học thực hành hội thoại tiếng Nhật thực tế.', 'Luyện giao tiếp trong các tình huống hàng ngày và công việc.', 'Trình độ N4-N3, phù hợp với người muốn thực hành.', 'Học phí: 2,200,000 VNĐ (bao gồm video thực tế).', '80 giờ'),
    ('CO008', 'Khóa học khám phá văn hóa Nhật Bản.', 'Tìm hiểu lịch sử, văn hóa truyền thống và hiện đại Nhật Bản.', 'Tất cả trình độ, không yêu cầu tiếng Nhật cao.', 'Học phí: 1,500,000 VNĐ (bao gồm tài liệu văn hóa).', '60 giờ'),
    ('CO009', 'Khóa học tiếng Nhật thương mại chuyên nghiệp.', 'Luyện tập Keigo, viết email và thuyết trình công việc.', 'Trình độ N3-N2, dành cho người làm việc với Nhật.', 'Học phí: 3,200,000 VNĐ (bao gồm tài liệu kinh doanh).', '160 giờ'),
    ('CO010', 'Khóa học luyện nghe N3-N2 chuyên sâu.', 'Cải thiện kỹ năng nghe qua hội thoại và tin tức.', 'Trình độ N3-N2, tập trung vào kỹ năng nghe.', 'Học phí: 1,900,000 VNĐ (bao gồm audio thực tế).', '90 giờ'),
    ('CO001', 'Khóa bổ sung kỹ năng cơ bản N5.', 'Ôn tập Hiragana, Katakana và số đếm.', 'Trình độ N5, hỗ trợ người mới bắt đầu chậm.', 'Học phí: 1,500,000 VNĐ (giảm giá cho người mới).', '90 giờ'),
    ('CO004', 'Khóa luyện thi N2 bổ sung.', 'Tập trung vào viết luận và đọc hiểu.', 'Trình độ N2, hỗ trợ thi JLPT.', 'Học phí: 2,800,000 VNĐ (bao gồm bài thi thử).', '150 giờ'),
    ('CO007', 'Khóa thực hành hội thoại nâng cao.', 'Luyện giao tiếp trong môi trường công sở.', 'Trình độ N2, dành cho người làm việc.', 'Học phí: 2,500,000 VNĐ (bao gồm video công việc).', '100 giờ');
    
    INSERT INTO commitments (course_id, title, description, icon, image_url, display_order) VALUES
    ('CO001', 'Hỗ trợ cá nhân', 'Giảng viên hỗ trợ 1-1 qua email hoặc chat.', 'support-icon.png', 'uploads/support.jpg', 1),
    ('CO002', 'Tài liệu miễn phí', 'Cung cấp tài liệu học tập đầy đủ trong khóa.', 'book-icon.png', 'uploads/materials.jpg', 2),
    ('CO003', 'Lịch học linh hoạt', 'Chọn thời gian học phù hợp với bạn.', 'calendar-icon.png', 'uploads/flexible.jpg', 1),
    ('CO004', 'Bài thi thử', 'Cung cấp bài thi thử JLPT định kỳ.', 'test-icon.png', 'uploads/test.jpg', 3),
    ('CO005', 'Học trực tuyến', 'Học mọi lúc, mọi nơi qua nền tảng online.', 'online-icon.png', 'uploads/online.jpg', 2),
    ('CO006', 'Flashcard miễn phí', 'Nhận flashcard Kanji in sẵn.', 'flashcard-icon.png', 'uploads/flashcard.jpg', 1),
    ('CO007', 'Thực hành thực tế', 'Tập trung vào hội thoại thực tế hàng ngày.', 'speech-icon.png', 'uploads/practice.jpg', 3),
    ('CO008', 'Chuyến tham quan', 'Tham gia chuyến đi thực tế tại Nhật (tùy chọn).', 'travel-icon.png', 'uploads/trip.jpg', 2),
    ('CO009', 'Hỗ trợ công việc', 'Kết nối với doanh nghiệp Nhật Bản.', 'job-icon.png', 'uploads/job.jpg', 1),
    ('CO010', 'Audio chất lượng cao', 'Cung cấp audio nghe rõ ràng, đa dạng.', 'audio-icon.png', 'uploads/audio.jpg', 3),
    ('CO001', 'Đánh giá tiến độ', 'Theo dõi và đánh giá tiến độ học viên.', 'progress-icon.png', 'uploads/progress.jpg', 4),
    ('CO004', 'Hướng dẫn thi', 'Hỗ trợ kỹ năng thi JLPT N2 chi tiết.', 'guide-icon.png', 'uploads/guide.jpg', 4),
    ('CO007', 'Phản hồi nhanh', 'Đội ngũ hỗ trợ phản hồi trong 24h.', 'feedback-icon.png', 'uploads/feedback.jpg', 4);
    
    INSERT INTO roadmap (course_id, step_number, title, description, duration) VALUES
    ('CO001', 1, 'Học Hiragana', 'Làm quen với bảng chữ cái Hiragana cơ bản.', '2 tuần'),
    ('CO001', 2, 'Học Katakana', 'Học bảng chữ cái Katakana và từ vựng ngoại lai.', '2 tuần'),
    ('CO001', 3, 'Số đếm và thời gian', 'Học đếm số và cách nói thời gian.', '1 tuần'),
    ('CO002', 1, 'Ngữ pháp N4 cơ bản', 'Học các cấu trúc ngữ pháp cơ bản.', '3 tuần'),
    ('CO002', 2, 'Từ vựng N4', 'Mở rộng từ vựng thiết yếu N4.', '2 tuần'),
    ('CO003', 1, 'Ngữ pháp N3', 'Học các cấu trúc ngữ pháp nâng cao.', '4 tuần'),
    ('CO004', 1, 'Đọc hiểu N2', 'Luyện đọc hiểu văn bản dài.', '3 tuần'),
    ('CO005', 1, 'Ngữ pháp N1', 'Học ngữ pháp phức tạp nhất.', '5 tuần'),
    ('CO006', 1, 'Kanji N5-N4', 'Học và ghi nhớ Kanji cơ bản.', '2 tuần'),
    ('CO007', 1, 'Hội thoại hàng ngày', 'Luyện giao tiếp cơ bản.', '1 tuần'),
    ('CO008', 1, 'Lịch sử Nhật Bản', 'Tìm hiểu lịch sử cổ đại.', '2 tuần'),
    ('CO009', 1, 'Keigo cơ bản', 'Học kính ngữ trong công việc.', '3 tuần'),
    ('CO010', 1, 'Nghe N3 cơ bản', 'Luyện nghe từ vựng và hội thoại.', '2 tuần');
    
	select * from Payment
    
	INSERT INTO Payment (studentID, enrollmentID, amount, paymentMethod, paymentStatus, paymentDate, transactionID) VALUES
    ('S001', 'E001', 1600000.00, 'Credit Card', 'Complete', '2025-01-15 10:00:00', 'TXN001'),
    ('S002', 'E002', 2125000.00, 'Bank Transfer', 'Complete', '2025-02-20 12:30:00', 'TXN002'),
    ('S003', 'E003', 1600000.00, 'Cash', 'Pending', '2025-03-10 09:15:00', 'TXN003'),
    ('S004', 'E004', 2250000.00, 'Credit Card', 'Complete', '2025-04-05 14:45:00', 'TXN004'),
    ('S005', 'E005', 2125000.00, 'Bank Transfer', 'Cancel', '2025-05-12 11:20:00', 'TXN005'),
    ('S006', 'E006', 2450000.00, 'Credit Card', 'Complete', '2025-06-18 16:00:00', 'TXN006'),
    ('S007', 'E007', 2250000.00, 'Cash', 'Pending', '2025-02-22 08:30:00', 'TXN007'),
    ('S008', 'E008', 3600000.00, 'Bank Transfer', 'Complete', '2025-06-08 13:10:00', 'TXN008'),
    ('S009', 'E009', 1600000.00, 'Credit Card', 'Complete', '2025-01-14 15:25:00', 'TXN009'),
    ('S010', 'E010', 1080000.00, 'Bank Transfer', 'Pending', '2025-2-25 10:50:00', 'TXN010');
    