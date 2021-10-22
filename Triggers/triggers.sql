-- TD3. Contraintes et Déclencheurs
-- Exercice 1. Gestion commerciale

-- 2. Triggers
-- a) date_com <= current_date

CREATE TRIGGER VerifierDateAvantInsCommande
BEFORE INSERT ON commande
FOR EACH ROW
IF (NEW.date_com>current_date) 
	THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT ="date erronée";
END IF;

-- b) date_colis <= current_date ET date_colis >= date_com

CREATE TRIGGER VerifierDateAvantInsColis
BEFORE INSERT ON colis 
FOR EACH ROW
BEGIN
DECLARE v_date_com DATE;
SELECT 	date_com
INTO 	v_date_com
FROM 	commande
WHERE 	no_com = NEW.no_com;
IF (NEW.date_colis>CURRENT_DATE) OR (NEW.date_colis<v_date_com) 
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT ="date erronée";
END IF;
END;

-- b) autre solution (sans variable locale v_date_com)

CREATE TRIGGER VerifierDateAvantInsColis
BEFORE INSERT ON colis 
FOR EACH ROW
IF (NEW.date_colis > CURRENT_DATE) OR 
(NEW.date_colis < (SELECT date_com FROM commande WHERE no_com = NEW.no_com)) 
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT ="date erronee";
END IF;

-- c) Mise à jour du stock après livraison

CREATE TRIGGER MAJStockApresInsLivraison 
AFTER INSERT ON livre 
FOR EACH ROW
	UPDATE produit
	SET qte_stock = qte_stock - NEW.qte_liv
	WHERE code_prod = NEW.code_prod;

-- Cas avec DELETE et UPDATE de qte_liv de livre
CREATE TRIGGER MAJStockApresSuppLivraison 
AFTER DELETE ON livre 
FOR EACH ROW
	UPDATE produit
	SET qte_stock = qte_stock + OLD.qte_liv
	WHERE code_prod = OLD.code_prod;

-- Cas avec UPDATE de qte_liv de livre
CREATE TRIGGER MAJStockApresModifLivraison 
AFTER UPDATE ON livre 
FOR EACH ROW
	UPDATE produit
	SET qte_stock = qte_stock - NEW.qte_liv + OLD.qte_liv
	WHERE code_prod = NEW.code_prod;

-- d) Levée d'exception

-- Création d'un vue "prod_cde_liv" contenant pour chaque produit de chaque commande la quantitée commandée et la somme des quantités livrées (pour faciliter le traitement) 
CREATE VIEW prod_cde_liv AS
SELECT l.code_prod, l.no_com, qte_cdee, COALESCE(sum_qte_liv, 0) sum_qte_liv 
FROM ligne_com l LEFT JOIN 
(SELECT code_prod, no_com, SUM(qte_liv) sum_qte_liv FROM livre JOIN colis ON livre.no_colis=colis.no_colis GROUP BY code_prod, no_com) r 
ON l.code_prod=r.code_prod AND l.no_com=r.no_com;


CREATE TRIGGER VerificationsAvantInsLivre
BEFORE INSERT ON Livre 
FOR EACH ROW
BEGIN
	DECLARE qc, ql INTEGER;
-- d1) Une livraison ne concerne que les produits commandés
	IF NEW.code_prod NOT IN 
				(SELECT code_prod 
				FROM ligne_com l, colis c 
				WHERE l.no_com=c.no_com AND c.no_colis=NEW.no_colis)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT ="livraison d'un produit non commandé";
	END IF;
-- d2) qte_liv <= qte_stock
	IF NEW.qte_liv > (SELECT qte_stock FROM produit WHERE code_prod=NEW.code_prod)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT ="qte_liv > qte_stok";
	END IF;
-- d3) somme qte_liv (nouvelle + anciennes) <= qte_cdee
	SELECT qte_cdee, sum_qte_liv INTO qc, ql FROM prod_cde_liv 
	WHERE code_prod=NEW.code_prod AND no_com IN (SELECT no_com FROM colis WHERE no_colis=NEW.no_colis);
	IF NEW.qte_liv + ql > qc 
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT ="somme qte_liv > qte_cdee";
	END IF;
END;

