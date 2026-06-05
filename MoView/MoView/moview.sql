-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 10, 2026 at 04:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `moview`
--

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `movie_id`, `user_id`, `comment`, `created_at`) VALUES
(1, 1, 2, 'Film bagus banget!', '2026-05-10 14:25:08');

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `imdb_id` varchar(20) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `plot` text DEFAULT NULL,
  `poster` varchar(500) DEFAULT NULL,
  `imdb_rating` varchar(10) DEFAULT NULL,
  `rotten_tomatoes` varchar(10) DEFAULT NULL,
  `runtime` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `imdb_id`, `title`, `year`, `genre`, `plot`, `poster`, `imdb_rating`, `rotten_tomatoes`, `runtime`) VALUES
(1, 'tt0133093', 'The Matrix', '1999', 'Action, Sci-Fi', 'Thomas A. Anderson is a man living two lives. By day he is an average computer programmer and by night a hacker known as Neo. Neo has always questioned his reality, but the truth is far beyond his imagination. Neo finds himself targeted by the police when he is contacted by Morpheus, a legendary computer hacker branded a terrorist by the government. As a rebel against the machines, Neo must confront the agents: super-powerful computer programs devoted to stopping Neo and the entire human rebellion.', 'https://m.media-amazon.com/images/M/MV5BN2NmN2VhMTQtMDNiOS00NDlhLTliMjgtODE2ZTY0ODQyNDRhXkEyXkFqcGc@._V1_QL75_UX380_CR0,4,380,562_.jpg', '8.7', '83%', '136 min'),
(2, 'tt0120338', 'Titanic', '1997', 'Drama, Romance', '84 years later, a 100 year-old woman named Rose DeWitt Bukater tells the story to her granddaughter Lizzy Calvert, Brock Lovett, Lewis Bodine, Bobby Buell and Anatoly Mikailavich on the Keldysh about her life set in April 10th 1912, on a ship called Titanic when young Rose boards the departing ship with the upper-class passengers and her mother, Ruth DeWitt Bukater, and her fiancé, Caledon Hockley. Meanwhile, a drifter and artist named Jack Dawson and his best friend Fabrizio De Rossi win third-class tickets to the ship in a game. And she explains the whole story from departure until the death of Titanic on its first and last voyage April 15th, 1912 at 2:20 in the morning.', 'https://m.media-amazon.com/images/M/MV5BYzYyN2FiZmUtYWYzMy00MzViLWJkZTMtOGY1ZjgzNWMwN2YxXkEyXkFqcGc@._V1_QL75_UX380_CR0,2,380,562_.jpg', '8.0', '88%', '194 min'),
(3, 'tt0076759', 'Star Wars: Episode IV - A New Hope', '1977', 'Action, Adventure, Fantasy', 'The Imperial Forces, under orders from cruel Darth Vader, hold Princess Leia hostage in their efforts to quell the rebellion against the Galactic Empire. Luke Skywalker and Han Solo, captain of the Millennium Falcon, work together with the companionable droid duo R2-D2 and C-3PO to rescue the beautiful princess, help the Rebel Alliance and restore freedom and justice to the Galaxy.', 'https://m.media-amazon.com/images/M/MV5BOGUwMDk0Y2MtNjBlNi00NmRiLTk2MWYtMGMyMDlhYmI4ZDBjXkEyXkFqcGc@._V1_SX300.jpg', '8.6', '94%', '121 min'),
(4, 'tt0080684', 'Star Wars: Episode V - The Empire Strikes Back', '1980', 'Action, Adventure, Fantasy', 'Luke Skywalker, Han Solo, Princess Leia and Chewbacca face attack by the Imperial forces and its AT-AT walkers on the ice planet Hoth. While Han and Leia escape in the Millennium Falcon, Luke travels to Dagobah in search of Yoda. Only with the Jedi Master\'s help will Luke survive when the Dark Side of the Force beckons him into the ultimate duel with Darth Vader.', 'https://m.media-amazon.com/images/M/MV5BMTkxNGFlNDktZmJkNC00MDdhLTg0MTEtZjZiYWI3MGE5NWIwXkEyXkFqcGc@._V1_SX300.jpg', '8.7', '93%', '124 min'),
(5, 'tt1640571', 'Titanic II', '2010', 'Action, Adventure, Drama, Romance, Thriller', 'On the 100th anniversary of the original voyage, a modern luxury liner christened \"Titanic 2,\" follows the path of its namesake. But when a tsunami hurls an ice berg into the new ship\'s path, the passengers and crew must fight to avoid a similar fate.', 'https://m.media-amazon.com/images/M/MV5BMTMxMjQ1MjA5Ml5BMl5BanBnXkFtZTcwNjIzNjg1Mw@@._V1_SX300.jpg', '1.6', 'N/A', '90 min'),
(6, 'tt0234215', 'The Matrix Reloaded', '2003', 'Action, Sci-Fi', 'In this second adventure, Neo and the rebel leaders estimate that they have 72 hours until Zion falls under siege to the Machine Army. Only a matter of hours separates the last human enclave on Earth from 250,000 Sentinels programmed to destroy mankind. But the citizens of Zion, emboldened by Morpheus conviction that the One will fulfill the Oracles Prophecy and end the war with the Machines, rest all manner of hope and expectation on Neo, who finds himself stalled by disturbing visions as he searches for a course of action.', 'https://m.media-amazon.com/images/M/MV5BNjAxYjkxNjktYTU0YS00NjFhLWIyMDEtMzEzMTJjMzRkMzQ1XkEyXkFqcGc@._V1_SX300.jpg', '7.2', '74%', '138 min'),
(7, 'tt1201607', 'Harry Potter and the Deathly Hallows: Part 2', '2011', 'Adventure, Family, Fantasy', 'Harry (Daniel Radcliffe), Ron (Rupert Grint), and Hermione (Emma Watson) continue their quest of finding and destroying Voldemort\'s (Ralph Fiennes\') three remaining Horcruxes, the magical items responsible for his immortality. But as the mystical Deathly Hallows are uncovered, and Voldemort finds out about their mission, the biggest battle begins, and life as they know it will never be the same again.', 'https://m.media-amazon.com/images/M/MV5BOTA1Mzc2N2ItZWRiNS00MjQzLTlmZDQtMjU0NmY1YWRkMGQ4XkEyXkFqcGc@._V1_SX300.jpg', '8.1', '96%', '130 min'),
(8, 'tt0086190', 'Star Wars: Episode VI - Return of the Jedi', '1983', 'Action, Adventure, Fantasy', 'Luke Skywalker battles Jabba the Hutt and Darth Vader to save his comrades in the Rebel Alliance and triumph over the Galactic Empire. Han Solo and Princess Leia reaffirm their love, and team with Chewbacca, Lando Calrissian, the Ewoks, and droids C-3PO and R2-D2 to aid in the disruption of the Dark Side, and the defeat of the evil emperor.', 'https://m.media-amazon.com/images/M/MV5BNWEwOTI0MmUtMGNmNy00ODViLTlkZDQtZTg1YmQ3MDgyNTUzXkEyXkFqcGc@._V1_SX300.jpg', '8.3', '83%', '131 min'),
(9, 'tt0330994', 'Titanic: The Legend Goes On...', '2000', 'Animation, Family, Fantasy', 'An animated retelling of the worst passenger ship disaster in history. In this version, love blossoms between the upper-class Sir William and the blue-collar Angelica, who is hoping to find romance in America. At the same time, there are also a number of animal passengers, including talking dogs, cats and mice, who are also looking forward to arriving in the New World.', 'https://m.media-amazon.com/images/M/MV5BMTg5MjcxODAwMV5BMl5BanBnXkFtZTcwMTk4OTMwMg@@._V1_SX300.jpg', '1.5', 'N/A', '90 min'),
(10, 'tt0242653', 'The Matrix Revolutions', '2003', 'Action, Sci-Fi', 'Neo finds himself trapped between the Matrix and the Real World. Meanwhile, Zion is preparing for the oncoming war with the machines with very little chances of survival. Neo\'s associates set out to free him from The Merovingian since it\'s believed that he is the One who will end the war between humans and the machines. What they do not know is that there is a threat from a third party, someone who has plans to destroy both worlds.', 'https://m.media-amazon.com/images/M/MV5BMmNmMTEzODQtNmExMS00OGUxLWFkNTItMTM3NzBlNDk0YWU5XkEyXkFqcGc@._V1_SX300.jpg', '6.7', '33%', '129 min'),
(11, 'tt0241527', 'Harry Potter and the Sorcerer\'s Stone', '2001', 'Adventure, Family, Fantasy', 'This is the tale of Harry Potter (Daniel Radcliffe), an ordinary eleven-year-old boy serving as a sort of slave for his aunt and uncle who learns that he is actually a wizard and has been invited to attend the Hogwarts School for Witchcraft and Wizardry. Harry is snatched away from his mundane existence by Rubeus Hagrid (Robbie Coltrane), the groundskeeper for Hogwarts, and quickly thrown into a world completely foreign to both him and the viewer. Famous for an incident that happened at his birth, Harry makes friends easily at his new school. He soon finds, however, that the wizarding world is far more dangerous for him than he would have imagined, and he quickly learns that not all wizards are ones to be trusted.', 'https://m.media-amazon.com/images/M/MV5BNTU1MzgyMDMtMzBlZS00YzczLThmYWEtMjU3YmFlOWEyMjE1XkEyXkFqcGc@._V1_SX300.jpg', '7.7', '80%', '152 min'),
(12, 'tt2488496', 'Star Wars: Episode VII - The Force Awakens', '2015', 'Action, Adventure, Sci-Fi', '30 years after the defeat of Darth Vader and the Empire, Rey, a scavenger from the planet Jakku, finds a BB-8 droid that knows the whereabouts of the long lost Luke Skywalker. Rey, as well as a rogue stormtrooper and two smugglers, are thrown into the middle of a battle between the Resistance and the daunting legions of the First Order.', 'https://m.media-amazon.com/images/M/MV5BOTAzODEzNDAzMl5BMl5BanBnXkFtZTgwMDU1MTgzNzE@._V1_SX300.jpg', '7.7', '93%', '138 min'),
(13, 'tt0046435', 'Titanic', '1953', 'Drama, History, Romance', 'Unhappily married and uncomfortable with life among the British upper crust, Julia Sturges takes her two children and boards the RMS Titanic for America. Her husband, Richard, also arranges passage on the doomed luxury liner in order to allow him to have custody of their two children, Annette and Norman. Meanwhile, Annette begins a romance with a young American college student and tennis player, Gifford Rogers. Unfortunately, their family problems soon seem minor when the Titanic strikes an iceberg.', 'https://m.media-amazon.com/images/M/MV5BMTU3NTUyMTc3Nl5BMl5BanBnXkFtZTgwOTA2MDE3MTE@._V1_SX300.jpg', '7.0', '91%', '98 min'),
(14, 'tt10838180', 'The Matrix Resurrections', '2021', 'Action, Sci-Fi', 'Return to a world of two realities: one, everyday life; the other, what lies behind it. To find out if his reality is a construct, to truly know himself, Mr. Anderson will have to choose to follow the white rabbit once more.', 'https://m.media-amazon.com/images/M/MV5BMDMyNDIzYzMtZTMyMy00NjUyLWI3Y2MtYzYzOGE1NzQ1MTBiXkEyXkFqcGc@._V1_SX300.jpg', '5.6', '63%', '148 min'),
(15, 'tt0304141', 'Harry Potter and the Prisoner of Azkaban', '2004', 'Adventure, Family, Fantasy', 'Harry Potter (Daniel Radcliffe) is having a tough time with his relatives (yet again). He runs away after using magic to inflate Uncle Vernon\'s (Richard Griffiths\') sister Marge (Pam Ferris), who was being offensive towards Harry\'s parents. Initially scared for using magic outside the school, he is pleasantly surprised that he won\'t be penalized after all. However, he soon learns that a dangerous criminal and Voldemort\'s trusted aide Sirius Black (Gary Oldman) has escaped from Azkaban Prison and wants to kill Harry to avenge the Dark Lord. To worsen the conditions for Harry, vile creatures called Dementors are appointed to guard the school gates and inexplicably happen to have the most horrible effect on him. Little does Harry know that by the end of this year, many holes in his past (whatever he knows of it) will be filled up and he will have a clearer vision of what the future has in store.', 'https://m.media-amazon.com/images/M/MV5BMTY4NTIwODg0N15BMl5BanBnXkFtZTcwOTc0MjEzMw@@._V1_SX300.jpg', '7.9', '90%', '142 min'),
(16, 'tt0120915', 'Star Wars: Episode I - The Phantom Menace', '1999', 'Action, Adventure, Fantasy', 'The evil Trade Federation, led by Nute Gunray is planning to take over the peaceful world of Naboo. Jedi Knights Qui-Gon Jinn and Obi-Wan Kenobi are sent to confront the leaders. But not everything goes to plan. The two Jedi escape, and along with their new Gungan friend, Jar Jar Binks head to Naboo to warn Queen Amidala, but droids have already started to capture Naboo and the Queen is not safe there. Eventually, they land on Tatooine, where they become friends with a young boy known as Anakin Skywalker. Qui-Gon is curious about the boy, and sees a bright future for him. The group must now find a way of getting to Coruscant and to finally solve this trade dispute, but there is someone else hiding in the shadows. Are the Sith really extinct? Is the Queen really who she says she is? And what\'s so special about this young boy?', 'https://m.media-amazon.com/images/M/MV5BODVhNGIxOGItYWNlMi00YTA0LWI3NTctZmQxZGUwZDEyZWI4XkEyXkFqcGc@._V1_SX300.jpg', '6.5', '54%', '136 min'),
(17, 'tt0365467', 'Making \'The Matrix\'', '1999', 'Documentary, Short, Sci-Fi', 'A promotional making-of documentary for the film Matrix, The (1999) that devotes its time to explaining the digital and practical effects contained in the film. This is very interesting, seeing as how they\'re giving away the cinematic secrets that they created solely for the this movie, that have now been spoofed and referenced in countless other films.', 'https://m.media-amazon.com/images/M/MV5BOTZjYThlYjktMzI1Ny00ZTQ1LWEzYTYtMTQ2NzU5ZDc1MGIwXkEyXkFqcGc@._V1_SX300.jpg', '8.6', 'N/A', '26 min'),
(18, 'tt0081400', 'Raise the Titanic', '1980', 'Action, Adventure, Drama', 'A group of Americans are interested in raising the ill-fated ocean liner Titanic from its watery grave. One of them finds out the Russians also have plans to do so. Why all the interest? A rare mineral on board could be used to power a sound beam that will knock any missile out of the air while entering US airspace.', 'https://m.media-amazon.com/images/M/MV5BNGQ1YTExNDEtNmJhMS00M2Y4LWExNGEtNzFlZTQzYTExZTRmXkEyXkFqcGc@._V1_SX300.jpg', '5.2', '38%', '115 min'),
(19, 'tt0295297', 'Harry Potter and the Chamber of Secrets', '2002', 'Adventure, Family, Fantasy', 'Forced to spend his summer holidays with his muggle relations, Harry Potter (Daniel Radcliffe) gets a real shock when he gets a surprise visitor: Dobby (Toby Jones) the house-elf, who warns Harry against returning to Hogwarts, for terrible things are going to happen. Harry decides to ignore Dobby\'s warning and continues with his pre-arranged schedule. But at Hogwarts, strange and terrible things are indeed happening. Harry is suddenly hearing mysterious voices from inside the walls, muggle-born students are being attacked, and a message scrawled on the wall in blood puts everyone on his or her guard, \"The Chamber Of Secrets Has Been Opened. Enemies Of The Heir, Beware\".', 'https://m.media-amazon.com/images/M/MV5BNGJhM2M2MWYtZjIzMC00MDZmLThkY2EtOWViMDhhYjRhMzk4XkEyXkFqcGc@._V1_SX300.jpg', '7.5', '82%', '161 min'),
(20, 'tt0121766', 'Star Wars: Episode III - Revenge of the Sith', '2005', 'Action, Adventure, Fantasy', 'Nearly three years have passed since the beginning of the Clone Wars. The Republic, with the help of the Jedi, take on Count Dooku and the Separatists. With a new threat rising, the Jedi Council sends Obi-Wan Kenobi and Anakin Skywalker to aid the captured Chancellor. Anakin feels he is ready to be promoted to Jedi Master. Obi-Wan is hunting down the Separatist General, Grievous. When Anakin has future visions of pain and suffering coming Padmé\'s way, he sees Master Yoda for counsel. When Darth Sidious executes Order 66, it destroys most of all the Jedi have built. Experience the birth of Darth Vader. Feel the betrayal that leads to hatred between two brothers. And witness the power of hope.', 'https://m.media-amazon.com/images/M/MV5BNTc4MTc3NTQ5OF5BMl5BanBnXkFtZTcwOTg0NjI4NA@@._V1_SX300.jpg', '7.7', '79%', '140 min'),
(21, 'tt0295432', 'The Matrix Revisited', '2001', 'Documentary', 'An \"extras-only\" DVD, packed with documentaries and behind-the-scenes footage from the filming of the ground-breaking 1999 movie \"The Matrix\". Includes a rare interview with the elusive writer/directors, the Wachowski Brothers; insights from the cast and crew into the production process; and a preview of things to come: a series of anime films and two sequels.', 'https://m.media-amazon.com/images/M/MV5BMTkzNjg3NjE4N15BMl5BanBnXkFtZTgwNTc3NTAwNzE@._V1_SX300.jpg', '7.4', '71%', '123 min'),
(22, 'tt0330373', 'Harry Potter and the Goblet of Fire', '2005', 'Adventure, Family, Fantasy', 'Harry\'s (Daniel Radcliffe\'s) fourth year at Hogwarts is about to start and he is enjoying the summer vacation with his friends. They get the tickets to The Quidditch World Cup Final, but after the match is over, people dressed like Lord Voldemort\'s (Ralph Fiennes\') \"Death Eaters\" set a fire to all of the visitors\' tents, coupled with the appearance of Voldemort\'s symbol, the \"Dark Mark\" in the sky, which causes a frenzy across the magical community. That same year, Hogwarts is hosting \"The Triwizard Tournament\", a magical tournament between three well-known schools of magic : Hogwarts, Beauxbatons, and Durmstrang. The contestants have to be above the age of seventeen, and are chosen by a magical object called \"The Goblet of Fire\". On the night of selection, however, the Goblet spews out four names instead of the usual three, with Harry unwittingly being selected as the Fourth Champion. Since the magic cannot be reversed, Harry is forced to go with it and brave three exceedingly difficult tasks.', 'https://m.media-amazon.com/images/M/MV5BMTIzNzUzOTk2NV5BMl5BanBnXkFtZTYwNTI4MDg2._V1_SX300.jpg', '7.7', '88%', '157 min'),
(23, 'tt0115392', 'Titanic', '1996', 'Action, Drama, History', 'The story of R.M.S. Titanic, the famous luxury liner that claimed to be unsinkable. The plot focuses on the romances of two couples upon the doomed ship\'s maiden voyage. Isabella Paradine (Catherine Zeta-Jones) is a wealthy woman mourning the loss of her aunt, who reignites a romance with former flame Wynn Park (Peter Gallagher). Meanwhile, a charming ne\'er-do-well named Jamie Perse (Mike Doyle) steals a ticket for the ship, and falls for a sweet innocent Irish girl on board. But their romance is threatened by the nefarious Simon Doonan (Tim Curry), who has discovered about the ticket and makes Jamie his unwilling accomplice, as well as having sinister plans for the girl. The passengers and crew race against time to escape the Titanic and decide who will go into the lifeboats that can only hold more than half of the ship\'s people before they face almost certain death.', 'https://m.media-amazon.com/images/M/MV5BNzM5MTY0MGEtZWQ5Zi00MDRmLThiNjAtOTdjYzhiMGM0YmI1XkEyXkFqcGc@._V1_SX300.jpg', '5.8', 'N/A', '1 min'),
(24, 'tt0121765', 'Star Wars: Episode II - Attack of the Clones', '2002', 'Action, Adventure, Fantasy', 'Ten years after the invasion of Naboo, the Galactic Republic is facing a Separatist movement and the former queen and now Senator Padmé Amidala travels to Coruscant to vote on a project to create an army to help the Jedi to protect the Republic. Upon arrival, she escapes from an attempt to kill her, and Obi-Wan Kenobi and his Padawan Anakin Skywalker are assigned to protect her. They chase the shape-shifter Zam Wessell but she is killed by a poisoned dart before revealing who hired her. The Jedi Council assigns Obi-Wan Kenobi to discover who has tried to kill Amidala and Anakin to protect her in Naboo. Obi-Wan discovers that the dart is from the planet Kamino, and he heads to the remote planet. He finds an army of clones that has been under production for years for the Republic and that the bounty hunter Jango Fett was the matrix for the clones. Meanwhile Anakin and Amidala fall in love with each other, and he has nightmarish visions of his mother. They travel to his home planet, Tatooine, to see his mother, and he discovers that she has been abducted by Tusken Raiders. Anakin finds his mother dying, and he kills all the Tusken tribe, including the women and children. Obi-Wan follows Jango Fett to the planet Geonosis where he discovers who is behind the Separatist movement. He transmits his discoveries to Anakin since he cannot reach the Jedi Council. Who is the leader of the Separatist movement? Will Anakin receive Obi-Wan\'s message? And will the secret love between Anakin and Amidala succeed?', 'https://m.media-amazon.com/images/M/MV5BNTgxMjY2YzUtZmVmNC00YjAwLWJlODMtNDBhNzllNzIzMjgxXkEyXkFqcGc@._V1_SX300.jpg', '6.6', '62%', '142 min'),
(25, 'tt0277828', 'Enter the Matrix', '2003', 'Action, Adventure, Sci-Fi, Thriller', 'The game\'s story picks up just before The Matrix Reloaded and runs parallel to that of the film. Bend the rules of the Matrix with martial arts, pilot the fastest hovercraft in the fleet, or just fight with lots of guns.', 'https://m.media-amazon.com/images/M/MV5BNWM3MDU2MWQtYjdlNC00NDBlLTkyNGMtNjdhYjdlNTdiNTFlXkEyXkFqcGdeQXVyNTEwNDY2MjU@._V1_SX300.jpg', '6.9', 'N/A', 'N/A'),
(26, 'tt0373889', 'Harry Potter and the Order of the Phoenix', '2007', 'Action, Adventure, Family', 'After a lonely summer on Privet Drive, Harry (Daniel Radcliffe) returns to a Hogwarts full of ill-fortune. Few of students and parents believe him or Dumbledore (Sir Michael Gambon) that Voldemort (Ralph Fiennes) is really back. The ministry had decided to step in by appointing a new Defense Against the Dark Arts teacher, Professor Dolores Umbridge (Imelda Staunton), who proves to be the nastiest person Harry has ever encountered. Harry also can\'t help stealing glances with the beautiful Cho Chang (Katie Leung). To top it off are dreams that Harry can\'t explain, and a mystery behind something for which Voldemort is searching. With these many things, Harry begins one of his toughest years at Hogwarts School of Witchcraft and Wizardry.', 'https://m.media-amazon.com/images/M/MV5BYWJmM2M1YzItMjY1Ni00YzRmLTg5YWYtNDFmNTJjNzQ0ODkyXkEyXkFqcGc@._V1_SX300.jpg', '7.5', '78%', '138 min'),
(27, 'tt18394428', 'Titanic 666', '2022', 'Horror, Thriller', 'Dark forces from the deep rise to the surface, terrorizing all aboard from Titanic III and threatens to repeat one of history\'s greatest disasters.', 'https://m.media-amazon.com/images/M/MV5BNzcxY2RjOWUtZmE2Yy00YTBlLWE4N2UtOTg5NjdiNTFjNzk1XkEyXkFqcGc@._V1_SX300.jpg', '3.3', 'N/A', '91 min'),
(28, 'tt3748528', 'Rogue One: A Star Wars Story', '2016', 'Action, Adventure, Sci-Fi', 'All looks lost for the Rebellion against the Empire as they learn of the existence of a new super weapon, the Death Star. Once a possible weakness in its construction is uncovered, the Rebel Alliance must set out on a desperate mission to steal the plans for the Death Star. The future of the entire galaxy now rests upon its success.', 'https://m.media-amazon.com/images/M/MV5BMjEwMzMxODIzOV5BMl5BanBnXkFtZTgwNzg3OTAzMDI@._V1_SX300.jpg', '7.8', '84%', '133 min'),
(29, 'tt0926084', 'Harry Potter and the Deathly Hallows: Part 1', '2010', 'Adventure, Family, Fantasy', 'Voldemort\'s (Ralph Fiennes\') power is growing stronger. He now has control over the Ministry of Magic and Hogwarts. Harry (Daniel Radcliffe), Ron (Rupert Grint), and Hermione (Emma Watson) decide to finish Dumbledore\'s (Sir Michael Gambon\'s) work and find the rest of the Horcruxes to defeat the Dark Lord. But little hope remains for the trio and the rest of the Wizarding World, so everything they do must go as planned.', 'https://m.media-amazon.com/images/M/MV5BMTQ2OTE1Mjk0N15BMl5BanBnXkFtZTcwODE3MDAwNA@@._V1_SX300.jpg', '7.7', '76%', '146 min'),
(30, 'tt9847360', 'A Glitch in the Matrix', '2021', 'Documentary', 'Are we in fact living in a simulation? This is the question postulated, wrestled with, and ultimately argued for in the latest provocation from acclaimed documentary stylist Rodney Ascher (Room 237, The Nightmare) through archival footage, compelling interviews with real people shrouded in digital avatars, and a collection of cases from some of our most iconoclastic figures in contemporary culture.', 'https://m.media-amazon.com/images/M/MV5BYmU0NzFhYmEtMmUzNC00MjQ1LTg3NTctZDdlZmVlY2MzMDQzXkEyXkFqcGc@._V1_SX300.jpg', '5.2', 'N/A', '108 min'),
(31, 'tt1869152', 'Titanic', '2012', 'Drama, History', 'Follows the lives of the ship\'s passengers, from all walks of life, as they travel on the maiden voyage of the ill-fated Titanic. From the wealthy family of the Earl of Manton, the designers of the ship, to the stokers in the engine room - who will make it onto the lifeboats?', 'https://m.media-amazon.com/images/M/MV5BNjdhNDI1ZjMtYzAxNS00YjZkLWE2NDYtZjU4MTllNTQxZmQwXkEyXkFqcGc@._V1_SX300.jpg', '6.0', 'N/A', '190 min'),
(32, 'tt2527336', 'Star Wars: Episode VIII - The Last Jedi', '2017', 'Action, Adventure, Fantasy', 'Jedi Master-in-hiding Luke Skywalker unwillingly attempts to guide young hopeful Rey in the ways of the force, while Leia, former princess turned general, attempts to lead what is left of the Resistance away from the ruthless tyrannical grip of the First Order.', 'https://m.media-amazon.com/images/M/MV5BMjQ1MzcxNjg4N15BMl5BanBnXkFtZTgwNzgwMjY4MzI@._V1_SX300.jpg', '6.8', '91%', '152 min'),
(33, 'tt0417741', 'Harry Potter and the Half-Blood Prince', '2009', 'Action, Adventure, Family', 'During Harry Potter\'s sixth year at Hogwarts, he finds a book that once belonged to the mysterious Half-Blood Prince that earns him the respect of his new Potions professor Horace Slughorn. In addition, Dumbledore must prepare Harry for the ultimate final confrontation by finding out the secret behind Voldemort\'s power. Meanwhile, a hidden enemy waits in the shadows to carry out a mission given to him by the Dark Lord.', 'https://m.media-amazon.com/images/M/MV5BNzU3NDg4NTAyNV5BMl5BanBnXkFtZTcwOTg2ODg1Mg@@._V1_SX300.jpg', '7.6', '83%', '153 min'),
(34, 'tt1623780', 'The Legend of the Titanic', '1999', 'Animation, Drama, Family', 'A grandfather mouse tells his grandchildren the \"real\" story of the Titanic disaster, including himself, evil sharks, a giant octopus, and an evil whaling scheme.', 'https://m.media-amazon.com/images/M/MV5BMjMxNDU5MTk1MV5BMl5BanBnXkFtZTgwMDk5NDUyMTE@._V1_SX300.jpg', '1.4', 'N/A', '84 min'),
(35, 'tt0451118', 'The Matrix: Path of Neo', '2005', 'Action, Adventure, Family, Sci-Fi, Thriller', 'Play as Neo and battle your way through familiar fights and situations from the Matrix trilogy.', 'https://m.media-amazon.com/images/M/MV5BZGFiNGU4MjEtODM2ZC00OTg0LThkNmEtZTBlN2FkMmFjOWYzXkEyXkFqcGdeQXVyNTEwNDY2MjU@._V1_SX300.jpg', '7.5', 'N/A', 'N/A'),
(36, 'tt2527338', 'Star Wars: Episode IX - The Rise of Skywalker', '2019', 'Action, Adventure, Fantasy', 'While the First Order continues to ravage the galaxy, Rey finalizes her training as a Jedi. But danger suddenly rises from the ashes as the evil Emperor Palpatine mysteriously returns from the dead. While working with Finn and Poe Dameron to fulfill a new mission, Rey will not only face Kylo Ren once more, but she will also finally discover the truth about her parents as well as a deadly secret that could determine her future and the fate of the ultimate final showdown that is to come.', 'https://m.media-amazon.com/images/M/MV5BODg5ZTNmMTUtYThlNy00NjljLWE0MGUtYmQ1NDg4NWU5MjQ1XkEyXkFqcGc@._V1_SX300.jpg', '6.3', '51%', '141 min'),
(37, 'tt16116174', 'Harry Potter 20th Anniversary: Return to Hogwarts', '2022', 'Documentary, Family', 'Cast and crew members from all \"Harry Potter\" films reunite in a retrospective special to celebrate the 20th anniversary of Harry Potter and the Sorcerer\'s Stone (2001).', 'https://m.media-amazon.com/images/M/MV5BZTNhNjg1NWItZThkNC00N2JiLTkzOTgtNzZjYzAyYTQ4OTEwXkEyXkFqcGc@._V1_SX300.jpg', '8.0', '93%', '102 min'),
(38, 'tt1695366', 'Titanic: Blood and Steel', '2012', 'Drama', 'The construction of the R.M.S. Titanic at the Harland and Wolff shipyard in Belfast against the background of union riots, political and religious conflicts, and a romance between a young ambitious engineer and an Italian immigrant.', 'https://m.media-amazon.com/images/M/MV5BMjI2MzU2NzEzN15BMl5BanBnXkFtZTcwMzI5NTU3Nw@@._V1_SX300.jpg', '7.2', 'N/A', '1 min'),
(39, 'tt0303678', 'Armitage III: Dual Matrix', '2002', 'Animation, Drama, Sci-Fi, Thriller', 'Five years after the OAV series, Third series robot Naomi Armitage and her husband Ross Sylibus now live peacefully on Mars with their daughter, until a corporation wants to know the secrets of the third\'s ability to bear children.', 'https://m.media-amazon.com/images/M/MV5BOTUwOTY3Mjg1MF5BMl5BanBnXkFtZTcwODI2MTAyMQ@@._V1_SX300.jpg', '6.5', 'N/A', '90 min'),
(40, 'tt1756545', 'Harry Potter and the Forbidden Journey', '2010', 'Short, Adventure, Fantasy', 'Enter through the towering castle gates and make your way down the familiar passages and corridors of Hogwarts School of Witchcraft and Wizardry. You\'ll visit iconic locations such as Dumbledore\'s office, the Defence Against the Dark Arts classroom, the Gryffindor common room, the Room of Requirement and more. Then get ready to soar above the castle grounds as you join Harry Potter and his friends on an unforgettably thrilling adventure, coming face-to-face with an array of magical creatures! This amazing new attraction uses ground-breaking, state-of-the-art technology (and a little magic) to create a one-of-a-kind ride experience.', 'https://m.media-amazon.com/images/M/MV5BNDM0YzMyNGUtMTU1Yy00OTE2LWE5NzYtZDZhMTBmN2RkNjg3XkEyXkFqcGdeQXVyMzU5NjU1MDA@._V1_SX300.jpg', '8.2', 'N/A', '5 min');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'john', '$2b$10$VubFVLwaataIdan5mm6EHOdheRgE4Z3iPZR0rdL.JLlcECbHO/eyy'),
(2, 'dave', '$2b$10$zMlPOoudos/65JigC4CT/uAjbLkhnIZa8/DQvaRB5Zseijmk.69k2');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `imdb_id` (`imdb_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
