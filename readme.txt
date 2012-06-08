(SELECT * FROM GermplasmDonorNameSearch_wrk WHERE name LIKE '%FELDMANN%' ESCAPE '\') t1 

WHERE t1.germplasm_id = t0.germplasm_id