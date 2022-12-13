DECLARE
    V_BLOB                 BLOB;
    V_FILE_NAME            VARCHAR2(25)  := 'invoice.pdf';
    V_VCCONTENTDISPOSITION VARCHAR2(25)  := 'inline';
    V_INVOICE_ID           VARCHAR2(10)  := :INVOICE_ID; -- your NumberField Item
    V_HOSTNAME             VARCHAR2(30)  := :YOUR_HOSTNAME; -- your hostname, eg: localhost
    V_PORT                 NUMBER        := :YOUR_PORT; -- port for your JasperReports Server, eg: 8081
    V_USERNAME             VARCHAR2(50)  := :JASPER_USER; -- jasperreports server username
    V_PASSWORD             VARCHAR2(50)  := :JASPER_PASSWORD; -- jaspereports server password
    V_JASPER_STRING        VARCHAR2(30)  := V_USERNAME || ';' || V_PASSWORD;
    V_LOGIN_URL            VARCHAR2(100) :=
        'http://' || V_HOSTNAME || ':' || V_PORT || '/jasperserver/rest/login';
    -- modify below URL before use!
    -- you should modify the line below; change /Pretius/ to your own name
    -- before you add a line try your URL in a web browser
    V_REPORT_URL           VARCHAR2(100) :=
            'http://' || V_HOSTNAME || ':' || V_PORT || '/jasperserver/rest_v2/reports/Reports/' || V_FILE_NAME;
BEGIN
    -- log into jasper server
    V_BLOB := APEX_WEB_SERVICE.MAKE_REST_REQUEST_B(
            P_URL => V_LOGIN_URL,
            P_HTTP_METHOD => 'GET',
            P_PARM_NAME => APEX_UTIL.STRING_TO_TABLE('j_username;j_password', ';'),
            P_PARM_VALUE => APEX_UTIL.STRING_TO_TABLE(V_JASPER_STRING, ';')
        );
    -- download file
    V_BLOB := APEX_WEB_SERVICE.MAKE_REST_REQUEST_B(
            P_URL => V_REPORT_URL,
            P_HTTP_METHOD => 'GET',
            P_PARM_NAME => APEX_UTIL.STRING_TO_TABLE('invoice_id', ';'),
            P_PARM_VALUE => APEX_UTIL.STRING_TO_TABLE(V_INVOICE_ID, ';')
        );
    --OWA_UTIL.mime_header ('application/pdf', FALSE);  -- view your pdf file
    OWA_UTIL.MIME_HEADER('application/octet', FALSE); -- download your pdf file
    HTP.P('Content-Length: ' || DBMS_LOB.GETLENGTH(V_BLOB));
    HTP.P('Content-Disposition: ' || V_VCCONTENTDISPOSITION || '; filename="' || V_FILE_NAME || '"');
    OWA_UTIL.HTTP_HEADER_CLOSE;
    WPG_DOCLOAD.DOWNLOAD_FILE(V_BLOB);
    APEX_APPLICATION.STOP_APEX_ENGINE;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/