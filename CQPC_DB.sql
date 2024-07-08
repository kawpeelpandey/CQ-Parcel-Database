CREATE DATABASE cqpc_db; -- Created the database name --
USE cqpc_db;

-- Create customer table --

CREATE TABLE customer  
    (CustomerID INT PRIMARY KEY Not Null auto_increment,
	FirstName varchar(50) Not Null,
	LastName varchar(50) Not Null,
	Address varchar (100) Not Null,
	Phone varchar (20) Default Null,
	Email varchar(30) Default Null,
	Date_of_Birth date Not Null

	);
-- Create Indexing for the Customer table --

CREATE UNIQUE index idx_last_name ON customer (LastName);
CREATE UNIQUE index idx_phone ON customer (Phone);

-- Create employee table --

CREATE TABLE employee 
	 ( EmployeeID int PRIMARY KEY not null auto_increment,
	  FirstName varchar(50) Not Null,
	  LastName varchar(50) Not Null,
	  Phone varchar(20) Default Null,
	  Date_of_birth date Not Null,
	  TFN varchar(20) Not Null
	  );
  
-- Create sales_employee table --

CREATE TABLE sales_employee
	(TFN varchar(20),
	EmployeeID int Not Null,
	CONSTRAINT FKSales_employee_Employee FOREIGN KEY (EmployeeID) REFERENCES employee (EmployeeID)
	);

-- Create delivery_employee table --

CREATE TABLE delivery_employee
	(ABN varchar(20),
	EmployeeID int Not Null,
	CONSTRAINT FKDelivery_employee_Employee FOREIGN KEY (EmployeeID) REFERENCES employee (EmployeeID)
	);

-- Create contract table --

CREATE TABLE contract 
	  (Contract_ID int PRIMARY KEY Not Null auto_increment,
	  CustomerID int Not Null,
	  EmployeeID int Not Null,
	  Contract_Value decimal (10,2) Not Null,
	  Contract_Type varchar(50) Not Null,
	  StartDate date Not Null,
	  EndDate date Default Null,
	  CONSTRAINT FKContract_Customer FOREIGN KEY (CustomerID) REFERENCES customer (CustomerID),
	  constraint FKContract_Employee FOREIGN KEY (EmployeeID) REFERENCES sales_employee (EmployeeID)
	);

-- Create lead table --

CREATE TABLE `lead`
	  (Lead_ID int PRIMARY KEY Not Null auto_increment,
	  DateRecorded date Not Null,
	  ParcelEnquiry enum('Yes', 'No') Not Null,
	  CustomerID int Not Null,
	  EmployeeID int Not Null,
	  CONSTRAINT FKLead_Customer FOREIGN KEY (CustomerID) REFERENCES customer (CustomerID),
	  CONSTRAINT FKLead_Employee FOREIGN KEY (EmployeeID) REFERENCES sales_employee (EmployeeID)
	 );

-- Create Standard_Contract table --

CREATE TABLE Standard_Contract
	(FixedPricing decimal (10,2),
	Contract_ID int Not Null,
	CONSTRAINT FKStandard_contract_Contract FOREIGN KEY (Contract_ID) REFERENCES contract (Contract_ID)
	);

-- Create Non-Standard_Contract table --

CREATE TABLE Non_Standard_Contract
	(DiscountPercentage decimal(5,2),
	Contract_ID int Not Null,
	CONSTRAINT FKNon_Standard_contract_Contract FOREIGN KEY (Contract_ID) REFERENCES contract (Contract_ID)
	);

-- Create parcel table --

CREATE TABLE parcel
	(ParcelID int PRIMARY KEY Not Null auto_increment,
	ParcelType enum('Small','Medium','Large') Not Null,
	Length decimal(5,0) Default Null,
	Width decimal(5,2) Default Null,
	Height decimal(5,2) Default Null,
	ReceiverName varchar(50) Not Null,
	ReceiverAddress varchar(50) Not Null,
	Contract_ID int Not Null,
	CONSTRAINT FKParcel_Contract FOREIGN KEY (Contract_ID) REFERENCES contract (Contract_ID)
	);

-- Create parcel_delivery table --

CREATE TABLE parcel_delivery
	(ParcelID int Not Null,
	EmployeeID int Not Null,
	DeliveryDate date Not Null,
	DeliveryStatus enum('Delivered','Lost','Damaged'),
	NumberOfAttempts int Not Null,
	PRIMARY KEY (ParcelID, EmployeeID,DeliveryDate),
	CONSTRAINT FKParcel_delivery_ParcelID FOREIGN KEY (ParcelID) REFERENCES parcel (ParcelID),
	CONSTRAINT FKParcel_delivery_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES delivery_employee (EmployeeID)
	);

-- Create payment table --

CREATE TABLE payment
	(PaymentID int PRIMARY KEY Not Null auto_increment,
	PaymentDate date Not Null,
	AmountPayable decimal(10,2) Not Null,
	CustomerID int Not Null,
	CONSTRAINT FKPayment_CustomerID FOREIGN KEY (CustomerID) REFERENCES customer (CustomerID)
	);

-- Create invoice table --

CREATE TABLE invoice
	(InvoiceID int PRIMARY KEY Not Null auto_increment,
	InvoiceDate date Not Null,
	InvoiceAmount decimal(10,2) Not Null,
	DueDate date Not Null,
	DiscountAmount decimal(10,2) Default Null,
	CustomerID int Not Null,
	ParcelID int Not Null,
	CONSTRAINT FKInvoice_CustomerID FOREIGN KEY (CustomerID) REFERENCES payment (CustomerID),
	CONSTRAINT FKInvoice_ParcelID FOREIGN KEY (ParcelID) REFERENCES parcel_delivery (ParcelID)
	);

-- Create compensation claim table --

CREATE TABLE compensationClaim
	(ClaimID int PRIMARY KEY Not Null auto_increment,
	ClaimAmount decimal (10,2) Not Null,
	ClaimReason varchar(500) Not Null,
	CustomerID int Not Null,
	ParcelID int Not Null,
    InvoiceID int Not Null,
	CONSTRAINT FKCompensationClaim_CustomerID FOREIGN KEY (CustomerID) REFERENCES customer (CustomerID),
	CONSTRAINT FKCompensationClaim_ParcelID FOREIGN KEY (ParcelID) REFERENCES parcel (ParcelID),
    CONSTRAINT FKCompensationClaim_ClaimID FOREIGN KEY (InvoiceID) REFERENCES invoice (InvoiceID)
	);


-- INSERT THE DATA FOR ALL THE ABOVE TABLES SERIALLY ONE BY ONE WHICH IS MENTIONED BELOW --

-- INSERT DATA INTO CUSTOMER TABLE --
INSERT INTO customer (FirstName, LastName, Address, Phone, Email, Date_of_Birth)
VALUES 	('Kapil', 'Pandey', '17/9 Marion Street, Auburn, NSW 2144', '+61 0416986752', 'kapil.pandey@cqumail.com', '1994-10-15'),
		('Madhu', 'Shrestha', 'Parramatta', '+61 123456789', 'mhd1234@cqumail.com', '1992-11-20'),
		('Laxmi', 'Tiwari', '17/9 Marion Street, Auburn, NSW 2144', '+61 0416986741', Null, '1997-09-19'),
		('John', 'Doe', '24/6 Victoria Road, Parramatta, NSW 2150', '+61 0412456789', 'john.doe@cqumail.com', '1988-05-25'),
		('Jane', 'Smith', '56/7 Queens Street, Kogarah, NSW 2217', '+61 0412345678', 'jane.smith@cqumail.com', '1990-07-30'),
		('Bob', 'Brown', '12/8 King Street, Sydney, NSW 2000', '+61 0412123456', 'bob.brown@cqumail.com', '1985-03-15'),
		('Alice', 'Wong', '9/18 College Street, Brisbane, QLD 4000', '+61 0412987654', 'alice.wong@cqumail.com', '1992-12-01'),
		('Mohammed', 'Ali', '34/5 Sunset Boulevard, Perth, WA 6000', '+61 0412987123', 'mohammed.ali@cqumail.com', '1993-10-10');
       
-- INSERT DATA INTO EMPLOYEE TABLE --
INSERT INTO employee (FirstName, LastName, Phone, Date_of_birth, TFN)
VALUES 
		('Radhika', 'Bhusal', '+61 987654321', '1995-05-15', '123456789'),
		('Amit', 'Giri', '+61 987654321', '1992-08-20', '987654321'),
		('Bidur', 'Parsai', '+61 987654321', '1988-04-10', '456789123'),
		('Bishwas', 'Bhattrai', '+61 987654324', '1988-04-15', '456789143'),
		('Emily', 'Raj', '+61 987654325', '1993-09-25', '896745231'),
		('Kumar', 'Sanu', '+61 987654326', '1985-01-01', '234567890'),
		('Anita', 'Thapa', '+61 987654327', '1990-03-05', '345678912'),
		('Rajesh', 'Hamal', '+61 987654328', '1978-06-09', '123456789'),
		('Sita', 'Gurung', '+61 987654329', '1982-12-12', '987654321');

-- INSERT DATA INTO SALES_EMPLOYEE TABLE --
INSERT INTO sales_employee (EmployeeID, TFN)
VALUES 
		(1, '123456789'),
		(2, '987654321'),
		(3, '456789123'),
		(4, '456789143'),
		(5, '896745231'),
		(6, '234567890'),
		(7, '345678912'),
		(8, '123456789');

-- INSERT DATA INTO DELIVERY_EMPLOYEE TABLE --
INSERT INTO delivery_employee (ABN, EmployeeID)
VALUES 
		('123456789ABN', 1),
		('987654321ABN', 2),
		('456789123ABN', 3),
		('456789143ABN', 4),
		('896745231ABN', 5),
		('234567890ABN', 6),
		('345678912ABN', 7),
		('123456788ABN', 8);

-- INSERT DATA INTO CONTRACT TABLE --
INSERT INTO contract (CustomerID, EmployeeID, Contract_Value, Contract_Type, StartDate, EndDate)
VALUES 
		(1, 1, 5000.00, 'Standard', '2024-05-01', '2024-06-01'),
		(2, 2, 7000.00, 'Standard', '2024-05-01', '2024-06-01'),
		(3, 3, 3000.00, 'Non-Standard', '2024-05-01', Null),
		(4, 4, 10000.00, 'Standard', '2024-05-01', '2024-10-01'),
		(5, 5, 15000.00, 'Non-Standard', '2024-05-01', '2024-07-01'),
		(6, 6, 2000.00, 'Standard', '2024-05-01', '2024-05-15'),
		(7, 7, 9500.00, 'Non-Standard', '2024-05-01', Null),
		(8, 8, 5000.00, 'Standard', '2024-05-01', '2024-11-01');

-- INSERT DATA INTO LEAD TABLE --
INSERT INTO `lead` (DateRecorded, ParcelEnquiry, CustomerID, EmployeeID)
VALUES 
		('2024-05-01', 'Yes', 1, 1),
		('2024-05-01', 'No', 2, 2),
		('2024-05-01', 'Yes', 3, 3),
		('2024-05-02', 'No', 4, 4),
		('2024-05-02', 'Yes', 5, 5),
		('2024-05-03', 'No', 6, 6),
		('2024-05-03', 'Yes', 7, 7),
		('2024-05-04', 'No', 8, 8);

-- INSERT DATA INTO STANDARD-CONTRACT TABLE --
INSERT INTO Standard_Contract (FixedPricing, Contract_ID)
VALUES 
		(10000.00, 1),
		(20000.00, 2),
		(15000.00, 3),
		(25000.00, 4),
		(5000.00, 5),
		(30000.00, 6),
		(22000.00, 7),
		(12000.00, 8);

-- INSERT DATA INTO NON-STANDARD-CONTRACT TABLE --
INSERT INTO Non_Standard_Contract (DiscountPercentage, Contract_ID)
VALUES 
		(null, 1),
		(7.50, 2),
		(null, 3),
		(10.00, 4),
		(null, 5),
		(20.00, 6),
		(null, 7),
		(null, 8);

-- INSERT DATA INTO PARCEL TABLE --
INSERT INTO parcel (ParcelType, Length, Width, Height, ReceiverName, ReceiverAddress, Contract_ID)
VALUES 
		('Medium', 20, 15, 10, 'Kaushila Pandey', '789 Elm St, Anyville, USA', 1),
		('Large', 30, 20, 15, 'Madhu Shrestha', 'Parramatta', 2),
		('Small', 10, 5, 5, 'Kapil Pandey', '17/9 Marion Street, Auburn, NSW 2144', 3),
		('Large', 15, 4, 5, 'Bishwas Bhattrai', '18/9 Marion Street, Auburn, NSW 2144', 3),
		('Medium', 10, 4, 6, 'Sanjay Pokhrel', '19/9 Marion Street, Auburn, NSW 2144', 3),
		('Large', 40, 25, 20, 'Alice Wong', '24/7 Sunset Boulevard, Perth, WA 6000', 4),
		('Medium', 22, 14, 13, 'Rajesh Hamal', '56/2 Lakeview St, Sydney, NSW 2000', 5),
		('Medium', 12, 10, 9, 'Kapil Pandey', '17/9 Marion Street, Auburn, NSW 2144', 6),
        ('Large', 17, 15, 12, 'Laxmi Tiwari', '17/9 Marion Street, Auburn, NSW 2144', 2),
        ('Small', 10, 7, 6, 'Laxmi Tiwari', '17/9 Marion Street, Auburn, NSW 2144', 6);
		

-- INSERT DATA INTO PARCEL_DELIVERY TABLE WITH MULTIPLE ATTEMPTS -- 
INSERT INTO parcel_delivery (ParcelID, EmployeeID, DeliveryDate, DeliveryStatus, NumberOfAttempts)
VALUES
		(1, 1, '2024-04-01', 'Lost', 1),    	-- First Attempt : Lost parcel with ParcelID 1    
		(1, 1, '2024-04-15', 'Delivered', 2),   -- Second Attempt : Delivery parcel with ParcelID 1
		(2, 2, '2024-04-02', 'Delivered', 1),   -- First Attempt : Delivery parcel with ParcelID 2    
		(3, 2, '2024-04-16', 'Delivered', 1),   -- First Attempt : Delivery parcel with ParcelID 3
		(4, 3, '2024-04-03', 'Lost', 1),        -- First Attempt : Lost parcel with ParcelID 4  
		(4, 3, '2024-04-17', 'Delivered', 2),   -- Second Attempt : Delivery parcel with ParcelID 4  
		(5, 3, '2024-04-17', 'Delivered', 1),   -- First Attempt : Delivery parcel with ParcelID 5
		(6, 4, '2024-04-04', 'Lost', 1),       -- First Attempt: Lost parcel with ParcelID 6
		(6, 4, '2024-04-18', 'Delivered', 2),  -- Second Attempt: Delivered parcel with ParcelID 6
		(7, 5, '2024-04-05', 'Delivered', 1),  -- First Attempt: Delivered parcel with ParcelID 7
        (8, 5, '2024-04-05', 'Delivered', 1),  -- First Attempt: Delivered parcel with ParcelID 8
		(9, 6, '2024-04-06', 'Lost', 1),       -- First Attempt: Lost parcel with ParcelID 9
		(9, 2, '2024-04-20', 'Damaged', 2);    -- Second Attempt: Damaged parcel with ParcelID 9

-- INSERT DATA INTO PAYMENT TABLE --
INSERT INTO payment (PaymentDate, AmountPayable, CustomerID)
VALUES 
		('2024-04-03', 5000.00, 1),
		('2024-04-15', 15000.00, 2),
		('2024-05-18', 13000.00, 3),
		('2024-04-04', 25000.00, 4),
		('2024-04-16', 5000.00, 5),
		('2024-05-19', 20000.00, 6),
		('2024-06-01', 9500.00, 7),
		('2024-06-15', 12000.00, 8);

-- INSERT DATA INTO INVOICE TABLE --
INSERT INTO invoice (InvoiceDate, InvoiceAmount, DueDate, CustomerID, ParcelID)
VALUES 
		('2024-05-03', 5000.00, '2024-06-03', 1, 1),
		('2024-05-05', 15000.00, '2024-06-05', 2, 2),
		('2024-05-07', 13000.00, '2024-06-07', 3, 3),
		('2024-05-09', 25000.00, '2024-06-09', 4, 4),
		('2024-05-11', 5000.00, '2024-06-11', 5, 5),
		('2024-05-13', 20000.00, '2024-06-13', 6, 6),
		('2024-05-15', 9500.00, '2024-06-15', 7, 7),
		('2024-05-17', 12000.00, '2024-06-17', 8, 8);

-- INSERT DATA INTO COMPENSATION_CLAIM TABLE --
INSERT INTO compensationclaim (ClaimAmount, ClaimReason, CustomerID, ParcelID, InvoiceID)
VALUES 
		(1000.00, 'Parcel lost during transit', 1, 1, 1),  -- Related to ParcelID 1 that was initially lost
		(1800.00, 'Parcel damaged on second attempt', 8, 8, 8);  -- Related to ParcelID 8 that was damaged on the second attempt
        
        
        
-- Create the Store Procedure to get the Customer Details by Full name or Part --

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchCustomerByName`(IN p_CustomerName varchar(255))
begin
    -- Retrieve customer details whose name, either in full or in part
    select *from customer
   where concat(FirstName, ' ', LastName) like concat('%', p_CustomerName, '%');
end$$
DELIMITER ;


-- Create the Store Procedure to get Delivery Employee Name through the Parcel ID  --

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchCustomerByName`(IN p_CustomerName varchar(255))
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeliveryEmployeeDetails`(IN P_ParcelID Int, Out P_EmployeeName varchar(255))
Begin

-- variable declare to store the latest delivery date --
declare v_DeliveryDate date;

-- find the most recent delivery date for the pass parecel ID in Parameter--
select max(DeliveryDate) into v_DeliveryDate
from parcel_delivery
where ParcelID = P_ParcelID;

-- Find the Employee name who delivered the parcel on this date --
SELECT CONCAT(e.FirstName, ' ', e.LastName) INTO p_EmployeeName -- To get the Employee Full Name 
from parcel_delivery pd
join delivery_employee de on pd.EmployeeID = de.EmployeeID
join employee e on pd.EmployeeID = e.EmployeeID
where pd.ParcelID = P_ParcelID and pd.DeliveryDate = v_DeliveryDate;

end$$
DELIMITER ;





