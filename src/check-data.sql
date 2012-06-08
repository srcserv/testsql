SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , '', '' 
FROM Germplasm g ,  
( SELECT * FROM  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE 'CS2360%' ESCAPE '\') t0
WHERE t0.germplasm_id IN
 (SELECT germplasm_id FROM GermplasmDonorNameSearch_wrk t1 WHERE name LIKE '%FELDMANN%' ESCAPE '\')
 ) filter , 
Germplasm_Pedigree_wrk gp 
WHERE g.is_obsolete = 'F' AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1