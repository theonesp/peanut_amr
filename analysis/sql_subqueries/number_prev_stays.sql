SELECT     
    stay_id,
    (SELECT COUNT(*)
     FROM `physionet-data.mimiciv_icu.icustays` u2
     WHERE u2.subject_id = u1.subject_id
     AND u2.intime < u1.intime) AS previous_icu_stays
FROM 
    `physionet-data.mimiciv_icu.icustays` u1
WHERE 
    u1.stay_id IN (SELECT stay_id FROM `peanutproject-2024.stay_id_selection_peanut.stay_id_selection`)
ORDER BY 
    subject_id, intime;