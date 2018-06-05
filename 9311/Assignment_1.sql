-- COMP9311 16s2 Assignment 1
-- Schema for KensingtonCars
--
-- Written by <<Jiongtian Li>>
-- Student ID: <<z5099187>>
--

-- Some useful domains; you can define more if needed.

create domain URLType as
	varchar(100) check (value like 'http://%');

create domain EmailType as
	varchar(100) check (value like '%@%.%');

create domain PhoneType as
	char(10) check (value ~ '[0-9]{10}');


-- EMPLOYEE

create table Employee (
	EID          serial not null, 
	TFN         char(9) not null check (tfn ~ '[0-9]{9}'),         
    firstname   varchar(50) not null,
    lastname    varchar(50) not null,
    Salary       integer not null check (Salary > 0),
	primary key (EID)
);

create table Admin (
	EID serial not null references Employee(EID),
	primary key (EID)
);

create table Mechanic (
	EID serial not null references Employee(EID),
	license char(8) not null check(license ~ '[a-zA-Z0-9]{8}'),
	primary key (EID)
);

create table Salesman (
	EID serial not null references Employee(EID),
	commRate integer not null check (commRate>=5 and commRate<=20),
	primary key (EID)
);

-- CLIENT

create table Client (
	CID          serial not null,
	address  	 varchar(200) not null,
	name         varchar(100) not null,
	phone  		 PhoneType not null,
	email		EmailType,
	primary key (CID)
);

create table Company (
	CID serial not null references Client(CID),
	ABN char(11) not null check (ABN ~ '[0-9]{11}'),
	url URLType,
	primary key (CID)
);




-- CAR

create domain CarLicenseType as
        char(6) check (value ~ '[0-9A-Za-z]{6}');

create domain OptionType as varchar(12)
	check (value in ('sunroof','moonroof','GPS','alloy wheels','leather'));

create domain VINType as char(17) check (value ~ '[^IOQ][A-Z0-9]{17}');

create domain DateType as date check(value between '1970-01-01' and '2099-12-31');

create table Car (
	VIN         VINType not null, 
	year      DateType not null,
	model 		varchar(40) not null,
	manufacturer  varchar(40) not null,
	primary key (VIN)
);

create table CarOptions (
	VIN         VINType not null references Car(VIN),
	options     OptionType,
	primary key (VIN, options)
);

create table NewCar (
	VIN         VINType not null references Car(VIN),
	cost 		numeric(8,2) not null check (cost >0),
	charges 	numeric(8,2) not null check (charges >0),
	primary key (VIN)
);

create table UsedCar (
	VIN         VINType not null references Car(VIN),
	plateNumber char(6) not null check(plateNumber ~ '[a-zA-Z0-9]{6}'),	
	primary key (VIN)
);

--buy sell and repair 

create table RepairJob (
	EID serial 		not null references Mechanic(EID),
	number 			integer not null unique check (number>=1 and number<=999),
	description 	varchar(250) not null,
	parts 			numeric(8,2) not null check ( parts>0),
	work  			numeric(8,2) not null check (work >0),
	date 			date    not null,
	CID          	serial not null references Client(CID),
	VIN             VINType not null references UsedCar(VIN),
	primary key (EID, number)
);


create table Does (
	EID             serial 		not null references Mechanic(EID),
	number 			integer not null check (number>=1 and number<=999) references RepairJob(number) ,
	primary key( EID, number)
);

create table SellsNew (
	EID 		    serial not null references Salesman(EID),
	CID          	serial not null references Client(CID),
	VIN              VINType not null references NewCar(VIN),
	commission 		numeric(8,2) not null check (commission>0),
	date   			date not null,
	price          numeric(8,2) not null check (price>0),
	plateNumber    char(6) not null check(plateNumber ~ '[a-zA-Z0-9]{6}'),	
	primary key(EID,CID,VIN)
	
);

create table Sells (
	EID 		    serial not null references Salesman(EID),
	CID          	serial not null references Client(CID),
	VIN              VINType not null references UsedCar(VIN),
	commission 		numeric(8,2) not null check (commission>0),
	date   			date not null,
	price          numeric(8,2) not null check (price>0),
	primary key(EID,CID,VIN)
	
);

create table Buys (
	EID 		    serial not null references Salesman(EID),
	CID          	serial not null references Client(CID),
	VIN              VINType not null references UsedCar(VIN),
	commission 		numeric(8,2) not null check (commission>0),
	date   			date not null,
	price          numeric(8,2) not null check (price>0),
	primary key(EID,CID,VIN)
	
);








































