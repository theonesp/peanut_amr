SELECT DISTINCT (md.stay_id)

   FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_icu.icustays` s
  ON
    s.hadm_id = md.hadm_id
  WHERE 
  s.intime < md.icu_intime AND
  s.stay_id != md.stay_id;
