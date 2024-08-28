WITH FilteredMicrobiologyEvents AS (
  SELECT
    hadm_id,
    org_name,
    ab_name,
    microevent_id,
    interpretation,
    charttime,
    storetime,
    spec_type_desc,
    subject_id
  FROM
    `physionet-data.mimiciv_hosp.microbiologyevents`
  WHERE
    (
      (org_name IN ('ESCHERICHIA COLI', 'PROTEUS MIRABILIS', 'ENTEROBACTER CLOACAE COMPLEX', 'STREPTOCOCCUS PNEUMONIAE', 'ENTEROBACTER CLOACAE', 'ENTEROBACTER SPECIES') AND ab_name IN ('CEFTRIAXONE', 'CEFEPIME', 'CEFTAZIDIME'))
      OR (org_name IN ('ESCHERICHIA COLI' , 'PROTEUS MIRABILIS', 'ENTEROBACTER CLOACAE COMPLEX' , 'STREPTOCOCCUS PNEUMONIAE' , 'ENTEROBACTER CLOACAE' , 'ENTEROBACTER SPECIES') AND ab_name IN ('MEROPENEM', 'IMIPENEM'))
      OR (org_name IN ('PSEUDOMONAS AERUGINOSA', 'ACINETOBACTER BAUMANNII COMPLEX', 'ACINETOBACTER BAUMANNII') AND ab_name IN ('MEROPENEM', 'IMIPENEM'))
      OR (org_name IN ('STENOTROPHOMONAS MALTOPHILIA')  AND ab_name IN ('TRIMETHOPRIM/SULFA'))
      OR (org_name IN ('ENTEROCOCCUS FAECIUM') AND ab_name IN ('VANCOMYCIN'))
      OR (org_name IN ('STAPH AUREUS COAG +', 'POSITIVE FOR METHICILLIN RESISTANT STAPH AUREUS', 'S. AUREUS POSITIVE; MRSA POSITIVE','S. AUREUS POSITIVE; MRSA NEGATIVE') AND ab_name IN ('OXACILLIN'))
    )
    AND 
    interpretation IN ('R', 'S', 'I') -- Incluyendo 'I' para luego convertirlo a 'S'
    AND charttime IS NOT NULL -- Excluir NaT (Not a Time)
    AND interpretation != 'P' -- Excluir 'P'
    AND hadm_id IS NOT NULL
)

SELECT
  me.*,
  icu.*
  -- COUNT(DISTINCT me.stay_id )
FROM
  FilteredMicrobiologyEvents me
LEFT JOIN
  `physionet-data.mimiciv_derived.icustay_detail` icu
ON
  me.hadm_id = icu.hadm_id
