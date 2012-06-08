SELECT * FROM  (SELECT * FROM GermplasmStockNameSearch_wrk WHERE name LIKE 'CS2360%' ESCAPE '\') t0
WHERE t0.germplasm_id IN
 (SELECT germplasm_id FROM GermplasmDonorNameSearch_wrk t1 WHERE name LIKE '%FELDMANN%' ESCAPE '\')