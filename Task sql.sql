CREATE DATABASE BlogDB

USE BlogDB


Create table Categories(
Id INT PRIMARY KEY IDENTITY ,
Name NVARCHAR(50) UNIQUE NOT NULL
)

INSERT INTO Categories(Name)
VALUES('cat1'),
('cat2'),
('cat3'),
('cat4')


CREATE TABLE Tags(
Id INT  PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL UNIQUE
)

Insert INTO Tags(Name)
VALUES('tag1'),
('tag2'),
('tag3'),
('tag4')

CREATE TABLE Users(
Id INT  PRIMARY KEY IDENTITY,
UserName NVARCHAR(50) NOT NULL UNIQUE,
FullName NVARCHAR(50) NOT NULL,
Age INT
CHECK(Age<150))

INSERT INTO Users(UserName,FullName,Age)
VALUES('Ali004','Ali Memmedov',19),
('Anar01','Anar Balaca',24),
('Maqa02','Mehemmed Zeynalli',21),
('Murik006','Murad Memmedov',18)


Create TABLE Blogs(
Id INT  PRIMARY KEY IDENTITY,
Title NVARCHAR(50) NOT NULL,
Description NVARCHAR(50) NOT NULL,
IsDeleted BIT DEFAULT 0,
UsersId INT,
CategoriesId INT,
FOREIGN KEY(UsersId) REFERENCES Users(Id),
FOREIGN KEY(CategoriesId) REFERENCES Categories(Id))

INSERT INTO Blogs(Title,Description,IsDeleted,UsersId,CategoriesId)
Values('title1','des',0,1,3),
('title2','des',0,2,2),
('title2','des',0,2,3),
('title3','des',0,3,1),
('title3','des',0,3,3),
('title4','des',0,4,1),
('title4','des',0,4,3),
('title4','des',0,4,4)



CREATE TABLE Comments(
Id INT  PRIMARY KEY IDENTITY,
Content NVARCHAR(250) NOT NULL,
UsersId INT,
BlogsId INT,
FOREIGN KEY(UsersId) REFERENCES Users(Id),
FOREIGN KEY(BlogsId) REFERENCES Blogs(Id))

INSERT INTO Comments(Content,UsersId,BlogsId)
VALUES('con1',1,3),
('con1',3,4),
('con1',2,3),
('con2',2,3),
('con2',3,4),
('con2',3,5),
('con3',4,6),
('con3',4,4)


CREATE TABLE Blogs_Tags(
BlogsId INT,
TagsId INT,
FOREIGN KEY(BlogsId) REFERENCES Blogs(Id),
FOREIGN KEY(TagsId) REFERENCES Tags(Id),
PRIMARY KEY(BlogsId,TagsId))

INSERT INTO Blogs_Tags(BlogsId,TagsId)
VALUES(1,3),
(1,2),
(1,4),
(2,2),
(2,3),
(3,1),
(3,3),
(3,4),
(4,2),
(4,3),
(4,4),
(5,1),
(5,3),
(6,2),
(6,3),
(6,4),
(7,1),
(7,4),
(8,1),
(8,2),
(8,4)
Create VIEW vw_BlogsByData
AS
SELECT B.Title AS 'BlogsTitle' , U.UserName, U.FullName
FROM Blogs B
JOIN Users U
ON U.Id=B.UsersId

SELECT*FROM vw_BlogsByData


Create VIEW vw_BlogsANDCategories
AS
SELECT B.Title AS 'BlogsTitle', C.Name
FROM Blogs B
JOIN Categories C
ON C.Id=B.CategoriesId

SELECT*FROM vw_BlogsANDCategories

Alter PROCEDURE SP_GetComments @UsersId INT
AS
SELECT C.Id, C.Content
FROM Comments C
JOIN Users U
ON U.Id=C.UsersId
WHERE U.Id=@UsersId

EXEC SP_GetComments 3

CREATE PROCEDURE SP_GetBlogs @UsersId INT
AS
SELECT B.Id, B.Title, B.Description
FROM Blogs B
JOIN Users U
ON U.Id=B.UsersId
WHERE U.Id=@UsersId

EXEC SP_GetBlogs 2

CREATE FUNCTION UFN_GetBlogsCount(@categoryId INT) 
RETURNS INT 

BEGIN
DECLARE @Count INT 
SELECT @Count =COUNT(@categoryId) FROM Blogs 
WHERE CategoriesId=@categoryId
RETURN @Count 
END

SELECT dbo.UFN_GetBlogsCount(4) AS 'BlogsCount'  

CREATE FUNCTION UFN_GetBlogsTable(@userId INT)
RETURNS TABLE 

RETURN
SELECT B.Id, B.Title, B.Description  FROM Blogs B
WHERE B.UsersId=@userId

SELECT*FROM dbo.UFN_GetBlogsTable(4) 

Create TRIGGER TRGR_IsDeleteBlogs
ON Blogs
Instead OF DELETE
AS
BEGIN
   Update Blogs
   Set IsDeleted=1
   from deleted
   Where Blogs.Id=deleted.Id
   
END


Delete Blogs 
Where Blogs.Id=2

Select*from Blogs