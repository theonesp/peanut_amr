SELECT  DISTINCT (md.hadm_id)

   FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_hosp.admissions` s
  ON
    s.subject_id = md.subject_id
  WHERE

     DATE_DIFF(s.admittime,md.icu_intime, DAY) <= 90
     AND s.hadm_id != md.hadm_id;
