1: 

CREATE OR REPLACE FUNCTION getExchangesRate(bigint, float, float)
RETURNS TABLE("В рублях" BIGINT, "В долларах" FLOAT, "В евро" FLOAT) AS $$
	SELECT PRICE, rnd(price/$2, 2), rnd(price/$3, 2) FROM REALTY_OBJECT r WHERE ID = $1;
$$ language SQL;

DROP FUNCTION getexchangesrate(bigint,double precision,double precision);

SELECT * FROM getExchangesRate(124, 88.81, 96.92);

2:

CREATE OR REPLACE FUNCTION getSalary(S float, R bigint, f text, beg TIMESTAMP, ends TIMESTAMP)
RETURNS TABLE(idrr BIGINT, last_name character(15), y integer, m integer, cnt BIGINT
, arrids BIGINT[], arridr BIGINT[], sumobj text, "Сумма заработной платы" text) AS $$
BEGIN
	DROP TABLE IF EXISTS x, x1;
	create temporary table x as SELECT rR.ID idRR, rR.LAST_NAME, to_char(DATE_OF_SALE, 'yyyy')::INT y, to_char(DATE_OF_SALE, 'mm')::INT m, s.id idS, s.REALTY_OBJECT_ID idR FROM SALE s, REALTOR rR WHERE REALTOR_ID = rR.ID AND rR.LAST_NAME = f AND DATE_OF_SALE BETWEEN beg AND ends;
	create temporary table x1 as SELECT x.idRR, x.LAST_NAME, x.y, x.m, COUNT(x.m), array_agg(idS) arrids, array_agg(idR), to_char(SUM(PRICE), '999 999 999') sumObj FROM x, REALTY_OBJECT r WHERE idR = r.ID GROUP BY x.idRR, x.LAST_NAME, x.y, x.m;
	return query(SELECT x1.*, to_char(replace(x1.sumObj, ' ', '')::INT*S+R, '999 999.99') FROM x1);
END $$ language plpgsql;

SELECT * FROM getSalary(0.002, 40000, 'Мякина', '2017-05-07', '2023-11-24');

DROP FUNCTION getSalary(S float, R bigint, f text, beg TIMESTAMP, ends TIMESTAMP);

3:

CREATE TABLE REALTORS_SALARY (
	ID BIGINT PRIMARY KEY,
	REALTOR_ID BIGINT REFERENCES REALTOR (ID),
	YEAR BIGINT,
	MONTH BIGINT,
	VALUE FLOAT
);

CREATE OR REPLACE FUNCTION getSalary3(S float, R bigint, f text, beg TIMESTAMP, ends TIMESTAMP)
RETURNS TABLE(ID BIGINT, REALTOR_ID BIGINT, YEAR BIGINT, MONTH BIGINT, VALUE FLOAT) AS $$
BEGIN
	DROP TABLE IF EXISTS x, x1;
	create temporary table x as SELECT rR.ID idRR, rR.LAST_NAME, to_char(DATE_OF_SALE, 'yyyy')::INT y, to_char(DATE_OF_SALE, 'mm')::INT m, s.id idS, s.REALTY_OBJECT_ID idR FROM SALE s, REALTOR rR WHERE s.REALTOR_ID = rR.ID AND rR.LAST_NAME = f AND DATE_OF_SALE BETWEEN beg AND ends;
	create temporary table x1 as SELECT x.idRR, x.LAST_NAME, x.y, x.m, COUNT(x.m), array_agg(idS) arrids, array_agg(idR), to_char(SUM(PRICE), '999 999 999') sumObj FROM x, REALTY_OBJECT r WHERE idR = r.ID GROUP BY x.idRR, x.LAST_NAME, x.y, x.m;
	INSERT INTO REALTORS_SALARY SELECT
		ROW_NUMBER() over() + 508, idRR, y, m, rnd(replace(sumObj, ' ', '')::INT*S+R, 2)
		from x1;
	RETURN query(SELECT * FROM REALTORS_SALARY);
END $$ language plpgsql;

SELECT * FROM getSalary3(0.002, 40000, 'Мякина', '2017-05-07', '2023-11-24');

DROP FUNCTION getSalary3(S float, R bigint, f text, beg TIMESTAMP, ends TIMESTAMP);

DROP TABLE REALTORS_SALARY;

delete FROM REALTORS_SALARY WHERE ID>508;

4:

CREATE OR REPLACE FUNCTION getInfo6_4()
RETURNS TABLE(sP double precision, rP double precision, dR TIMESTAMP, dS TIMESTAMP, "%" FLOAT, getDiffMonth NUMERIC) AS $$
BEGIN
	DROP TABLE IF EXISTS x;
	create temporary table x as SELECT s.PRICE sP, r.PRICE rP, DATE_OF_ANNOUNCEMENT dR, DATE_OF_SALE dS FROM SALE s, REALTY_OBJECT r WHERE REALTY_OBJECT_ID = r.ID;
	RETURN query(SELECT x.*, rnd((x.sP-x.rP)/x.rP * 100, 2), getDiffMonth(x.dS, x.dR) FROM x);
END $$ language plpgsql;

SELECT * FROM getInfo6_4();

DROP FUNCTION getInfo6_4();

5:

CREATE OR REPLACE FUNCTION getInfo6_5()
RETURNS TABLE(sP double precision, rP double precision, dR TIMESTAMP, dS TIMESTAMP, "%" FLOAT, getDiffMonth NUMERIC, "Срок" text) AS $$
BEGIN
	DROP TABLE IF EXISTS x, x1;
	create temporary table x as SELECT s.PRICE sP, r.PRICE rP, DATE_OF_ANNOUNCEMENT dR, DATE_OF_SALE dS FROM SALE s, REALTY_OBJECT r WHERE REALTY_OBJECT_ID = r.ID;
	create temporary table x1 as SELECT x.*, rnd((x.sP-x.rP)/x.rP * 100, 2), getDiffMonth(x.dS, x.dR) dif FROM x;
	RETURN query(SELECT *, (CASE
		WHEN x1.dif < 3 THEN 'Очень быстро'
		WHEN x1.dif >= 3 AND x1.dif < 6 THEN 'Быстро'
		WHEN x1.dif >= 6 AND x1.dif < 12 THEN 'Долго'
		WHEN x1.dif >= 12 THEN 'Очень долго'
		ELSE ''
	END) FROM x1 limit 30);
END $$ language plpgsql;

SELECT * FROM getInfo6_5();

DROP FUNCTION getInfo6_5();

6:

CREATE OR REPLACE FUNCTION getInfo6_6(idRe BIGINT)
RETURNS TABLE("Критерий" character(30), "Средняя оценка" text) AS $$
BEGIN
	DROP TABLE IF EXISTS x;
	create temporary table x as SELECT NAME, RND(AVG(VALUE), 1) avg FROM Score s, REALTY_OBJECT r, ASSESSMENT_CRITERION asCr WHERE REALTY_OBJECT_ID = idRe AND REALTY_OBJECT_ID = r.ID AND ASSESSMENT_CRITERION_ID = asCr.ID GROUP BY NAME;
	RETURN query(SELECT x.NAME, (x.avg || ' из 5') FROM x);
END $$ language plpgsql;

SELECT * FROM getInfo6_6(20);

DROP FUNCTION getInfo6_6(idRe BIGINT);

7:

CREATE OR REPLACE FUNCTION getInfo6_7(idRe BIGINT, per FLOAT, y BIGINT, fPay DOUBLE PRECISION)
RETURNS DOUBLE PRECISION AS $$
DECLARE sP DOUBLE PRECISION;
		rez DOUBLE PRECISION;
		i FLOAT;
		n BIGINT;
BEGIN
	sP := (SELECT s.PRICE sP FROM SALE s, REALTY_OBJECT r WHERE r.ID = idRe AND REALTY_OBJECT_ID = r.ID limit 1);
	sP := sP - fPay;
	i := per / 100 / 12;
	n := y * 12;
	rez := sP * (i + i/(POWER(1+i, n) - 1));
	RETURN rnd(rez, 2);
END $$ language plpgsql;

SELECT * FROM getInfo6_7(20, 10.0, 20, 1000000);

DROP FUNCTION getInfo6_7(idRe BIGINT, per FLOAT, y BIGINT, fPay DOUBLE PRECISION);

8:

CREATE OR REPLACE FUNCTION getInfo6_8(idRe BIGINT, lastTax DOUBLE PRECISION)
RETURNS DOUBLE PRECISION AS $$
DECLARE sP DOUBLE PRECISION;
		rez DOUBLE PRECISION;
		rate FLOAT;
BEGIN
	sP := (SELECT s.PRICE sP FROM SALE s, REALTY_OBJECT r WHERE r.ID = idRe AND REALTY_OBJECT_ID = r.ID limit 1);
	rate := (SELECT CASE
		WHEN sP < 10000000 THEN 0.1
		WHEN sP >= 10000000 AND sP < 20000000 THEN 0.15
		WHEN sP >= 20000000 AND sP < 50000000 THEN 0.2
		WHEN sP >= 50000000 AND sP < 300000000 THEN 0.3
	END);
	sP := sP / rand(3, 10);
	rez := (sP * rate - lastTax)* 0.05 + lastTax;
	RETURN rnd(rez, 2);
END $$ language plpgsql;

SELECT * FROM getInfo6_8(20, 15000);

DROP FUNCTION getInfo6_8(idRe BIGINT, lastTax DOUBLE PRECISION);

9:

CREATE TABLE PRICE_MOVEMENT (
	ID BIGINT PRIMARY KEY,
	REALTY_OBJECT_ID BIGINT REFERENCES REALTY_OBJECT (ID),
	NEW_PRICE DOUBLE PRECISION,
	LAGG DOUBLE PRECISION,
	DATE_OF_CHANGE TIMESTAMP
);

CREATE OR REPLACE FUNCTION getInfo6_9(idRe BIGINT)
RETURNS TABLE("Дата" TIMESTAMP, "Новая стоимость" DOUBLE PRECISION
, "Изменение" DOUBLE PRECISION, "% Изменения" FLOAT) AS $$
BEGIN
	DROP TABLE x;
	create temporary table x as SELECT r.ID rID, s.PRICE sP, s.DATE_OF_SALE dS, r.PRICE rP FROM SALE s, REALTY_OBJECT r WHERE r.ID = idRe AND REALTY_OBJECT_ID = r.ID;
	INSERT INTO PRICE_MOVEMENT SELECT
		ROW_NUMBER() over() + 524, x.rID, x.sP, LAG(x.sP) OVER(ORDER BY x.dS), x.dS
		from x;
	RETURN query(SELECT DATE_OF_CHANGE, NEW_PRICE, coalesce(NEW_PRICE - LAGG, 0), coalesce(rnd((NEW_PRICE-LAGG)/LAGG * 100, 2), 0) FROM PRICE_MOVEMENT ORDER BY DATE_OF_CHANGE);
END $$ language plpgsql;

SELECT * FROM getInfo6_9(20);
SELECT * FROM PRICE_MOVEMENT;

delete FROM PRICE_MOVEMENT WHERE ID>524;

DROP FUNCTION getInfo6_9(idRe BIGINT);

delete FROM PRICE_MOVEMENT WHERE ID>524;

DROP TABLE PRICE_MOVEMENT;
