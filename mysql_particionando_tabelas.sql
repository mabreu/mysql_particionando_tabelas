-- Criando a tabela cargas_naps
CREATE TABLE cargas_naps (
    data date NOT NULL,
    hora time NOT NULL,
    id_nap smallint(6) NOT NULL,
    qtde int(11) NOT NULL,
    dt_inclusao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_alteracao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (data, hora, id_nap),
    KEY idx_cargas_e1s_id_nap (id_nap)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;


-- Particionamento usando Key
ALTER TABLE cargas_naps
PARTITION BY key( id_nap )
	PARTITIONS 20;


-- Criando a tabela cargas_e1s
CREATE TABLE cargas_e1s (
    data date NOT NULL,
    hora time NOT NULL,
    id_nap smallint(6) NOT NULL,
    id_e1 smallint(6) NOT NULL,
    qtde int(11) NOT NULL,
    dt_inclusao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_alteracao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (data, hora, id_nap, id_e1),
    KEY idx_cargas_e1s_id_nap (id_nap),
    KEY idx_cargas_e1s_id_e1 (id_e1)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;


-- Particionamento usando Hash
ALTER TABLE cargas_e1s
PARTITION BY hash( month( data ) )
	PARTITIONS 12;


-- Criando tabela cargas_operadoras
CREATE TABLE cargas_operadoras (
    data date NOT NULL,
    hora time NOT NULL,
    cod_operadora smallint(6) NOT NULL,
    id_bilhetador smallint(6) NOT NULL,
    qtde int(11) NOT NULL,
    dt_inclusao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_alteracao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (data,hora,cod_operadora,id_bilhetador),
    KEY idx_cargas_operadoras_cod_operadora (cod_operadora),
    KEY idx_cargas_operadoras_id_bilhetador (id_bilhetador)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;


-- Particionamento usando List
ALTER TABLE cargas_operadoras
PARTITION BY list( month( data ) ) (
PARTITION p_cargas_operadoras_01 VALUES IN(1),
PARTITION p_cargas_operadoras_02 VALUES IN(2),
PARTITION p_cargas_operadoras_03 VALUES IN(3),
PARTITION p_cargas_operadoras_04 VALUES IN(4),
PARTITION p_cargas_operadoras_05 VALUES IN(5),
PARTITION p_cargas_operadoras_06 VALUES IN(6),
PARTITION p_cargas_operadoras_07 VALUES IN(7),
PARTITION p_cargas_operadoras_08 VALUES IN(8),
PARTITION p_cargas_operadoras_09 VALUES IN(9),
PARTITION p_cargas_operadoras_10 VALUES IN(10),
PARTITION p_cargas_operadoras_11 VALUES IN(11),
PARTITION p_cargas_operadoras_12 VALUES IN(12) );


-- Criando tabela totais_cdrs
CREATE TABLE totais_cdrs (
    data date NOT NULL,
    hora time NOT NULL,
    cn char(2) COLLATE latin1_general_ci NOT NULL,
    uf char(2) COLLATE latin1_general_ci DEFAULT NULL,
    cod_operadora smallint(6) DEFAULT NULL,
    id_projeto smallint(6) DEFAULT NULL,
    id_provedor smallint(6) DEFAULT NULL,
    qtde int(11) NOT NULL,
    duracao bigint(20) NOT NULL,
    dt_inclusao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_alteracao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (data, hora, cn, uf, cod_operadora, id_projeto, id_provedor),
    KEY fk_totais_cdrs_ufs1_idx (uf),
    KEY fk_totais_cdrs_projetos1_idx (id_projeto),
    KEY fk_totais_cdrs_provedores1_idx (id_provedor),
    KEY fk_totais_cdrs_operadoras1_idx (cod_operadora),
    CONSTRAINT fk_totais_cdrs_operadoras FOREIGN KEY (cod_operadora) REFERENCES geral.operadoras (cod_operadora) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_totais_cdrs_projetos FOREIGN KEY (id_projeto) REFERENCES geral.projetos (id_projeto) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_totais_cdrs_provedores FOREIGN KEY (id_provedor) REFERENCES geral.provedores (id_provedor) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_totais_cdrs_ufs FOREIGN KEY (uf) REFERENCES geral.ufs (uf) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;


-- Particionando por Range
ALTER TABLE totais_cdrs
PARTITION BY range( year( data ) ) (
	PARTITION p_totais_cdrs_2014 VALUES LESS THAN (2015),
	PARTITION p_totais_cdrs_2015 VALUES LESS THAN (2016),
	PARTITION p_totais_cdrs_2016 VALUES LESS THAN (2017),
	PARTITION p_totais_cdrs_2017 VALUES LESS THAN (2018),
	PARTITION p_totais_cdrs_2018 VALUES LESS THAN (2019),
	PARTITION p_totais_cdrs_2019 VALUES LESS THAN (MAXVALUE)
);


-- Tabela cargas_bilhetadores
CREATE TABLE cargas_bilhetadores (
    data date NOT NULL,
    hora time NOT NULL,
    id_bilhetador smallint(6) NOT NULL,
    qtde int(11) NOT NULL,
    dt_inclusao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dt_alteracao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (data, hora, id_bilhetador),
    KEY idx_cargas_bilhetadores_id_bilhetador (id_bilhetador)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;


-- Particionamento com sub-partições
ALTER TABLE cargas_bilhetadores
PARTITION BY LIST( month( data ) )
SUBPARTITION BY HASH( id_bilhetador - 1 ) (
	PARTITION p_cargas_bilhetadores_01 VALUES IN(1) (
        SUBPARTITION sp_cargas_bilhetadores_01_1,
		SUBPARTITION sp_cargas_bilhetadores_01_2,
		SUBPARTITION sp_cargas_bilhetadores_01_3
	),
	PARTITION p_cargas_bilhetadores_02 VALUES IN(2) (
        SUBPARTITION sp_cargas_bilhetadores_02_1,
		SUBPARTITION sp_cargas_bilhetadores_02_2,
		SUBPARTITION sp_cargas_bilhetadores_02_3
	),
	PARTITION p_cargas_bilhetadores_03 VALUES IN(3) (
        SUBPARTITION sp_cargas_bilhetadores_03_1,
		SUBPARTITION sp_cargas_bilhetadores_03_2,
		SUBPARTITION sp_cargas_bilhetadores_03_3
	),
	PARTITION p_cargas_bilhetadores_04 VALUES IN(4) (
        SUBPARTITION sp_cargas_bilhetadores_04_1,
		SUBPARTITION sp_cargas_bilhetadores_04_2,
		SUBPARTITION sp_cargas_bilhetadores_04_3
	),
	PARTITION p_cargas_bilhetadores_05 VALUES IN(5) (
        SUBPARTITION sp_cargas_bilhetadores_05_1,
		SUBPARTITION sp_cargas_bilhetadores_05_2,
		SUBPARTITION sp_cargas_bilhetadores_05_3
	),
	PARTITION p_cargas_bilhetadores_06 VALUES IN(6) (
        SUBPARTITION sp_cargas_bilhetadores_06_1,
		SUBPARTITION sp_cargas_bilhetadores_06_2,
		SUBPARTITION sp_cargas_bilhetadores_06_3
	),
	PARTITION p_cargas_bilhetadores_07 VALUES IN(7) (
        SUBPARTITION sp_cargas_bilhetadores_07_1,
		SUBPARTITION sp_cargas_bilhetadores_07_2,
		SUBPARTITION sp_cargas_bilhetadores_07_3
	),
	PARTITION p_cargas_bilhetadores_08 VALUES IN(8) (
        SUBPARTITION sp_cargas_bilhetadores_08_1,
		SUBPARTITION sp_cargas_bilhetadores_08_2,
		SUBPARTITION sp_cargas_bilhetadores_08_3
	),
	PARTITION p_cargas_bilhetadores_09 VALUES IN(9) (
        SUBPARTITION sp_cargas_bilhetadores_09_1,
		SUBPARTITION sp_cargas_bilhetadores_09_2,
		SUBPARTITION sp_cargas_bilhetadores_09_3
	),
	PARTITION p_cargas_bilhetadores_10 VALUES IN(10) (
        SUBPARTITION sp_cargas_bilhetadores_10_1,
		SUBPARTITION sp_cargas_bilhetadores_10_2,
		SUBPARTITION sp_cargas_bilhetadores_10_3
	),
	PARTITION p_cargas_bilhetadores_11 VALUES IN(11) (
        SUBPARTITION sp_cargas_bilhetadores_11_1,
		SUBPARTITION sp_cargas_bilhetadores_11_2,
		SUBPARTITION sp_cargas_bilhetadores_11_3
	),
	PARTITION p_cargas_bilhetadores_12 VALUES IN(12) (
        SUBPARTITION sp_cargas_bilhetadores_12_1,
		SUBPARTITION sp_cargas_bilhetadores_12_2,
		SUBPARTITION sp_cargas_bilhetadores_12_3
	)
);


-- Verificando as partições das tabelas
SELECT table_schema, table_name, partition_name, table_rows,
	round((data_length + index_length) / 1024 / 1024, 2) AS "Tamanho (MB)"
FROM information_schema.partitions
WHERE table_schema = 'overloaded' AND table_name LIKE 'cargas_%' AND table_rows > 0;
