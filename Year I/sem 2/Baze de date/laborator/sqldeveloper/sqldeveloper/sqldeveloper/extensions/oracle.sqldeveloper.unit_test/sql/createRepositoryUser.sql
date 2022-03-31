--------------------------------------------------------------------------------
-- createRepositoryUser
--
-- Grant requires privileges to a database user that can then be initialized as 
-- a unit test repository.

-- The repository initialization is subsequently done by running SQLDeveloper 
-- and selecting Tools/Unit Test/Select Current Repository.
--
-- &1 => the new user name
--------------------------------------------------------------------------------

GRANT CONNECT, RESOURCE TO &1;
GRANT UT_REPO_ADMINISTRATOR TO &1 WITH ADMIN OPTION;
GRANT CREATE VIEW, UNLIMITED TABLESPACE TO &1;

GRANT SELECT ON DBA_ROLES TO &1;
GRANT SELECT ON DBA_ROLE_PRIVS TO &1;
