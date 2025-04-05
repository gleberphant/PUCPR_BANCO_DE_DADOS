-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema PUC_SOMATIVA1
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `PUC_SOMATIVA1` ;

-- -----------------------------------------------------
-- Schema PUC_SOMATIVA1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PUC_SOMATIVA1` DEFAULT CHARACTER SET utf8mb3 ;
USE `PUC_SOMATIVA1` ;

-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`categorias_produtos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`categorias_produtos` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`categorias_produtos` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `descricao` TINYTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`cidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`cidades` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`cidades` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`ruas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`ruas` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`ruas` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `cidade_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `cidade_id_idx` (`cidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_ruas_cidades`
    FOREIGN KEY (`cidade_id`)
    REFERENCES `PUC_SOMATIVA1`.`cidades` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`enderecos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`enderecos` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`enderecos` (
  `id` INT UNSIGNED NOT NULL,
  `rua_id` INT UNSIGNED NOT NULL,
  `cep` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `rua_id_idx` (`rua_id` ASC) VISIBLE,
  CONSTRAINT `fk_enderecos_ruas`
    FOREIGN KEY (`rua_id`)
    REFERENCES `PUC_SOMATIVA1`.`ruas` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`pessoas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`pessoas` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`pessoas` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `telefone` VARCHAR(45) NULL DEFAULT NULL,
  `endereco_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `endereco_id_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_pessoas_enderecos`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `PUC_SOMATIVA1`.`enderecos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`clientes` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`clientes` (
  `id` INT UNSIGNED NOT NULL,
  `pessoa_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pessoa_id_idx` (`pessoa_id` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_pessoas`
    FOREIGN KEY (`pessoa_id`)
    REFERENCES `PUC_SOMATIVA1`.`pessoas` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`entregador`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`entregador` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`entregador` (
  `id` INT UNSIGNED NOT NULL,
  `pessoa_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pessoa_id_idx` (`pessoa_id` ASC) VISIBLE,
  CONSTRAINT `fk_entregadores_pessoas`
    FOREIGN KEY (`pessoa_id`)
    REFERENCES `PUC_SOMATIVA1`.`pessoas` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`ingredientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`ingredientes` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`ingredientes` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `tipo` ENUM('vegetal', 'proteina', 'tempero', 'outro') NOT NULL,
  `estoque` INT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'estoque se refere a quantidade de porcoes do ingrediente\\n',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`pedidos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`pedidos` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`pedidos` (
  `id` INT UNSIGNED NOT NULL,
  `cliente_id` INT UNSIGNED NOT NULL,
  `entregador_id` INT UNSIGNED NOT NULL,
  `endereco_id` INT UNSIGNED NOT NULL,
  `data_pedido` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `observacoes` TEXT NULL DEFAULT NULL,
  `status` ENUM('aberto', 'producao', 'deslocamento', 'entregue', 'cancelado') NOT NULL DEFAULT 'aberto' COMMENT 'flag do status do pedido\\n1 - aberto: produto iniciado\\n2 - producao: quando iniciar a producao\\n3 - deslocamento: quando sair para entrega\\n4 - entregue: quando o cliente receber\\n5 - cancelado: quando for cancelado por algum motivo',
  PRIMARY KEY (`id`),
  INDEX `cliente_id_idx` (`cliente_id` ASC) VISIBLE,
  INDEX `entregador_id_idx` (`entregador_id` ASC) VISIBLE,
  INDEX `endereco_id_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_clientes`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `PUC_SOMATIVA1`.`clientes` (`id`),
  CONSTRAINT `fk_pedidos_enderecos`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `PUC_SOMATIVA1`.`enderecos` (`id`),
  CONSTRAINT `fk_pedidos_entregadores`
    FOREIGN KEY (`entregador_id`)
    REFERENCES `PUC_SOMATIVA1`.`entregador` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`produtos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`produtos` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`produtos` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `preco` DECIMAL(10,0) NULL DEFAULT NULL,
  `descricao` TINYTEXT NULL DEFAULT NULL,
  `disponivel` TINYINT NULL DEFAULT '1',
  `categoria_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `categoria_id_idx` (`categoria_id` ASC) VISIBLE,
  CONSTRAINT `fk_produtos_categorias`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `PUC_SOMATIVA1`.`categorias_produtos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`pedido_produto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`pedido_produto` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`pedido_produto` (
  `id` INT UNSIGNED NOT NULL,
  `pedido_id` INT UNSIGNED NOT NULL,
  `produto_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pedidos_produtos_idx` (`pedido_id` ASC) VISIBLE,
  INDEX `fk_produtos_pedidos_idx` (`produto_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_produtos`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `PUC_SOMATIVA1`.`pedidos` (`id`),
  CONSTRAINT `fk_produtos_pedidos`
    FOREIGN KEY (`produto_id`)
    REFERENCES `PUC_SOMATIVA1`.`produtos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = 'lista de produtos\\n';


-- -----------------------------------------------------
-- Table `PUC_SOMATIVA1`.`produto_ingrediente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`produto_ingrediente` ;

CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`produto_ingrediente` (
  `id` INT UNSIGNED NOT NULL,
  `produto_id` INT UNSIGNED NOT NULL,
  `ingrediente_id` INT UNSIGNED NOT NULL,
  `quantidade` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `produto_id_idx` (`produto_id` ASC) VISIBLE,
  INDEX `ingrediente_id_idx` (`ingrediente_id` ASC) VISIBLE,
  CONSTRAINT `fk_ingredientes_produtos`
    FOREIGN KEY (`ingrediente_id`)
    REFERENCES `PUC_SOMATIVA1`.`ingredientes` (`id`),
  CONSTRAINT `fk_produtos_ingredientes`
    FOREIGN KEY (`produto_id`)
    REFERENCES `PUC_SOMATIVA1`.`produtos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `PUC_SOMATIVA1` ;

-- -----------------------------------------------------
-- Placeholder table for view `PUC_SOMATIVA1`.`historico_pedidos_por_cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`historico_pedidos_por_cliente` (`id` INT, `data_pedido` INT, `observacoes` INT, `status` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PUC_SOMATIVA1`.`lista_de_produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PUC_SOMATIVA1`.`lista_de_produtos` (`id` INT, `data_pedido` INT, `observacoes` INT, `status` INT, `nome` INT, `preco` INT);

-- -----------------------------------------------------
-- View `PUC_SOMATIVA1`.`historico_pedidos_por_cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`historico_pedidos_por_cliente`;
DROP VIEW IF EXISTS `PUC_SOMATIVA1`.`historico_pedidos_por_cliente` ;
USE `PUC_SOMATIVA1`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `PUC_SOMATIVA1`.`historico_pedidos_por_cliente` AS select `PUC_SOMATIVA1`.`pedidos`.`id` AS `id`,`PUC_SOMATIVA1`.`pedidos`.`data_pedido` AS `data_pedido`,`PUC_SOMATIVA1`.`pedidos`.`observacoes` AS `observacoes`,`PUC_SOMATIVA1`.`pedidos`.`status` AS `status` from `PUC_SOMATIVA1`.`pedidos` order by `PUC_SOMATIVA1`.`pedidos`.`cliente_id`;

-- -----------------------------------------------------
-- View `PUC_SOMATIVA1`.`lista_de_produtos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PUC_SOMATIVA1`.`lista_de_produtos`;
DROP VIEW IF EXISTS `PUC_SOMATIVA1`.`lista_de_produtos` ;
USE `PUC_SOMATIVA1`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `PUC_SOMATIVA1`.`lista_de_produtos` AS select `PUC_SOMATIVA1`.`pedidos`.`id` AS `id`,`PUC_SOMATIVA1`.`pedidos`.`data_pedido` AS `data_pedido`,`PUC_SOMATIVA1`.`pedidos`.`observacoes` AS `observacoes`,`PUC_SOMATIVA1`.`pedidos`.`status` AS `status`,`PUC_SOMATIVA1`.`produtos`.`nome` AS `nome`,`PUC_SOMATIVA1`.`produtos`.`preco` AS `preco` from ((`PUC_SOMATIVA1`.`produtos` join `PUC_SOMATIVA1`.`pedido_produto` on((`PUC_SOMATIVA1`.`pedido_produto`.`produto_id` = `PUC_SOMATIVA1`.`produtos`.`id`))) join `PUC_SOMATIVA1`.`pedidos` on((`PUC_SOMATIVA1`.`pedido_produto`.`pedido_id` = `PUC_SOMATIVA1`.`pedidos`.`id`)));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
