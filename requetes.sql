USE db_space_invaders;
 
-- GESTION DES UTILISATEURS
 
-- ADMIN
 
CREATE ROLE 'Admin';
GRANT CREATE, SELECT, UPDATE, DELETE
ON db_space_invaders.*
TO 'Admin'
WITH GRANT OPTION;
 
-- JOUEUR
 
CREATE ROLE 'Joueur';
GRANT SELECT
ON t_arme
TO 'Joueur';
 
GRANT INSERT, SELECT
ON t_commande
TO 'Joueur';
 
-- GESTIONNAIRE DE LA BOUTIQUE
 
CREATE ROLE 'gestionnaire_de_la_boutique';
GRANT SELECT
ON t_joueur
TO 'gestionnaire_de_la_boutique';
 
 
GRANT UPDATE, SELECT, DELETE
ON t_arme
TO 'gestionnaire_de_la_boutique';
 
GRANT SELECT
ON t_commande
TO 'gestionnaire_de_la_boutique';
 
-- Création des utilisateurs et attribution des rôles
 
-- 1. Admin du jeu
CREATE USER 'admin'@'%' IDENTIFIED BY 'smjGd2z8ah7hf5aw';
GRANT 'Admin' TO 'admin'@'%';
SET DEFAULT ROLE 'Admin' TO 'admin'@'%';
 
-- 2. Joueur
CREATE USER 'joueur'@'%' IDENTIFIED BY 'jGd2z8ahadsafg7ff5aw';
GRANT 'Joueur' TO 'joueur'@'%';
SET DEFAULT ROLE 'Joueur' TO 'joueur'@'%';
 
-- 3. Gestionnaire de la boutique
CREATE USER 'gestionnaire_boutique'@'%' IDENTIFIED BY 'g7ds9fsz8ah7hf5aw8dfsf';
GRANT 'gestionnaire_de_la_boutique' TO 'gestionnaire_boutique'@'%';
SET DEFAULT ROLE 'gestionnaire_de_la_boutique' TO 'boutique'@'%';

-- Requête n°1 :
SELECT * FROM `t_joueur` ORDER BY `jouNombrePoints` DESC LIMIT 5;

-- Requête n°2 :
SELECT MAX(`armPrix`) AS PrixMaximum, AVG(`armPrix`) AS prixMoyen, MIN(`armPrix`) AS PrixMinimum FROM `t_arme`;

-- Requête n°3 :
SELECT DISTINCT `fkJoueur` AS "idJoueur", COUNT(idCommande) AS "NombreCommandes" 
FROM t_commande 
JOIN t_joueur ON t_joueur.idJoueur = t_commande.fkJoueur 
GROUP BY fkJoueur 
ORDER BY NombreCommandes DESC;

-- Requête n°4 :
SELECT DISTINCT `fkJoueur` AS "idJoueur", COUNT(idCommande) AS "NombreCommandes" 
FROM t_commande 
GROUP BY fkJoueur 
HAVING COUNT(idCommande) > 2;

-- Requête n°5 :
 SELECT DISTINCT jouPseudo, armNom /*, comNumeroCommande*/
FROM t_detail_commande 
    JOIN t_joueur 
        ON t_detail_commande.fkCommande = t_joueur.idJoueur 
    JOIN t_arme 
        ON t_detail_commande.fkArme = t_arme.idArme
     JOIN t_commande                                    /*jointure manquante*/
        ON t_commande.fkJoueur = t_joueur.idJoueur ;    

-- Requête n°6 :
SELECT idJoueur, SUM(detQuantiteCommande * armPrix) AS "TotalDepense" 
FROM t_detail_commande 
JOIN t_commande ON t_detail_commande.fkCommande = t_commande.idCommande 
JOIN t_arme ON t_detail_commande.fkArme = t_arme.idArme 
JOIN t_joueur ON t_commande.fkJoueur = t_joueur.idJoueur 
GROUP BY idJoueur 
ORDER BY TotalDepense DESC LIMIT 10;

-- Requête n°7 :
SELECT jouPseudo, idCommande 
FROM `t_commande` 
RIGHT JOIN t_joueur ON t_commande.fkJoueur = t_joueur.idJoueur;

-- Requête n°8 :
SELECT idCommande, jouPseudo 
FROM `t_joueur` 
RIGHT JOIN t_commande ON t_commande.fkJoueur = t_joueur.idJoueur;

-- Requête n°9 :
SELECT jouPseudo AS Joueur, SUM(detQuantiteCommande) AS TotalQuantite 
FROM t_joueur 
LEFT JOIN t_commande ON t_joueur.idJoueur = t_commande.fkJoueur 
LEFT JOIN t_detail_commande ON t_commande.idCommande = t_detail_commande.fkCommande 
WHERE jouPseudo IS NOT NULL 
GROUP BY jouPseudo 
ORDER BY TotalQuantite DESC;

-- Requête n°10 :
SELECT idJoueur, jouPseudo, COUNT(DISTINCT fkArme) AS NombreCommandes 
FROM t_joueur 
JOIN t_commande ON idJoueur = t_commande.fkJoueur 
JOIN t_detail_commande ON t_commande.idCommande = t_detail_commande.fkCommande 
GROUP BY jouPseudo 
HAVING COUNT(DISTINCT fkArme) > 3;