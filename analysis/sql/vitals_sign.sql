-- Select the data of stay_id (ICU stays) with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'

WITH PreviousVitalSign AS (
  -- Subquery to get the closest previous vitalsign record by stay_id
  SELECT
    s.*,
    md.charttime as cultive_charttime,
    ROW_NUMBER() OVER (PARTITION BY s.stay_id, md.charttime ORDER BY s.charttime DESC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
  `physionet-data.mimiciv_derived.vitalsign` s
    
  ON
    s.stay_id = md.stay_id
    AND s.charttime < md.charttime -- Filtrar por charttime anterior
)

-- Final query to select the closest previous vitalsign registration by stay_id
SELECT
  ps.*
FROM
  PreviousVitalSign ps
WHERE
  ps.RowNum = 1;