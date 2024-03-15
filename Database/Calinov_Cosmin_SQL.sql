-- artist

CREATE TABLE `artist` (
  `artist_spotify_id` varchar(23) NOT NULL,
  `nume_artist` varchar(30) NOT NULL,
  `tip` enum('solo','duet','trupa') NOT NULL,
  `tara_origine` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`artist_spotify_id`),
  UNIQUE KEY `artist_spotify_id_UNIQUE` (`artist_spotify_id`)
);

-- album

CREATE TABLE `album` (
  `upc` varchar(14) NOT NULL,
  `nume_album` varchar(40) NOT NULL,
  `data_lansarii` date NOT NULL,
  `casa_discuri` varchar(40) DEFAULT NULL,
  `artist_spotify_id` varchar(23) NOT NULL,
  PRIMARY KEY (`upc`),
  UNIQUE KEY `idalbum_UNIQUE` (`upc`),
  KEY `artist_album_idx` (`artist_spotify_id`),
  CONSTRAINT `artist_album` FOREIGN KEY (`artist_spotify_id`) REFERENCES `artist` (`artist_spotify_id`) ON DELETE CASCADE ON UPDATE CASCADE
);



-- gen

CREATE TABLE `gen` (
  `id_gen` int NOT NULL,
  `nume_gen` varchar(10) NOT NULL,
  `categorie` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_gen`),
  UNIQUE KEY `id_gen_UNIQUE` (`id_gen`),
  CONSTRAINT `restr_id_gen` CHECK ((`id_gen` > 0))
);
-- melodie

CREATE TABLE `melodie` (
  `upc_album` varchar(14) NOT NULL,
  `nume_melodie` varchar(50) NOT NULL,
  `durata` int NOT NULL,
  `limba` varchar(10) DEFAULT NULL,
  `index_album` int NOT NULL,
  `id_gen` int NOT NULL,
  PRIMARY KEY (`upc_album`,`nume_melodie`),
  KEY `melodie_gen_idx` (`id_gen`),
  CONSTRAINT `melodie_album` FOREIGN KEY (`upc_album`) REFERENCES `album` (`upc`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `melodie_gen` FOREIGN KEY (`id_gen`) REFERENCES `gen` (`id_gen`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `restr_durata` CHECK ((`durata` > 0)),
  CONSTRAINT `restr_index` CHECK ((`index_album` > 0))
);
-- utilizator

CREATE TABLE `utilizator` (
  `id_utilizator` int NOT NULL,
  `nume_utilizator` varchar(25) NOT NULL,
  `parola_utilizator` varchar(30) NOT NULL,
  `email_utilizator` varchar(45) NOT NULL,
  `tip_abonament` enum('standard','premium_individual','premium_duo','premium_family','premium_student') NOT NULL,
  PRIMARY KEY (`id_utilizator`),
  UNIQUE KEY `id_utilizator_UNIQUE` (`id_utilizator`),
  UNIQUE KEY `email_utilizator_UNIQUE` (`email_utilizator`),
  CONSTRAINT `restr_email` CHECK ((`email_utilizator` like '%@%.%')),
  CONSTRAINT `restr_id_utiliz` CHECK ((`id_utilizator` > 0)),
  CONSTRAINT `restr_parola` CHECK ((length(`parola_utilizator`) >= 8))
);

-- dispozitiv

CREATE TABLE `dispozitiv` (
  `id_dispozitiv` int NOT NULL,
  `tip` enum('pc','laptop','smartphone','tableta') DEFAULT NULL,
  `marca` varchar(15) DEFAULT NULL,
  `model` varchar(20) DEFAULT NULL,
  `id_utilizator_proprietar` int NOT NULL,
  PRIMARY KEY (`id_dispozitiv`),
  UNIQUE KEY `id_dispozitiv_UNIQUE` (`id_dispozitiv`),
  KEY `dispozitiv_utilizator_idx` (`id_utilizator_proprietar`),
  CONSTRAINT `dispozitiv_utilizator` FOREIGN KEY (`id_utilizator_proprietar`) REFERENCES `utilizator` (`id_utilizator`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `restr_id_disp` CHECK ((`id_dispozitiv` > 0))
);
-- pagina_web 

CREATE TABLE `pagina_web` (
  `url_pagina` varchar(50) NOT NULL,
  `rol_pentru_licentiator` enum('sincronizare','master','fizica') DEFAULT NULL,
  `tip_pagina` enum('socializare','streaming','magazin') DEFAULT NULL,
  PRIMARY KEY (`url_pagina`),
  CONSTRAINT `URL_FMT` CHECK ((`URL_PAGINA` like '%.%'))
);

-- artist_pagina

CREATE TABLE `artist_pagina` (
  `artist_spotify_id` varchar(23) NOT NULL,
  `url_pagina` varchar(50) NOT NULL,
  `statut_de_verificare` tinyint NOT NULL,
  `monetizare` tinyint NOT NULL,
  PRIMARY KEY (`artist_spotify_id`,`url_pagina`),
  KEY `tip_pagina_pagina_web_idx` (`url_pagina`),
  CONSTRAINT `artist_tip_pagina` FOREIGN KEY (`artist_spotify_id`) REFERENCES `artist` (`artist_spotify_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tip_pagina_pagina_web` FOREIGN KEY (`url_pagina`) REFERENCES `pagina_web` (`url_pagina`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- melodie_utilizator

CREATE TABLE `melodie_utilizator` (
  `id_utilizator` int NOT NULL,
  `upc_album` varchar(14) NOT NULL,
  `nume_melodie` varchar(50) NOT NULL,
  `apreciata` tinyint DEFAULT NULL,
  `evaluare` int DEFAULT NULL,
  PRIMARY KEY (`id_utilizator`,`upc_album`,`nume_melodie`),
  KEY `melodie_utilizator_melod_idx` (`upc_album`,`nume_melodie`),
  CONSTRAINT `melodie_utilizator_melod` FOREIGN KEY (`upc_album`, `nume_melodie`) REFERENCES `melodie` (`upc_album`, `nume_melodie`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `melodie_utilizator_utiliz` FOREIGN KEY (`id_utilizator`) REFERENCES `utilizator` (`id_utilizator`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `restr_eval` CHECK ((`evaluare` between 1 and 5))
);

-- inserari

-- artist

INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('6fuALtryzj4cq7vkglKLxq', 'The Ocean', 'trupa', 'Germania');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('0ybFZ2Ab08V8hueghSXm6E', 'Opeth', 'trupa', 'Suedia');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('2hPgGN4uhvXAxiXQBIXOmE', 'KIDS SEE GHOSTS', 'duet', 'SUA');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('2YZyLoL8N0Wb9xBt1NhZWg', 'Kendrick Lamar', 'solo', 'SUA');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('13GH7wviJQ9gfZmr1pXHS4', 'Unprocessed', 'trupa', 'Germania');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('0X380XXQSNBYuleKzav5UO', 'Nine Inch Nails', 'trupa', 'SUA');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('2yEwvVSSSUkcLeSTNyHKh8', 'TOOL', 'trupa', 'SUA');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('4vGrte8FDu062Ntj0RsPiZ', 'Polyphia', 'trupa', 'SUA');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('4pejUc4iciQfgdX6OKulQn', 'Queens of the Stone Age', 'trupa', 'SUA');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('6bYFkBNvayh3nGqxcPp7Sv', 'Ulver', 'trupa', 'Norvegia');
INSERT INTO `artist` (`artist_spotify_id`, `nume_artist`, `tip`, `tara_origine`) VALUES ('74XFHRwlV6OrjEM0A2NCMF', 'Paramore', 'trupa', 'SUA');


-- album

INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('00602557276428', 'My Arms, Your Hearse', '1998-08-18', 'Candlelight Records', '0ybFZ2Ab08V8hueghSXm6E');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('00602567803911', 'KIDS SEE GHOSTS', '2018-06-08', 'UMG Recordings', '2hPgGN4uhvXAxiXQBIXOmE');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('00602547289049', 'To Pimp A Butterfly', '2015-03-16', 'Top Dawg Entertainment', '2YZyLoL8N0Wb9xBt1NhZWg');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `artist_spotify_id`) VALUES ('4099885711015', '…And Everything In Between', '2023-12-01', '13GH7wviJQ9gfZmr1pXHS4');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('00606949047320', 'The Fragile', '1999-09-21', 'Interscope Records', '0X380XXQSNBYuleKzav5UO');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('00731452212627', 'The Downward Spiral', '1994-03-08', 'UMG Recordings', '0X380XXQSNBYuleKzav5UO');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('886447824771', '10,000 Days', '2006-04-28', 'Volcano Entertainment', '2yEwvVSSSUkcLeSTNyHKh8');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('886447824764', 'Lateralus', '2001-05-15', 'Volcano Entertainment', '2yEwvVSSSUkcLeSTNyHKh8');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('4050538873566', 'Remember That You Will Die', '2022-10-28', 'Rise Records', '4vGrte8FDu062Ntj0RsPiZ');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('039841942125', 'Phanerozoic II: Mesozoic | Cenozoic', '2020-09-25', 'Metal Blade Records', '6fuALtryzj4cq7vkglKLxq');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('039841934021', 'Phanerozoic I: Palaeozoic', '2018-11-02', 'Metal Blade Records', '6fuALtryzj4cq7vkglKLxq');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('744861112556', 'Villains', '2017-08-25', 'Matador Records', '4pejUc4iciQfgdX6OKulQn');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('191401176859', 'Queens of the Stone Age', '1998-09-22', 'Matador Records', '4pejUc4iciQfgdX6OKulQn');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('0884388161528', 'The Assassination of Julius Caesar', '2017-04-07', 'House of Mythology', '6bYFkBNvayh3nGqxcPp7Sv');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('7071155273000', 'Bergtatt', '1994-02-27', 'Voices Music & Entertainment', '6bYFkBNvayh3nGqxcPp7Sv');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('075679897138', 'After Laughter', '2017-05-12', 'Atlantic Recordings Corporation', '74XFHRwlV6OrjEM0A2NCMF');
INSERT INTO `album` (`upc`, `nume_album`, `data_lansarii`, `casa_discuri`, `artist_spotify_id`) VALUES ('075679981844', 'Brand New Eyes', '2009-09-22', 'Atlantic Recordings Corporation', '74XFHRwlV6OrjEM0A2NCMF');

-- gen

INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('1', 'Metal', 'Progresiv');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('2', 'Metal', 'Death');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('3', 'Rap', 'Progresiv');
INSERT INTO `gen` (`id_gen`, `nume_gen`) VALUES ('4', 'Hip Hop');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('5', 'Rock', 'Progresiv');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('6', 'Rock', 'Indie');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('7', 'Pop', 'Indie');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('8', 'Rock', 'Industrial');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('9', 'Metal', 'Sludge');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('10', 'Metal', 'Post');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('11', 'Metal', 'Black');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('12', 'Rock', 'Stoner');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('13', 'Rock', 'Hard');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('14', 'Pop', 'Synth');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('15', 'Pop', 'Emo');
INSERT INTO `gen` (`id_gen`, `nume_gen`, `categorie`) VALUES ('16', 'Rock', 'Alternativ');


-- melodie

INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'Prologue', '59', 'ENGLEZA', '1', '2');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'April Ethereal', '521', 'ENGLEZA', '2', '2');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'When', '554', 'ENGLEZA', '3', '2');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'Madrigal', '86', 'ENGLEZA', '4', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'The Amen Corner', '523', 'ENGLEZA', '5', '2');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'Demon Of The Fall', '373', 'ENGLEZA', '6', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'Credence', '326', 'ENGLEZA', '7', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'Karma', '470', 'ENGLEZA', '8', '2');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602557276428', 'Epilogue', '242', 'ENGLEZA', '9', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', 'Feel The Love', '165', 'ENGLEZA', '1', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', 'Fire', '140', 'ENGLEZA', '2', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', '4th Dimension', '153', 'ENGLEZA', '3', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', 'Freeee', '206', 'ENGLEZA', '4', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', 'Reborn', '324', 'ENGLEZA', '5', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', 'Kids See Ghosts', '245', 'ENGLEZA', '6', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602567803911', 'Cudi Montage', '197', 'ENGLEZA', '7', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Wesley\'s Theory', '287', 'ENGLEZA', '1', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'For Free?', '130', 'ENGLEZA', '2', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'King Kunta', '234', 'ENGLEZA', '3', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Institutionalized', '271', 'ENGLEZA', '4', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'These Walls', '300', 'ENGLEZA', '5', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'u', '268', 'ENGLEZA', '6', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Alright', '219', 'ENGLEZA', '7', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'For Sale?', '291', 'ENGLEZA', '8', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Momma', '283', 'ENGLEZA', '9', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Hood Politics', '292', 'ENGLEZA', '10', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'How Much A Dollar Cost', '261', 'ENGLEZA', '11', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Complexion', '263', 'ENGLEZA', '12', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'The Blacker The Berry', '328', 'ENGLEZA', '13', '3');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'You Ain\'t Gotta Lie', '241', 'ENGLEZA', '14', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'i', '336', 'ENGLEZA', '15', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00602547289049', 'Mortal Man', '727', 'ENGLEZA', '16', '4');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Hell', '288', 'ENGLEZA', '1', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Lore', '230', 'ENGLEZA', '2', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Thrash', '216', 'ENGLEZA', '3', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Blackbone', '272', 'ENGLEZA', '4', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Die On The Cross Of The Martyr', '270', 'ENGLEZA', '5', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Glass', '226', 'ENGLEZA', '6', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Abysm', '339', 'ENGLEZA', '7', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'I Wish I Wasn\'t', '185', 'ENGLEZA', '8', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4099885711015', 'Purgatory', '291', 'ENGLEZA', '9', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'Somewhat Damaged', '271', 'ENGLEZA', '1', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'The Day The World Went Away', '273', 'ENGLEZA', '2', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('00606949047320', 'The Frail', '114', '3', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'The Wretched', '325', 'ENGLEZA', '4', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'We\'re In This Together', '436', 'ENGLEZA', '5', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'The Fragile', '275', 'ENGLEZA', '6', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('00606949047320', 'Just Like You Imagined', '229', '7', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'Even Deeper', '347', 'ENGLEZA', '8', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('00606949047320', 'Pilgrimage', '211', '9', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'No, You Don\'t', '215', 'ENGLEZA', '10', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'La Mer', '277', 'FRANCEZA', '11', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00606949047320', 'The Great Below', '317', 'ENGLEZA', '12', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Mr. Self Destruct', '270', 'ENGLEZA', '1', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Piggy', '264', 'ENGLEZA', '2', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Heresy', '234', 'ENGLEZA', '3', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'March Of The Pigs', '178', 'ENGLEZA', '4', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Closer', '373', 'ENGLEZA', '5', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Ruiner', '296', 'ENGLEZA', '6', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'The Becoming', '331', 'ENGLEZA', '7', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'I Do Not Want This', '341', 'ENGLEZA', '8', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Big Man With A Gun', '96', 'ENGLEZA', '9', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('00731452212627', 'A Warm Place', '202', '10', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Eraser', '294', 'ENGLEZA', '11', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Reptile', '411', 'ENGLEZA', '12', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'The Downward Spiral', '237', 'ENGLEZA', '13', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('00731452212627', 'Hurt', '373', 'ENGLEZA', '14', '8');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Vicarious', '426', 'ENGLEZA', '1', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Jambi', '448', 'ENGLEZA', '2', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Wings For Marie', '371', 'ENGLEZA', '3', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', '10,000 Days', '673', 'ENGLEZA', '4', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'The Pot', '381', 'ENGLEZA', '5', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Lipan Conjuring', '71', 'APACHE', '6', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Lost Keys', '226', 'ENGLEZA', '7', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Rosetta Stoned', '671', 'ENGLEZA', '8', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('886447824771', 'Intension', '441', '9', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824771', 'Right In Two', '535', 'ENGLEZA', '10', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('886447824771', 'Viginti Tres', '302', '11', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'The Grudge', '515', 'ENGLEZA', '1', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('886447824764', 'Eon Blue Apocalypse', '64', '2', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'The Patient', '433', 'ENGLEZA', '3', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('886447824764', 'Mantra', '72', '4', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Schism', '403', 'ENGLEZA', '5', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Parabol', '184', 'ENGLEZA', '6', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Parabola', '363', 'ENGLEZA', '7', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Ticks & Leeches', '487', 'ENGLEZA', '8', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Lateralus', '562', 'ENGLEZA', '9', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('886447824764', 'Disposition', '286', '10', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Reflection', '667', 'ENGLEZA', '11', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Triad', '395', 'ENGLEZA', '12', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('886447824764', 'Faaip De Oiad', '161', 'ENGLEZA', '13', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Genesis', '194', '1', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Playing God', '205', '2', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'The Audacity', '144', '3', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Reverie', '242', '4', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4050538873566', 'ABC', '152', 'ENGLEZA', '5', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Memento Mori', '164', 'ENGLEZA', '6', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4050538873566', 'F**k Around and Find Out', '151', 'ENGLEZA', '7', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'All Falls Apart', '79', '8', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Neurotica', '194', '9', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Chimera', '236', 'ENGLEZA', '10', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Bloodbath', '230', 'ENGLEZA', '11', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('4050538873566', 'Ego Death', '350', '12', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Triassic', '511', 'ENGLEZA', '1', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Jurassic | Cretaceous', '804', 'ENGLEZA', '2', '1');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Palaeocene', '240', 'ENGLEZA', '3', '11');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Eocene', '237', 'ENGLEZA', '4', '10');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('039841942125', 'Oligocene', '240', '5', '9');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Miocene | Pliocene', '280', 'ENGLEZA', '6', '9');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Pleistocene', '400', 'ENGLEZA', '7', '9');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841942125', 'Holocene', '347', 'ENGLEZA', '8', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('039841934021', 'The Cambrian Explosion', '114', '1', '5');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841934021', 'Cambrian II: Eternal Reccurence', '471', 'ENGLEZA', '2', '9');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841934021', 'Ordovicium: The Glaciation of Gondwana', '289', 'ENGLEZA', '3', '10');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841934021', 'Silurian: Age of Sea Scorpions', '576', 'ENGLEZA', '4', '10');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841934021', 'Devonian: Nascent', '665', 'ENGLEZA', '5', '9');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('039841934021', 'The Carboniferous Rainforest Collapse', '188', '6', '10');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('039841934021', 'Permian: The Great Dying', '562', 'ENGLEZA', '7', '9');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Feet Don\'t Fail Me', '341', 'ENGLEZA', '1', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'The Way You Used To Do', '274', 'ENGLEZA', '2', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Domesticated Animals', '320', 'ENGLEZA', '3', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Fortress', '327', 'ENGLEZA', '4', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Head Like A Haunted House', '201', 'ENGLEZA', '5', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Un-Reborn Again', '400', 'ENGLEZA', '6', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Hideaway', '258', 'ENGLEZA', '7', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'The Evil Has Landed', '390', 'ENGLEZA', '8', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('744861112556', 'Villains Of Circumstance', '369', 'ENGLEZA', '9', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'Regular John', '277', 'ENGLEZA', '1', '12');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'Avon', '205', 'ENGLEZA', '2', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'If Only', '202', 'ENGLEZA', '3', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'Walkin on the Sidewalks', '301', 'ENGLEZA', '4', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'You Would Know', '258', 'ENGLEZA', '5', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'How to Handle a Rope', '211', 'ENGLEZA', '6', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'Mexicola', '295', 'ENGLEZA', '7', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('191401176859', 'Hispanic Impressions', '166', '8', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'You Can\'t Quit Me Baby', '396', 'ENGLEZA', '9', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('191401176859', 'These Aren\'t the Droids You\'re Looking For', '187', '10', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'Give the Mule What He Wants', '189', 'ENGLEZA', '11', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `index_album`, `id_gen`) VALUES ('191401176859', 'Spiders and Vinegaroons', '386', '12', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('191401176859', 'I Was a Teenage Hand Model', '302', 'ENGLEZA', '13', '13');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'Nemoralia', '250', 'ENGLEZA', '1', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'Rolling Stone', '566', 'ENGLEZA', '2', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'So Falls the World', '357', 'ENGLEZA', '3', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'Southern Gothic', '220', 'ENGLEZA', '4', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'Angelus Novus', '247', 'ENGLEZA', '5', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'Transverberation', '270', 'ENGLEZA', '6', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', '1969', '239', 'ENGLEZA', '7', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('0884388161528', 'Coming Home', '470', 'ENGLEZA', '8', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('7071155273000', 'I Troldskog Faren Vild', '471', 'NORVEGIANA', '1', '11');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('7071155273000', 'Soelen Gaaer Bag Aase Need', '394', 'NORVEGIANA', '2', '11');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('7071155273000', 'Braablick Blev Hun Vaer', '464', 'NORVEGIANA', '3', '11');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('7071155273000', 'Een Stemme Locker', '241', 'NORVEGIANA', '4', '11');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('7071155273000', 'Bergtatt-Ind | Fjeldkamrene', '486', 'NORVEGIANA', '5', '11');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Hard Times', '182', 'ENGLEZA', '1', '6');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Rose-Colored Boy', '212', 'ENGLEZA', '2', '14');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Told You So', '188', 'ENGLEZA', '3', '7');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Forgiveness', '219', 'ENGLEZA', '4', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Fake Happy', '235', 'ENGLEZA', '5', '6');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', '26', '221', 'ENGLEZA', '6', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Pool', '232', 'ENGLEZA', '7', '14');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Grudges', '187', 'ENGLEZA', '8', '14');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Caught in the Middle', '214', 'ENGLEZA', '9', '6');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Idle Worship', '198', 'ENGLEZA', '10', '7');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'No Friend', '203', 'ENGLEZA', '11', '6');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679897138', 'Tell Me How', '260', 'ENGLEZA', '12', '15');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Careful', '230', 'ENGLEZA', '1', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Ignorance', '218', 'ENGLEZA', '2', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Playing God', '182', 'ENGLEZA', '3', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Brick by Boring Brick', '253', 'ENGLEZA', '4', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Turn It Off', '259', 'ENGLEZA', '5', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'The Only Exception', '267', 'ENGLEZA', '6', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Feeling Sorry', '185', 'ENGLEZA', '7', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Looking Up', '209', 'ENGLEZA', '8', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Where the Lines Overlap', '198', 'ENGLEZA', '9', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Misguided Ghosts', '181', 'ENGLEZA', '10', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'All I Wanted', '225', 'ENGLEZA', '11', '16');
INSERT INTO `melodie` (`upc_album`, `nume_melodie`, `durata`, `limba`, `index_album`, `id_gen`) VALUES ('075679981844', 'Decode', '261', 'ENGLEZA', '12', '16');


-- utilizator

INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('1', 'cosmin.calinov', 'cocosssminmax23', 'cosmin.calinov@yahoo.com', 'premium_family');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('2', 'Adrifot', 'merg@19@doc', 'adrain_fota@gmail.com', 'premium_individual');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('3', 'if_raluca_else', 'return_0', 'raluca.if@gmail.com', 'premium_duo');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('4', 'Vlood', 'dracoola4life', 'slg-vlad@yahoo.ro', 'premium_duo');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('5', 'vasius36', '36epatrat-perf', 'dobrisan.robert@yahoo.ro', 'premium_individual');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('6', 'Dobri-san', '18samurai_katana', 'dobri.san@gmail.com', 'premium_family');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('7', 'Ivan Donogbav', 'cossacks_rule09', 'bogdan.ivanov13@gmail.com', 'premium_family');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('8', 'ppz', 'unghii@15pt_mada', 'daria.ppz@yahoo.com', 'standard');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('9', 'same_me', 'un_stil_dif25', 'john_doe@cti.ro', 'standard');
INSERT INTO `utilizator` (`id_utilizator`, `nume_utilizator`, `parola_utilizator`, `email_utilizator`, `tip_abonament`) VALUES ('10', 'Nu Iustin', 'm#P52s@ap$V', 'iustin-alexandru@s.unibuc.ro', 'premium_student');


-- dispozitiv

INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('1', 'pc', 'Alienware', 'Aurora R14', '6');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('2', 'laptop', 'Lenovo', 'Ideapad 3', '1');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('3', 'smartphone', 'Samsung', 'Galaxy a54', '2');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('4', 'tableta', 'Samsung', 'Galaxy tab A9', '7');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('5', 'pc', 'Apple', 'MAC mini', '9');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('6', 'smartphone', 'Samsung', 'Galaxy s10', '1');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('7', 'smartphone', 'Samsung', 'Galaxy s10', '3');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('8', 'tableta', 'Apple', 'Ipad 10', '4');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('9', 'smartphone', 'Huawei', 'P 30', '7');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('10', 'laptop', 'Asus', 'Tuf f15', '7');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('11', 'laptop', 'Apple', 'Mackbook air 15', '5');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('12', 'smartphone', 'Apple', 'Iphone 13', '8');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('13', 'laptop', 'Acer', 'Nitro 5', '2');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('14', 'tableta', 'Samsung', 'Galaxy tab 4', '9');
INSERT INTO `dispozitiv` (`id_dispozitiv`, `tip`, `marca`, `model`, `id_utilizator_proprietar`) VALUES ('15', 'pc', 'Lenovo', 'LOQ 17IRB8', '10');


-- pagina_web

INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('facebook.com', 'sincronizare', 'socializare');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('instagram.com', 'sincronizare', 'socializare');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('x.com', 'sincronizare', 'socializare');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('soundcloud.com', 'master', 'streaming');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('threads.com', 'sincronizare', 'socializare');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('bandcamp.com', 'master', 'streaming');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('youtube.com', 'master', 'streaming');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('amazon.com', 'fizica', 'magazin');
INSERT INTO `pagina_web` (`url_pagina`, `rol_pentru_licentiator`, `tip_pagina`) VALUES ('carturesti.com', 'fizica', 'magazin');


-- artist_pagina

INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('0ybFZ2Ab08V8hueghSXm6E', 'instagram.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('0ybFZ2Ab08V8hueghSXm6E', 'x.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('0ybFZ2Ab08V8hueghSXm6E', 'youtube.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2YZyLoL8N0Wb9xBt1NhZWg', 'instagram.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2YZyLoL8N0Wb9xBt1NhZWg', 'x.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2YZyLoL8N0Wb9xBt1NhZWg', 'threads.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2YZyLoL8N0Wb9xBt1NhZWg', 'youtube.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2YZyLoL8N0Wb9xBt1NhZWg', 'amazon.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('13GH7wviJQ9gfZmr1pXHS4', 'facebook.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('13GH7wviJQ9gfZmr1pXHS4', 'instagram.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('13GH7wviJQ9gfZmr1pXHS4', 'bandcamp.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('13GH7wviJQ9gfZmr1pXHS4', 'soundcloud.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('0X380XXQSNBYuleKzav5UO', 'youtube.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('0X380XXQSNBYuleKzav5UO', 'amazon.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('0X380XXQSNBYuleKzav5UO', 'carturesti.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('74XFHRwlV6OrjEM0A2NCMF', 'instagram.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('74XFHRwlV6OrjEM0A2NCMF', 'x.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('74XFHRwlV6OrjEM0A2NCMF', 'youtube.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('74XFHRwlV6OrjEM0A2NCMF', 'amazon.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('74XFHRwlV6OrjEM0A2NCMF', 'carturesti.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4vGrte8FDu062Ntj0RsPiZ', 'instagram.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4vGrte8FDu062Ntj0RsPiZ', 'soundcloud.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4vGrte8FDu062Ntj0RsPiZ', 'bandcamp.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4vGrte8FDu062Ntj0RsPiZ', 'youtube.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4vGrte8FDu062Ntj0RsPiZ', 'amazon.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4pejUc4iciQfgdX6OKulQn', 'x.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4pejUc4iciQfgdX6OKulQn', 'youtube.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('4pejUc4iciQfgdX6OKulQn', 'amazon.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2yEwvVSSSUkcLeSTNyHKh8', 'facebook.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2yEwvVSSSUkcLeSTNyHKh8', 'instagram.com', '1', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2yEwvVSSSUkcLeSTNyHKh8', 'youtube.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('2yEwvVSSSUkcLeSTNyHKh8', 'carturesti.com', '0', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('6bYFkBNvayh3nGqxcPp7Sv', 'facebook.com', '1', '0');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('6bYFkBNvayh3nGqxcPp7Sv', 'soundcloud.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('6bYFkBNvayh3nGqxcPp7Sv', 'bandcamp.com', '0', '1');
INSERT INTO `artist_pagina` (`artist_spotify_id`, `url_pagina`, `statut_de_verificare`, `monetizare`) VALUES ('6fuALtryzj4cq7vkglKLxq', 'youtube.com', '1', '0');


-- melodie_utilizator

INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'Prologue', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'April Ethereal', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'When', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'Madrigal', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'The Amen Corner', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'Demon Of The Fall', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'Credence', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'Karma', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '00602557276428', 'Epilogue', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Triassic', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Jurassic | Cretaceous', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Palaeocene', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Eocene', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Oligocene', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Miocene | Pliocene', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Pleistocene', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('1', '039841942125', 'Holocene', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'The Cambrian Explosion', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'Cambrian II: Eternal Reccurence', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'Ordovicium: The Glaciation of Gondwana', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'Silurian: Age of Sea Scorpions', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'Devonian: Nascent', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'The Carboniferous Rainforest Collapse', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841934021', 'Permian: The Great Dying', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '4099885711015', 'Thrash', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '4099885711015', 'Blackbone', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('2', '039841942125', 'Triassic', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679897138', 'Hard Times', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679897138', 'Rose-Colored Boy', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679897138', 'Told You So', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679897138', 'Forgiveness', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679897138', 'Fake Happy', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679981844', 'Ignorance', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679981844', 'Playing God', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679981844', 'Brick by Boring Brick', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679981844', 'Turn It Off', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679981844', 'The Only Exception', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('3', '075679981844', 'Decode', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'Somewhat Damaged', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'The Day The World Went Away', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'The Frail', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'The Wretched', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'We\'re In This Together', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'The Fragile', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'Just Like You Imagined', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'Even Deeper', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'Pilgrimage', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'No, You Don\'t', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'La Mer', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00606949047320', 'The Great Below', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Mr. Self Destruct', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Piggy', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Heresy', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'March Of The Pigs', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Closer', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Ruiner', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'The Becoming', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'I Do Not Want This', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Big Man With A Gun', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'A Warm Place', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Eraser', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Reptile', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'The Downward Spiral', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '00731452212627', 'Hurt', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Feet Don\'t Fail Me', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'The Way You Used To Do', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Domesticated Animals', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Fortress', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Head Like A Haunted House', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Un-Reborn Again', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Hideaway', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'The Evil Has Landed', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '744861112556', 'Villains Of Circumstance', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Regular John', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Avon', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'If Only', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Walkin on the Sidewalks', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'You Would Know', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'How to Handle a Rope', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Mexicola', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Hispanic Impressions', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'You Can\'t Quit Me Baby', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'These Aren\'t the Droids You\'re Looking For', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Give the Mule What He Wants', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'Spiders and Vinegaroons', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('4', '191401176859', 'I Was a Teenage Hand Model', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', 'Feel The Love', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', 'Fire', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', '4th Dimension', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', 'Freeee', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', 'Reborn', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', 'Kids See Ghosts', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602567803911', 'Cudi Montage', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'Wesley\'s Theory', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'For Free?', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'Complexion', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'The Blacker The Berry', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'You Ain\'t Gotta Lie', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'i', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00602547289049', 'Mortal Man', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00731452212627', 'Closer', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '00731452212627', 'Ruiner', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '886447824764', 'The Grudge', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '886447824764', 'Mantra', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '886447824764', 'Schism', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('5', '886447824764', 'Parabola', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('6', '191401176859', 'You Can\'t Quit Me Baby', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Wesley\'s Theory', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'For Free?', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'King Kunta', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Institutionalized', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'These Walls', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'u', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Alright', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'For Sale?', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Momma', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Hood Politics', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'How Much A Dollar Cost', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Complexion', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'The Blacker The Berry', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'You Ain\'t Gotta Lie', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'i', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '00602547289049', 'Mortal Man', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '744861112556', 'Feet Don\'t Fail Me', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '744861112556', 'The Way You Used To Do', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '744861112556', 'Fortress', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '744861112556', 'Head Like A Haunted House', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '744861112556', 'Un-Reborn Again', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '744861112556', 'Villains Of Circumstance', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '191401176859', 'How to Handle a Rope', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('7', '191401176859', 'Mexicola', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '4099885711015', 'Lore', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '00731452212627', 'Closer', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '886447824771', 'Vicarious', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '886447824771', 'Wings For Marie', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '4050538873566', 'Neurotica', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '039841942125', 'Holocene', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '0884388161528', 'So Falls the World', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '0884388161528', 'Southern Gothic', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '0884388161528', 'Transverberation', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '0884388161528', 'Coming Home', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679897138', 'Hard Times', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679897138', 'Rose-Colored Boy', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679897138', 'Told You So', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679897138', 'Forgiveness', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679897138', 'Pool', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679897138', 'Idle Worship', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679981844', 'Turn It Off', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679981844', 'Feeling Sorry', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679981844', 'All I Wanted', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('8', '075679981844', 'Decode', '1', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Hard Times', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Rose-Colored Boy', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Told You So', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Forgiveness', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Fake Happy', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', '26', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Pool', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Grudges', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Caught in the Middle', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Idle Worship', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'No Friend', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679897138', 'Tell Me How', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Careful', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Ignorance', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Playing God', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Brick by Boring Brick', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Turn It Off', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'The Only Exception', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Feeling Sorry', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Looking Up', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Where the Lines Overlap', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Misguided Ghosts', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'All I Wanted', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('9', '075679981844', 'Decode', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '4099885711015', 'Hell', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '4099885711015', 'Lore', '0', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '00606949047320', 'Just Like You Imagined', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '00606949047320', 'Even Deeper', '1', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '00606949047320', 'Pilgrimage', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '886447824771', 'Intension', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '886447824771', 'Right In Two', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '886447824771', 'Viginti Tres', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '4050538873566', 'Memento Mori', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '4050538873566', 'F**k Around and Find Out', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '4050538873566', 'All Falls Apart', '1', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '039841942125', 'Pleistocene', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '039841942125', 'Holocene', '0', '1');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '7071155273000', 'Bergtatt-Ind | Fjeldkamrene', '0', '2');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '075679897138', 'Hard Times', '1', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '075679897138', 'Rose-Colored Boy', '0', '5');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '075679981844', 'Feeling Sorry', '0', '4');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '075679981844', 'Looking Up', '1', '3');
INSERT INTO `melodie_utilizator` (`id_utilizator`, `upc_album`, `nume_melodie`, `apreciata`, `evaluare`) VALUES ('10', '075679981844', 'Where the Lines Overlap', '1', '2');


-- stergerea tabelelor

DROP TABLE melodie_utilizator;
DROP TABLE artist_pagina;
DROP TABLE pagina_web;
DROP TABLE dispozitiv;
DROP TABLE utilizator;
DROP TABLE melodie;
DROP TABLE gen;
DROP TABLE album;
DROP TABLE artist;
