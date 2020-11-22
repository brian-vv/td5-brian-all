-- TD5 --

--  right = produit / left = remplacement --
1/ select produits.reference, qteremplacee, nointerv, designation from produits
LEFT JOIN remplacements on remplacements.reference = produits.reference
ORDER BY qteremplacee DESC

--  right = factures / left = interventions --
2/ select factures.nofacture, interventions.nointerv from factures
LEFT JOIN interventions on interventions.nofacture = factures.nofacture
ORDER BY nofacture, nointerv 


3/ select qteremplacee, reference, nointerv from remplacements WHERE qteremplacee >= ALL (select qteremplacee from remplacements)

--SELECT reference,qteremplacee,COUNT(*) AS NbInterv
--FROM remplacements
--GROUP BY reference, qteremplacee

--select MAX(qteremplacee) as totalremplacee, COUNT(*) as nbInterv ,reference from remplacements
--group by reference


4/ select qteremplacee, reference, nointerv from remplacements WHERE qteremplacee < ANY (select qteremplacee from remplacements)

5/ 

--v1-- 
select clients.nom, interventions.nominterv from clients
join interventions on interventions.noclient = clients.noclient
WHERE interventions.nominterv = 'Bonnaz'

--v2--
select clients.nom, interventions.nominterv from clients
join interventions on interventions.noclient = clients.noclient
WHERE interventions.nominterv = ALL (select nominterv from interventions WHERE nominterv = 'Bonnaz')

--v3--
select noclient, nominterv FROM interventions
EXCEPT  
select noclient, nominterv FROM interventions WHERE nominterv='Saultier' OR nominterv = 'Crespin'

--v4--
select clients.nom, interventions.nominterv from clients
join interventions on interventions.noclient = clients.noclient
WHERE interventions.nominterv = ANY (select nominterv from interventions WHERE nominterv = 'Bonnaz')

--v5--
select nom from clients
JOIN interventions ON clients.noclient=interventions.noclient
WHERE nominterv<>'Saultier' and  nominterv<>'Crespin'




6/ 

-- intervention avec le plus de temps--
--select interventions.temps from interventions WHERE interventions.temps >= ALL (select temps from interventions) 


--v1--

-- plus petit numéro de facture avec le plus de temps | dans l'hypothèse où on choisi que 0.5 de temps sont les factures avec le moins de temps --
select MIN(factures.nofacture) from factures 
join interventions on interventions.nofacture = factures.nofacture
HAVING MAX(interventions.temps)>0

--v1*--

select MIN(nofacture) FROM interventions
WHERE temps<>(select MIN(temps) from interventions)


--v2--

--Plus petit numéro de facture parmi toutes les interventions SAUF celles qui ont duré le moins longtemps--
--cad, je ne veux pas le numéro des factures qui ont durée pas longtemps--
--OU--
--Plus petit numéro de facture parmi toutes les interventions qui ont durées le plus longtemps--
-- j'ai nofacture 1011--
-- Si je rajoute une intervention à 2.5 de temps et comme nofacture 1013, ma requete va choisir le plus petit nofacture etre 1011 et 1013 --


select MIN(nofacture), temps from interventions 
GROUP BY nofacture, temps
EXCEPT
select nofacture, temps from interventions WHERE temps < ANY (select temps from interventions)
GROUP BY nofacture, temps