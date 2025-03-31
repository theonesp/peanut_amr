-- Select the data of hadm_id with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
-- Select the  amines administration previous cultive request present in inputevents table

WITH AntibioticsGiven AS (
  SELECT
    emar.subject_id,
    emar.hadm_id,
    emar.charttime AS antibiotic_charttime,
    emar.medication,
    md.charttime AS cultive_charttime
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_hosp.emar` emar
  ON
    emar.hadm_id = md.hadm_id
  WHERE
    LOWER(emar.medication) LIKE '%cefotaxime%'
    OR LOWER(emar.medication) LIKE '%ceftriaxone%'
    OR LOWER(emar.medication) LIKE '%ceftazidime%'
    OR LOWER(emar.medication) LIKE '%cefepime%'
    OR LOWER(emar.medication) LIKE '%meropenem%'
    OR LOWER(emar.medication) LIKE '%imipenem%'
    OR LOWER(emar.medication) LIKE '%trimethoprim%'
    OR LOWER(emar.medication) LIKE '%sulfamethoxazole%'
    OR LOWER(emar.medication) LIKE '%vancomycin%'
    OR LOWER(emar.medication) LIKE '%oxacillin%'
    AND emar.event_txt IN (
      'Administered',
      'Delayed Administered',
      'Administered in Other Location',
      'Partial Administered',
      'Started',
      'Restarted',
      'Delayed Started',
      'Started in Other Location'
    )
    AND md.admittime < emar.charttime AND
    emar.charttime < md.charttime -- Only antibiotics administered BEFORE the culture time
)
SELECT
  DISTINCT -- Avoid duplicates
  hadm_id,
  medication,
  cultive_charttime
FROM
  AntibioticsGiven
ORDER BY
   hadm_id, medication;
