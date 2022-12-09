-----------------Create database-----------------------------------------------------
CREATE TABLE Branch(	
	code		VARCHAR(10)	PRIMARY KEY,
	province	VARCHAR(10)	NOT NULL,
	address		VARCHAR(30)	NOT NULL UNIQUE,
	phone		VARCHAR(10)	UNIQUE,
	email		VARCHAR(30)	UNIQUE
);
CREATE TABLE Picture(	
	Branch_code	VARCHAR(10),
	picture		VARCHAR(30),
	PRIMARY KEY (Branch_code,picture),
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Zone(	
	Branch_code	VARCHAR(10),
	name_zone		VARCHAR(30),
	PRIMARY KEY (Branch_code, name_zone),
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE RoomType(	
	code		DECIMAL(10)	 GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name_rtype		VARCHAR(30),
	space_rtype	DECIMAL(10,2),
	NoCustomers	INT		NOT NULL 
			CHECK(NoCustomers >=1 AND NoCustomers <=10),
	other		VARCHAR(10)
);
CREATE TABLE Bed(	
	RoomType_code	DECIMAL(10),
	space_bed		DECIMAL(2,1),
	number_bed		INT	DEFAULT 1	NOT NULL 
			CHECK(number_bed >=1 AND number_bed <=10),
	PRIMARY KEY (RoomType_code,space_bed),
	FOREIGN KEY (RoomType_code) REFERENCES RoomType(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE R_Branch_RoomType(	
	RoomType_code	DECIMAL(10),
	Branch_code	VARCHAR(10),
	price		DECIMAL(10,2)	NOT NULL,
	PRIMARY KEY (RoomType_code,Branch_code),
	FOREIGN KEY (RoomType_code) REFERENCES RoomType(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Room(	
	Branch_code	VARCHAR(10),
	number_room		VARCHAR(3),
	RoomType_code	DECIMAL(10),
	Zone_name	VARCHAR(30),
	PRIMARY KEY (Branch_code, number_room),
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE,
    	FOREIGN KEY (RoomType_code) REFERENCES RoomType(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code,Zone_name) REFERENCES Zone(Branch_code, name_zone) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE SupplyType(	
	code		VARCHAR(6)	PRIMARY KEY	
			CHECK (code LIKE 'VT%'),
	name_suptype		VARCHAR(30)	NOT NULL
);
CREATE TABLE R_RoomType_SupplyType(	
	RoomType_code	DECIMAL(10),
	SupplyType_code	VARCHAR(10),
	number_rrstype	INT	DEFAULT 1	NOT NULL
			CHECK(number_rrstype >=1 AND number_rrstype <=20),
	PRIMARY KEY (RoomType_code, SupplyType_code),
	FOREIGN KEY (RoomType_code) REFERENCES RoomType(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (SupplyType_code) REFERENCES SupplyType(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Supply(	
	Branch_code	VARCHAR(10),
	SupplyType_code	VARCHAR(10),
	ssn		INT
			CHECK(ssn>0),
	situation	VARCHAR(10),
	Room_number	VARCHAR(3),
	PRIMARY KEY (Branch_code, SupplyType_code,ssn),
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (SupplyType_code) REFERENCES SupplyType(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code,Room_number) REFERENCES Room(Branch_code, number_room) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Provider(
	code		VARCHAR(7)	PRIMARY KEY	
			CHECK (code LIKE 'NCC%'),
	name_provider		VARCHAR(30)	NOT NULL UNIQUE,
	email		VARCHAR(30)	UNIQUE,
	address		VARCHAR(30)	
);
CREATE TABLE R_provide(
	Provider_code	VARCHAR(10),
	SupplyType_code	VARCHAR(10),
	Branch_code	VARCHAR(10),
	PRIMARY KEY (SupplyType_code, Branch_code),
	FOREIGN KEY (Provider_code) REFERENCES Provider(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (SupplyType_code) REFERENCES SupplyType(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Customer(
	code		VARCHAR(8)	PRIMARY KEY
			CHECK (code LIKE 'KH%'),
	id_cus		VARCHAR(12)	NOT NULL UNIQUE,
	name_cus		VARCHAR(30)	NOT NULL,
	phone		VARCHAR(10)	UNIQUE,
	email		VARCHAR(30)	UNIQUE,
	address		VARCHAR(30),
	username	VARCHAR(30)	UNIQUE,
	password_cus	VARCHAR(30),
	point_cus	INT		DEFAULT 0	NOT NULL 
			CHECK (point_cus>=0),
	type_cus		INT		DEFAULT 1 	NOT NULL
			CHECK (type_cus >=1 AND type_cus <=4)
);
CREATE TABLE ServiceType(
	name_sertype		VARCHAR(30)	PRIMARY KEY,
	NoDate		DECIMAL(3)	NOT NULL,
	NoCustomer	DECIMAL(2)	NOT NULL,
	price		DECIMAL(10)	NOT NULL
);
CREATE TABLE BillService(
	Customer_code	VARCHAR(10),
	ServiceType_name	VARCHAR(30),
	timebooking	TIMESTAMP,
	startingdate	DATE,
	sum_bser		DECIMAL(10,2)	NOT NULL,
	PRIMARY KEY (Customer_code, ServiceType_name, timebooking),
	FOREIGN KEY (Customer_code) REFERENCES Customer(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (ServiceType_name) REFERENCES ServiceType(name_sertype) ON DELETE SET NULL DEFERRABLE,
    	CONSTRAINT ck_time CHECK (startingdate>timebooking)
);
CREATE TABLE Booking(
	code		VARCHAR(16)	PRIMARY KEY,
	timebooking	TIMESTAMP,
	NoCustumer	DECIMAL(10),
	datereciving	DATE,
	datereturning	DATE,
	situation	INT
			CHECK (situation >=1 AND situation <=3),
	sum_booking		DECIMAL(10,2)	DEFAULT 0,
	Customer_code	VARCHAR(8),
	ServiceType_name	VARCHAR(30),
	FOREIGN KEY (Customer_code) REFERENCES Customer(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (ServiceType_name) REFERENCES ServiceType(name_sertype) ON DELETE SET NULL DEFERRABLE,
	CONSTRAINT 	ck_datereciving CHECK (datereciving > timebooking),
	CONSTRAINT 	ck_datereturning CHECK (datereturning > datereciving)
);
CREATE TABLE Renting(
	Booking_code	VARCHAR(20),
	Branch_code	VARCHAR(10),
	Room_number	VARCHAR(3),
	PRIMARY KEY (Booking_code, Branch_code, Room_number),
	FOREIGN KEY (Booking_code) REFERENCES Booking(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code,Room_number) REFERENCES Room(Branch_code, number_room) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Bill(
	code		VARCHAR(16)	PRIMARY KEY,
	timereciving	VARCHAR(5),
	timeturning	VARCHAR(5),
	Booking_code	VARCHAR(16)	NOT NULL UNIQUE,
	FOREIGN KEY (Booking_code) REFERENCES Booking(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Lessee(
	code		VARCHAR(6)	PRIMARY KEY	
			CHECK (code LIKE 'DN%'),
	name_les		VARCHAR(30)	NOT NULL
);
CREATE TABLE Service(
	code		VARCHAR(6)	PRIMARY KEY,
	type_service		VARCHAR(1)	NOT NULL,
	NoCustomer	DECIMAL(10),
	style_service		VARCHAR(30),
	Lessee_code	VARCHAR(6),
	FOREIGN KEY (Lessee_code) REFERENCES Lessee(code) ON DELETE SET NULL DEFERRABLE,
	CONSTRAINT 	CHK_code_type CHECK ((code LIKE 'DVR%' AND type_service = 'R')
					OR (code LIKE 'DVS%' AND type_service = 'S')
					OR (code LIKE 'DVC%' AND type_service = 'C')
					OR (code LIKE 'DVM%' AND type_service = 'M')
					OR (code LIKE 'DVB%' AND type_service = 'B'))
);
CREATE TABLE Spa(
	Service_code	VARCHAR(6)
			CHECK (Service_code LIKE 'DVS%'),
	spa_spa		VARCHAR(30),
	PRIMARY KEY (Service_code, spa_spa),
	FOREIGN KEY (Service_code) REFERENCES Service(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE SourvenirType(
	Service_code	VARCHAR(6)
			CHECK (Service_code LIKE 'DVM%'),
	type_sour		VARCHAR(30),
	PRIMARY KEY (Service_code, type_sour),
	FOREIGN KEY (Service_code) REFERENCES Service(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE SourvenirBranch(
	Service_code	VARCHAR(6)
			CHECK (Service_code LIKE 'DVM%'),
	brand		VARCHAR(30),
	PRIMARY KEY (Service_code, brand),
	FOREIGN KEY (Service_code) REFERENCES Service(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Space(
	Branch_code	VARCHAR(10),
	ssn		INT	DEFAULT 1
			CHECK (ssn>=1 AND ssn<=50),
	length_space		DECIMAL(10),
	width 		DECIMAL(10),
	price		DECIMAL(10)	NOT NULL,
	description_space	VARCHAR(30),
	Service_code	VARCHAR(6),
	storename	VARCHAR(30),
	logo		VARCHAR(30),
	PRIMARY KEY (Branch_code,ssn),	
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Service_code) REFERENCES Service(code) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Store_picture(
	Branch_code	VARCHAR(10),
	Space_ssn	INT,
	picture		VARCHAR(30),
	PRIMARY KEY (Branch_code,Space_ssn,picture),
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code, Space_ssn) REFERENCES Space(Branch_code, ssn) ON DELETE SET NULL DEFERRABLE
);
CREATE TABLE Openningtime(
	Branch_code	VARCHAR(10),
	Space_ssn	INT,
	openningtime	VARCHAR(5),
	closingtime	VARCHAR(5),
	PRIMARY KEY (Branch_code,Space_ssn,openningtime),
	FOREIGN KEY (Branch_code) REFERENCES Branch(code) ON DELETE SET NULL DEFERRABLE,
	FOREIGN KEY (Branch_code, Space_ssn) REFERENCES Space(Branch_code, ssn) ON DELETE SET NULL DEFERRABLE
);
-----------------Trigger in some tables-----------------------------------------------------
ALTER SESSION SET nls_date_format='DD/MM/YYYY';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD/MM/YYYY HH24:MI';
--Branch---
CREATE SEQUENCE Branch_seq START WITH 1;
CREATE OR REPLACE TRIGGER Branch_code
BEFORE INSERT ON Branch
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    IF :NEW.code IS NULL THEN
        SELECT 'CN' || TO_CHAR(Branch_seq.NEXTVAL) INTO :NEW.code FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER Branch_code ENABLE;
--Bill---
CREATE SEQUENCE Bill_seq START WITH 1;
CREATE OR REPLACE TRIGGER Bill_code
BEFORE INSERT ON Bill
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    IF :NEW.code IS NULL THEN
        SELECT 'HD' || TO_CHAR(SYSDATE, 'DDMMYYYY') || TO_CHAR(Bill_seq.NEXTVAL, 'FM000000') INTO :NEW.code FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER Bill_code ENABLE;
--Booking---
CREATE SEQUENCE Booking_seq START WITH 1;
CREATE OR REPLACE TRIGGER Booking_code
BEFORE INSERT ON Booking
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    IF :NEW.code IS NULL THEN
    SELECT 'DP' || TO_CHAR(:NEW.timebooking,'DDMMYYYY') ||TO_CHAR(Booking_seq.NEXTVAL, 'FM000000')  INTO :NEW.code FROM DUAL;
    END IF;
END;
/
ALTER TRIGGER Booking_code ENABLE;
-----------------STORE PROCEDURE, FUNCTION-----------------------------------------------------
--1
CREATE OR REPLACE PROCEDURE Goidichvu (p_code IN Customer.code% type)
IS q SYS_REFCURSOR;
BEGIN
	OPEN q FOR SELECT ST.name_sertype, ST.NoCustomer, BS.startingdate, (BS.startingdate + ST.NoDate), (SYSDATE - BS.startingdate)
	FROM ServiceType ST INNER JOIN BillService BS ON ST.name_sertype = BS.ServiceType_name
	WHERE BS.Customer_code= p_code
	AND  ( SYSDATE - BS.startingdate) >0;
     	DBMS_SQL.return_result (q);
END;
/
--2
CREATE VIEW statisticCustomer AS
SELECT  EXTRACT(YEAR FROM timebooking) AS YEAR_V,
        EXTRACT(MONTH FROM timebooking) AS MONTH_V,
        Count (NoCustumer) As Number_of_Customer
FROM Booking
WHERE situation = 1
GROUP BY     EXTRACT(YEAR FROM timebooking),  EXTRACT(MONTH FROM timebooking)
ORDER BY    EXTRACT(YEAR FROM timebooking),  EXTRACT(MONTH FROM timebooking);
CREATE OR REPLACE PROCEDURE ThongKeLuotKhac (yearsatistic NUMBER)
IS q SYS_REFCURSOR;
BEGIN 
     OPEN q FOR SELECT Month_V, Number_of_Customer
     FROM statisticCustomer
     WHERE  yearsatistic= statisticCustomer.YEAR_V;
     DBMS_SQL.return_result (q);
END;
/
-----------------TRIGGER-----------------------------------------------------
--a
CREATE OR REPLACE TRIGGER BillService_sum
BEFORE INSERT ON BillService
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE 
        priceSerivice DECIMAL (10,0);
                typeCustomer INT;
BEGIN
        SELECT price INTO priceSerivice FROM ServiceType  WHERE ServiceType.name_sertype =  :NEW.ServiceType_name;
        SELECT type_cus INTO typeCustomer FROM Customer WHERE Customer.code = :NEW.Customer_code;
        IF INSERTING THEN
        :NEW.sum_bser := CASE
        WHEN typeCustomer = 2 THEN priceSerivice * 0.9
        WHEN typeCustomer = 3 THEN priceSerivice * 0.85 
        WHEN typeCustomer = 4 THEN priceSerivice * 0.8
        END;
        END IF;
END;
/
ALTER TRIGGER BillService_sum ENABLE;
--b
CREATE OR REPLACE TRIGGER Booking_sum
BEFORE INSERT ON Renting
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE 
        roomtype_v RoomType.code%TYPE;
        priceRT_v R_Branch_RoomType.price%TYPE;
        priceST_v ServiceType.price%type;
        ServiceType_v ServiceType.name_sertype%type;
        Customer_v Customer.code%type;
        type_v Customer.type_cus%type;
BEGIN
        SELECT RoomType_code INTO roomtype_v FROM ROOM 
        WHERE :New.Branch_code = Branch_code AND :New.Room_number = number_room;
        SELECT price INTO priceRT_v FROM R_Branch_RoomType 
        WHERE :New.Branch_code = Branch_code AND roomtype_v = RoomType_code;
        
        SELECT ServiceType_name INTO ServiceType_v FROM Booking 
        WHERE :New.Booking_code = code;
        SELECT price INTO priceST_v FROM ServiceType 
        WHERE ServiceType_v = name_sertype;
        
        SELECT Customer_code INTO Customer_v FROM Booking 
        WHERE :New.Booking_code = code;
        SELECT type_cus INTO type_v FROM Customer 
        WHERE  Customer_v= code;
        
        UPDATE Booking
        SET sum_booking = CASE
        WHEN type_v = 2 THEN priceRT_v + priceST_v*0.9
        WHEN type_v = 3 THEN priceRT_v + priceST_v*0.85
        WHEN type_v = 4 THEN priceRT_v + priceST_v*0.8
        ELSE priceRT_v + priceST_v 
        END
        WHERE :NEW.Booking_code = code;
END;
/
ALTER TRIGGER Booking_sum ENABLE;
--c
CREATE OR REPLACE TRIGGER Customer_point1
BEFORE INSERT ON BillService
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
        UPDATE Customer
        SET point_cus = point_cus + FLOOR(:NEW.sum_bser/1000)
        WHERE :NEW.Customer_code = code;
END;
/
ALTER TRIGGER Customer_point1 ENABLE;
CREATE OR REPLACE TRIGGER Customer_point2
BEFORE INSERT ON Booking
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
        UPDATE Customer
        SET point_cus = point_cus + FLOOR(:NEW.sum_booking/1000)
        WHERE :NEW.Customer_code = code;
END;
/
ALTER TRIGGER Customer_point2 ENABLE;
--d
CREATE OR REPLACE TRIGGER Customer_type
BEFORE INSERT OR UPDATE OF point_cus ON Customer
FOR EACH ROW
BEGIN
        :NEW.type_cus := CASE
            WHEN :NEW.point_cus <50 THEN 1
            WHEN :NEW.point_cus <100 AND :NEW.point_cus >=50 THEN 2
            WHEN :NEW.point_cus <1000 AND :NEW.point_cus >=100 THEN 3
            ELSE 4
        END;
END;
/
ALTER TRIGGER Customer_type ENABLE;
--
CREATE OR REPLACE TRIGGER BillService_no_more_same_type
BEFORE INSERT ON BillService
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE p_date BillService.startingdate%type;c INT;
    
BEGIN
    SELECT COUNT(startingdate) INTO c
    FROM BillService
    WHERE Customer_code = :NEW.Customer_code AND ServiceType_name = :NEW.ServiceType_name;
    IF c =1 THEN 
    BEGIN 
        SELECT startingdate INTO p_date FROM BillService
            WHERE Customer_code = :NEW.Customer_code AND ServiceType_name = :NEW.ServiceType_name;
        IF :NEW.startingdate <= p_date THEN raise_application_error(-1000, 'Starting date is period'); 
        ELSIF  (:New.startingdate - p_date)/ 364.242199 <1 THEN raise_application_error(-1002, 'The old service is using'); 
        END IF;
    END;
    END IF;
END;
/
ALTER TRIGGER BillService_no_more_same_type ENABLE;
-----------------Insert database-----------------------------------------------------
INSERT INTO Branch(province, address, phone, email) 	VALUES('HCMC', '285 Ly Thuong Kiet stress, D10', '0123123123', 'hcm.d10@gmail.com');
INSERT INTO Branch(province, address, phone) 		VALUES('HCMC', '28 Le Van Sy stress, D3', '0123123122');
INSERT INTO Branch(province, address, email) 		VALUES('HCMC', '25 Mai Lao Ban stress, D.TB','hcm.dtb@gmail.com');
INSERT INTO Branch(province, address) 			VALUES('Hanoi', '32 Hang Buom');

INSERT INTO Picture VALUES('CN1', 'Mona Lisa');
INSERT INTO Picture VALUES('CN1', 'Universal Monster');
INSERT INTO Picture VALUES('CN2', 'Mona Lisa');
INSERT INTO Picture VALUES('CN3', 'Light Night');

INSERT INTO Zone VALUES('CN1', 'garden');
INSERT INTO Zone VALUES('CN1', 'kingdom');
INSERT INTO Zone VALUES('CN2', 'garden');
INSERT INTO Zone VALUES('CN4', 'forest');	

INSERT INTO RoomType(name_rtype, space_rtype,NoCustomers) 	VALUES('Single', 30.2, 1);	
INSERT INTO RoomType(name_rtype, space_rtype,NoCustomers) 	VALUES('Couple', 50.2, 2);	
INSERT INTO RoomType(name_rtype, space_rtype,NoCustomers) 	VALUES('Beach', 30.2, 10);	
INSERT INTO RoomType(name_rtype,NoCustomers) 		VALUES('Top',5);	

INSERT INTO Bed VALUES(1,3.2,default);
INSERT INTO Bed VALUES(1,3.5,default);
INSERT INTO Bed VALUES(2,5.6,default);
INSERT INTO Bed VALUES(3,3.5,default);
INSERT INTO Bed	VALUES(4,5.6, 2);

INSERT INTO R_Branch_RoomType VALUES(1,'CN1', 10.2);
INSERT INTO R_Branch_RoomType VALUES(2,'CN1', 10.2);	
INSERT INTO R_Branch_RoomType VALUES(1,'CN2', 10.2);	
INSERT INTO R_Branch_RoomType VALUES(1,'CN3', 10.2);		

INSERT INTO Room VALUES('CN1','001', 1, 'garden');
INSERT INTO Room VALUES('CN1','102', 2, 'garden');
INSERT INTO Room VALUES('CN1','301', 3, 'kingdom');
INSERT INTO Room VALUES('CN2','001', 1, 'garden');

INSERT INTO SupplyType VALUES('VT1001','bath');
INSERT INTO SupplyType VALUES('VT2001','chair');
INSERT INTO SupplyType VALUES('VT2501','sofa');
INSERT INTO SupplyType VALUES('VT3102','TV');

INSERT INTO R_RoomType_SupplyType VALUES(1,'VT2501',default);
INSERT INTO R_RoomType_SupplyType VALUES(2,'VT2501',default);	
INSERT INTO R_RoomType_SupplyType VALUES(3,'VT2501',default);	
INSERT INTO R_RoomType_SupplyType VALUES(3,'VT3102',20);

INSERT INTO Supply 					VALUES('CN1', 'VT1001', 1, 'good', '001');
INSERT INTO Supply 					VALUES('CN1', 'VT2001', 1, 'good', '001');
INSERT INTO Supply					VALUES('CN1', 'VT1001', 2, 'good', '102');
INSERT INTO SupplY(Branch_code, SupplyType_code, ssn) 	VALUES('CN2', 'VT1001', 1);

INSERT INTO Provider 				VALUES('NCC1001', 'Amazon', 'amazon@gmail.com', '12 HillStone street, NYC');
INSERT INTO Provider(code, name_provider)		VALUES('NCC2001', 'Tiki');
INSERT INTO Provider(code, name_provider, email)		VALUES('NCC2222', 'Shopee', 'shopee@gmail.com');
INSERT INTO Provider 				VALUES('NCC3010', 'Lazada', 'lazada@gmail.com', '1 Dinh Tien Hoang street, HCMC');

INSERT INTO R_provide VALUES('NCC1001', 'VT1001', 'CN1');
INSERT INTO R_provide VALUES('NCC1001', 'VT2001', 'CN1');
INSERT INTO R_provide VALUES('NCC2001', 'VT3102', 'CN1');
INSERT INTO R_provide VALUES('NCC3010', 'VT2501', 'CN3');

INSERT INTO Customer(code, id_cus, name_cus, phone, email, username, password_cus, point_cus, type_cus) 	VALUES('KH000001', '123456789012', 'Nguyen Thanh Loc', '0708562001', 'loc.nguyen@hcmut.edu.vn','loc.nguyen', '123',1000, 3);
INSERT INTO Customer  									VALUES('KH000002', '223456789012', 'Nguyen Xuan Truc', '0442592031', 'truc.nguyen@hcmut.edu.vn','Tan Phu','truc.nguyen', '123',200, 2);
INSERT INTO Customer(code, id_cus, name_cus, phone, email, address, point_cus, type_cus) 		VALUES('KH000003', '323456789012', 'Le Ngoc Duyen', '0702592001', 'duyen.le@hcmut.edu.vn','Dau Tieng', 300, 3);
INSERT INTO Customer(code, id_cus, name_cus, username, password_cus, point_cus, type_cus) 			VALUES('KH540001', '423456789012', 'Nguyen Thanh Loc','loc.nguyen1', '123',default, 1);

INSERT INTO ServiceType VALUES('washing',2,2,500);
INSERT INTO ServiceType VALUES('breakfast',3,2,1000);
INSERT INTO ServiceType VALUES('gym',3,1,800);
INSERT INTO ServiceType VALUES('photos',3,10,10000);

INSERT INTO BillService 							VALUES('KH000001', 'gym', '01/01/2022 13:23', '01/02/2022', 802);
INSERT INTO BillService(Customer_code, ServiceType_name, timebooking, sum_bser) 	VALUES('KH000001', 'washing', '01/01/2021 17:00', 500);
INSERT INTO BillService 							VALUES('KH000002', 'photos', '01/01/2021 13:23', '01/01/2022', 10000);
INSERT INTO BillService 							VALUES('KH000003', 'washing', '01/01/2021 13:23', '02/01/2022', 500);

INSERT INTO Booking(timebooking, NoCustumer, datereciving, datereturning, situation, Customer_code, ServiceType_name) VALUES('31/12/2021 23:59', 5, '01/01/2022', '07-01-2022', 1, 'KH000001', 'gym');
INSERT INTO Booking(timebooking, NoCustumer, datereciving, datereturning, situation, sum_booking, Customer_code, ServiceType_name) VALUES('31/12/2021 23:59', 5, '01/01/2022',  '07/05/2022', 2, 100, 'KH000001', 'washing');
INSERT INTO Booking(timebooking, NoCustumer, datereciving, datereturning, situation, sum_booking, Customer_code, ServiceType_name) VALUES('31/12/2021 23:59', 5, '01/01/2022',  '07/01/2022', 3, 200, 'KH000002', 'gym');
INSERT INTO Booking(timebooking, NoCustumer, datereciving, datereturning, situation, sum_booking, Customer_code, ServiceType_name) VALUES('30/12/2021 23:59', 5, '02/05/2022', '07/05/2022', 2, 100, 'KH000003', 'gym');

INSERT INTO Renting VALUES('DP31122021000001', 'CN1', '001');
INSERT INTO Renting VALUES('DP31122021000001', 'CN2', '001');
INSERT INTO Renting VALUES('DP31122021000001', 'CN1', '102');
INSERT INTO Renting VALUES('DP31122021000003', 'CN1', '001');

INSERT INTO Bill(timereciving,timeturning, Booking_code) VALUES('13:00','10:00','DP31122021000001');
INSERT INTO Bill(timereciving,timeturning, Booking_code) VALUES('13:00','10:00','DP31122021000002');
INSERT INTO Bill(timereciving,timeturning, Booking_code) VALUES('13:00','10:00','DP31122021000003');
INSERT INTO Bill(timereciving,timeturning, Booking_code) VALUES('13:00','10:00','DP30122021000004');

INSERT INTO Lessee VALUES('DN1001', 'HandM');
INSERT INTO Lessee VALUES('DN1002', 'Channel');
INSERT INTO Lessee VALUES('DN3001', 'Dior');
INSERT INTO Lessee VALUES('DN4011', 'Nike');

INSERT INTO Service 						VALUES('DVS101', 'S', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVS102', 'S', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVS201', 'S', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVS221', 'S', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVR101', 'R', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVC102', 'C', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVB201', 'B', 100, 'Luxury', 'DN3001');
INSERT INTO Service 						VALUES('DVM101', 'M', 100, 'Luxury', 'DN3001');
INSERT INTO Service(code, type_service) 				VALUES('DVM102', 'M');
INSERT INTO Service(code, type_service, NoCustomer, style_service) 		VALUES('DVM201', 'M', 100, 'Normal');
INSERT INTO Service(code, type_service, NoCustomer, Lessee_code) 	VALUES('DVM333', 'M', 30, 'DN1001');

INSERT INTO Spa VALUES('DVS101', 'skincare');
INSERT INTO Spa VALUES('DVS102', 'haircare');
INSERT INTO Spa VALUES('DVS201', 'botox');
INSERT INTO Spa VALUES('DVS221', 'chill');

INSERT INTO SourvenirType VALUES('DVM101', 'teddy');
INSERT INTO SourvenirType VALUES('DVM102', 'toy');
INSERT INTO SourvenirType VALUES('DVM201', 'toy');
INSERT INTO SourvenirType VALUES('DVM333', 'paradigm');

INSERT INTO SourvenirBranch VALUES('DVM101', 'Disney');
INSERT INTO SourvenirBranch VALUES('DVM102', 'Disney');
INSERT INTO SourvenirBranch VALUES('DVM102', 'Barbie');
INSERT INTO SourvenirBranch VALUES('DVM333', 'Lego');

INSERT INTO Space 						VALUES('CN1', 50, 10, 10, 100, 'also suitable for meeting', 'DVB201', 'Kchamel', 'Kch');
INSERT INTO Space(Branch_code, price, Service_code) 		VALUES('CN1', 100, 'DVB201');
INSERT INTO Space(Branch_code,ssn, price, Service_code)		VALUES('CN1',2, 100, 'DVM101');
INSERT INTO Space(Branch_code, ssn, price, Service_code)	VALUES('CN2', 50, 500, 'DVS101');

INSERT INTO Store_picture VALUES('CN1', 1, 'Mona Lisa');
INSERT INTO Store_picture VALUES('CN1', 50, 'Mona Lisa');
INSERT INTO Store_picture VALUES('CN1', 50, 'Universal Monster');
INSERT INTO Store_picture VALUES('CN2', 50, 'Mona Lisa');

INSERT INTO Openningtime VALUES('CN1', 1, '10:00', '19:00');
INSERT INTO Openningtime VALUES('CN1', 2, '10:00', '19:00');
INSERT INTO Openningtime VALUES('CN2', 50, '10:00', '19:00');
INSERT INTO Openningtime(Branch_code, Space_ssn, openningtime)  VALUES('CN1', 50, '11:00');

commit;
