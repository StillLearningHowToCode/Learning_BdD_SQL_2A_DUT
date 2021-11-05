CREATE DEFINER = CURRENT_USER TRIGGER `muller851u_bd_resto`.`VerifSoldeAvantInsAchat` 
BEFORE INSERT ON `achat` 
FOR EACH ROW
BEGIN
	DECLARE p decimal(4,2);
    DECLARE s decimal(5,2);
    
    SELECT prix, solde INTO p, s
    FROM ticket ti, tarif ta, usager u
    WHERE ti.num_ticket = NEW.num_ticket
    AND ta.num_prest = NEW.num_prest
    AND ti.num_carte = u.num_carte
    AND ta.num_categ = u.num_categ;
    
    IF NEW.nb_prest*p
END
