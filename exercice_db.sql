DROP TABLE IF EXISTS Commentaires, Emprunts, Livre, Utilisateurs;

CREATE TABLE Utilisateurs (
    id_utilisateur INT PRIMARY KEY,
    nom VARCHAR(100),
    email VARCHAR(100),
    role ENUM('lecteur', 'bibliothecaire', 'admin')
);

CREATE TABLE Livre (
    id_livre INT PRIMARY KEY,
    titre VARCHAR(150),
    auteur VARCHAR(100),
    categorie VARCHAR(50),
    disponible BOOLEAN
);

CREATE TABLE Emprunts (
    id_emprunts INT PRIMARY KEY,
    id_utilisateur INT,
    id_livre INT,
    date_emprunt DATE,
    date_retour_prevue DATE,
    date_retour_reelle DATE,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateurs(id_utilisateur),
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre)
);

CREATE TABLE Commentaires (
    id_commentaire INT PRIMARY KEY,
    id_utilisateur INT,
    id_livre INT,
    texte TEXT,
    note INT,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateurs(id_utilisateur),
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre)
);


INSERT INTO Utilisateurs VALUES
(1, 'Alice Martin', 'alice.martin@mail.com', 'lecteur'),
(2, 'John Doe', 'john.doe@mail.com', 'bibliothecaire'),
(3, 'Sarah Lopez', 'sarah.lopez@mail.com', 'lecteur'),
(4, 'Marc Dupont', 'marc.dupont@mail.com', 'admin'),
(5, 'Emma Bernard', 'emma.bernard@mail.com', 'bibliothecaire'),
(6, 'Thomas Durand', 'thomas.durand@mail.com', 'lecteur');

INSERT INTO Livre VALUES
(1, "L'Étranger", 'Albert Camus', 'Roman', TRUE),
(2, '1984', 'George Orwell', 'Science-fiction', FALSE),
(3, 'Le Petit Prince', 'Antoine de Saint-Ex.', 'Conte', TRUE),
(4, 'Dune', 'Frank Herbert', 'Science-fiction', FALSE),
(5, 'Les Misérables', 'Victor Hugo', 'Classique', TRUE),
(6, 'Sapiens', 'Yuval Noah Harari', 'Histoire', TRUE);

INSERT INTO Emprunts VALUES
(1, 1, 2, '2024-06-01', '2024-06-15', NULL),
(2, 3, 4, '2024-06-20', '2024-07-05', '2024-07-03'),
(3, 6, 2, '2024-05-10', '2024-05-25', '2024-05-24'),
(4, 1, 4, '2024-07-01', '2024-07-15', NULL);

INSERT INTO Commentaires VALUES
(1, 1, 2, 'Un classique à lire absolument', 5),
(2, 3, 4, 'Très dense, mais fascinant', 4),
(3, 6, 2, 'Excellent, mais un peu long', 4),
(4, 1, 4, 'Très bon roman de SF', 5),
(5, 3, 1, 'Lecture facile et intéressante', 3);

-- requetes 
SELECT * FROM Livre WHERE disponible = TRUE;

SELECT * FROM Utilisateurs WHERE role = 'bibliothecaire';

SELECT * FROM Emprunts
WHERE date_retour_reelle IS NULL AND date_retour_prevue < CURRENT_DATE;

SELECT COUNT(*) AS total_emprunts FROM Emprunts;

SELECT c.texte, c.note, u.nom AS utilisateur, l.titre AS livre
FROM Commentaires c
JOIN Utilisateurs u ON c.id_utilisateur = u.id_utilisateur
JOIN Livre l ON c.id_livre = l.id_livre
ORDER BY c.id_commentaire DESC
LIMIT 5;


SELECT u.nom, COUNT(e.id_emprunts) AS nb_emprunts
FROM Utilisateurs u
LEFT JOIN Emprunts e ON u.id_utilisateur = e.id_utilisateur
GROUP BY u.id_utilisateur;

SELECT * FROM Livre
WHERE id_livre NOT IN (SELECT DISTINCT id_livre FROM Emprunts);

SELECT l.titre, AVG(DATEDIFF(e.date_retour_reelle, e.date_emprunt)) AS duree_moyenne
FROM Livre l
JOIN Emprunts e ON l.id_livre = e.id_livre
WHERE e.date_retour_reelle IS NOT NULL
GROUP BY l.id_livre;

SELECT l.titre, AVG(c.note) AS moyenne_note
FROM Commentaires c
JOIN Livre l ON c.id_livre = l.id_livre
GROUP BY c.id_livre
ORDER BY moyenne_note DESC
LIMIT 3;

SELECT DISTINCT u.nom
FROM Utilisateurs u
JOIN Emprunts e ON u.id_utilisateur = e.id_utilisateur
JOIN Livre l ON e.id_livre = l.id_livre
WHERE l.categorie = 'Science-fiction';


UPDATE Livre
SET disponible = FALSE
WHERE id_livre IN (
    SELECT id_livre FROM Emprunts WHERE date_retour_reelle IS NULL
);

START TRANSACTION;

INSERT INTO Emprunts (id_emprunts, id_utilisateur, id_livre, date_emprunt, date_retour_prevue, date_retour_reelle)
VALUES (5, 3, 1, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), NULL);

UPDATE Livre SET disponible = FALSE WHERE id_livre = 1;

COMMIT;

DELETE FROM Commentaires
WHERE id_utilisateur IN (
  SELECT id_utilisateur FROM Utilisateurs
  WHERE id_utilisateur NOT IN (
    SELECT DISTINCT id_utilisateur FROM Emprunts
  )
);


CREATE VIEW Vue_Emprunts_Actifs AS
SELECT * FROM Emprunts
WHERE date_retour_reelle IS NULL;

DELIMITER $$

CREATE FUNCTION nb_emprunts_utilisateur(uid INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total
  FROM Emprunts
  WHERE id_utilisateur = uid;
  RETURN total;
END $$

DELIMITER ;

SELECT nb_emprunts_utilisateur(1);
