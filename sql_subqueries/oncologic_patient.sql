SELECT * FROM  `physionet-data.mimiciv_hosp.procedures_icd` where ICD_CODE IN ('0010','9925','9925','9928','9985')
  AND hadm_id IN (SELECT hadm_id FROM `peanutproject-2024.stay_id_selection_peanut.stay_id_selection`)

