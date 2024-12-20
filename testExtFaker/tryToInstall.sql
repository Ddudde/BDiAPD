DROP EXTENSION plpython3u CASCADE;
DROP EXTENSION plpgsql;
DROP EXTENSION faker;
DROP SCHEMA faker;

CREATE EXTENSION plpython3u;
CREATE EXTENSION plpgsql;
CREATE SCHEMA faker;
CREATE EXTENSION faker SCHEMA faker CASCADE;

pip install -r D:\Desk\Rep\BDiAPD\testExtFaker\requirements.txt

ALTER DATABASE realty SET faker.locales = 'ru_RU';
