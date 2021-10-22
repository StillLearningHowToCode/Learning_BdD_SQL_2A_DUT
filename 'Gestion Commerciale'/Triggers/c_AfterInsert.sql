CREATE DEFINER=`muller851u_appli`@`%` TRIGGER `muller851u_bd_colis`.`MAJStockApresInsLivraison` 
AFTER INSERT ON `livre` FOR EACH ROW
BEGIN
	UPDATE produit
	SET qte_stock = qte_stock - NEW.qte_liv
	WHERE code_prod = NEW.code_prod;
END