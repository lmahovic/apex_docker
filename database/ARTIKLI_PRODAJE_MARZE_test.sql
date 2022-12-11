SELECT *
FROM ARTIKLI_PRODAJE_MARZE APM
ORDER BY MARZA_POSTOTAK;

SELECT N.ID_NORMATIV,
       N.UTROSAK,
       N.ARTIKL_PRODAJA_ID                                                             PRODAJA_ID,
       AN.NAZIV                                                                        NAZIVNABAVA,
       AN.SIFRA                                                                        SIFRAN,
       AN.CIJENA_BEZ_PDVA,
       N.UTROSAK * AN.CIJENA_BEZ_PDVA                                               AS POJ_UTR,
       AP.NAZIV                                                                        NAZIVPRODAJA,
       AP.SIFRA                                                                        SIFRAP,
       AP.CIJENA_S_PDVOM,
       SUM(N.UTROSAK * AN.CIJENA_BEZ_PDVA) OVER ( PARTITION BY N.ARTIKL_PRODAJA_ID) AS ZBROJTROSKOVA
FROM PDBADMIN.NORMATIV N
         INNER JOIN PDBADMIN.ARTIKL_NABAVA AN ON AN.ID_ARTIKL_NABAVA = N.ARTIKL_NABAVA_ID
         INNER JOIN PDBADMIN.ARTIKL_PRODAJA AP ON N.ARTIKL_PRODAJA_ID = AP.ID_ARTIKL_PRODAJA
WHERE N.ARTIKL_PRODAJA_ID = 166;