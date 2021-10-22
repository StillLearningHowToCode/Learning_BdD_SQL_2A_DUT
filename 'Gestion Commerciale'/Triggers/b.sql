CREATE DEFINER=`muller851u_appli`@`%` TRIGGER `muller851u_bd_colis`.`VerifierDateAvantInsColis` 
BEFORE INSERT ON `colis` 
FOR EACH ROW
IF (NEW.date_colis > CURRENT_DATE) OR (NEW.date_colis < (SELECT date_com FROM commande WHERE no_com = NEW.no_com)) 
THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT ="date erronee";
END IF