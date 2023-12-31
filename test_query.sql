CREATE DATABASE BankDbTest

USE BankDbTest
--�������� ������� Bank
CREATE TABLE Bank(
BankId int IDENTITY(1,1) primary key NOT NULL,
Name varchar(255) NOT NULL);

--�������� ������� SocialStatus
CREATE TABLE SocialStatus(
SocialStatusId int IDENTITY primary key,
Status VARCHAR(255) not null)

--�������� ������� Customer
CREATE TABLE Customer(
CustomerId int IDENTITY(1,1) primary key NOT NULL,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
DateBirth date NULL,
Address varchar(255) NULL,
Phone varchar(20) NULL,
Email varchar(100) NULL,
SocialStatusId int,
FOREIGN KEY (SocialStatusId) REFERENCES SocialStatus(SocialStatusId));


--�������� ������� Branch
CREATE TABLE Branch(
BranchId int IDENTITY(1,1) primary key NOT NULL,
BankId int NOT NULL,
Name varchar(255) NOT NULL,
Address varchar(255) NULL,
FOREIGN KEY (BankId) REFERENCES Bank(BankId));


--�������� ������� Account
CREATE TABLE Account(
AccountId int IDENTITY(1,1) primary key NOT NULL,
CustomerId int NULL,
BranchId int NOT NULL,
Balance numeric(10, 2) NULL,
OpenningDate date NULL,
FOREIGN KEY (BranchId) REFERENCES Branch(BranchId),
FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId));


--�������� ������� CustomerCard
CREATE TABLE CustomerCard(
CardId int IDENTITY(1,1) NOT NULL,
CardNumber varchar(16) NOT NULL,
ExpirationDate date NULL,
Balance numeric(10, 2) NULL,
AccountId int NULL,
FOREIGN KEY (AccountId) REFERENCES Account(AccountId));


--���������� 5 ������� � ������� "SocialStatus"
INSERT INTO SocialStatus(Status)
VALUES
('Employed'),
('Unemployed'),
('Disabled'),
('Retired'),
('Student');

--���������� 10 ������� � ������� "Bank"
INSERT INTO Bank(Name)
VALUES
('Bank A'),
('Bank B'),
('Bank C'),
('Bank D'),
('Bank E'),
('Bank F'),
('Bank G'),
('Bank H'),
('Bank I'),
('Bank J');

--���������� 10 ������� � ������� "Branch"
INSERT INTO Branch (BankId, Name, Address)
VALUES
(1, 'Downtown Branch', '1st Ave, New York City'),
(1, 'Uptown Branch', '2nd Ave, CNew York City'),
(2, 'Main Branch', '3rd St, Los Angeles'),
(2, 'East Branch', '4th St, Los Angeles'),
(3, 'City Center Branch', '5th Ave, Chicago'),
(4, 'Central Branch', '6th St, Houston'),
(5, 'Downtown Branch', '7th Ave, Phoenix'),
(6, 'Uptown Branch', '8th Ave, Philadelphia'),
(7, 'Main Branch', '9th St, San Antonio'),
(8, 'City Center Branch', '10th Ave, San Diego');

--� ���������� 10 ������� � ������� "Customer"
INSERT INTO Customer (FirstName, LastName, DateBirth, Address, Phone, Email, SocialStatusId)
VALUES
('John', 'Doe', '1990-01-15', '123 Elm St', '555-123-4567', 'john@example.com', 1),
('Mary', 'Smith', '1985-03-22', '456 Oak St', '555-987-6543', 'mary@example.com', 3),
('Robert', 'Johnson', '1995-07-10', '789 Maple St', '555-555-5555', 'robert@example.com', 3),
('Lisa', 'Brown', '1980-12-05', '101 Pine St', '555-777-8888', 'lisa@example.com',1),
('Michael', 'Wilson', '1992-09-30', '222 Birch St', '555-444-3333', 'michael@example.com',4),
('Elizabeth', 'Lee', '1988-04-18', '333 Cedar St', '555-222-1111', 'elizabeth@example.com',1),
('David', 'Miller', '1993-11-26', '444 Walnut St', '555-111-9999', 'david@example.com',4),
('Jennifer', 'Anderson', '1987-06-14', '555 Chestnut St', '555-999-7777', 'jennifer@example.com',3),
('Christopher', 'Garcia', '1994-05-03', '666 Redwood St', '555-333-6666', 'christopher@example.com',2),
('Jessica', 'Martinez', '1983-08-09', '777 Oak St', '555-666-4444', 'jessica@example.com',1);

--� ���������� 7 ������� � ������� "Account"
INSERT INTO Account (CustomerId, BranchId, Balance, OpenningDate)
VALUES
(1, 1, 2000.00, '2022-01-10'),
(1, 3, 2000.00, '2021-03-15'),
(2, 3, 3000.00, '2023-05-20'),
(2, 5, 2500.00, '2022-09-08'),
(3, 7, 5000.00, '2022-11-30'),
(3, 8, 3500.00, '2023-04-25'),
(4, 9, 1800.00, '2021-07-13');

--���������� 8 ������� � ������� "CustomerCard"
INSERT INTO CustomerCard (AccountId, CardNumber, ExpirationDate, Balance)
VALUES
(1, '1234 5678 9012 3', '2025-12-31', 1000.00),
(2, '9876 5432 1098 7', '2024-09-30', 500.00),
(3, '5555 6666 7777 8', '2026-06-30', 750.00),
(4, '1111 2222 3333 4', '2023-05-31', 1200.00),
(5, '9999 8888 7777 6', '2024-08-15', 300.00),
(6, '3333 4444 5555 6', '2025-11-30', 900.00),
(7, '7777 6666 5555 4', '2026-10-31', 1500.00),
(1, '1231 1231 2312 2', '2026-11-30', 0);

--1
SELECT Bank.Name
FROM Bank
JOIN Branch
	ON Bank.BankId = Branch.BankId
WHERE Branch.Address LIKE '%, N%' 

--2
SELECT CC.CardNumber,
	   (C.FirstName + ' ' + C.LastName) AS FullName,
	   CC.Balance AS Card_Balance, 
	   B.Name
FROM CustomerCard AS CC
JOIN Account AS A
	ON CC.AccountId = A.AccountId
JOIN Customer AS C
	ON A.CustomerId = C.CustomerId
JOIN Branch AS Br
	ON A.BranchId = Br.BranchId
JOIN Bank AS B
	ON Br.BankId = B.BankId;

--3
SELECT A.AccountId,
	   C.LastName,
	   A.Balance AS Account_Balance,
	   CC.Balance AS Card_Balance,
	   (A.Balance - CC.Balance) AS Difference
FROM CustomerCard AS CC
INNER JOIN Account AS A
	ON CC.AccountId = A.AccountId
INNER JOIN Customer AS C
	ON A.CustomerId = C.CustomerId


--4
--4.1
SELECT S.Status,
	   Count(S.Status) AS StatusCount
FROM CustomerCard AS CC
JOIN Account AS A
	ON A.AccountId = CC.AccountId
JOIN Customer AS C
	ON C.CustomerId = A.AccountId
JOIN SocialStatus AS S
	ON S.SocialStatusId = C.SocialStatusId
GROUP BY  S.Status

--4.2
SELECT S.Status,
	   (SELECT COUNT(*)
	   FROM CustomerCard AS CC
	   JOIN Account AS A
	   	ON A.AccountId = CC.AccountId
	   JOIN Customer AS C
	   	ON C.CustomerId = A.AccountId
	   WHERE S.SocialStatusId = C.SocialStatusId) AS StatusCount
FROM SocialStatus AS S; 

--5
Use BankDbTest
GO
CREATE PROCEDURE AddMoneyOnAccountBySocialStatusTest
@SocialStatusId int
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT @SocialStatusId = 3
		THROW 50000,'You can''t get money with your social status, sorry :(', 16;

    IF NOT EXISTS (SELECT 1 FROM SocialStatus WHERE SocialStatusId = @SocialStatusId)
	 THROW 50000,'No Records Found', 16

	BEGIN
		UPDATE Account
		SET Balance += 10
		FROM Account AS A
		JOIN Customer AS C 
			ON A.CustomerId = C.CustomerId
		WHERE C.SocialStatusId = @SocialStatusId;
	END
END

 
--Test
--sucsess
SELECT 
	C.LastName,
	C.SocialStatusId,
	A.Balance
From Customer AS C
JOIN Account AS A 
	On A.CustomerId = C.CustomerId
where C.SocialStatusId = 3

EXEC AddMoneyOnAccountBySocialStatusTest @SocialStatusId = 3

SELECT C.LastName,
	   SS.Status,
	   A.Balance 
FROM Account As A
Join Customer AS C 
	On A.CustomerId = C.CustomerId
Join SocialStatus AS SS 
	On SS.SocialStatusId = C.SocialStatusId
WHERE SS.SocialStatusId = 3

--Test
--fail
EXEC AddMoneyOnAccountBySocialStatusTest @SocialStatusId = 5

GO

--6
SELECT A.AccountId,
		 A.Balance AS Account_balance,
		 SUM(CC.Balance) AS Cards_balance,
		 A.Balance - SUM(CC.Balance) AS Available_balance
FROM CustomerCard AS CC
JOIN Account AS A
	ON CC.AccountId= A.AccountId
GROUP BY  A.AccountId, A.Balance, A.BranchId;
GO


--7
USE BankDbTest
Go
CREATE PROCEDURE SendMoneyToCard
@AccountId int,
@NumberOfCustomerCard VARCHAR(16),
@SendedMoney int
AS
BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRANSACTION; -- ������ ����������
	
	DECLARE @AvailableMoney int = (Select Balance From Account where AccountId = @AccountId ) -		
							      (Select Sum(Balance) From CustomerCard where AccountId = @AccountId)
	
	IF NOT EXISTS (SELECT AccountID FROM Account WHERE AccountId = @AccountId)
		BEGIN
			ROLLBACK; -- ����� ���������� � ������ ������
			PRINT 'Transaction rolled back. AccountID doesnt exsists';
		END
	ELSE IF  NOT EXISTS (SELECT CardNumber FROM CustomerCard WHERE CardNumber = @NumberOfCustomerCard)
	    BEGIN
			ROLLBACK; -- ����� ���������� � ������ ������
			PRINT 'Transaction rolled back. CardNumber doesnt exists';
		END
	ELSE IF  @AvailableMoney < @SendedMoney
		 BEGIN
			ROLLBACK; -- ����� ���������� � ������ ������
			PRINT 'Transaction rolled back. You send more money than you have';
		END
	ELSE
		BEGIN
			Update CustomerCard
			Set Balance += @SendedMoney
			Where CardNumber = @NumberOfCustomerCard
			COMMIT; -- ������������� ����������
			PRINT 'Transaction committed.';
		END
END

--Test
--sucsess
SELECT AccountId,
		 Balance
FROM CustomerCard
WHERE CardNumber = '1231 1231 2312 2';

exec SendMoneyToCard @AccountId = 1,
				     @NumberOfCustomerCard = '1231 1231 2312 2',
				     @SendedMoney = 200;

SELECT AccountId,
		 Balance
FROM CustomerCard
WHERE CardNumber = '1231 1231 2312 2';
--Test
--error
EXEC SendMoneyToCard @AccountId = 12, --!
				     @NumberOfCustomerCard = '1231 1231 2312 2',
				     @SendedMoney = 200;
--Test
--error
EXEC SendMoneyToCard @AccountId = 1,
				     @NumberOfCustomerCard = '12fail31 1231 2312 2', --!
				     @SendedMoney = 200;
--Test
--error
EXEC SendMoneyToCard @AccountId = 1,
				     @NumberOfCustomerCard = '1231 1231 2312 2',
				     @SendedMoney = 20000; --!

GO


--8
--ACCOUNT
CREATE TRIGGER  trgAfterAddingBalanceTest
   ON  Account
   AFTER UPDATE
AS 
BEGIN
        IF EXISTS (
		   SELECT 1 
		   FROM INSERTED As i
		   JOIN CustomerCard As CC On I.AccountId = CC.AccountId
		   WHERE I.Balance < (SELECT SUM(Balance) FROM CustomerCard Where AccountId = i.AccountId))
        BEGIN
           
            PRINT('Updated value cannot be greater than the sum of values from OtherTable.');
            ROLLBACK; 
        END
END;

--Test
--sucsess
Select Balance 
From Account 
Where AccountId = 1

Update Account
Set Balance = 2500
Where AccountId = 1;

Select Balance
From Account
Where AccountId = 1

--Test
--fail
Update Account
Set Balance = 0
Where AccountId = 1;
GO

--CustomerCard
CREATE TRIGGER trgAfterAddingBalanceOnCardTest
   ON  CustomerCard
   AFTER Update
AS 
BEGIN
	IF EXISTS (
		   SELECT 1 
		   FROM INSERTED As I
		   JOIN Account As A On I.AccountId = A.AccountId
		   WHERE A.Balance < (SELECT SUM(Balance) FROM CustomerCard Where AccountId = A.AccountId))
        BEGIN
            
            PRINT('Updated value cannot be greater than the sum of balance from Account.');
            ROLLBACK; 
        END
END

--Test
--sucsess
SELECT Balance
FROM CustomerCard
WHERE CardNumber = '1231 1231 2312 2' 

Update CustomerCard
Set Balance = 1500
Where CardNumber = '1231 1231 2312 2'

SELECT Balance
FROM CustomerCard
WHERE CardNumber = '1231 1231 2312 2' 

--Test
--fail
select Balance
From CustomerCard 
Where CardNumber = '1231 1231 2312 2' 

Update CustomerCard
Set Balance = 2500
Where CardNumber = '1231 1231 2312 2'

SELECT Balance
FROM CustomerCard
WHERE CardNumber = '1231 1231 2312 2' 
GO

