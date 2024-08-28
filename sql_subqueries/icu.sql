SELECT *
FROM physionet-data.mimiciv_derived.icustay_detail
WHERE subject_id IN (SELECT subject_id
  FROM (
WITH RankedMicrobiologyEvents AS (
  SELECT
    hadm_id,
    org_name,
    ab_name,
    interpretation,
    charttime,
    storetime,
    subject_id,
    ROW_NUMBER() OVER (
      PARTITION BY hadm_id, org_name, ab_name
      ORDER BY
        CASE WHEN interpretation = 'I' THEN 'S' ELSE interpretation END, -- Cambiar 'I' a 'S'
        charttime ASC -- Ordenar de forma ascendente para obtener el más antiguo primero
    ) AS RowNum
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


    AND interpretation IN ('R', 'S', 'I') -- Incluyendo 'I' para luego convertirlo a 'S'
    AND charttime IS NOT NULL -- Excluir NaT (Not a Time)
    AND interpretation != 'P' -- Excluir 'P'
     AND hadm_id IS NOT NULL
)
, FilteredMicrobiologyEvents AS (
  SELECT
    hadm_id,
    org_name,
    ab_name,
    subject_id,
    CASE WHEN interpretation = 'I' THEN 'S' ELSE interpretation END AS interpretation,
    charttime,
    storetime
  FROM RankedMicrobiologyEvents
  WHERE RowNum = 1 -- Seleccionar la fila con el índice más bajo
)
    SELECT subject_id
    FROM FilteredMicrobiologyEvents
  )
);