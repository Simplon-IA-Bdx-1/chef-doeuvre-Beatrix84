CREATE TABLE `Patients` (
	`Id_patient` varchar(50) NOT NULL,
	`Sex` varchar(1) NOT NULL,
	`Date_de_naissance` DATE NOT NULL,
	`Id_docteur` INT NOT NULL,
	PRIMARY KEY (`Id_patient`)
);

CREATE TABLE `Scanner_cerebral` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Id_patient` varchar(50) NOT NULL,
	`Image` varchar(255) NOT NULL,
	`Date` DATE NOT NULL,
	`Groupe` varchar(5) NOT NULL,
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

CREATE TABLE `Docteurs` (
	`Id_docteur` INT NOT NULL AUTO_INCREMENT,
	`Prenom` varchar(255) NOT NULL,
	`Nom` varchar(255) NOT NULL,
	PRIMARY KEY (`Id_docteur`)
);

ALTER TABLE `Patients` ADD CONSTRAINT `Patients_fk0` FOREIGN KEY (`Id_docteur`) REFERENCES `Docteurs`(`Id_docteur`);

ALTER TABLE `Scanner_cerebral` ADD CONSTRAINT `Scanner_cerebral_fk0` FOREIGN KEY (`Id_patient`) REFERENCES `Patients`(`Id_patient`);

