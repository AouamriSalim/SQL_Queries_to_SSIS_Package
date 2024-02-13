WITH Query1 AS (
    SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE(SUM(montant) / 1000, 0) AS masse
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = 'ZNT' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa
),
Query2 AS (
    SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE(COUNT(Matricule),0) AS eff_reel
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = '030' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa

),
Query3 AS (
    SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE(SUM(Taux),0) as hnt
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = '030' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa

),
Query4 AS (
select 
     (CASE 
          WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
          WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
     END ) as Pole,
     CODE_groupe,Mmaa,
     COALESCE(SUM(Base)/1000,0) as Sal_Base 
 from 
     RH.Tab_Archive_paie_partielle
where 
     Code_Rubrique IN ('030','031','032') and Mmaa='20230501'
group by 
     (CASE 
          WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
          WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
       END ),
       CODE_groupe,Mmaa
),
Query5 AS (
select (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ) as Pole,CODE_groupe,Mmaa,COALESCE(SUM(Base)/1000,0) as Sal_Brut from RH.Tab_Archive_paie_partielle
where Code_Rubrique = '450' and Mmaa='20230501'
group by (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ),CODE_groupe,Mmaa
),
Query6 AS (
           select (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ) as Pole,CODE_groupe,Mmaa,COALESCE(count(Matricule),0) as eff_paye from RH.Tab_Archive_paie_partielle
where Code_Rubrique = '999' and Mmaa='20230501'
group by (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ),CODE_groupe,Mmaa
),
Query7 AS (
select (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ) as Pole,CODE_groupe,Mmaa,COALESCE(count(Matricule),0) as eff_dep from RH.Tab_Archive_paie_partielle
where Code_Rubrique IN ('704','707','708') and Mmaa='20230501'
group by (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ),CODE_groupe,Mmaa
),
Query8 AS (
      select (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ) as Pole,CODE_groupe,Mmaa,COALESCE(sum(Taux),0) as h_supp from RH.Tab_Archive_paie_partielle
where Code_Rubrique IN ('109','113','126','129','114','130') and Mmaa='20230501'
group by (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ),CODE_groupe,Mmaa
),
Query9 AS (
select (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ) as Pole,CODE_groupe,Mmaa,COALESCE(sum(Montant)/1000,0) as autre_indemenite from RH.Tab_Archive_paie_partielle
where Code_Rubrique IN ('656','657','658','667','670','671','672','673','674',
'675','676','677','684','687','688','704','707','708','720','721','722','727','728','729') 
and Mmaa='20230501'
group by (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ),CODE_groupe,Mmaa
),
Query10 AS (
SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE( avg(Taux), 0 ) AS PRC
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = '317' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa
),
Query11 AS (
SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE(  sum(Montant) * 1.43345 / 1000, 0 ) AS Montant_PRC
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = '317' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa
),
Query12 AS (
SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE( avg(Taux), 0 ) AS PRI
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = '350' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa
),
Query13 AS (
SELECT
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END) AS Pole,
        CODE_groupe,Mmaa,
        COALESCE( (sum(Montant) * 1.43345) / 1000, 0 ) AS Montant_PRI
    FROM
        RH.Tab_Archive_paie_partielle
    WHERE
        Code_Rubrique = '350' AND Mmaa = '20230501'
    GROUP BY
        (CASE 
            WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
            WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
        END),
        CODE_groupe,Mmaa
),
Query14 AS (SELECT 
    (CASE 
WHEN RIGHT(LEFT(Matricule,4),1)='_' THEN LEFT(Matricule,3)
WHEN RIGHT(LEFT(Matricule,4),1)<>'_' THEN LEFT(Matricule,4)
END ) as Pole,CODE_groupe,Mmaa,
    COUNT(Matricule) AS Nbr
FROM 
    RH.Tab_Archive_Paie_partielle
WHERE 
CASE 
        WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
        WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
    END =  (CASE 
        WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
        WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
    END  )  and
    Mmaa = '20230501' AND 
    Code_Rubrique = '378' AND 
    Matricule NOT IN (
        SELECT [Matricule]
        FROM RH.Tab_Archive_Paie_partielle
        WHERE 
        CASE 
        WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
        WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
    END =  (CASE 
        WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
        WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
    END  )  and
             Mmaa = '20230501' 
            AND Code_Rubrique = '030'
    )
GROUP BY 
    (CASE 
        WHEN RIGHT(LEFT(Matricule, 4), 1) = '_' THEN LEFT(Matricule, 3)
        WHEN RIGHT(LEFT(Matricule, 4), 1) <> '_' THEN LEFT(Matricule, 4)
    END), CODE_groupe,Mmaa

    
)
SELECT
    COALESCE(Q1.Pole, Q2.Pole, Q3.Pole, Q4.Pole, Q5.Pole, Q6.Pole, Q7.Pole, Q8.Pole, Q9.Pole, Q10.Pole, Q11.Pole, Q12.Pole, Q13.Pole, Q14.Pole) AS Pole,
    COALESCE(Q1.CODE_groupe, Q2.CODE_groupe, Q3.CODE_groupe, Q4.CODE_groupe, Q5.CODE_groupe, Q6.CODE_groupe, Q7.CODE_groupe, Q8.CODE_groupe, Q9.CODE_groupe, Q10.CODE_groupe, Q11.CODE_groupe, Q12.CODE_groupe, Q13.CODE_groupe, Q14.CODE_groupe) AS CODE_groupe,
    COALESCE(Q1.Mmaa,Q2.Mmaa,Q3.Mmaa,Q4.Mmaa,Q5.Mmaa,Q6.Mmaa,Q7.Mmaa,Q8.Mmaa,Q9.Mmaa,Q10.Mmaa,Q11.Mmaa,Q12.Mmaa,Q13.Mmaa,Q14.Mmaa) AS Mmaa,
    COALESCE(Q1.masse, 0) AS masse,
    COALESCE(Q2.eff_reel, 0) AS eff_reel,
    COALESCE(Q3.hnt, 0) AS hnt,
    COALESCE(Q4.Sal_Base, 0) AS Sal_Base,
    COALESCE(Q5.Sal_Brut, 0) AS Sal_Brut,
    COALESCE(Q6.eff_paye, 0)  AS eff_paye,
    COALESCE(Q7.eff_dep, 0) AS eff_dep,
    COALESCE(Q8.h_supp, 0) AS h_supp,
    COALESCE(Q9.autre_indemenite, 0) AS autre_indemenite,
    COALESCE(Q10.PRC, 0) AS PRC,
    COALESCE(Q11.Montant_PRC, 0) AS Montant_PRC,
    COALESCE(Q12.PRI, 0) AS PRI,
    COALESCE(Q13.Montant_PRI, 0) AS Montant_PRI,
    COALESCE(Q14.Nbr, 0) AS Nbr
FROM
    Query1 Q1
FULL JOIN
    Query2 Q2 ON Q1.Pole = Q2.Pole AND Q1.CODE_groupe = Q2.CODE_groupe
FULL JOIN
    Query3 Q3 ON Q1.Pole = Q3.Pole AND Q1.CODE_groupe = Q3.CODE_groupe
FULL JOIN 
    Query4 Q4 ON Q1.Pole = Q4.Pole AND Q1.CODE_groupe = Q4.CODE_groupe
FULL JOIN 
    Query5 Q5 ON Q1.Pole = Q5.Pole AND Q1.CODE_groupe = Q5.CODE_groupe
FULL JOIN 
    Query6 Q6 ON Q1.Pole = Q6.Pole AND Q1.CODE_groupe = Q6.CODE_groupe
FULL JOIN 
    Query7 Q7 ON Q1.Pole = Q7.Pole AND Q1.CODE_groupe = Q7.CODE_groupe
FULL JOIN 
    Query8 Q8 ON Q1.Pole = Q8.Pole AND Q1.CODE_groupe = Q8.CODE_groupe
FULL JOIN 
    Query9 Q9 ON Q1.Pole = Q9.Pole AND Q1.CODE_groupe = Q9.CODE_groupe
FULL JOIN 
    Query10 Q10 ON Q1.Pole = Q10.Pole AND Q1.CODE_groupe = Q10.CODE_groupe
FULL JOIN 
    Query11 Q11 ON Q1.Pole = Q11.Pole AND Q1.CODE_groupe = Q11.CODE_groupe
FULL JOIN 
    Query12 Q12 ON Q1.Pole = Q12.Pole AND Q1.CODE_groupe = Q12.CODE_groupe
FULL JOIN 
    Query13 Q13 ON Q1.Pole = Q13.Pole AND Q1.CODE_groupe = Q13.CODE_groupe
FULL JOIN 
    Query14 Q14 ON Q1.Pole = Q14.Pole AND Q1.CODE_groupe = Q14.CODE_groupe

WHERE
   COALESCE(Q1.CODE_groupe, Q2.CODE_groupe, Q3.CODE_groupe, Q4.CODE_groupe, Q5.CODE_groupe, Q6.CODE_groupe, Q7.CODE_groupe, Q8.CODE_groupe, Q9.CODE_groupe,Q10.CODE_groupe,Q11.CODE_groupe,Q12.CODE_groupe,Q13.CODE_groupe,Q14.CODE_groupe) <> '0'
ORDER BY
    Pole, CODE_groupe,Mmaa