WITH PreviousChemistry AS (
  -- Subquery to get the closest previous chemistry tests by hadm_id
  SELECT
    s.*,
    md.charttime AS cultive_charttime,
    ROW_NUMBER() OVER (PARTITION BY md.stay_id, md.charttime ORDER BY md.charttime - s.charttime ASC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_derived.chemistry` s
  ON
    s.hadm_id = md.hadm_id
    AND s.charttime < md.charttime -- Filtrar por charttime anterior
--   WHERE
--     TIMESTAMP_DIFF(md.charttime, s.charttime, HOUR) <= 24 -- Administration in the previuos 24 hours
)

-- Final query to select the closest previous amines administration by stay_id
SELECT *
FROM
  PreviousChemistry ps
WHERE
  ps.RowNum = 1;

--  SELECT *
-- FROM physionet-data.mimiciv_derived.chemistry
-- WHERE hadm_id IN (SELECT hadm_id
--   FROM (
    
--   WITH RankedMicrobiologyEvents AS (
--   SELECT
--     hadm_id,
--     org_name,
--     ab_name,
--     interpretation,
--     charttime,
--     storetime,
--     subject_id,
--     ROW_NUMBER() OVER (
--       PARTITION BY hadm_id, org_name, ab_name
--       ORDER BY
--         CASE WHEN interpretation = 'I' THEN 'S' ELSE interpretation END, -- Cambiar 'I' a 'S'
--         charttime ASC -- Ordenar de forma ascendente para obtener el más antiguo primero
--     ) AS RowNum
--   FROM
--     `physionet-data.mimiciv_hosp.microbiologyevents`
--   WHERE
-- interpretation IN ('R', 'S', 'I') -- Incluyendo 'I' para luego convertirlo a 'S'
--     AND charttime IS NOT NULL -- Excluir NaT (Not a Time)
--     AND interpretation != 'P' -- Excluir 'P'
--      AND hadm_id IS NOT NULL
-- )
-- , FilteredMicrobiologyEvents AS (
--   SELECT
--     hadm_id,
--     org_name,
--     ab_name,
--     subject_id,
--     CASE WHEN interpretation = 'I' THEN 'S' ELSE interpretation END AS interpretation,
--     charttime,
--     storetime
--   FROM RankedMicrobiologyEvents
--   WHERE RowNum = 1 -- Seleccionar la fila con el índice más bajo
-- )

-- , ICUStayClosest AS (
--   SELECT
--     me.hadm_id,
--     me.org_name,
--     me.ab_name,
--     me.charttime,
--     me.interpretation,
--     icu.stay_id,
--     icu.gender,
--     icu.dod,
--     dischtime,icu.los_hospital,icu.admission_age,icu.race,
--     hospital_expire_flag,icu.hospstay_seq,icu.first_hosp_stay,
--     icu.los_icu,icu.icustay_seq,icu.first_icu_stay,
--     icu.icu_intime,
--     icu.icu_outtime,

--     ROW_NUMBER() OVER (PARTITION BY me.hadm_id, me.org_name, me.ab_name, me.charttime ORDER BY ABS(DATETIME_DIFF(me.charttime, icu.icu_intime, MINUTE))) AS RowNum
--   FROM
--     FilteredMicrobiologyEvents me
--   INNER  JOIN
--     `physionet-data.mimiciv_derived.icustay_detail` icu
--   ON
--     me.hadm_id = icu.hadm_id
--     AND me.charttime >= icu.icu_intime
--     AND me.charttime <= icu.icu_outtime -- Añadir esta condición
-- )
-- , MergedData AS (
--   SELECT
--     icu_closest.*
--   FROM
--     FilteredMicrobiologyEvents fme
--   INNER JOIN
--     ICUStayClosest icu_closest
--   ON
--     fme.hadm_id = icu_closest.hadm_id
--     AND fme.org_name = icu_closest.org_name
--     AND fme.ab_name = icu_closest.ab_name
--     AND icu_closest.RowNum = 1
-- )  SELECT hadm_id
--     FROM MergedData))
