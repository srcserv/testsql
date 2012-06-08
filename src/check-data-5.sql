SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , 
'2900980', CURRENT_DATE FROM Germplasm g ,  (SELECT t0.germplasm_id FROM  (SELECT * FROM GermplasmGeneNameSearch_wrk 
WHERE name LIKE 'CUL1%' ESCAPE '\') t0,  (  SELECT Germplasm_Phenotype.germplasm_id, Phenotype.phenotype_uc as name  
FROM Germplasm_Phenotype, Phenotype  WHERE Germplasm_Phenotype.phenotype_id = Phenotype.phenotype_id  AND Phenotype.phenotype_uc LIKE '%LEAVES%' ESCAPE '\'   UNION    SELECT germplasm_id, description_uc AS name FROM Germplasm WHERE description_uc
 LIKE '%LEAVES%'     AND is_obsolete = 'F'   ) t1,  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE 'CS28' ESCAPE '\') t2 WHERE t1.germplasm_id = t0.germplasm_id  
 AND t2.germplasm_id = t1.germplasm_id ) filter , Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = 'F' 
 AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1