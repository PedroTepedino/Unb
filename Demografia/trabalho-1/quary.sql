USE demog;

DROP TABLE aux_doba;
CREATE TABLE aux_doba LIKE aux_do;

DROP TABLE aux_does;

CALL PROC_AUX_DO('ba');
SELECT * FROM tmptable;


CREATE TABLE aux_does LIKE aux_doba;
CALL PROC_AUX_DO('es');
select * from aux_does;


CREATE TABLE aux_dope LIKE aux_doba;
CALL PROC_AUX_DO('pe');
select * from aux_dope;

SHOW CREATE TABLE aux_dnba;


CREATE TABLE `aux_do` (
  `index` int NOT NULL AUTO_INCREMENT,
  `DTOBITO` text,
  `DTNASC` text,
  `IDADE` text,
  `ANOORIGEM` int NOT NULL,
  `CONT` int NOT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `uc_origem_cont` (`ANOORIGEM`,`CONT`)
);


CREATE TABLE `aux_date` (
  `index` int NOT NULL AUTO_INCREMENT,
  `DTOBITO` text,
  `DTNASC` text,
  `IDADE` text,
  `ANOORIGEM` int NOT NULL,
  `CONT` int NOT NULL,
  `DATAOBITO` date DEFAULT NULL,
  `DATANASC` date DEFAULT NULL,
  `DATADIFF` double DEFAULT NULL,
  `IDADECONVERT` double DEFAULT NULL,
  `SEXO` int DEFAULT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `uc_origem_cont` (`ANOORIGEM`,`CONT`)
);

CREATE TABLE `aux_dnba` (
    `ANOORIGEM` int DEFAULT NULL,
    `DTNASC` text,
    `IDADEMAE` int DEFAULT NULL,
    `SEXO` int DEFAULT NULL
);

DROP TABLE aux_dnba;
CALL PROC_DN_AUX('ba');
SELECT * FROM aux_dnba;

ALTER TABLE `demog`.`aux_dnba` 
ADD COLUMN `x` INT NULL AFTER `SEXO`,
ADD COLUMN `n` INT NULL AFTER `x`;


DROP TABLE aux_dnrn;
CREATE TABLE aux_dnrn LIKE aux_dnba;
CALL PROC_DN_AUX('rn');
SELECT * FROM aux_dnrn;

UPDATE aux_dnba 
	SET
		x = (IDADEMAE DIV 5) * 5,
        n = 5;
        
UPDATE aux_dnrn 
	SET
		x = (IDADEMAE DIV 5) * 5,
        n = 5;

DROP TABLE aux_dnrn;        
CREATE TABLE aux_dnrn LIKE aux_dnba;
CALL PROC_DN_AUX('rn');
SELECT * FROM aux_dnrn;

SELECT ANOORIGEM, SEXO, x, n, COUNT(*) COUNT 
	FROM aux_dnba 
	WHERE ANOORIGEM IN (2014, 2015, 2016) AND SEXO != 0 AND IDADEMAE != 99 
	GROUP BY ANOORIGEM, SEXO, n, x
    ORDER BY ANOORIGEM, SEXO, x
    ;
    
SELECT ANOORIGEM, x, n, COUNT(*) COUNT 
	FROM aux_dnba 
	WHERE ANOORIGEM IN (2009, 2010, 2011) AND SEXO != 0 AND IDADEMAE != 99 
	GROUP BY ANOORIGEM, n, x
    ORDER BY ANOORIGEM, x
    ;    
    
    
SELECT ANOORIGEM, SEXO, x, n, COUNT(*) COUNT 
	FROM aux_dnba 
	WHERE ANOORIGEM IN (2014, 2015, 2016) AND SEXO != 0 AND IDADEMAE != 99 
	GROUP BY ANOORIGEM, SEXO, n, x
    ORDER BY ANOORIGEM, SEXO, x
    ;
    
SELECT ANOORIGEM, SEXO, x, n, COUNT(*) COUNT 
	FROM aux_dnrn
	WHERE ANOORIGEM IN (2014, 2015, 2016) AND SEXO != 0 AND IDADEMAE != 99 
	GROUP BY ANOORIGEM, SEXO, n, x
    ORDER BY ANOORIGEM, SEXO, x
    ;


SELECT ANOORIGEM, SEXO, x, n, COUNT(*) COUNT 
	FROM aux_dnba 
	WHERE ANOORIGEM IN (2009, 2010, 2011) AND SEXO != 0 AND IDADEMAE != 99 
	GROUP BY ANOORIGEM, SEXO, n, x
    ORDER BY ANOORIGEM, SEXO, x
    ;    
    
    
SELECT ANOORIGEM, IDADEMAE, SEXO, COUNT(*) COUNT 
	FROM aux_dnba 
	GROUP BY ANOORIGEM, IDADEMAE, SEXO
    ORDER BY ANOORIGEM, SEXO, IDADEMAE
    ;
    
SELECT * FROM aux_dnba;
    


CREATE TABLE aux_dtba LIKE aux_date;
CREATE TABLE aux_dtrn LIKE aux_date;
CREATE TABLE aux_dtes LIKE aux_date;
CREATE TABLE aux_dtpe LIKE aux_date;

DROP TABLE aux_dtes;
INSERT INTO aux_dtba (DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO) 
	SELECT DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO 
    FROM aux_doba 
    ORDER BY `index`;


INSERT INTO aux_dtrn (DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO) 
	SELECT DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO 
    FROM aux_dorn 
    ORDER BY `index`;


INSERT INTO aux_dtes (DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO) 
	SELECT DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO 
    FROM aux_does 
    ORDER BY `index`;
    

INSERT INTO aux_dtpe (DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO) 
	SELECT DTOBITO, DTNASC, IDADE, ANOORIGEM, CONT, SEXO 
    FROM aux_dope 
    ORDER BY `index`;
    
    
UPDATE aux_dtba 
	SET DATAOBITO = FUNC_STRING_TO_DATE(DTOBITO),
		DATANASC = FUNC_STRING_TO_DATE(DTNASC),
        DATADIFF = DATEDIFF(DATAOBITO, DATANASC) / 365,
        IDADECONVERT = FUNC_DECODE_IDADE(IDADE);

UPDATE aux_dtrn 
	SET DATAOBITO = FUNC_STRING_TO_DATE(DTOBITO),
		DATANASC = FUNC_STRING_TO_DATE(DTNASC),
        DATADIFF = DATEDIFF(DATAOBITO, DATANASC) / 365,
        IDADECONVERT = FUNC_DECODE_IDADE(IDADE);
        
UPDATE aux_dtes 
	SET DATAOBITO = FUNC_STRING_TO_DATE(DTOBITO),
		DATANASC = FUNC_STRING_TO_DATE(DTNASC),
        DATADIFF = DATEDIFF(DATAOBITO, DATANASC) / 365,
        IDADECONVERT = FUNC_DECODE_IDADE(IDADE);

UPDATE aux_dtpe 
	SET DATAOBITO = FUNC_STRING_TO_DATE(DTOBITO),
		DATANASC = FUNC_STRING_TO_DATE(DTNASC),
        DATADIFF = DATEDIFF(DATAOBITO, DATANASC) / 365,
        IDADECONVERT = FUNC_DECODE_IDADE(IDADE);

select * from aux_dtes;

DROP TABLE LEXISBA;
CREATE TABLE LEXISBA
SELECT 
	`index`, 
	CONT, 
	ANOORIGEM ANOBITO, 
    YEAR(DATANASC) COORTE, 
    FLOOR(DATADIFF) ANOSCOMPDIFF, 
    FLOOR(IDADECONVERT) ANOSCOMPCONVERT 
		FROM aux_dtba;


DROP TABLE IF EXISTS LEXISRN;
CREATE TABLE LEXISRN
SELECT 
	`index`, 
	CONT, 
	ANOORIGEM ANOBITO, 
    YEAR(DATANASC) COORTE, 
    FLOOR(DATADIFF) ANOSCOMPDIFF, 
    FLOOR(IDADECONVERT) ANOSCOMPCONVERT 
		FROM aux_dtrn;
       
       
CREATE TABLE morte_2000_2021_menor_5_rn
SELECT COORTE, COUNT(*) 
	FROM LEXISRN
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5
	GROUP BY COORTE
    ORDER BY COORTE
    ;
    
-- CREATE TABLE morte_2000_2021_menor_5_ba 
SELECT COORTE, COUNT(*) 
	FROM LEXISBA
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5
	GROUP BY COORTE
    ORDER BY COORTE
    ;
    
SELECT ANORIGEM COORTE, COUNT(*) FROM aux_dnba GROUP BY COORTE;

-- OBITOS RN
SELECT  COUNT(*) OBITOS 
	FROM LEXISRN
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5;    

-- NASCIMENTOS RN
SELECT SUM(CONT) NASCIMENTOS
	FROM aux_dnrn_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2016 ;

SELECT rate.OBITOS / rate.NASCIMENTOS p
FROM (SELECT 1 id,  COUNT(*) OBITOS 
	FROM LEXISRN
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5
UNION ALL

SELECT 1 id, SUM(CONT) NASCIMENTOS
	FROM aux_dnrn_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2016 ) rate;

SELECT ob.OBITOS / nasc.NASCIMENTOS pmorrer, 1 - (ob.OBITOS / nasc.NASCIMENTOS) psob
FROM (SELECT 1 id,  COUNT(*) OBITOS 
	FROM LEXISRN
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5) ob
        INNER JOIN 
(SELECT 1 id, SUM(CONT) NASCIMENTOS
	FROM aux_dnrn_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2016 ) nasc;
   
SELECT ob.OBITOS / nasc.NASCIMENTOS pmorrer, 1 - (ob.OBITOS / nasc.NASCIMENTOS) psob
FROM (SELECT 1 id,  COUNT(*) OBITOS 
	FROM LEXISRN
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2020
        AND ANOSCOMPCONVERT < 1) ob
        INNER JOIN 
(SELECT 1 id, SUM(CONT) NASCIMENTOS
	FROM aux_dnrn_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2020 ) nasc;
    
    
    
SELECT ob.OBITOS / nasc.NASCIMENTOS pmorrer, 1 - (ob.OBITOS / nasc.NASCIMENTOS) psob
FROM (SELECT 1 id,  COUNT(*) OBITOS 
	FROM LEXISBA
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5) ob
        INNER JOIN 
(SELECT 1 id, SUM(CONT) NASCIMENTOS
	FROM aux_dnba_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2016 ) nasc

UNION ALL
   
SELECT ob.OBITOS / nasc.NASCIMENTOS pmorrer, 1 - (ob.OBITOS / nasc.NASCIMENTOS) psob
FROM (SELECT 1 id,  COUNT(*) OBITOS 
	FROM LEXISBA
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2020
        AND ANOSCOMPCONVERT < 1) ob
        INNER JOIN 
(SELECT 1 id, SUM(CONT) NASCIMENTOS
	FROM aux_dnba_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2020 ) nasc;
    
    
SELECT  "OBITOS BA",COUNT(*) 
	FROM LEXISBA
    WHERE COORTE IS NOT NULL 
		AND COORTE >= 2000 AND COORTE <= 2016
        AND ANOSCOMPCONVERT < 5; 
        
SELECT "NASC BA", SUM(CONT)
	FROM aux_dnba_count
	WHERE YEAR(ANOCORR) BETWEEN 2000 AND 2016 ;
    
SELECT 
    ANOBITO,
    COORTE,
    ANOSCOMPDIFF,
    COUNT(*) `COUNT`
	FROM LEXISBA
	WHERE COORTE = 2010
	GROUP BY ANOBITO, COORTE, ANOSCOMPDIFF
	ORDER BY  ANOBITO, COORTE, ANOSCOMPDIFF
    ;
    

DROP TABLE lexis_ba;
CREATE TABLE lexis_ba
SELECT 
    ANOBITO,
    MAKEDATE(ANOBITO, 365 * IF((ANOBITO - COORTE) - ANOSCOMPDIFF, 1/4, 3/4)) ANOCORR,
    COORTE,
    ANOSCOMPDIFF,
    IF((ANOBITO - COORTE) - ANOSCOMPDIFF, ANOSCOMPDIFF + 0.75, ANOSCOMPDIFF + 0.25) ANOSCORR,
    COUNT(*) `COUNT`
	FROM LEXISBA
	WHERE ANOSCOMPDIFF BETWEEN 0 AND 5
	GROUP BY ANOBITO, COORTE, ANOSCOMPDIFF
	ORDER BY  ANOBITO, COORTE, ANOSCOMPDIFF
    ;
    
SELECT COUNT(*)  FROM lexis_ba; 

DROP TABLE lexis_rn;
CREATE TABLE lexis_rn
SELECT 
    ANOBITO,
    MAKEDATE(ANOBITO, 365 * IF((ANOBITO - COORTE) - ANOSCOMPDIFF, 1/4, 3/4)) ANOCORR,
    COORTE,
    ANOSCOMPDIFF,
    IF((ANOBITO - COORTE) - ANOSCOMPDIFF, ANOSCOMPDIFF + 0.75, ANOSCOMPDIFF + 0.25) ANOSCORR,
    COUNT(*) `COUNT`
	FROM LEXISRN
	-- WHERE ANOSCOMPDIFF BETWEEN 0 AND 5
	GROUP BY ANOBITO, COORTE, ANOSCOMPDIFF
	ORDER BY  ANOBITO, COORTE, ANOSCOMPDIFF
    ;

SELECT 
	ANOORIGEM,
	COUNT(*) TOTAL,
	SUM(IF(FUNC_IS_VALID_DATE(DTOBITO), 0, 1)) INVALIDOBITO,
	SUM(IF(FUNC_IS_VALID_DATE(DTNASC), 0, 1)) INVALIDNASC,
    SUM(IF(FUNC_IS_VALID_IDADE(IDADE), 0, 1)) INVALIDIDADE
    FROM aux_dorn
		GROUP BY ANOORIGEM;


SELECT 
	ANOORIGEM,
	COUNT(*) TOTAL,
	SUM(IF(FUNC_IS_VALID_DATE(DTOBITO), 0, 1)) INVALIDOBITO,
	SUM(IF(FUNC_IS_VALID_DATE(DTNASC), 0, 1)) INVALIDNASC,
    SUM(IF(FUNC_IS_VALID_IDADE(IDADE), 0, 1)) INVALIDIDADE
    FROM aux_doba
		GROUP BY ANOORIGEM;
        
        
SELECT * FROM dnrn2020;

SELECT COUNT(*) 
	FROM lexis_rn
    WHERE COORTE BETWEEN 2000 AND 2016;

    
-- DROP TABLE IF EXISTS aux_dnrn_count;
-- CREATE TABLE aux_dnrn_count 

SELECT 
    MAKEDATE(ANORIGEM, IF (ANORIGEM % 4 = 0, 1, 0) + 182) ANOCORR, COUNT(*) CONT 
    FROM aux_dnrn 
    GROUP BY ANORIGEM;


DROP TABLE IF EXISTS aux_dnba_count;
CREATE TABLE aux_dnba_count
SELECT 
    MAKEDATE(ANORIGEM, IF (ANORIGEM % 4 = 0, 1, 0) + 182) ANOCORR, 
    COUNT(*) CONT 
    FROM aux_dnba 
    GROUP BY ANORIGEM;
    

SELECT `index`, ANOORIGEM, CONT, DATANASC, DATAOBITO, IDADE, DATADIFF, IDADECONVERT 
	FROM aux_dtba 
	WHERE ANOORIGEM = 2010;

CREATE  TABLE aux_ano_pessoa_vividos_ba
SELECT * FROM aux_dtba WHERE `index` NOT IN (
	SELECT `index`
		FROM aux_dtba
		WHERE 
			(ANOORIGEM = 2010 OR ANOORIGEM = 2019 OR ANOORIGEM = 2021)
			AND
			NOT FUNC_IS_VALID_DATE(DTNASC) AND NOT FUNC_IS_VALID_IDADE(IDADE))
        ;


CREATE  TABLE aux_ano_pessoa_vividos_es
SELECT * FROM aux_dtes WHERE `index` NOT IN (
	SELECT `index`
		FROM aux_dtes
		WHERE 
			(ANOORIGEM = 2010 OR ANOORIGEM = 2019 OR ANOORIGEM = 2021)
			AND
			NOT FUNC_IS_VALID_DATE(DTNASC) AND NOT FUNC_IS_VALID_IDADE(IDADE))
        ;

SELECT 
	`aux_ano_pessoa_vividos_ba`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_ano_pessoa_vividos_ba 
    WHERE ANOORIGEM IN (2010, 2019, 2021)
    HAVING TEMPOVIVIDO IS NOT NULL
    ;


DROP TABLE life_table;
CREATE TABLE life_table_es
SELECT 
	`index`,
	ANOORIGEM,
    CONT,
	TEMPOVIVIDO,
    CASE
		WHEN TEMPOVIVIDO < 1 THEN 0
        WHEN TEMPOVIVIDO < 4 THEN 1
        WHEN TEMPOVIVIDO < 90 THEN (FLOOR(TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN TEMPOVIVIDO < 1 THEN 1
        WHEN TEMPOVIVIDO < 4 THEN 4
        WHEN TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n 
	FROM aux_tempo_vivido
;

SELECT *,
	TEMPOVIVIDO - x nkx
	FROM life_table
    WHERE x = 20
    ;
    
SELECT ANOORIGEM, x, COUNT(*)
	FROM life_table
    GROUP BY ANOORIGEM, x;
    
    
SELECT DISTINCT ANOORIGEM FROM aux_tempo_vivido;
SELECT DISTINCT x, n
	FROM life_table;
    
DROP TABLE life_table_raw;
CREATE TABLE life_table_raw
SELECT `index`, ANOORIGEM, CONT,
	TEMPOVIVIDO, 
    TEMPOVIVIDO - FLOOR(TEMPOVIVIDO) TEMPVIVIDOINTERVALO,
	IF ( TEMPOVIVIDO < 90, FLOOR(TEMPOVIVIDO), 90) x,
    IF ( TEMPOVIVIDO < 90, 1, NULL) n
    FROM aux_tempo_vivido
    ;

DROP TABLE death_table;
CREATE TABLE death_table
SELECT ANOORIGEM, 
	x, 
	n, 
	COUNT(*) CONTMORTES,
    SUM(TEMPVIVIDOINTERVALO) / COUNT(*) nkx
    FROM life_table_raw
    GROUP BY x, ANOORIGEM, n
    ORDER BY ANOORIGEM;
    
DROP TABLE life_table;
CREATE TABLE life_table
SELECT 
	death_table.ANOORIGEM, 
	death_table.x, 
	death_table.n, 
    death_table.nkx,
	death_table.CONTMORTES,
    populacao_ba.POPULACAO
	FROM death_table
    INNER JOIN populacao_ba ON death_table.ANOORIGEM = populacao_ba.ANOORIGEM AND death_table.x = populacao_ba.IDADEEXATA;

ALTER TABLE `demog`.`life_table` ADD COLUMN `nMx` 	DOUBLE NULL AFTER `POPULACAO`;
ALTER TABLE `demog`.`life_table` ADD COLUMN `nqx` 	DOUBLE NULL AFTER `nMx`;
ALTER TABLE `demog`.`life_table` ADD COLUMN `lx` 	DOUBLE NULL AFTER `nqx`;
ALTER TABLE `demog`.`life_table` ADD COLUMN `ndx` 	DOUBLE NULL AFTER `lx`;


UPDATE life_table 
	SET lx = IF (x = 0, 100000, NULL);

UPDATE life_table 
	SET nMx = CONTMORTES / POPULACAO;
    
SELECT * FROM life_table;

UPDATE life_table 
	SET nqx = (n * nMx) / (1 + ((n - nkx) * nMx));    
UPDATE life_table 
	SET nqx = 1
    WHERE nqx IS NULL;

SELECT ANOORIGEM, SUM(nqx) 
	FROM life_table
    GROUP BY ANOORIGEM;
   
DROP TABLE lf_test;
CREATE TABLE lf_test 
SELECT * FROM life_table;

SELECT * FROM aux_ano_pessoa_vividos_ba;
SELECT *, 
	CASE
		WHEN TEMPOVIVIDO < 1 THEN 0
        WHEN TEMPOVIVIDO < 4 THEN 1
        WHEN TEMPOVIVIDO < 90 THEN (FLOOR(TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN TEMPOVIVIDO < 1 THEN 1
        WHEN TEMPOVIVIDO < 4 THEN 4
        WHEN TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM aux_dtba;
    
SELECT * FROM aux_dtba;
SELECT `aux_dtba`.*, doba2000.SEXO 
	FROM aux_dtba 
    INNER JOIN doba2000
    ON `aux_dtba`.`index` = doba2000.`index` AND `aux_dtba`.ANOORIGEM = 2000;
    
DROP TABLE aux_doba;
DROP table aux_dorn;
CREATE TABLE aux_dorn LIKE aux_doba;
CALL PROC_AUX_DO('rn');
SELECT * FROM aux_dtba;
SELECT * FROM aux_dtrn;

CREATE TABLE `aux_doba` (
  `index` int NOT NULL AUTO_INCREMENT,
  `DTOBITO` text,
  `DTNASC` text,
  `IDADE` text,
  `ANOORIGEM` int NOT NULL,
  `CONT` int NOT NULL,
  `SEXO` int DEFAULT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `uc_origem_cont` (`ANOORIGEM`,`CONT`)
  );
  
  
        
-- life table
DROP TABLE aux_tempo_vivido_ba;

CREATE TABLE aux_tempo_vivido_ba
SELECT 
	`aux_dtba`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtba
    WHERE ANOORIGEM IN (2010, 2019, 2021)
    HAVING TEMPOVIVIDO IS NOT NULL
    ;

CREATE TABLE aux_tempo_vivido_ba
SELECT aux.*, 
	CASE 
		WHEN aux.TEMPOVIVIDO < 1 THEN 0
        WHEN aux.TEMPOVIVIDO < 5 THEN 1
        WHEN aux.TEMPOVIVIDO < 90 THEN (FLOOR(aux.TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN aux.TEMPOVIVIDO < 1 THEN 1
        WHEN aux.TEMPOVIVIDO < 5 THEN 4
        WHEN aux.TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM (SELECT 
	`aux_dtba`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtba
    HAVING TEMPOVIVIDO IS NOT NULL) aux
    ;
    
    
DROP TABLE aux_tempo_vivido_rn;
CREATE TABLE aux_tempo_vivido_rn
SELECT aux.*, 
	CASE 
		WHEN aux.TEMPOVIVIDO < 1 THEN 0
        WHEN aux.TEMPOVIVIDO < 5 THEN 1
        WHEN aux.TEMPOVIVIDO < 90 THEN (FLOOR(aux.TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN aux.TEMPOVIVIDO < 1 THEN 1
        WHEN aux.TEMPOVIVIDO < 5 THEN 4
        WHEN aux.TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM (SELECT 
	`aux_dtba`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtba
    HAVING TEMPOVIVIDO IS NOT NULL) aux
    ;
    
SELECT * FROM aux_tempo_vivido_ba;
SELECT * FROM populacao_ba;



DELETE FROM aux_tempo_vivido_ba WHERE SEXO NOT IN (1, 2);
SELECT DISTINCT SEXO, ANOORIGEM, COUNT(SEXO) 
	FROM aux_tempo_vividlife_table_bao_ba
    GROUP BY SEXO, ANOORIGEM;
    
DROP TABLE aux_tempo_medio_vivido_intevalo;
CREATE TABLE aux_tempo_medio_vivido_intevalo
SELECT 	aux.ANOORIGEM, 
		aux.SEXO, 
		aux.CONTAGEM CONTMORTES, 
        populacao_ba.CONTAGEM POPTOTAL, 
        aux.x, 
        aux.n, 
        aux.nkx,
		aux.CONTAGEM / populacao_ba.CONTAGEM nMx
        FROM(
SELECT ANOORIGEM, SEXO, COUNT(*) CONTAGEM, x,  n,
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_ba 
    GROUP BY ANOORIGEM, x, SEXO, n

UNION ALL
 
SELECT ANOORIGEM, NULL SEXO, COUNT(*) CONTAGEM, x,  n, 
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_ba 
    GROUP BY ANOORIGEM, x, n
    ) aux
    JOIN populacao_ba 
		ON aux.ANOORIGEM = populacao_ba.ANOORIGEM 
        AND ((aux.SEXO = populacao_ba.SEXO) OR (aux.SEXO IS NULL AND populacao_ba.SEXO IS NULL)) 
        AND aux.x = populacao_ba.x 
        AND ((aux.n = populacao_ba.n) OR (aux.n IS NULL AND populacao_ba.n IS NULL))
ORDER BY aux.ANOORIGEM, aux.SEXO, aux.x, aux.n
   ;
    
SELECT * FROM aux_tempo_medio_vivido_intevalo;

DROP TABLE life_table_ba;
CREATE TABLE life_table_ba
SELECT *,
	IF (n IS NOT NULL,(n * nMx) / (1 + ((n - nkx)* nMx)), 1) nqx
	FROM aux_tempo_medio_vivido_intevalo;
    
SELECT * FROM life_table_ba;
    


-- life table
CREATE TABLE aux_tempo_vivido_rn
SELECT 
	`aux_dtrn`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtrn
    WHERE ANOORIGEM IN (2010, 2019, 2021)
    HAVING TEMPOVIVIDO IS NOT NULL
    ;
    
CREATE TABLE aux_tempo_vivido_rn
SELECT aux.*, 
	CASE 
		WHEN aux.TEMPOVIVIDO < 1 THEN 0
        WHEN aux.TEMPOVIVIDO < 5 THEN 1
        WHEN aux.TEMPOVIVIDO < 90 THEN (FLOOR(aux.TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN aux.TEMPOVIVIDO < 1 THEN 1
        WHEN aux.TEMPOVIVIDO < 5 THEN 4
        WHEN aux.TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM (SELECT 
	`aux_dtrn`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtrn
    WHERE ANOORIGEM IN (2010, 2019, 2021) 
    HAVING TEMPOVIVIDO IS NOT NULL) aux
    ;

SELECT * FROM aux_tempo_vivido_rn;
SELECT * FROM populacao_rn;

DELETE FROM aux_tempo_vivido_rn WHERE SEXO NOT IN (1, 2);
SELECT DISTINCT SEXO, ANOORIGEM, COUNT(SEXO) 
	FROM aux_tempo_vivido_rn
    GROUP BY SEXO, ANOORIGEM;
    
DROP TABLE aux_tempo_medio_vivido_intevalo_rn;
CREATE TABLE aux_tempo_medio_vivido_intevalo_rn
SELECT 	aux.ANOORIGEM, 
		aux.SEXO, 
		aux.CONTAGEM CONTMORTES, 
        populacao_rn.CONTAGEM POPTOTAL, 
        aux.x, 
        aux.n, 
        aux.nkx,
		aux.CONTAGEM / populacao_rn.CONTAGEM nMx
        FROM(
SELECT ANOORIGEM, SEXO, COUNT(*) CONTAGEM, x,  n,
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_rn 
    GROUP BY ANOORIGEM, x, SEXO, n

UNION ALL
 
SELECT ANOORIGEM, NULL SEXO, COUNT(*) CONTAGEM, x,  n, 
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_rn 
    GROUP BY ANOORIGEM, x, n
    ) aux
    JOIN populacao_rn
		ON aux.ANOORIGEM = populacao_rn.ANOORIGEM 
        AND ((aux.SEXO = populacao_rn.SEXO) OR (aux.SEXO IS NULL AND populacao_rn.SEXO IS NULL)) 
        AND aux.x = populacao_rn.x 
        AND ((aux.n = populacao_rn.n) OR (aux.n IS NULL AND populacao_rn.n IS NULL))
ORDER BY aux.ANOORIGEM, aux.SEXO, aux.x, aux.n
   ;
    
SELECT * FROM aux_tempo_medio_vivido_intevalo_rn;

DROP TABLE life_table_ba;
CREATE TABLE life_table_rn
SELECT *,
	IF (n IS NOT NULL,(n * nMx) / (1 + ((n - nkx)* nMx)), 1) nqx
	FROM aux_tempo_medio_vivido_intevalo_rn;
    
SELECT * FROM life_table_rn;




-- life table
DROP TABLE aux_tempo_vivido_es;
CREATE TABLE aux_tempo_vivido_es
SELECT 
	`aux_dtes`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtes
    WHERE ANOORIGEM IN (2010, 2019, 2021)
    HAVING TEMPOVIVIDO IS NOT NULL
    ;
    
CREATE TABLE aux_tempo_vivido_es
SELECT aux.*, 
	CASE 
		WHEN aux.TEMPOVIVIDO < 1 THEN 0
        WHEN aux.TEMPOVIVIDO < 5 THEN 1
        WHEN aux.TEMPOVIVIDO < 90 THEN (FLOOR(aux.TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN aux.TEMPOVIVIDO < 1 THEN 1
        WHEN aux.TEMPOVIVIDO < 5 THEN 4
        WHEN aux.TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM (SELECT 
	`aux_dtes`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtes
    WHERE ANOORIGEM IN (2010, 2019, 2021) 
    HAVING TEMPOVIVIDO IS NOT NULL) aux
    ;

SELECT * FROM aux_tempo_vivido_es;
SELECT * FROM populacao_es;

DELETE FROM aux_tempo_vivido_es WHERE SEXO NOT IN (1, 2);
SELECT DISTINCT SEXO, ANOORIGEM, COUNT(SEXO) 
	FROM aux_tempo_vivido_es
    GROUP BY SEXO, ANOORIGEM;
    
DROP TABLE aux_tempo_medio_vivido_intevalo_es;
CREATE TABLE aux_tempo_medio_vivido_intevalo_es
SELECT 	aux.ANOORIGEM, 
		aux.SEXO, 
		aux.CONTAGEM CONTMORTES, 
        populacao_es.CONTAGEM POPTOTAL, 
        aux.x, 
        aux.n, 
        aux.nkx,
		aux.CONTAGEM / populacao_es.CONTAGEM nMx
        FROM(
SELECT ANOORIGEM, SEXO, COUNT(*) CONTAGEM, x,  n,
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_es 
    GROUP BY ANOORIGEM, x, SEXO, n

UNION ALL
 
SELECT ANOORIGEM, NULL SEXO, COUNT(*) CONTAGEM, x,  n, 
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_es
    GROUP BY ANOORIGEM, x, n
    ) aux
    JOIN populacao_es
		ON aux.ANOORIGEM = populacao_es.ANOORIGEM 
        AND ((aux.SEXO = populacao_es.SEXO) OR (aux.SEXO IS NULL AND populacao_es.SEXO IS NULL)) 
        AND aux.x = populacao_es.x 
        AND ((aux.n = populacao_es.n) OR (aux.n IS NULL AND populacao_es.n IS NULL))
ORDER BY aux.ANOORIGEM, aux.SEXO, aux.x, aux.n
   ;
    
SELECT * FROM aux_tempo_medio_vivido_intevalo_es;

DROP TABLE life_table_es;
CREATE TABLE life_table_es
SELECT *,
	IF (n IS NOT NULL,(n * nMx) / (1 + ((n - nkx)* nMx)), 1) nqx
	FROM aux_tempo_medio_vivido_intevalo_es;
    
SELECT * FROM life_table_es;




CREATE TABLE aux_tempo_vivido_pe
SELECT aux.*, 
	CASE 
		WHEN aux.TEMPOVIVIDO < 1 THEN 0
        WHEN aux.TEMPOVIVIDO < 5 THEN 1
        WHEN aux.TEMPOVIVIDO < 90 THEN (FLOOR(aux.TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN aux.TEMPOVIVIDO < 1 THEN 1
        WHEN aux.TEMPOVIVIDO < 5 THEN 4
        WHEN aux.TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM (SELECT 
	`aux_dtpe`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtpe
    WHERE ANOORIGEM IN (2010, 2019, 2021) 
    HAVING TEMPOVIVIDO IS NOT NULL) aux
    ;
    
DELETE FROM aux_tempo_vivido_pe WHERE SEXO NOT IN (1, 2);
SELECT DISTINCT SEXO, ANOORIGEM, COUNT(SEXO) 
	FROM aux_tempo_vivido_pe
    GROUP BY SEXO, ANOORIGEM;
    
CREATE TABLE aux_tempo_medio_vivido_intevalo_pe
SELECT 	aux.ANOORIGEM, 
		aux.SEXO, 
		aux.CONTAGEM CONTMORTES, 
        populacao_pe.CONTAGEM POPTOTAL, 
        aux.x, 
        aux.n, 
        aux.nkx,
		aux.CONTAGEM / populacao_pe.CONTAGEM nMx
        FROM(
SELECT ANOORIGEM, SEXO, COUNT(*) CONTAGEM, x,  n,
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_pe 
    GROUP BY ANOORIGEM, x, SEXO, n

UNION ALL
 
SELECT ANOORIGEM, NULL SEXO, COUNT(*) CONTAGEM, x,  n, 
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_pe
    GROUP BY ANOORIGEM, x, n
    ) aux
    JOIN populacao_pe
		ON aux.ANOORIGEM = populacao_pe.ANOORIGEM 
        AND ((aux.SEXO = populacao_pe.SEXO) OR (aux.SEXO IS NULL AND populacao_pe.SEXO IS NULL)) 
        AND aux.x = populacao_pe.x 
        AND ((aux.n = populacao_pe.n) OR (aux.n IS NULL AND populacao_pe.n IS NULL))
ORDER BY aux.ANOORIGEM, aux.SEXO, aux.x, aux.n;


DROP TABLE life_table_pe;
CREATE TABLE life_table_pe
SELECT *,
	IF (n IS NOT NULL,(n * nMx) / (1 + ((n - nkx)* nMx)), 1) nqx
	FROM aux_tempo_medio_vivido_intevalo_pe;
    
SELECT * FROM life_table_pe;


# Tabua de vida 2015
# taxa de mortapidade infantil
SELECT morte.ANOORIGEM, morte.MORTES, nasc.NASCIMENTOS, morte.MORTES/nasc.NASCIMENTOS MORTINF FROM
(SELECT ANOORIGEM, COUNT(*) MORTES FROM aux_dtba WHERE IDADECONVERT < 1 GROUP BY ANOORIGEM )morte
JOIN 
(SELECT ANORIGEM, COUNT(*) NASCIMENTOS FROM aux_dnba GROUP BY ANORIGEM) nasc
on morte.ANOORIGEM = nasc.ANORIGEM
;

SELECT ANORIGEM, COUNT(*) NASCIMENTOS FROM aux_dnba GROUP BY ANORIGEM;


CREATE TABLE aux_tempo_vivido_ba
SELECT aux.*, 
	CASE 
		WHEN aux.TEMPOVIVIDO < 1 THEN 0
        WHEN aux.TEMPOVIVIDO < 5 THEN 1
        WHEN aux.TEMPOVIVIDO < 90 THEN (FLOOR(aux.TEMPOVIVIDO) DIV 5) * 5
        ELSE 90  
	END x ,
    CASE
		WHEN aux.TEMPOVIVIDO < 1 THEN 1
        WHEN aux.TEMPOVIVIDO < 5 THEN 4
        WHEN aux.TEMPOVIVIDO < 90 THEN 5
        ELSE null  
	END n
    FROM (SELECT 
	`aux_dtba`.* , 
    IF((IDADECONVERT - FLOOR(IDADECONVERT)) > 0, IDADECONVERT, DATADIFF) TEMPOVIVIDO
    FROM aux_dtpe
    WHERE ANOORIGEM IN (2010, 2019, 2021) 
    HAVING TEMPOVIVIDO IS NOT NULL) aux
    ;
    
select * from aux_tempo_vivido_ba;
    
DELETE FROM aux_tempo_vivido_pe WHERE SEXO NOT IN (1, 2);
SELECT DISTINCT SEXO, ANOORIGEM, COUNT(SEXO) 
	FROM aux_tempo_vivido_pe
    GROUP BY SEXO, ANOORIGEM;
    
CREATE TABLE aux_tempo_medio_vivido_intevalo_pe
SELECT 	aux.ANOORIGEM, 
		aux.SEXO, 
		aux.CONTAGEM CONTMORTES, 
        populacao_pe.CONTAGEM POPTOTAL, 
        aux.x, 
        aux.n, 
        aux.nkx,
		aux.CONTAGEM / populacao_pe.CONTAGEM nMx
        FROM(
SELECT ANOORIGEM, SEXO, COUNT(*) CONTAGEM, x,  n,
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_pe 
    GROUP BY ANOORIGEM, x, SEXO, n

UNION ALL
 
SELECT ANOORIGEM, NULL SEXO, COUNT(*) CONTAGEM, x,  n, 
	SUM((TEMPOVIVIDO - x))/COUNT(*) nkx
	FROM aux_tempo_vivido_pe
    GROUP BY ANOORIGEM, x, n
    ) aux
    JOIN populacao_pe
		ON aux.ANOORIGEM = populacao_pe.ANOORIGEM 
        AND ((aux.SEXO = populacao_pe.SEXO) OR (aux.SEXO IS NULL AND populacao_pe.SEXO IS NULL)) 
        AND aux.x = populacao_pe.x 
        AND ((aux.n = populacao_pe.n) OR (aux.n IS NULL AND populacao_pe.n IS NULL))
ORDER BY aux.ANOORIGEM, aux.SEXO, aux.x, aux.n;


DROP TABLE life_table_pe;
CREATE TABLE life_table_pe
SELECT *,
	IF (n IS NOT NULL,(n * nMx) / (1 + ((n - nkx)* nMx)), 1) nqx
	FROM aux_tempo_medio_vivido_intevalo_pe;
    
SELECT * FROM life_table_pe;

SELECT * FROM populacao_ba;


select * from doba2000 where DTOBITO = 2000;
SELECT * FROM doba2021;


SELECT ANOORIGEM, SEXO, x, n, COUNT(*) as count, (SUM(TEMPOVIVIDO)/COUNT(*)) - x as nkx  
	FROM aux_tempo_vivido_ba
    WHERE ANOORIGEM IN (2009, 2010, 2011) AND SEXO NOT IN (0, 9)
    GROUP BY x, ANOORIGEM, n, SEXO
    ORDER BY ANOORIGEM, SEXO, x
    ;
    
SELECT ANOORIGEM, x, n, COUNT(*) as count, (SUM(TEMPOVIVIDO)/COUNT(*)) - x as nkx  
	FROM aux_tempo_vivido_ba
    WHERE ANOORIGEM IN (2009, 2010, 2011) AND SEXO NOT IN (0, 9)
    GROUP BY x, ANOORIGEM, n
    ORDER BY ANOORIGEM, x
    ;

SELECT ANOORIGEM, SEXO, x, n, COUNT(*) as count, (SUM(TEMPOVIVIDO)/COUNT(*)) - x as nkx  
	FROM aux_tempo_vivido_rn
    WHERE ANOORIGEM IN (2014, 2015, 2016) AND SEXO NOT IN (0, 9)
    GROUP BY x, ANOORIGEM, n, SEXO
    ORDER BY ANOORIGEM, SEXO, x
    ;
    
SELECT ANOORIGEM, SEXO, x, n, COUNT(*) as count, (SUM(TEMPOVIVIDO)/COUNT(*)) - x as nkx  
	FROM aux_tempo_vivido_rn
    WHERE ANOORIGEM IN (2014, 2015, 2016) AND SEXO NOT IN (0, 9)
    GROUP BY x, ANOORIGEM, n, SEXO
    ORDER BY ANOORIGEM, SEXO, x
    ;
    
SELECT ANOORIGEM, x, n, COUNT(*) as count, (SUM(TEMPOVIVIDO)/COUNT(*)) - x as nkx  
	FROM aux_tempo_vivido_rn
    WHERE ANOORIGEM IN (2014, 2015, 2016) 
    GROUP BY x, ANOORIGEM, n
    ORDER BY ANOORIGEM, x
    ;
    
    
SELECT * FROM aux_tempo_vivido_rn;
SELECT * FROM dnba2020;