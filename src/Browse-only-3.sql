SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , '', '' FROM 
Germplasm g ,  (SELECT * FROM  (  SELECT Germplasm_Phenotype.germplasm_id, Phenotype.phenotype_uc as name  FROM Germplasm_Phenotype, Phenotype  
WHERE Germplasm_Phenotype.phenotype_id = Phenotype.phenotype_id  AND Phenotype.phenotype_uc LIKE '%BRASSINOSTEROID%' ESCAPE '\'   UNION    
SELECT germplasm_id, description_uc AS name FROM Germplasm WHERE description_uc LIKE '%BRASSINOSTEROID%'     AND is_obsolete = 'F'  ) t0) filter , 
Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = 'F' AND g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1 