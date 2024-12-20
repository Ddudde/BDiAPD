
CREATE OR REPLACE FUNCTION return_path()
RETURNS VARCHAR
AS $$
	import sys
	plpy.notice('pl/python3 Path: {}'.format(sys.path))
	return ""
$$ LANGUAGE plpython3u;

SELECT return_path();

CREATE OR REPLACE FUNCTION set_path()
RETURNS VARCHAR
AS $$
	from sys import path
	path.append( 'C:\Python\Python39' )
	return ""
$$ LANGUAGE plpython3u;

SELECT set_path();

CREATE OR REPLACE FUNCTION get_ver()
RETURNS VARCHAR
AS $$
	from sys
	return sys.version()
$$ LANGUAGE plpython3u;

SELECT get_ver();
