SELECT *
FROM physionet-data.mimiciv_hosp.diagnoses_icd
WHERE hadm_id
 IN (SELECT hadm_id FROM `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` )