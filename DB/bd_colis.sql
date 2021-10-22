-- Cr�ation des tables
CREATE TABLE client(
        mat_cl 	VARCHAR (10) NOT NULL ,
        nom_cl 	VARCHAR (20) NOT NULL ,
        ad_cli 	VARCHAR (40) NOT NULL ,
        PRIMARY KEY (mat_cl)
);

CREATE TABLE commande(
        no_com   VARCHAR (10) NOT NULL ,
        date_com DATE NOT NULL ,
        mat_cl   VARCHAR (10) NOT NULL ,
        PRIMARY KEY (no_com) ,
	FOREIGN KEY (mat_cl) REFERENCES client(mat_cl)
);

CREATE TABLE produit(
        code_prod VARCHAR (10) NOT NULL ,
        nom_prod VARCHAR (40) NOT NULL ,
        prix_unit DECIMAL (6,2) NOT NULL ,
        qte_stock INT NOT NULL CHECK(qte_stock>=0),
        PRIMARY KEY (code_prod)
);

CREATE TABLE ligne_com(    
        no_com    VARCHAR (10) NOT NULL ,
        code_prod VARCHAR (10) NOT NULL ,
 	qte_cdee  INT NOT NULL ,
        PRIMARY KEY (no_com, code_prod) ,
	FOREIGN KEY (no_com) REFERENCES commande(no_com) ,
	FOREIGN KEY (code_prod) REFERENCES produit(code_prod)
);

CREATE TABLE colis(
        no_colis   VARCHAR (10) NOT NULL ,
	no_com     VARCHAR (10) NOT NULL ,
        date_colis DATE NOT NULL ,
        PRIMARY KEY (no_colis),
	FOREIGN KEY (no_com) REFERENCES commande(no_com)
);

CREATE TABLE livre(     
        no_colis  	VARCHAR (10) NOT NULL ,
        code_prod 	VARCHAR (10) NOT NULL ,
	qte_liv   	INT ,
        PRIMARY KEY (no_colis, code_prod) ,
	FOREIGN KEY (no_colis) REFERENCES colis(no_colis) ,
	FOREIGN KEY (code_prod) REFERENCES produit(code_prod) 
);

-- Insertion des donn�es
INSERT INTO client VALUES
('CL1', 'Pierre', 'Metz'),
('CL2', 'Paul', 'Strasbourg'),
('CL3', 'Durand', 'Metz');

INSERT INTO commande VALUES
('C1', '2021-09-01', 'CL1'),
('C2', '2021-09-23', 'CL1'),
('C3', '2021-09-23', 'CL2'),
('C4', '2021-09-25', 'CL3');

INSERT INTO produit VALUES
('P1', 'crayon', 1.20, 4),
('P2', 'cahier', 2.30, 10),
('P3', 'gomme', 0.70, 150),
('P4', 'agrafeuse', 17.90, 6);

INSERT INTO ligne_com VALUES
('C1', 'P1', 5),
('C1', 'P2', 2),
('C2', 'P2', 1),
('C3', 'P1', 10),
('C3', 'P2', 3),
('C3', 'P3', 1),
('C3', 'P4', 1),
('C4', 'P4', 1);

INSERT INTO colis VALUES
('Co1', 'C1', '2021-09-03'),
('Co2', 'C1', '2021-09-10'),
('Co3', 'C2', '2021-09-30');

INSERT INTO livre VALUES
('Co1', 'P1', 2),
('Co1', 'P2', 2),
('Co2', 'P1', 2),
('Co3', 'P2', 1);

COMMIT;