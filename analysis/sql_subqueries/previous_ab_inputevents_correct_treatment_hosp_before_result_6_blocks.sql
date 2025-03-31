-- Select the data of stay_id (ICU stays) with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
-- Select the  amines administration previous cultive request present in inputevents table
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
    md.hadm_id,
    s.itemid,
    md.admittime, --hospital admission
    s.starttime, --antibiotic administration
    md.charttime as cultive_charttime,
    s.stay_id,
    s.amount,
    s.rate,
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
  
  `physionet-data.mimiciv_icu.inputevents` s
    
  ON
    s.stay_id = md.stay_id
  WHERE 
    md.admittime < s.starttime
  AND s.starttime < md.charttime -- ensure starttime is before cultive result and after admission
)

-- Final query to select the closest previous ab registration by stay_id
SELECT 
  DISTINCT -- Avoid duplicates
  hadm_id,
  stay_id,
  itemid,
  ps.admittime,
  ps.starttime,
  cultive_charttime
FROM
  PreviousAmines ps
WHERE
  ps.stay_id IS NOT NULL
  -- AND hadm_id IS NOT NULL
 AND ps.itemid IN (225697, 226064, 226065, 227453, 227454, 227455, 225798, 225851, 225853, 225855, 225876, 225883, 225889) --extracted from table d_items
