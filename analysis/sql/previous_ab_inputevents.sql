-- Select the data of stay_id (ICU stays) with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
-- Select the  amines administration previous cultive request present in inputevents table
WITH PreviousAmines AS (
  -- Subquery to get the closest previous ab record by stay_id
  SELECT
    s.itemid,
    s.starttime,
    md.charttime as cultive_charttime,
    s.stay_id,
    s.amount,
    s.rate,

    ROW_NUMBER() OVER (PARTITION BY s.stay_id, md.charttime ORDER BY s.starttime DESC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
  
  `physionet-data.mimiciv_icu.inputevents` s
    
  ON
    s.stay_id = md.stay_id
  WHERE 
    s.starttime < md.charttime -- ensure starttime is before charttime
    AND DATE_DIFF(md.charttime, s.starttime, DAY) <= 90 -- time window
)

-- Final query to select the closest previous ab registration by stay_id
SELECT *
-- COUNT(DISTINCT ps.stay_id) AS unique_stay_count
FROM
  PreviousAmines ps
WHERE
  ps.stay_id IS NOT NULL 
 AND ps.itemid IN (225662,226068,226069,227447,227448,227449,225840,225842,225843	,225845	,225847	,225850	,225851	,225853	,225855	,225859	,225860	,225875,225879,225881,225883,225884,225886,225888,225899,227691,229059,229587,226403) 