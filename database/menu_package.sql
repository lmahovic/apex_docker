SELECT *
    FROM SYS.ALL_PLSQL_OBJECT_SETTINGS APOS
    WHERE APOS.NAME = 'GET_TIER';

SELECT DBMS_WARNING.GET_WARNING_SETTING_STRING()
    FROM SYS.DUAL D;

ALTER SESSION SET PLSQL_CODE_TYPE = 'INTERPRETED';

ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL';

ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 2;



CREATE OR REPLACE PACKAGE MENU AUTHID CURRENT_USER
IS
    PROCEDURE GET_MENU_PDF;
END;

CREATE OR REPLACE PACKAGE BODY MENU
IS
    PROCEDURE GET_MENU_PDF IS
        V_BLOB                 BLOB;
        V_FILE_NAME            VARCHAR2(25)  := 'menu.pdf';
        V_VCCONTENTDISPOSITION VARCHAR2(25)  := 'inline';
        V_HOSTNAME             VARCHAR2(30)  := 'jasper'; -- your hostname, eg: localhost
        V_PORT                 NUMBER        := '8080'; -- port for your JasperReports Server, eg: 8081
        V_USERNAME             VARCHAR2(50)  := 'invoice'; -- jasperreports server username
        V_PASSWORD             VARCHAR2(50)  := 'invoice'; -- jaspereports server password
        V_JASPER_STRING        VARCHAR2(30)  := V_USERNAME || ';' || V_PASSWORD;
        V_LOGIN_URL            VARCHAR2(100) :=
                                                'http://' || V_HOSTNAME || ':' || V_PORT || '/jasperserver/rest/login';

        -- modify below URL before use!
        -- you should modify the line below; change /Pretius/ to your own name
        -- before you add a line try your URL in a web browser
        V_REPORT_URL           VARCHAR2(100) :=
                                                'http://' || V_HOSTNAME || ':' || V_PORT ||
                                                '/jasperserver/rest_v2/reports/Reports/' || V_FILE_NAME;
    BEGIN
        -- log into jasper server
        V_BLOB := APEX_WEB_SERVICE.MAKE_REST_REQUEST_B(
                P_URL => V_LOGIN_URL,
                P_HTTP_METHOD => 'GET',
                P_PARM_NAME => APEX_UTIL.STRING_TO_TABLE('j_username;j_password', ';'),
                P_PARM_VALUE => APEX_UTIL.STRING_TO_TABLE(V_JASPER_STRING, ';')
            );
        V_BLOB := APEX_WEB_SERVICE.MAKE_REST_REQUEST_B(
                P_URL => V_REPORT_URL,
                P_HTTP_METHOD => 'GET'
            );

        OWA_UTIL.MIME_HEADER('application/pdf', FALSE);
        -- view your pdf file
--         OWA_UTIL.MIME_HEADER('application/octet', FALSE); -- download your pdf file
        HTP.P('Content-Length: ' || DBMS_LOB.GETLENGTH(V_BLOB));
        HTP.P('Content-Disposition: ' || V_VCCONTENTDISPOSITION || '; filename="' || V_FILE_NAME || '"');
        OWA_UTIL.HTTP_HEADER_CLOSE;
        -- download file
        WPG_DOCLOAD.DOWNLOAD_FILE(V_BLOB);
        APEX_APPLICATION.STOP_APEX_ENGINE;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;
END;

