CREATE DEFINER=`muller851u_appli`@`%` TRIGGER `muller851u_bd_colis`.`VerificationsAvantInsLivre` 
BEFORE INSERT ON `livre` FOR EACH ROW
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
END