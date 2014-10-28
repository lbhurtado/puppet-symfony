CREATE TABLE `virtual_domains` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `virtual_users` (
  `id` int(11) NOT NULL auto_increment,
  `domain_id` int(11) NOT NULL,
  `password` varchar(106) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `virtual_aliases` (
  `id` int(11) NOT NULL auto_increment,
  `domain_id` int(11) NOT NULL,
  `source` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `mailserver`.`virtual_domains`
(`id` ,`name`)
VALUES
  ('1', 'txtcmdr.xyz'),
  ('2', 'txtcmdr.org'),
  ('3', 'txtcmdr.net');

INSERT INTO `mailserver`.`virtual_users`
(`id`, `domain_id`, `password` , `email`)
VALUES
  ('1', '1', MD5('apple1'), 'lester@txtcmdr.xyz'),
  ('2', '1', MD5('lester1'), 'apple@txtcmdr.xyz'),
  ('3', '1', ENCRYPT('firstpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email1@applester.dev'),
  ('4', '1', ENCRYPT('secondpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email2@applester.dev');

INSERT INTO `mailserver`.`virtual_aliases`
(`id`, `domain_id`, `source`, `destination`)
VALUES
  ('1', '1', 'info@txtcmdr.xyz', 'lester@txtcmdr.xyz');


