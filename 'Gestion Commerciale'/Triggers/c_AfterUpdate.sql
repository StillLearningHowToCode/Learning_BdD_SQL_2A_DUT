CREATE DEFINER = CURRENT_USER TRIGGER `muller851u_bd_colis`.`MAJStockApresModifLivraison` 
AFTER UPDATE ON `livre` FOR EACH ROW
BEGIN
	UPDATE produit
	SET qte_stock = qte_stock - NEW.qte_liv + OLD.qte_liv
	WHERE code_prod = NEW.code_prod;
END