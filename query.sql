--B.1) Creare il calendario delle gare di un circolo in un anno. Il calendario deve essere un documento XML.
SELECT XMLELEMENT("calendario",
            XMLATTRIBUTES(c.nome AS "circolo"),
            XMLAgg(
                XMLElement("gara",
                    XMLATTRIBUTES(value(g).data AS data, value(g).sponsor AS sponsor),
                    value(g).nome
                    )
                    order by value(g).data
            )
        ).getstringval()
FROM circoli c, table(c.gare) g 
where c.nome='Golf Club Milano' AND extract(YEAR from value(g).data) = 2009
group by c.nome;

--B.2) Determinare il circolo a cui è iscritto un dato golfista
SELECT DEREF(circolo).nome from giocatori where numerotessera='MC1001';

--B.3) Determinare i golfisti che partecipano solo a gare organizzate dal proprio circolo solo per i propri soci
SELECT DISTINCT VALUE(p).giocatore.numeroTessera FROM gare g, TABLE(g.punteggi) p WHERE privata = 1
MINUS
SELECT VALUE(p).giocatore.numeroTessera 
FROM gare g, TABLE(g.punteggi) p 
WHERE privata = 0

--B.4) Per ogni gara, determinare i golfisti ritirati. Ordinare la lista in base al numero di buche che sono state completate
SELECT g.nome, XMLElement("ritirati", XMLAgg(
                XMLElement("giocatore", 
                 XMLAttributes(s.buche_completate AS "buche_completate"),
                 deref(s.giocatore).nome)
               order by s.buche_completate DESC)
             ).getstringval()  ritirati
from gare g, table(g.punteggi) s 
where s.buche_completate<9 --ritirato
group by g.nome

--b.5)

SELECT XMLQUERY('
<classifica>{
    for $c in $cat/category_list/category
    let $nprizes := $c/@numPrize
    let $tgiocatori := if($c/@type = "Over") then(
                            $doc//classifica/giocatore[@eta>=$c/@age]
                        )else if($c/@type = "Lady") then(
                            $doc//classifica/giocatore[@sesso="f"]
                        )else(
                            $doc//classifica/giocatore[@handicap>$c/@from and @handicap<$c/@to]
                        )
    let $giocatori := $tgiocatori                  
        
    return 
        <categoria tipo="{$c/@type}" posti="{$nprizes}">{
            (for $g in $giocatori
            let $ord := $g/@punteggio 
            order by $ord ascending
            return $g)[position()<=$nprizes]
        }</categoria>
    }</classifica>
    '
    PASSING itab1.doc AS "doc", itab2.categorie AS "cat"
    RETURNING CONTENT) classifica
FROM ( SELECT XMLELEMENT(
                "classifica", XMLAGG(XMLELEMENT(
                    "giocatore",
                    XMLATTRIBUTES(
                        value(p).giocatore.numerotessera AS "numero_tessera",(CASE
                            WHEN(value(p).risultato - value(p).giocatore.handicap) < g.partotale() THEN 'true'
                            ELSE 'false'
                        END) AS "sotto_par",(value(p).risultato - value(p).giocatore.handicap) AS "punteggio", value(p).giocatore
                        .sesso AS "sesso", value(p).giocatore.eta AS "eta",
                        value(p).giocatore.handicap AS "handicap"
                    ), value(p).giocatore.nome
                      || ' '
                      || value(p).giocatore.cognome
                       
                ) ORDER BY giocatore DESC )
            ) doc
        FROM  gare g, TABLE ( g.punteggi ) p
        WHERE nome = 'Coppa del presidente' AND value(p).buche_completate = 9
        GROUP BY nome
    ) itab1,
    ( SELECT g2.categorie
        FROM gare g2
        WHERE g2.nome = 'Coppa del presidente'
    ) itab2