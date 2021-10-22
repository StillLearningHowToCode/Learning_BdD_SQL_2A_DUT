CREATE DEFINER=`muller851u_appli`@`%` TRIGGER `muller851u_bd_colis`.`VerifierDateAvantInsCommande` 
BEFORE INSERT ON `commande` 
FOR EACH ROW IF (NEW.date_com>current_date) 
	THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT ="date erronée";
END IF