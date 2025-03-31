SELECT
    DISTINCT (s.stay_id)

   FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_icu.icustays` s
  ON
    s.subject_id = md.subject_id
  WHERE
     DATE_DIFF(md.icu_intime,s.intime, YEAR) <= 1
     AND s.stay_id != md.stay_id