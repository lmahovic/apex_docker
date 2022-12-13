DECLARE
    V_ACL_NAME       VARCHAR2(30)  := 'apex-network.xml';
    V_ACL_DESC       VARCHAR2(100) := 'Connection from APEX to Jasper Server for Invoicing';
    V_ACL_PRIC       VARCHAR2(30)  := 'APEX_220100'; -- change if you installed newer APEX
    V_ACL_HOST       VARCHAR2(30)  := 'jasper';
    V_ACL_PORT_LOWER NUMBER        := NULL; -- change if needed
    V_ACL_PORT_UPPER NUMBER        := NULL; -- change if needed
BEGIN
    DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
            ACL => V_ACL_NAME,
            DESCRIPTION => V_ACL_DESC,
            PRINCIPAL => V_ACL_PRIC,
            IS_GRANT => TRUE,
            PRIVILEGE => 'connect'
        );
    DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
            ACL => V_ACL_NAME,
            PRINCIPAL => V_ACL_PRIC,
            IS_GRANT => TRUE,
            PRIVILEGE => 'resolve'
        );
    DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
            ACL => V_ACL_NAME,
            HOST => V_ACL_HOST,
            LOWER_PORT => V_ACL_PORT_LOWER,
            UPPER_PORT => V_ACL_PORT_UPPER
        );
    COMMIT;
END;
/