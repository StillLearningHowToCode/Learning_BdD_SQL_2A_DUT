CREATE TABLE IF NOT EXISTS achat (
  num_ticket varchar(5) NOT NULL,
  num_prest int(11) NOT NULL,
  nb_prest int(11) NOT NULL,
  PRIMARY KEY (num_ticket,num_prest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO achat (num_ticket, num_prest, nb_prest) VALUES
('TI1', 1, 1),
('TI10', 1, 1),
('TI10', 4, 3),
('TI11', 1, 1),
('TI11', 4, 1),
('TI12', 1, 1),
('TI12', 4, 3),
('TI12', 5, 2),
('TI13', 1, 1),
('TI13', 2, 2),
('TI14', 2, 1),
('TI2', 1, 1),
('TI2', 4, 1),
('TI3', 1, 1),
('TI3', 5, 2),
('TI4', 1, 1),
('TI4', 4, 1),
('TI5', 2, 1),
('TI6', 1, 1),
('TI7', 1, 1),
('TI8', 1, 1),
('TI9', 5, 3);

CREATE TABLE IF NOT EXISTS categorie (
  num_categ varchar(2) NOT NULL,
  lib_categ varchar(20) NOT NULL,
  PRIMARY KEY (num_categ)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO categorie (num_categ, lib_categ) VALUES
('T1', 'petits revenus'),
('T2', 'gros revenus'),
('T3', 'revenus moyens');

CREATE TABLE IF NOT EXISTS depot (
  num_carte varchar(3) NOT NULL,
  date_depot date NOT NULL,
  montant int(11) NOT NULL,
  PRIMARY KEY (num_carte,date_depot)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO depot (num_carte, date_depot, montant) VALUES
('C1', '2018-04-22', 10),
('C1', '2018-05-24', 10),
('C1', '2019-10-01', 15),
('C1', '2020-03-03', 30),
('C2', '2018-05-24', 15),
('C2', '2019-10-01', 10),
('C3', '2019-06-22', 20),
('C4', '2019-10-01', 20),
('C5', '2020-02-02', 20),
('C5', '2020-03-02', 10),
('C5', '2020-05-02', 15),
('C6', '2021-04-01', 20);

CREATE TABLE IF NOT EXISTS prestation (
  num_prest int(11) NOT NULL,
  type_prest varchar(25) NOT NULL,
  PRIMARY KEY (num_prest)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO prestation (num_prest, type_prest) VALUES
(1, 'repas normal'),
(2, 'quart de vin rouge'),
(3, 'bière'),
(4, 'supplément frites'),
(5, 'supplément Chantilly'),
(6, 'macaron');

CREATE TABLE IF NOT EXISTS tarif (
  num_prest int(11) NOT NULL,
  num_categ varchar(2) NOT NULL,
  prix decimal(4,2) NOT NULL,
  PRIMARY KEY (num_prest,num_categ)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO tarif (num_prest, num_categ, prix) VALUES
(1, 'T1', 4.00),
(1, 'T2', 5.00),
(2, 'T1', 1.00),
(2, 'T2', 1.00),
(3, 'T1', 1.00),
(3, 'T2', 1.00),
(4, 'T1', 0.50),
(4, 'T2', 0.60),
(5, 'T1', 0.50),
(5, 'T2', 0.60);

CREATE TABLE IF NOT EXISTS ticket (
  num_ticket varchar(5) NOT NULL,
  num_carte varchar(3) NOT NULL,
  date_achat date NOT NULL,
  PRIMARY KEY (num_ticket)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO ticket (num_ticket, num_carte, date_achat) VALUES
('TI1', 'C1', '2018-04-22'),
('TI2', 'C1', '2018-04-24'),
('TI3', 'C2', '2018-05-24'),
('TI4', 'C1', '2018-05-26'),
('TI5', 'C1', '2018-05-26'),
('TI6', 'C3', '2019-06-22'),
('TI7', 'C4', '2019-10-02'),
('TI8', 'C2', '2019-10-02'),
('TI9', 'C2', '2019-10-02'),
('TI10', 'C5', '2020-02-02'),
('TI11', 'C1', '2020-03-02'),
('TI12', 'C5', '2020-03-04'),
('TI13', 'C6', '2021-04-01'),
('TI14', 'C6', '2021-04-01');


CREATE TABLE IF NOT EXISTS usager (
  num_carte varchar(3) NOT NULL,
  nom varchar(20) NOT NULL,
  num_categ varchar(2) NOT NULL,
  mt_caution int(11) NOT NULL,
  date_carte date NOT NULL,
  solde decimal(5,2) DEFAULT 0.00 CHECK(solde >=0),
  PRIMARY KEY (num_carte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO usager (num_carte, nom, num_categ, mt_caution, date_carte, solde) VALUES
('C1', 'Pierre L.', 'T2', 5, '2018-04-19', 42.20),
('C2', 'Zsuzsanna R.', 'T1', 5, '2018-05-20', 14.50),
('C3', 'Michel A.', 'T2', 6, '2019-06-22', 15.00),
('C4', 'Nathalie B.', 'T1', 6, '2019-09-30', 16.00),
('C5', 'Nicolas G.', 'T2', 6, '2020-01-31', 30.20),
('C6', 'Bernard H.', 'T2', 7, '2021-04-01', 12.00);

--
-- Contraintes pour la table achat
--
ALTER TABLE achat
  ADD CONSTRAINT achat_ibfk_1 FOREIGN KEY (num_ticket) REFERENCES ticket (num_ticket) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT achat_ibfk_2 FOREIGN KEY (num_prest) REFERENCES prestation (num_prest) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table depot
--
ALTER TABLE depot
  ADD CONSTRAINT depot_ibfk_1 FOREIGN KEY (num_carte) REFERENCES usager (num_carte) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table tarif
--
ALTER TABLE tarif
  ADD CONSTRAINT tarif_ibfk_1 FOREIGN KEY (num_prest) REFERENCES prestation (num_prest) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT tarif_ibfk_2 FOREIGN KEY (num_categ) REFERENCES categorie (num_categ) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table ticket
--
ALTER TABLE ticket
  ADD CONSTRAINT ticket_ibfk_1 FOREIGN KEY (num_carte) REFERENCES usager (num_carte) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table usager
--
ALTER TABLE usager
  ADD CONSTRAINT usager_ibfk_1 FOREIGN KEY (num_categ) REFERENCES categorie (num_categ) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Validation des opérations
COMMIT;