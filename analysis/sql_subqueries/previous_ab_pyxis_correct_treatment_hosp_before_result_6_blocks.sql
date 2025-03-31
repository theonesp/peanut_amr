WITH PreviousAmines AS (
  -- Subquery to get the closest previous ab administration by subject_id
  SELECT
    s.*,
    md.charttime AS cultive_charttime,
    md.*
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_ed.pyxis` s
  ON
    s.stay_id = md.stay_id
  WHERE
    ( LOWER(s.name) LIKE '%cefotaxime%'
    OR LOWER(s.name) LIKE '%ceftriaxone%'
    OR LOWER(s.name) LIKE '%ceftazidime%'
    OR LOWER(s.name) LIKE '%cefepime%'
    OR LOWER(s.name) LIKE '%meropenem%'
    OR LOWER(s.name) LIKE '%imipenem%'
    OR LOWER(s.name) LIKE '%trimethoprim%'
    OR LOWER(s.name) LIKE '%sulfamethoxazole%'
    OR LOWER(s.name) LIKE '%vancomycin%'
    OR LOWER(s.name) LIKE '%oxacillin%'    
    )
    AND  md.admittime < s.charttime
  AND s.charttime < md.charttime -- ensure starttime is before cultive result and after admission
)

-- Final query to select the closest previous ab administration by stay_id
SELECT 
*
-- hadm_id,
-- stay_id,
-- cultive_charttime,
-- charttime,
-- name
FROM
  PreviousAmines ps;
