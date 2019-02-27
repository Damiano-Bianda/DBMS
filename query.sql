--B.1) Creare il calendario delle gare di un circolo in un anno. Il calendario deve essere un documento XML.
SELECT XMLELEMENT("calendario",
            XMLATTRIBUTES(c.nome AS "circolo"),
            XMLAgg(
                XMLElement("gara",
                    XMLATTRIBUTES(value(g).data AS data, value(g).sponsor AS sponsor),
                    value(g).nome
                    )
            )
        )
FROM circoli c, table(c.gare) g 
where c.nome='Golf Club Milano' AND extract(YEAR from value(g).data) = 2009
group by c.nome;

--B.2) Determinare il circolo a cui è iscritto un dato golfista
SELECT DEREF(circolo).nome from giocatori where numerotessera='MC1001';

--B.3) Determinare i golfisti che partecipano solo a gare organizzate dal proprio circolo solo per i propri soci

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
