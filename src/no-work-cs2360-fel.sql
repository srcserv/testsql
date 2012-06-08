--------------------------------------------------------
--  File created - Thursday-May-24-2012   
--------------------------------------------------------
REM INSERTING into RESULT_QUERYID
Insert into RESULT_QUERYID (QUERY_ID,QUERY) values (2810454,'SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , '''', '''' FROM Germplasm g ,  (SELECT * FROM  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE ''%CS2360%'' ESCAPE ''\'') t0,  (SELECT * FROM GermplasmDonorNameSearch_wrk WHERE name LIKE ''%FELDMANN%'' ESCAPE ''\'') t1 WHERE t1.germplasm_id = t0.germplasm_id ) filter , Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = ''F'' AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1');
Insert into RESULT_QUERYID (QUERY_ID,QUERY) values (2810455,'SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , '''', '''' FROM Germplasm g ,  (SELECT * FROM  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE ''%CS2360%'' ESCAPE ''\'') t0) filter , Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = ''F'' AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1');
Insert into RESULT_QUERYID (QUERY_ID,QUERY) values (2810456,'SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , '''', '''' FROM Germplasm g ,  (SELECT * FROM  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE ''CS2360%'' ESCAPE ''\'') t0) filter , Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = ''F'' AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1');
Insert into RESULT_QUERYID (QUERY_ID,QUERY) values (2810457,'SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , '''', '''' FROM Germplasm g ,  (SELECT * FROM  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE ''CS2360%'' ESCAPE ''\'') t0,  (SELECT * FROM GermplasmDonorNameSearch_wrk WHERE name LIKE ''%FELDMANN%'' ESCAPE ''\'') t1 WHERE t1.germplasm_id = t0.germplasm_id ) filter , Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = ''F'' AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1');
