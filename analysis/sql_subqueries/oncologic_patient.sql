SELECT * 
FROM `physionet-data.mimiciv_hosp.procedures_icd` 
WHERE icd_code IN (
    '9927',  -- ✅ Administración de quimioterapia
    '9929',  -- ✅ Radioterapia
    '4021',  -- ✅ Resección parcial de ganglio linfático (cáncer linfático)
    '403',   -- ✅ Disección radical de cuello (cáncer de cabeza y cuello)
    '6841',  -- ✅ Mastectomía radical modificada (cáncer de mama)
    '686',   -- ✅ Lumpectomía de mama (resección de tumor mamario)
    '4542',  -- ✅ Colectomía parcial (cáncer de colon)
    '9921',  -- ✅ Transfusión de plaquetas (común en leucemia)
    '9922',  -- ✅ Transfusión de glóbulos rojos (para anemia en pacientes con quimio)
    '9923'   -- ✅ Transfusión de plasma (para coagulopatías en cáncer hematológico)
) 
AND icd_version = 9   
AND hadm_id IN (
    SELECT hadm_id 
    FROM `peanutproject-2024.stay_id_selection_peanut.stay_id_selection`
);
