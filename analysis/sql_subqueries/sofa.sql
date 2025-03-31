-- Select the data of stay_id (ICU stays) with data in sofa coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
    -- 150524: Returns: 7719 unique stays and 7562 hadm_id
-- 150524: Returns: 7511 unique stays with sofa registries
    
WITH PreviousSofa AS (
  -- Subquery to get the closest previous sofa record by stay_id
  SELECT
    s.*,
    md.charttime as cultive_charttime,
    ROW_NUMBER() OVER (PARTITION BY s.stay_id, md.charttime ORDER BY s.starttime DESC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_derived.sofa` s
  ON
    s.stay_id = md.stay_id
    AND s.starttime < md.charttime -- Filtrar por charttime anterior
)

-- Final query to select the closest previous sofa registration by stay_id
SELECT
  ps.*
FROM
  PreviousSofa ps
WHERE
  ps.RowNum = 1
  AND ps.stay_id IS NOT NULL;
