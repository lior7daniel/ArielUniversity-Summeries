DROP DATABASE IF EXISTS AirportsDB;

CREATE DATABASE IF NOT EXISTS AirportsDB;

USE AirportsDB;

CREATE TABLE `airports` (
  `a_id` varchar(45) NOT NULL,
  `country` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`a_id`),
  KEY `city` (`city`,`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `flights` (
  `flight_no` int(11) NOT NULL,
  `dep_loc` varchar(45) DEFAULT NULL,
  `dep_date` date DEFAULT NULL,
  `dep_time` time DEFAULT NULL,
  `arr_loc` varchar(45) DEFAULT NULL,
  `arr_time` time DEFAULT NULL,
  `arr_date` date DEFAULT NULL,
  `tail_no` int(11) DEFAULT NULL,
  PRIMARY KEY (`flight_no`),
  KEY `arr_loc_idx` (`arr_loc`),
  CONSTRAINT `arr_loc` FOREIGN KEY (`arr_loc`) REFERENCES `airports` (`a_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `planes` (
  `tail_no` int(11) NOT NULL,
  `make` varchar(45) DEFAULT NULL,
  `model` varchar(45) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `mph` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`tail_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `passengers` (
  `p_id` int(11) NOT NULL,
  `f_name` varchar(45) DEFAULT NULL,
  `l_name` varchar(45) DEFAULT NULL,
  `gender` enum('M','F') DEFAULT NULL,
  `birth_year` int(11) DEFAULT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `onboard` (
  `p_id` int(11) NOT NULL,
  `flight_no` int(11) NOT NULL,
  `seat` int(11) DEFAULT NULL,
  PRIMARY KEY (`p_id`,`flight_no`),
  CONSTRAINT `p_id` FOREIGN KEY (`p_id`) REFERENCES `passengers` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into airports value ("Schiphol", "Netherland", "Amsterdam");
insert into airports value ("Pafos", "Cyprus", "Paphos");
insert into airports value ("Larnaca", "Cyprus", "Larnaca");
insert into airports value ("Bucharest", "Romania", "Bucharest");
insert into airports value ("Vienna", "Austria", "Vienna");
insert into airports value ("Mykonos", "Greece", "Mykonos");
insert into airports value ("Rhodes", "Greece", "Rhodes");
insert into airports value ("Santorini", "Greece", "Santorini");
insert into airports value ("London City", "United Kingdom", "London");
insert into airports value ("Manchester", "United Kingdom", "Manchester");
insert into airports value ("Stockholm Arlanda", "Sweden", "Stockholm");
insert into airports value ("Václav Havel", "Czechia", "Prague");
insert into airports value ("Sheremetyevo", "Russia", "Moscow");
insert into airports value ("El Prat", "Spain", "Barcelona");
insert into airports value ("Madrid-Barajas", "Spain", "Madrid");
insert into airports value ("Suvarnabhumi", "Thailand", "Bangkok");
insert into airports value ("Sao-Paulo - Guarulhos", "Brazil", "Sao Paulo");
insert into airports value ("Cancun", "Mexico", "Cancun");
insert into airports value ("Ereiza", "Argentina", "Buenos Aires");
insert into airports value ("El-Dorado", "Colombia", "Bogota");
insert into airports value ("Ramon", "Israel", "Eilat");
insert into airports value ("Ben-Gurion", "Israel", "Tel-Aviv");


insert into flights value (101, "Ben-Gurion", "2019/08/18", "01:00:00", "Cancun", "20:00:00", "2019/08/18", 701);
insert into flights value (102, "Ben-Gurion", "2019/08/18", "01:00:00", "Ramon", "02:00:00", "2019/08/18", 702);
insert into flights value (103, "Ben-Gurion", "2019/08/18", "01:00:00", "Schiphol", "05:00:00", "2019/08/18", 703);
insert into flights value (104, "Ben-Gurion", "2019/08/18", "01:00:00", "Pafos", "03:00:00", "2019/08/18", 704);
insert into flights value (105, "Ben-Gurion", "2019/08/18", "01:00:00", "Santorini", "03:00:00", "2019/08/18", 705);
insert into flights value (106, "Ben-Gurion", "2019/08/18", "01:00:00", "Rhodes", "03:00:00", "2019/08/18", 706);
insert into flights value (107, "Ben-Gurion", "2019/08/18", "01:00:00", "Mykonos", "03:00:00", "2019/08/18", 707);
insert into flights value (108, "Ben-Gurion", "2019/08/18", "01:00:00", "Vienna", "05:00:00", "2019/08/18", 708);
insert into flights value (109, "Ben-Gurion", "2019/08/18", "01:00:00", "Bucharest", "05:00:00", "2019/08/18", 709);
insert into flights value (110, "Ben-Gurion", "2019/08/18", "01:00:00", "London City", "05:00:00", "2019/08/18", 710);
insert into flights value (111, "Ben-Gurion", "2019/08/18", "01:00:00", "Manchester", "05:00:00", "2019/08/18", 711);
insert into flights value (112, "Ben-Gurion", "2019/08/18", "01:00:00", "Stockholm Arlanda", "06:00:00", "2019/08/18", 712);
insert into flights value (113, "Ben-Gurion", "2019/08/18", "01:00:00", "Václav Havel", "07:00:00", "2019/08/18", 713);
insert into flights value (114, "Ben-Gurion", "2019/08/18", "01:00:00", "Sheremetyevo", "08:00:00", "2019/08/18", 714);
insert into flights value (115, "Ben-Gurion", "2019/08/18", "01:00:00", "El Prat", "05:00:00", "2019/08/18", 715);
insert into flights value (116, "Ben-Gurion", "2019/08/18", "01:00:00", "Madrid-Barajas", "05:00:00", "2019/08/18", 716);
insert into flights value (117, "Ben-Gurion", "2019/08/18", "01:00:00", "Suvarnabhumi", "05:00:00", "2019/08/18", 717);
insert into flights value (119, "Ben-Gurion", "2019/08/18", "01:00:00", "Ereiza", "20:00:00", "2019/08/18", 719);


insert into planes value (703, "make3", "Boing", 100, "300");
insert into planes value (705, "make3", "Boing", 100, "300");
insert into planes value (706, "make3", "Boing", 100, "300");
insert into planes value (707, "make3", "Boing", 100, "300");
insert into planes value (708, "make3", "Boing", 100, "300");
insert into planes value (709, "make3", "Boing", 100, "300");
insert into planes value (710, "make3", "Boing", 100, "300");
insert into planes value (711, "make3", "Boing", 100, "300");
insert into planes value (712, "make3", "Boing", 100, "300");
insert into planes value (713, "make3", "Boing", 100, "300");
insert into planes value (714, "make3", "Boing", 100, "300");
insert into planes value (715, "make3", "Boing", 100, "300");
insert into planes value (716, "make3", "Boing", 100, "300");
insert into planes value (717, "make3", "Boing", 100, "300");
insert into planes value (718, "make3", "Boing", 100, "300");
insert into planes value (719, "make3", "Boing", 100, "300");
insert into planes value (720, "make3", "Boing", 100, "300");
insert into planes value (721, "make3", "Boing", 100, "300");
insert into planes value (722, "make3", "Boing", 100, "300");
insert into planes value (723, "make3", "Boing", 100, "300");
insert into planes value (724, "make3", "Boing", 100, "300");
insert into planes value (725, "make3", "Boing", 100, "300");
insert into planes value (726, "make3", "Boing", 100, "300");
insert into planes value (727, "make3", "Boing", 100, "300");
insert into planes value (728, "make3", "Boing", 100, "300");
insert into planes value (729, "make3", "Boing", 100, "300");
insert into planes value (730, "make3", "Boing", 100, "300");
insert into planes value (731, "make3", "Boing", 100, "300");
insert into planes value (732, "make3", "Boing", 100, "300");
insert into planes value (733, "make3", "Boing", 100, "300");
insert into planes value (734, "make3", "Boing", 100, "300");
insert into planes value (735, "make3", "Boing", 100, "300");
insert into planes value (736, "make3", "Boing", 100, "300");
insert into planes value (737, "make3", "Boing", 100, "300");
insert into planes value (738, "make3", "Boing", 100, "300");
insert into planes value (739, "make3", "Boing", 100, "300");
insert into planes value (740, "make3", "Boing", 100, "300");
insert into planes value (741, "make3", "Boing", 100, "300");
insert into planes value (742, "make3", "Boing", 100, "300");
insert into planes value (743, "make3", "Boing", 100, "300");
insert into planes value (744, "make3", "Boing", 100, "300");
insert into planes value (745, "make3", "Boing", 100, "300");
insert into planes value (746, "make3", "Boing", 100, "300");
insert into planes value (747, "make3", "Boing", 100, "300");
insert into planes value (748, "make3", "Boing", 100, "300");
insert into planes value (749, "make3", "Boing", 100, "300");
insert into planes value (750, "make3", "Boing", 100, "300");
insert into planes value (761, "make3", "Boing", 100, "300");
insert into planes value (762, "make3", "Boing", 100, "300");
insert into planes value (763, "make3", "Boing", 100, "300");
insert into planes value (764, "make3", "Boing", 100, "300");
insert into planes value (765, "make3", "Boing", 100, "300");
insert into planes value (766, "make3", "Boing", 100, "300");
insert into planes value (767, "make3", "Boing", 100, "300");
insert into planes value (768, "make3", "Boing", 100, "300");
insert into planes value (769, "make3", "Boing", 100, "300");
insert into planes value (770, "make3", "Boing", 100, "300");
insert into planes value (771, "make3", "Boing", 100, "300");
insert into planes value (772, "make3", "Boing", 100, "300");
insert into planes value (773, "make3", "Boing", 100, "300");
insert into planes value (774, "make3", "Boing", 100, "300");
insert into planes value (775, "make3", "Boing", 100, "300");
insert into planes value (776, "make3", "Boing", 100, "300");
insert into planes value (777, "make3", "Boing", 100, "300");
insert into planes value (778, "make3", "Boing", 100, "300");
insert into planes value (779, "make3", "Boing", 100, "300");
insert into planes value (780, "make3", "Boing", 100, "300");

insert into passengers value (1, "Lior", "Daniel", "M","1990");
insert into passengers value (2, "Saggi", "Bashsari", "M","1990");
insert into passengers value (3, "Neri", "Madar", "M","1990");
insert into passengers value (4, "Nave", "Hason", "M","1991");
insert into passengers value (5, "Omri", "Naor", "M","1992");
insert into passengers value (6, "Amir", "Adar", "M","1992");
insert into passengers value (7, "Ben", "Windman", "M","1991");
insert into passengers value (8, "Noam", "Ashkenazi", "M","1991");
insert into passengers value (9, "Avraham", "Mangisto", "M","1991");
insert into passengers value (10, "Barak", "Edward", "M","1991");

insert into onboard values (1, 101, 12);
insert into onboard values (2, 101, 13);
insert into onboard values (3, 101, 14);
insert into onboard values (4, 101, 14);
insert into onboard values (5, 101, 14);


DROP PROCEDURE IF exists lastYearFlights;
DELIMITER $$
CREATE PROCEDURE lastYearFlights (IN sp_p_id INT, OUT num INT)
	BEGIN
		SELECT COUNT(DISTINCT country)
        INTO num
		FROM onboard o JOIN flights f ON o.flight_no = f.flight_no 
		JOIN airports a ON f.arr_loc = a.a_id
		WHERE arr_date >= DATE_SUB(NOW(), INTERVAL 1 YEAR) AND p_id = sp_p_id;
        select num;
	END
$$ DELIMITER ;


DROP TRIGGER if exists isFull;
DELIMITER //
CREATE TRIGGER isFull 
BEFORE INSERT ON onboard
FOR EACH ROW
	BEGIN
		IF
			(SELECT COUNT(flight_no) FROM onboard WHERE flight_no = new.flight_no)
			>=
			(SELECT capacity FROM flights f JOIN planes p ON f.tail_no = p.tail_no WHERE f.flight_no = new.flight_no)
        THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The flight is FULL !';
		END IF;
	END //
DELIMITER ;