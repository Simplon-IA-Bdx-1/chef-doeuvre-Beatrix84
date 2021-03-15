CREATE TABLE `Patient` (
	`Patient_id` varchar(50) NOT NULL,
	`Gender` varchar(1) NOT NULL,
	`Birthday` DATE NOT NULL,
	`Doctor_id` INT NOT NULL,
	PRIMARY KEY (`Patient_id`)
);

CREATE TABLE `Brain_scanner` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Patient_id` varchar(50) NOT NULL,
	`Image_path` varchar(255) NOT NULL,
	`Date` DATE NOT NULL,
	`Group` varchar(5) NOT NULL,
	PRIMARY KEY (`Id`)
);

CREATE TABLE `Patient_data_train` (
	`Image_data_id` varchar(50) NOT NULL,
	`Group` varchar(25) NOT NULL,
	`Sex` varchar(1) NOT NULL,
	`Age` INT NOT NULL,
	`Image_path` varchar(255) NOT NULL,
	PRIMARY KEY (`Image_data_id`)
);

CREATE TABLE `Patient_data_test` (
	`Image_data_id` varchar(50) NOT NULL,
	`Group` varchar(25) NOT NULL,
	`Sex` varchar(1) NOT NULL,
	`Age` INT NOT NULL,
	`Image_path` varchar(255) NOT NULL,
	PRIMARY KEY (`Image_data_id`)
);

CREATE TABLE `Models_list` (
	`Model_name` varchar(255) NOT NULL,
	`Accuracy` FLOAT NOT NULL,
	`Precision` FLOAT NOT NULL,
	`Recall` FLOAT NOT NULL,
	`f1-score` FLOAT NOT NULL,
	`Nb_data` INT NOT NULL,
	`Description` varchar(255) NOT NULL,
	PRIMARY KEY (`Model_name`)
);

CREATE TABLE `Doctor` (
	`Doctor_id` INT NOT NULL AUTO_INCREMENT,
	`Firstname` varchar(255) NOT NULL,
	`Lastname` varchar(255) NOT NULL,
	PRIMARY KEY (`Doctor_id`)
);

ALTER TABLE `Patient` ADD CONSTRAINT `Patient_fk0` FOREIGN KEY (`Doctor_id`) REFERENCES `Doctor`(`Doctor_id`);

ALTER TABLE `Brain_scanner` ADD CONSTRAINT `Brain_scanner_fk0` FOREIGN KEY (`Patient_id`) REFERENCES `Patient`(`Patient_id`);

