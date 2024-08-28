SELECT
  w.subject_id, w.stay_id, w.weight_admit, h.height 
FROM
  `physionet-data.mimiciv_derived.first_day_weight` AS w
JOIN
  `physionet-data.mimiciv_derived.first_day_height` AS h
ON
  w.stay_id = h.stay_id
WHERE
  w.stay_id IN (SELECT stay_id FROM `peanutproject-2024.stay_id_selection_peanut.stay_id_selection`);
