
CREATE OR REPLACE FUNCTION test1()
RETURNS VARCHAR
AS $$
	from faker import Faker
	fake = Faker('it_IT')
	Faker.seed(4321)
	return fake.name()
$$ LANGUAGE plpython3u;

SELECT test1();

CREATE OR REPLACE FUNCTION test1()
RETURNS float
AS $$
	import numpy
	return numpy.pi
$$ LANGUAGE plpython3u;

SELECT test1();

DROP FUNCTION test1();

CREATE EXTENSION plpython3u;

python C:\Users\DonJun\Downloads\get-pip.py

SET plpython3.python_path='C:\Python39';