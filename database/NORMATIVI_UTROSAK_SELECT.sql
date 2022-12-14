SELECT ARTIKL_PRODAJA_ID,
       ARTIKL_NABAVA_ID,
       UTROSAK,
       (SELECT NAZIV FROM ARTIKL_NABAVA AN WHERE ID_ARTIKL_NABAVA = ARTIKL_NABAVA_ID) AS NAZIV_ARTIKLA_NABAVE,
       (SELECT CIJENA_BEZ_PDVA
        FROM ARTIKL_NABAVA AN
        WHERE ID_ARTIKL_NABAVA = ARTIKL_NABAVA_ID)                                    AS CIJENA_ARTIKLA_NABAVE,
       (SELECT UTROSAK * CIJENA_BEZ_PDVA
        FROM ARTIKL_NABAVA AN2
        WHERE ID_ARTIKL_NABAVA = ARTIKL_NABAVA_ID)                                    AS CIJENA_MATERIJALA
FROM NORMATIV N;