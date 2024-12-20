
select extract(SECOND from (now() - '2013-02-28'::timestamp));

select '2013-02-28'::TIMESTAMP + interval '14 hours';

interval '2 hours'

SELECT '2020-01-10 08:00'::TIME::INTERVAL + '2020-01-10 08:00'::TIME + '2020-01-10 08:00'::TIME;

SELECT INTERVAL '8 hours' + '2020-01-10 08:00'::TIME;

SELECT EXTRACT(EPOCH FROM '00:30'::TIME) / 60;

SELECT ('00:30'::TIME / INTERVAL '10 minutes');

SELECT (INTERVAL '40 minutes' / INTERVAL '10 minutes');

SELECT 'allballs'::TIME;

select age(now()::timestamp, '2013-02-28');

select extract(year from d) * 12 + extract(month from d) FROM age(now()::timestamp, '2013-02-28') d;

select extract(year from d) * 12 + extract(month from d) FROM age(now()::timestamp, '2024-11-01') d;

select getDiffSec(now()::timestamp, '2013-02-28');

10368000

select (now() - '2013-02-28'::timestamp)::interval + now();

SELECT faker.last_name_female();

SELECT faker.first_name_female();

SELECT faker.middle_name_female();

SELECT faker.phone_number();

SELECT faker.name();

SELECT faker.faker('ru_RU');

SELECT faker.faker('en_US');

SELECT faker.faker('en_GB');

SELECT faker.name();
SELECT faker.address();
SELECT faker.text();
SELECT faker.unique_null_boolean();
SELECT faker.unique_ipv4_public();

SELECT faker.date_between('-50y');

SELECT faker.date_between('-4M') FROM generate_series(1,30);

SELECT faker.date_this_century();

SELECT faker.street_title();

SELECT faker.date_between('-1y') FROM generate_series(1,3);

SELECT i FROM generate_series(0,3) as i;

SELECT faker.unique_clear();

https://faker.readthedocs.io/en/master/locales/ru_RU.html#faker-providers-address

DROP FUNCTION rand(min integer, max integer);

CREATE FUNCTION rand(min int DEFAULT 0, max int DEFAULT 1) RETURNS int AS $$
    SELECT random() * (max - min) + min;
$$ LANGUAGE SQL;

DROP FUNCTION getX(x BIGINT);

CREATE FUNCTION getX(x float) RETURNS TEXT AS $$
    SELECT x;
$$ LANGUAGE SQL;

DROP FUNCTION RND(float,int);

CREATE FUNCTION RND(float,int) RETURNS float AS $f$
  SELECT ROUND( CAST($1 AS numeric), $2 )
$f$ language SQL IMMUTABLE;

DROP FUNCTION getText11(float);

CREATE FUNCTION getText11(float) RETURNS TEXT AS $$
	SELECT CASE
		WHEN ($1 >= 0.9) AND ($1 < 1) THEN 'превосходно'
		WHEN ($1 >= 0.8) AND ($1 < 0.9) THEN 'очень хорошо'
		WHEN ($1 >= 0.7) AND ($1 < 0.8) THEN 'хорошо'
		WHEN ($1 >= 0.6) AND ($1 < 0.7) THEN 'удовлетворительно'
		ELSE 'неудовлетворительно'
	END
$$ language SQL;

CREATE FUNCTION getTypeText(BIGINT) RETURNS TEXT AS $$
	SELECT CASE
		WHEN $1 = 1 THEN 'кухня'
		WHEN $1 = 2 THEN 'зал'
		WHEN $1 = 3 THEN 'спальня'
		WHEN $1 = 4 THEN 'санузел'
		ELSE ''
	END
$$ language SQL;

CREATE FUNCTION getDiffSec(timestamp, timestamp) RETURNS NUMERIC AS $$
	SELECT extract(epoch from ($1 - $2))
$$ language SQL;

CREATE FUNCTION getTypeTextSt(BIGINT) RETURNS TEXT AS $$
	SELECT CASE
		WHEN $1 = 0 THEN 'продано'
		WHEN $1 = 1 THEN 'в продаже'
		ELSE ''
	END
$$ language SQL;

CREATE FUNCTION getTypeTextRO(BIGINT) RETURNS TEXT AS $$
	SELECT CASE
		WHEN $1 = 0 THEN 'Квартир'
		WHEN $1 = 1 THEN 'Домов'
		WHEN $1 = 2 THEN 'Апартаменты'
		ELSE ''
	END
$$ language SQL;

CREATE FUNCTION getDiffSec(timestamp, timestamp) RETURNS NUMERIC AS $$
	SELECT extract(epoch from ($1 - $2))
$$ language SQL;

CREATE FUNCTION getDiffMonth(timestamp, timestamp) RETURNS NUMERIC AS $$
	SELECT extract(year from d) * 12 + extract(month from d) FROM age($1, $2) d;
$$ language SQL;
