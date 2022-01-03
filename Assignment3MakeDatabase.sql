
DROP TABLE [Contains];
DROP TABLE IngredientOrderDetails;
DROP TABLE IngredientOrderDate;
DROP TABLE Includes;
DROP TABLE Ingredient;
DROP TABLE Has;
DROP TABLE MenuItem;
DROP TABLE PickUpOrder;
DROP TABLE DeliveryOrder;
DROP TABLE WalkInOrder;
DROP TABLE PhoneOrder;
DROP TABLE [ORDER];
DROP TABLE DeliveryPay;
DROP TABLE InStorePay;
DROP TABLE Payment;
DROP TABLE DeliveryShift;
DROP TABLE InStoreShift;
DROP TABLE EmployeeShift;
DROP TABLE DeliveryDriver;
DROP TABLE InStoreWorker;
DROP TABLE Employee;
DROP TABLE Customer;
--DROP DATABASE DeliTastePizza;
--DATABASE CREATION
--CREATE DATABASE DeliTastePizza;

--CUSTOMER TABLE
CREATE TABLE Customer(
CustomerID		Char(10) PRIMARY KEY,
FirstName		VarChar(50) NOT NULL, 
LastName		VarChar(50) NOT NULL,
PhoneNumber		Int NOT NULL,
Address			VarChar(99) NOT NULL);


--EMPLOYEE TABLE
CREATE TABLE Employee ( 
EmployeeNumber  Char(10) PRIMARY KEY,
FirstName	    VarChar(20) NOT NULL,
LastName	    VarChar(20) NOT NULL,
Address			VarChar(99) NOT NULL,
ContactNumber	Int NOT NULL,
TaxFileNumber	Char(10) NOT NULL,
BankDetails		VarChar(20) NOT NULL,
Description		VarChar(99) DEFAULT 'NO DESCRIPTION');


--INSTOREWORKER TABLE
CREATE TABLE InStoreWorker( 
EmployeeNumber	Char(10) PRIMARY KEY,
HourlyRate		NUMERIC(4,2) NOT NULL
FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
ON UPDATE CASCADE ON DELETE NO ACTION);

--DELIVERYDRIVER TABLE 
CREATE TABLE DeliveryDriver(
EmployeeNumber	Char(10) PRIMARY KEY,
LicenseDetails	Char(16) NOT NULL,
RatePerDelivery NUMERIC(6,2) NOT NULL,
FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
ON UPDATE CASCADE ON DELETE NO ACTION);


--EMPLOYEESHIFT TABLE
CREATE TABLE EmployeeShift(
ShiftID			Char(10) PRIMARY KEY,
EmployeeNumber	Char(10) NOT NULL,
StartDate		Date NOT NULL,
StartTime		Time NOT NULL,
EndDate			Date,
EndTime			Time,
FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
ON UPDATE CASCADE ON DELETE NO ACTION );

--INSTORESHIFT TABLE
CREATE TABLE InStoreShift(
ShiftID			Char(10) PRIMARY KEY,
WorkedHours		NUMERIC(6,2) NOT NULL,
FOREIGN KEY (ShiftID) REFERENCES EmployeeShift(ShiftID)
ON UPDATE NO ACTION ON DELETE NO ACTION );


--DELIVERYSHIFT TABLE 
CREATE TABLE DeliveryShift(
ShiftID			Char(10) PRIMARY KEY,
NumberOfDeliveries Int NOT NULL,
FOREIGN KEY (ShiftID) REFERENCES EmployeeShift(ShiftID)
ON UPDATE NO ACTION ON DELETE NO ACTION);


--PAYMENT TABLE
CREATE TABLE Payment(
PayslipNumber		Char(10) PRIMARY KEY,
EmployeeNumber		Char(10) NOT NULL,
GrossPayment		NUMERIC(6,2) NOT NULL,
TaxWithheld			NUMERIC(6,2) NOT NULL,
TotalPaid			NUMERIC(6,2) NOT NULL,
PaymentDate			Date NOT NULL,
PaymentPeriodEnd	Date NOT NULL,
FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
ON UPDATE CASCADE ON DELETE NO ACTION);


--INSTOREPAY TABLE
CREATE TABLE InStorePay(
PayslipNumber		Char(10) PRIMARY KEY ,
PaidHours			NUMERIC(5,2) NOT NULL,
PaidRate			NUMERIC(6,2) NOT NULL,
ShiftID				Char(10) NOT NULL,
FOREIGN KEY (PayslipNumber) REFERENCES Payment(PayslipNumber) 
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (ShiftID) REFERENCES InStoreShift(ShiftID)
ON UPDATE CASCADE ON DELETE NO ACTION);


--DELIVERYPAY TABLE
CREATE TABLE DeliveryPay(
PayslipNumber		Char(10) PRIMARY KEY,
NumberOfDelivieries Int NOT NULL,
RatePerDelivery		NUMERIC(6,2) NOT NULL,
ShiftID				Char(10) NOT NULL,
FOREIGN KEY (PayslipNumber) REFERENCES Payment(PayslipNumber) 
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (ShiftID) REFERENCES DeliveryShift(ShiftID)
ON UPDATE CASCADE ON DELETE NO ACTION);

--ORDER TABLE
CREATE TABLE [Order](
OrderNumber			Char(10) PRIMARY KEY, --Order Number
EmployeeNumber		Char(10) NOT NULL,
CustomerID			Char(10) NOT NULL, 
TotalPrice			VarChar(10) NOT NULL,
OrderDate			DATE NOT NULL,
OrderStatus			VarChar(99) NOT NULL,
PaymentApprovalNumber Bit,
FOREIGN KEY (EmployeeNumber) REFERENCES InStoreWorker(EmployeeNumber)
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
ON UPDATE CASCADE ON DELETE NO ACTION);



--PHONEORDER TABLE
CREATE TABLE PhoneOrder (
OrderNumber			Char(10) PRIMARY KEY,
TimeCallAnswered	TIME NOT NULL,
TimeCallEnded		TIME NOT NULL,
FOREIGN KEY(OrderNumber) REFERENCES [ORDER](OrderNumber)
ON UPDATE CASCADE ON DELETE NO ACTION);


--WalkInOrder
CREATE TABLE WalkInOrder (
OrderNumber			Char(10) PRIMARY KEY,
TimeEntered			TIME NOT NULL,
EmployeeNumber Char(10) NOT NULL,
FOREIGN KEY(OrderNumber) REFERENCES [Order](OrderNumber)
ON UPDATE CASCADE ON DELETE CASCADE);


--DELIVERY ORDER TABLE
CREATE TABLE DeliveryOrder ( 
OrderNumber			Char(10) PRIMARY KEY,
ShiftID				Char(10) NOT NULL,
DeliveryTime		TIME NOT NULL,
FOREIGN KEY(OrderNumber) REFERENCES PhoneOrder(OrderNumber)
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (ShiftID) REFERENCES DeliveryShift(ShiftID)
ON UPDATE  CASCADE ON DELETE NO ACTION );

CREATE TABLE PickUpOrder(
OrderNumber Char(10) PRIMARY KEY,
PickUpTime TIME NOT NULL,
FOREIGN KEY (OrderNumber) REFERENCES PhoneOrder(OrderNumber) 
ON UPDATE CASCADE ON DELETE NO ACTION);

--MENUITEM TABLE
CREATE TABLE MenuItem ( 
ItemCode			Char(10) PRIMARY KEY,
[Name]				VarChar(20) NOT NULL,
Size				VarChar(20) NOT NULL,
CurrentPrice		NUMERIC(6,2) NOT NULL,
Description			VarChar(99) DEFAULT 'NO DESCRIPTION');

--HAS TABLE
CREATE TABLE Has(
ItemCode			Char(10) NOT NULL,
OrderNumber			Char(10) NOT NULL,
Quantity			Int,
Primary Key (OrderNumber, ItemCode),
FOREIGN KEY (ItemCode) REFERENCES MenuItem(ItemCode)
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (OrderNumber) REFERENCES [Order](OrderNumber)
ON UPDATE CASCADE ON DELETE NO ACTION);

--INGREDIENT TABLE
CREATE TABLE Ingredient(
IngredientCode		Char(10) PRIMARY KEY,
Description			VarChar(99) DEFAULT 'NO DESCRIPTION',
CurrentLevel		VarChar(10) NOT NULL,
LastStocktake		Date NOT NULL,
SuggestedLevel		VarChar(10) NOT NULL,
RestockLevel		VarChar(10) NOT NULL,
IngredientType		VarChar(99) NOT NULL);

--INGREDIENT ON ITEM TABLE
CREATE TABLE Includes(
IngredientCode		Char(10) NOT NULL,
ItemCode			Char(10) NOT NULL,
Quantity			Int NOT NULL,
PRIMARY KEY (IngredientCode,ItemCode),
FOREIGN KEY (IngredientCode) REFERENCES Ingredient(IngredientCode)
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (ItemCode) REFERENCES MenuItem(ItemCode)
ON UPDATE CASCADE ON DELETE NO ACTION
);


--IngredientOrderDates TABLE
CREATE TABLE IngredientOrderDate(
OrderDate			DATE PRIMARY KEY,
OrderArrivalDate	DATE NOT NULL);


--INGREDIENTORDER TABLE
CREATE TABLE IngredientOrderDetails(
IngredientOrderNumber	Char(10) PRIMARY KEY,
TotalPrice				NUMERIC(8,2) NOT NULL,
OrderDate				DATE NOT NULL,
Status					VarChar(99) NOT NULL,
FOREIGN KEY (OrderDate) REFERENCES IngredientOrderDate(OrderDate)
ON UPDATE CASCADE ON DELETE NO ACTION 
);

--INGREDIENT IN ORDER JUNCTION TABLE
CREATE TABLE [Contains](
IngredientCode			Char(10) NOT NULL,
IngredientOrderNumber	Char(10) NOT NULL,
Quantity				Int NOT NULL,
Price					Int NOT NULL,
PRIMARY KEY (IngredientCode,IngredientOrderNumber),
FOREIGN KEY (IngredientCode) REFERENCES Ingredient(IngredientCode)
ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (IngredientOrderNumber) REFERENCES IngredientOrderDetails(IngredientOrderNumber)
ON UPDATE CASCADE ON DELETE NO ACTION
);

--LOADING TO Customer TABLE

INSERT INTO Customer VALUES ('xew1DBFuCF','Jai','Stokes', '0000000001', '10 University Street')
INSERT INTO Customer VALUES ('00qvJuF1Uw','John','Smith', '0000000002', '11 University Street')
INSERT INTO Customer VALUES ('H2VjkT4Ve5','Ben','Wilson', '0000000003', '12 University Street')
INSERT INTO Customer VALUES ('1LqA5abLM7','Hugh','Brent', '0000000004', '13 University Street')

--LOADING TO Employee TABLE

INSERT INTO Employee VALUES('3743921893','Charles','White','14 University Street','0000000005','4036207269','BankAccount1',NULL)
INSERT INTO Employee VALUES('1900684484', 'Jackson','Smith','15 University Street','0000000006','2089377679','BankAccount2','Tall Brown Hair')
INSERT INTO Employee VALUES('9553643345','Andrew' , 'Evitts','16 University Street','0000000007','4198299390','BankAccount3',NULL)
INSERT INTO Employee VALUES('8966371790','Michael','James','17 University Street','0000000008','1368002962','BankAccount4', ' Short Blonde Hair')
INSERT INTO Employee VALUES('6353938212','Aria','Belle','18 University Street','0000000009','0716165271','BankAccount5', NULL)
INSERT INTO Employee VALUES('9770643769','Ivy','Landow', '1 University Street','0000000010','7705279654','BankAccount6',NULL)

--LOADING TO InStoreWorker TABLE
INSERT INTO InStoreWorker VALUES('3743921893',15)
INSERT INTO InStoreWorker VALUES('6353938212',16.5)
INSERT INTO InStoreWorker VALUES('9553643345',19.5)

--LOADING TO DeliveryDriver TABLE

INSERT INTO DeliveryDriver VALUES('1900684484','0000000000000001',8.5)
INSERT INTO DeliveryDriver VALUES ('9770643769','0000000000000002',12.5)
INSERT INTO DeliveryDriver VALUES('8966371790','0000000000000003',5.5)

--LOADING TO EMPLOYEE SHIFT

INSERT INTO EmployeeShift VALUES('NwHhxWCtnV','3743921893', '2021-10-15', '10:30','2021-10-15','13:30')
INSERT INTO EmployeeShift VALUES('q3EdKiECIW','6353938212', '2021-09-15',' 10:00','2021-10-15','16:00')
INSERT INTO EmployeeShift VALUES('n7uqs8ewxo','9553643345', '2021-10-13', '12:00','2021-10-13','20:00')
INSERT INTO EmployeeShift VALUES('2usv9xpj4o','3743921893', '2021-10-01', '16:00','2021-10-13','22:00')
INSERT INTO EmployeeShift VALUES('n7uqs2swxo','9553643345', '2021-10-01', '12:30','2021-10-01','22:00')
INSERT INTO EmployeeShift VALUES('2dCxQxpj4o','1900684484', '2021-10-01', '12:00','2021-10-01','20:00')
INSERT INTO EmployeeShift VALUES('6gkEoySXqt','9770643769', '2021-09-15', '15:30','2021-09-15','22:00')
INSERT INTO EmployeeShift VALUES('tyy8Qmkmgf','8966371790', '2021-10-15', '17:00', '2021-10-15','21:00')

--LOADING TO IN STORE SHIFT

INSERT INTO InStoreShift VALUES('NwHhxWCtnV',3)
INSERT INTO InStoreShift VALUES('q3EdKiECIW',6)
INSERT INTO InStoreShift VALUES('n7uqs8ewxo',6)
INSERT INTO InStoreShift VALUES('n7uqs2swxo',9.5)
INSERT INTO InStoreShift VALUES('2usv9xpj4o',6)

--LOADING TO DELIVERY SHIFT

INSERT INTO DeliveryShift VALUES('2dCxQxpj4o',36)
INSERT INTO DeliveryShift VALUES('6gkEoySXqt',20)
INSERT INTO DeliveryShift VALUES('tyy8Qmkmgf',15)

--LOADING TO ORDER TABLE


INSERT INTO [Order] Values('7359076659','3743921893','1LqA5abLM7','$10','2021-10-15','Completed',1)
INSERT INTO [Order] Values('2936500474','6353938212','xew1DBFuCF','$7.5','2021-10-15','Completed',1)
INSERT INTO [Order] Values('3124739541','6353938212','1LqA5abLM7','$20','2021-09-15','Completed',1)
INSERT INTO [Order] Values('0936874613','3743921893','00qvJuF1Uw','$10','2021-10-15','Completed',1)
INSERT INTO [Order] Values('1709697673','9553643345','H2VjkT4Ve5','$7.5','2021-10-13','Completed',1)
INSERT INTO [Order] Values('3965023192','9553643345','xew1DBFuCF','$10','2021-10-13','Completed',1)
INSERT INTO [Order] Values('1362731792','3743921893','H2VjkT4Ve5','$20','2021-10-15','Completed',1)
INSERT INTO [Order] Values('8511522084','3743921893','1LqA5abLM7','$30','2021-10-01','Completed',1)
INSERT INTO [Order] Values('2251103300','3743921893','00qvJuF1Uw','$20','2021-10-01','Completed',1)

--LOADING TO MENUITEM TABLE
INSERT INTO MenuItem Values('0uleu1g7pl','Margerita','Medium','10','Tomato Sauce, Mozzerella')
INSERT INTO MenuItem Values('ZEQJ2G02K5','BottledWater','600ml','5','Water')
INSERT INTO MenuItem Values('jFB9kQjSxe','MeatLovers','Medium','10','Barbecue Sauce,Bacon,Pepperoni, Cheese')
INSERT INTO MenuItem Values('wE4SWU6Aj0','Pepperoni Extreme','Large','20','Tomato Sauce, Pepperoni And Cheese')
INSERT INTO MenuItem Values('fqQbBZQZfe','Veggie','Medium','10','Tomato Sauce,Cheese and Vegetables')
INSERT INTO MenuItem Values('lofmI4Zo6H','Mini MeatLovers','Small','7.5','Barbecue Sauce,Bacon,Beef,Pepperoni, Cheese')

--LOADING TO HAS TABLE
INSERT INTO Has Values('0uleu1g7pl','7359076659',1)
INSERT INTO Has Values('lofmI4Zo6H','2936500474',1)
INSERT INTO Has Values('jFB9kQjSxe','3124739541',1)
INSERT INTO Has Values('fqQbBZQZfe','3124739541',1)
INSERT INTO Has Values('fqQbBZQZfe','0936874613',1)
INSERT INTO Has Values('lofmI4Zo6H','1709697673',1)
INSERT INTO Has Values('ZEQJ2G02K5','3965023192',2)
INSERT INTO Has Values('wE4SWU6Aj0','1362731792',1)
INSERT INTO Has Values('wE4SWU6Aj0','8511522084',1)
INSERT INTO Has Values('jFB9kQjSxe','8511522084',1)
INSERT INTO Has Values('lofmI4Zo6H','2251103300',2)
INSERT INTO Has Values('ZEQJ2G02K5','2251103300',1)

--LOADING TO INGREDIENTS TABLE
INSERT INTO Ingredient Values('vr07O81ILU','Tomato Sauce','5 Boxes','2021-10-18','6 Boxes','6 Boxes','Sauce')
INSERT INTO Ingredient Values('qL2FhpGz92','BBQ Sauce','4 Boxes','2021-10-18','5 Boxes','4 Boxes','Sauce')
INSERT INTO Ingredient Values('fbQoPwJvVB','Cheese','8 Boxes','2021-10-18','12 Boxes','12 Boxes','Cheese')
INSERT INTO Ingredient Values('X0PojnbSKy','Pepperoni','6 Boxes','2021-10-18','8 Boxes','8 Boxes','Meat')
INSERT INTO Ingredient Values('vXMLeLpWtw','Bacon','6 Boxes','2021-10-18','7 Boxes','8 Boxes','Meat')
INSERT INTO Ingredient Values('F8bd09peUG','Water','4 Boxes','2021-10-18','6 Boxes','7 Boxes','Water Bottles')
INSERT INTO Ingredient Values('fFh5l2A1zC','Vegetables','2 Pallets','2021-10-18','2 Boxes','2 Boxes','Vegetables')
INSERT INTO Ingredient Values('f9Ezj6YUiw','Beef','4 Boxes','2021-10-18','3 Boxes','3 Boxes','Meat')

--LOADING TO INCLUDES TABLE 
INSERT INTO Includes Values('vr07O81ILU','0uleu1g7pl',2)
INSERT INTO Includes Values('fbQoPwJvVB','0uleu1g7pl',2)
INSERT INTO Includes Values('F8bd09peUG','ZEQJ2G02K5',1)
INSERT INTO Includes Values('qL2FhpGz92','jFB9kQjSxe',2)
INSERT INTO Includes Values('fbQoPwJvVB','jFB9kQjSxe',2)
INSERT INTO Includes Values('vXMLeLpWtw','jFB9kQjSxe',2)
INSERT INTO Includes Values('X0PojnbSKy','jFB9kQjSxe',2)
INSERT INTO Includes Values('f9Ezj6YUiw','jFB9kQjSxe',2)
INSERT INTO Includes Values('X0PojnbSKy','wE4SWU6Aj0',4)
INSERT INTO Includes Values('fbQoPwJvVB','wE4SWU6Aj0',3)
INSERT INTO Includes Values('vr07O81ILU','wE4SWU6Aj0',3)
INSERT INTO Includes Values('vr07O81ILU','fqQbBZQZfe',2)
INSERT INTO Includes Values('fbQoPwJvVB','fqQbBZQZfe',2)
INSERT INTO Includes Values('fFh5l2A1zC','fqQbBZQZfe',2)
INSERT INTO Includes Values('qL2FhpGz92','lofmI4Zo6H',1)
INSERT INTO Includes Values('fbQoPwJvVB','lofmI4Zo6H',1)
INSERT INTO Includes Values('vXMLeLpWtw','lofmI4Zo6H',1)
INSERT INTO Includes Values('X0PojnbSKy','lofmI4Zo6H',1)
INSERT INTO Includes Values('f9Ezj6YUiw','lofmI4Zo6H',1)

--LOADING TO INGREDIENT ORDERDATE
INSERT Into IngredientOrderDate VALUES('2021-10-18','2021-10-19')
INSERT Into IngredientOrderDate VALUES('2021-10-11','2021-10-12')
INSERT Into IngredientOrderDate VALUES('2021-10-04','2021-10-06')

--LOADING TO INGREDIENTORDER DETAILS
INSERT INTO IngredientOrderDetails VALUES('71DDAfu62x',500,'2021-10-18','Arrived')
INSERT INTO IngredientOrderDetails VALUES('CfGbJ8odsG',650,'2021-10-11','Arrived')
INSERT INTO IngredientOrderDetails VALUES('X3DxmaGamc',300,'2021-10-04','Arrived')

--LOADING TO CONTAINS DETAILS
INSERT INTO [Contains] VALUES('vr07O81ILU','71DDAfu62x',2,50)
INSERT INTO [Contains] VALUES('X0PojnbSKy','71DDAfu62x',2,200)

INSERT INTO [Contains] VALUES('vr07O81ILU','CfGbJ8odsG',2,50)
INSERT INTO [Contains] VALUES('fFh5l2A1zC','CfGbJ8odsG',2,150)
INSERT INTO [Contains] VALUES('fbQoPwJvVB','CfGbJ8odsG',1,150)
INSERT INTO [Contains] VALUES('vXMLeLpWtw','CfGbJ8odsG',1,100)

INSERT INTO [Contains] VALUES('X0PojnbSKy','X3DxmaGamc',1,200)
INSERT INTO [Contains] VALUES('vXMLeLpWtw','X3DxmaGamc',1,100)

--LOADING TO PHONEORDER TABLE
INSERT INTO PhoneOrder Values('7359076659','11:00','11:05')
INSERT INTO PhoneOrder Values('2936500474','13:25','13:27')
INSERT INTO PhoneOrder Values('2251103300','18:05','18:10')
INSERT INTO PhoneOrder Values('3124739541','15:45','15:48')
INSERT INTO PhoneOrder Values('1362731792','17:00','17:02')
INSERT INTO PhoneOrder Values('3965023192','17:25','17:28')

--LOADING INTO DeliveryOrder
INSERT INTO DeliveryOrder Values('2251103300','2dCxQxpj4o','18:25')
INSERT INTO DeliveryOrder Values('3124739541','6gkEoySXqt','16:30')
INSERT INTO DeliveryOrder Values('1362731792','tyy8Qmkmgf','17:35')
--LOADING INTO PICKUP ORDER
INSERT INTO PickUPOrder Values('7359076659','11:25')
INSERT INTO PickUpOrder Values('2936500474','13:54')
INSERT INTO PickUpOrder Values('3965023192','17:52')
--LOADING INTO WALKIN ORDER
INSERT INTO WalkInOrder VALUES ('0936874613','11:00','3743921893')
INSERT INTO WalkInOrder VALUES ('1709697673','15:22','9553643345')
INSERT INTO WalkInOrder VALUES ('8511522084','19:00','9553643345')

--LOADING INTO PAYMENT
INSERT INTO Payment VALUES ('1731346795','9770643769',250,50,200,'2021-09-16','2021-09-15')
INSERT INTO Payment VALUES ('8219250989','6353938212',99,0,99,'2021-09-16','2021-09-15')
INSERT INTO Payment VALUES ('5076788983','1900684484',306,60,246,'2021-10-02','2021-10-01')
INSERT INTO Payment VALUES ('1210212659','9553643345',185.25,12.20,173.05,'2021-10-02','2021-10-01')
INSERT INTO Payment VALUES ('5605022483','3743921893',90,0,90,'2021-10-02','2021-10-01')
INSERT INTO Payment Values ('4855232631','8966371790',82.5,0,82.5,'2021-10-02','2021-10-01')

--LOADING INTO InStorePay 
INSERT INTO InStorePay VALUES ('8219250989',6,16.5,'q3EdKiECIW')
INSERT INTO InStorePay VALUES ('1210212659',6,19.5,'n7uqs8ewxo')
INSERT INTO InStorePay VALUES ('5605022483',6,15,'2usv9xpj4o')

--LOADING INTO DeliveryPay
INSERT INTO DeliveryPay VALUES('1731346795',20,12.5,'6gkEoySXqt')
INSERT INTO DeliveryPay VALUES('5076788983',36,8.5,'2dCxQxpj4o')
INSERT INTO DeliveryPay VALUES('4855232631',15,5.5,'tyy8Qmkmgf')
