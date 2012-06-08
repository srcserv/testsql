SELECT g.tair_object_id, g.germplasm_id, g.name, g.germplasm_type, NULL, NULL, NULL, NULL , 
'2900957', CURRENT_DATE FROM Germplasm g ,  (SELECT * FROM  (SELECT GermplasmDonorNameSearch_wrk.germplasm_id, GermplasmDonorNameSearch_wrk.name 
FROM GermplasmDonorNameSearch_wrk WHERE name LIKE '%FELDMANN%' ESCAPE '\') t0) filter , Germplasm_Pedigree_wrk gp WHERE g.is_obsolete = 'F' AND 
g.germplasm_id = gp.germplasm_id  AND g.germplasm_id = filter.germplasm_id AND gp.taxon_id = 1