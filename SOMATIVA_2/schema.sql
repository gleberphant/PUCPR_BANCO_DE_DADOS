-- 1. faça o modelo fisico do projeto


-- CREATE Schema PUC_SOMATIVA2
DROP SCHEMA IF EXISTS `PUC_SOMATIVA2` ;
CREATE SCHEMA IF NOT EXISTS `PUC_SOMATIVA2` ;


-- seleciona o schema
USE `PUC_SOMATIVA2` ;

-- criação das tabelas

--- tabela vinho
DROP TABLE IF EXISTS `vinho`;
CREATE TABLE IF NOT EXISTS `vinho`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(50),
    `tipo_id` INT UNSIGNED NOT NULL,
    `ano` YEAR DEFAULT CURRENT_TIMESTAMP,
    `descricao` TEXT DEFAULT 'SEM DESCRIÇÃO',
    `vinicola_id` INT UNSIGNED NOT NULL,
    PRIMARY kEY(`id`),
    CONSTRAINT `fk_vinho_vinicola`
        FOREIGN KEY `vinicola_id` REFERENCES `vinicola`(`id`)
        ON DELETE NO ACTION,
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_vinho_tipo`
        FOREIGN KEY `tipo_id` REFERENCES `tipo_vinho`(`id`)
        ON DELETE NO ACTION,
        ON UPDATE NO ACTION
);

--- tabela tipo_vinho
DROP TABLE IF EXISTS `tipo_vinho`
CREATE TABLE IF NOT EXISTS `tipo_vinho`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `tipo` VARCHAR(30),
    PRIMARY KEY(`id`)

);


--- vinicola:  VINHO PERTENCE A VINICULA
DROP TABLE IF EXISTS `vinicola`;

CREATE TABLE IF NOT EXISTS `vinicola` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(100),
    `descricao` TEXT DEFAULT 'SEM DESCRIÇÃO',
    `fone` VARCHAR(15),
    `email` VARCHAR(15),
    `regiao_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`id`),
    CONSTRAINT `fk_vinicola_regiao`
        FOREIGN KEY `regiao_id` REFERENCES `regiao`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);


--- regiao: VINICULA POSSUI REGIAO
DROP TABLE IF EXISTS `regiao`;

CREATE TABLE IF NOT EXISTS `regiao`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(100) DEFAULT 'norte',
    `descricao` TEXT DEFAULT 'SEM DESCRIÇÃO',
    PRIMARY kEY(`id`)  
);


-- inserção de dados
--- 2. inserir pelo menos 5 registros em cada tabela 



--- INSERÇÃO REGIAO

START TRANSACTION;

    USE `PUC_SOMATIVA2` ;
    
    INSERT INTO `regiao` (`nome`, `descricao`) VALUES
        ('norte','descricao regiao norte'),
        ('sul','descricao regiao sul'),
        ('sudeste','descricao regiao sudeste'),
        ('nordeste','descricao regiao nordeste'),
        ('centro-oeste','descricao regiao central'); 

COMMIT;

--- INSERÇÃO VINICOLAS

START TRANSACTION;

    USE `PUC_SOMATIVA2` ;
    
    INSERT INTO `vinicola` (`nome` , `descricao`, `fone`, `email` , `regiao_id`)  VALUES
        ('Casa Perini', 'descricao da vinicola casa perini', '+558388887897', 'vinicola_casaperini@gmail.com', '1'),   
        ('Durigan', 'descricao da vinicola Durigan', '+558388887897', 'vinicola_durigan@gmail.com', '2'),
        ('Santa Helena', 'descricao da vinicola santa helana', '+558388887897', 'santa_helena@gmail.com', '3'),
        ('João Bosco', 'descricao da vinicola joao bosco', '+558388887897', 'joao_bosco@gmail.com', '4'),
        ('Garcia', 'descricao da vinicola portuguesa Garcia', '+558388887897', 'vinhos_garcia@gmail.com', '5'); 
    

COMMIT;


-- INSERVCADO DOS TIPOS DE VINHO

START TRANSACTION;
    USE `PUC_SOMATIVA2`

    INSERT INTO `tipo_vinho`(`id`, `tipo`) VALUES
        (1, 'branco'),
        (2, 'verde'),
        (3, 'rose'),
        (4, 'tinto'),
        (5, 'bordo'),
        (6, 'moscatel');

COMMIT;

--- INSERÇÃO VINHOS

START TRANSACTION;

    USE `PUC_SOMATIVA2`;

    INSERT INTO `vinho`(`nome`, `tipo_id`, `ano`, `descricao`, `vinicola_id`) VALUES
        ('Perini Rose', 3, 2010, 'descricao do vinho rose da casa perini', 1),
        ('Moscatel Premium', 6, 2022, 'descricao espumante moscatel da durigan', 2),
        ('Vinho Branco Santa Helena', 1, 2021, 'descricao do vinho branco da casa santa helena', 3),
        ('Vinho Tinto Joao Bosco', 4, 2024, 'descricao do vinho tinto joao bosco', 4),
        ('Casal Garcia', 2, 2020, 'descricao do vinho verde garcia', 5);

COMMIT;


-- Faça uma consulta que liste o nome e ano dos vinhos, incluindo o nome da vinícula e onome da região que ela pertence.
CREATE VIEW IF NOT EXISTS `lista_vinhos`
SELECT * 
FROM vinho


-- Crie um usuário Somellier, que deve ter acesso pelo localhost ao Select da tabela Vinho e ao Select do campo codVinicula e nomeVinicula da tabela Vinicula. Além disto, ele somente pode realizar 40 consultas por hora.