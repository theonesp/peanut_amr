-- Select the data of hadm_id with data in vitalsigns coming from the following subquery:
-- Select stays that meet the following criteria:
    -- Filter the cultures performed during each stay
    -- If there is more than one culture per stay
    -- Take the first result, prioritizing Resistant ones, by ordering by date in ascending order and selecting the first one that is Resistant; otherwise, take the Sensitive one
    -- Also transform Intermediate results into Sensitive
    -- Exclude those that do not have the following fields: interpretation, charttime, hadm_id
    -- Exclude those with a result of 'P'
-- Select the  amines administration previous cultive request present in inputevents table

WITH PreviousAmines AS (
  -- Subquery to get the closest previous ab administration by hadm_id
  SELECT
    s.*,
    md.charttime AS cultive_charttime,
    ROW_NUMBER() OVER (PARTITION BY md.stay_id, md.charttime ORDER BY md.charttime - s.charttime ASC) AS RowNum
  FROM
    `peanutproject-2024.stay_id_selection_peanut.stay_id_selection` md
  LEFT JOIN
    `physionet-data.mimiciv_hosp.emar` s
  ON
    s.hadm_id = md.hadm_id
  WHERE
    (LOWER(s.medication) LIKE '%ala-tet%' OR
     LOWER(s.medication) LIKE '%alodox%' OR
     LOWER(s.medication) LIKE '%amikacin%' OR
     LOWER(s.medication) LIKE '%amikin%' OR
     LOWER(s.medication) LIKE '%amoxicill%' OR
     LOWER(s.medication) LIKE '%amphotericin%' OR
     LOWER(s.medication) LIKE '%anidulafungin%' OR
     LOWER(s.medication) LIKE '%ancef%' OR
     LOWER(s.medication) LIKE '%clavulanate%' OR
     LOWER(s.medication) LIKE '%ampicillin%' OR
     LOWER(s.medication) LIKE '%augmentin%' OR
     LOWER(s.medication) LIKE '%avelox%' OR
     LOWER(s.medication) LIKE '%avidoxy%' OR
     LOWER(s.medication) LIKE '%azactam%' OR
     LOWER(s.medication) LIKE '%azithromycin%' OR
     LOWER(s.medication) LIKE '%aztreonam%' OR
     LOWER(s.medication) LIKE '%axetil%' OR
     LOWER(s.medication) LIKE '%bactocill%' OR
     LOWER(s.medication) LIKE '%bactrim%' OR
     LOWER(s.medication) LIKE '%bactroban%' OR
     LOWER(s.medication) LIKE '%bethkis%' OR
     LOWER(s.medication) LIKE '%biaxin%' OR
     LOWER(s.medication) LIKE '%bicillin l-a%' OR
     LOWER(s.medication) LIKE '%cayston%' OR
     LOWER(s.medication) LIKE '%cefazolin%' OR
     LOWER(s.medication) LIKE '%cedax%' OR
     LOWER(s.medication) LIKE '%cefoxitin%' OR
     LOWER(s.medication) LIKE '%ceftazidime%' OR
     LOWER(s.medication) LIKE '%cefaclor%' OR
     LOWER(s.medication) LIKE '%cefadroxil%' OR
     LOWER(s.medication) LIKE '%cefdinir%' OR
     LOWER(s.medication) LIKE '%cefditoren%' OR
     LOWER(s.medication) LIKE '%cefepime%' OR
     LOWER(s.medication) LIKE '%cefotan%' OR
     LOWER(s.medication) LIKE '%cefotetan%' OR
     LOWER(s.medication) LIKE '%cefotaxime%' OR
     LOWER(s.medication) LIKE '%ceftaroline%' OR
     LOWER(s.medication) LIKE '%cefpodoxime%' OR
     LOWER(s.medication) LIKE '%cefpirome%' OR
     LOWER(s.medication) LIKE '%cefprozil%' OR
     LOWER(s.medication) LIKE '%ceftibuten%' OR
     LOWER(s.medication) LIKE '%ceftin%' OR
     LOWER(s.medication) LIKE '%ceftriaxone%' OR
     LOWER(s.medication) LIKE '%cefuroxime%' OR
     LOWER(s.medication) LIKE '%cephalexin%' OR
     LOWER(s.medication) LIKE '%cephalothin%' OR
     LOWER(s.medication) LIKE '%cephapririn%' OR
     LOWER(s.medication) LIKE '%chloramphenicol%' OR
     LOWER(s.medication) LIKE '%cipro%' OR
     LOWER(s.medication) LIKE '%ciprofloxacin%' OR
     LOWER(s.medication) LIKE '%claforan%' OR
     LOWER(s.medication) LIKE '%clarithromycin%' OR
     LOWER(s.medication) LIKE '%cleocin%' OR
     LOWER(s.medication) LIKE '%clindamycin%' OR
     LOWER(s.medication) LIKE '%cubicin%' OR
     LOWER(s.medication) LIKE '%dicloxacillin%' OR
     LOWER(s.medication) LIKE '%dirithromycin%' OR
     LOWER(s.medication) LIKE '%doryx%' OR
     LOWER(s.medication) LIKE '%doxycy%' OR
     LOWER(s.medication) LIKE '%duricef%' OR
     LOWER(s.medication) LIKE '%dynacin%' OR
     LOWER(s.medication) LIKE '%ery-tab%' OR
     LOWER(s.medication) LIKE '%eryped%' OR
     LOWER(s.medication) LIKE '%eryc%' OR
     LOWER(s.medication) LIKE '%erythrocin%' OR
     LOWER(s.medication) LIKE '%erythromycin%' OR
     LOWER(s.medication) LIKE '%factive%' OR
     LOWER(s.medication) LIKE '%flagyl%' OR
     LOWER(s.medication) LIKE '%fortaz%' OR
     LOWER(s.medication) LIKE '%furadantin%' OR
     LOWER(s.medication) LIKE '%garamycin%' OR
     LOWER(s.medication) LIKE '%gentamicin%' OR
     LOWER(s.medication) LIKE '%kanamycin%' OR
     LOWER(s.medication) LIKE '%keflex%' OR
     LOWER(s.medication) LIKE '%kefzol%' OR
     LOWER(s.medication) LIKE '%ketek%' OR
     LOWER(s.medication) LIKE '%levaquin%' OR
     LOWER(s.medication) LIKE '%levofloxacin%' OR
     LOWER(s.medication) LIKE '%lincocin%' OR
     LOWER(s.medication) LIKE '%linezolid%' OR
     LOWER(s.medication) LIKE '%macrobid%' OR
     LOWER(s.medication) LIKE '%macrodantin%' OR
     LOWER(s.medication) LIKE '%maxipime%' OR
     LOWER(s.medication) LIKE '%mefoxin%' OR
     LOWER(s.medication) LIKE '%metronidazole%' OR
     LOWER(s.medication) LIKE '%meropenem%' OR
     LOWER(s.medication) LIKE '%methicillin%' OR
     LOWER(s.medication) LIKE '%minocin%' OR
     LOWER(s.medication) LIKE '%minocycline%' OR
     LOWER(s.medication) LIKE '%monodox%' OR
     LOWER(s.medication) LIKE '%monurol%' OR
     LOWER(s.medication) LIKE '%morgidox%' OR
     LOWER(s.medication) LIKE '%moxatag%' OR
     LOWER(s.medication) LIKE '%moxifloxacin%' OR
     LOWER(s.medication) LIKE '%mupirocin%' OR
     LOWER(s.medication) LIKE '%myrac%' OR
     LOWER(s.medication) LIKE '%nafcillin%' OR
     LOWER(s.medication) LIKE '%neomycin%' OR
     LOWER(s.medication) LIKE '%nicazel doxy 30%' OR
     LOWER(s.medication) LIKE '%nitrofurantoin%' OR
     LOWER(s.medication) LIKE '%norfloxacin%' OR
     LOWER(s.medication) LIKE '%noroxin%' OR
     LOWER(s.medication) LIKE '%ocudox%' OR
     LOWER(s.medication) LIKE '%ofloxacin%' OR
     LOWER(s.medication) LIKE '%omnicef%' OR
     LOWER(s.medication) LIKE '%oracea%'     
    )
    AND DATE_DIFF(md.charttime,s.charttime, DAY) <= 90
    AND s.event_txt IN ('Administered', 'Delayed Administered', 'Administered in Other Location', 'Partial Administered', 'Started', 'Restarted', 'Delayed Started', 'Started in Other Location')

)

-- Final query to select the closest previous ab administration by stay_id
SELECT *
FROM
  PreviousAmines ps;