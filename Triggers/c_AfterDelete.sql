CREATE DEFINER = CURRENT_USER TRIGGER `muller851u_bd_colis`.`MAJStockApresSuppLivraison` 
AFTER DELETE ON `livre` FOR EACH ROW
BEGIN
	UPDATE produit
	SET qte_stock = qte_stock + OLD.qte_liv
	WHERE code_prod = OLD.code_prod;
END