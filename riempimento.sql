insert into circoli values('Golf Club Milano', 'Milano', telefoni_set('0293829','9238421'), gare_set());
insert into circoli values('Golf Club Torino', 'Torino', telefoni_set('2321425','5262192', '2918231'), gare_set());

-- giocatori milano
insert into giocatori values('MC1001', 'Dustin', 'Johnson', 'm', 26, 10, NULL);
insert into giocatori values('MC1002', 'Sergio', 'Garcia Fernandez', 'm', 42, 20, NULL);

insert into giocatori values('FC1001', 'Annika', 'Sorenstam', 'f', 22, 4, NULL);
insert into giocatori values('FC1002', 'Ariya', 'Jutanugarn', 'f', 36, 17, NULL);

-- giocatori torino
insert into giocatori values('MC1003', 'Rory', 'Mcllroy', 'm', 53, 2, NULL);
insert into giocatori values('MC1004', 'Francesco', 'Molinari', 'm', 23, 27, NULL);

insert into giocatori values('FC1003', 'Stacy', 'Lewis', 'f', 43, 8, NULL);
insert into giocatori values('FC1004', 'Paula', 'Creamer', 'f', 23, 35, NULL);

-- giocatore club torino che gioca solo in gare reserved di torino
insert into giocatori values('FC1005', 'Alessandra', 'Del Piero', 'f', 45, 12, NULL);

update giocatori set circolo = (select ref(c) from circoli c where nome = 'Golf Club Milano') where mod(eta, 2) = 0;
update giocatori set circolo = (select ref(c) from circoli c where nome = 'Golf Club Torino') where mod(eta, 2) = 1;

-- gare Golf Club Milano

-- testa la classifica con le varie categorie
CALL valida_gara('<?xml version="1.0" encoding="UTF-8"?>
<golfCompetition xsi:noNamespaceSchemaLocation="GolfCompetition.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<name>Coppa del presidente</name>
<date>2009-12-25</date>
<sponsor>Lavazza S.p.A</sponsor>
<buche>
<buca par="4" />
<buca par="5" />
<buca par="3" />
<buca par="4" />
<buca par="4" />
<buca par="5" />
<buca par="3" />
<buca par="5" />
<buca par="3" />
</buche>
<category numPrize="3" from="0" to="15" type="First"/>
<category numPrize="3" from="16" to="36" type="Second"/>
<category numPrize="1" type="Lady"/>
<category numPrize="1" type="Over" age="40"/>
</golfCompetition>');

UPDATE circoli set gare = gare MULTISET UNION gare_set(
    (SELECT ref(g) FROM gare g where nome='Coppa del presidente')
) WHERE nome='Golf Club Milano';



-- Coppa del presidente
-- first
-- MC1001, FC1001		MC1003, FC1003
-- second
-- MC1002, FC1002		MC1004, FC1004
-- lady		 	ok
-- over 40		ok

-- first from="0" to="15"
-- MC1001 handicap 10, totale buche 50 	-> 	40
-- FC1001 handicap 4, totale buche 38 	->	34
-- MC1003 handicap 2, totale buche 35	->	33
-- FC1003 handicap 8, totale buche 46	->	38
-- MC1003 (33), FC1001 (34), FC1003 (38), MC1001 (40)

-- MC1001 handicap 10, totale buche 50 	-> 	40
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>MC1001</player>
<results>
<hole number="1" par="4">5</hole>
<hole number="2" par="5">5</hole>
<hole number="3" par="3">6</hole>
<hole number="4" par="4">4</hole>
<hole number="5" par="4">3</hole>
<hole number="6" par="5">7</hole>
<hole number="7" par="3">7</hole>
<hole number="8" par="5">7</hole>
<hole number="9" par="3">6</hole>
</results>
</golfscore>');

-- FC1001 handicap 4, totale buche 38 	->	34
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>FC1001</player>
<results>
<hole number="1" par="4">3</hole>
<hole number="2" par="5">4</hole>
<hole number="3" par="3">2</hole>
<hole number="4" par="4">5</hole>
<hole number="5" par="4">7</hole>
<hole number="6" par="5">5</hole>
<hole number="7" par="3">5</hole>
<hole number="8" par="5">3</hole>
<hole number="9" par="3">4</hole>
</results>
</golfscore>');


-- MC1003 handicap 2, totale buche 35	->	33
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>MC1003</player>
<results>
<hole number="1" par="4">2</hole>
<hole number="2" par="5">4</hole>
<hole number="3" par="3">1</hole>
<hole number="4" par="4">5</hole>
<hole number="5" par="4">6</hole>
<hole number="6" par="5">5</hole>
<hole number="7" par="3">5</hole>
<hole number="8" par="5">3</hole>
<hole number="9" par="3">4</hole>
</results>
</golfscore>');


-- FC1003 handicap 8, totale buche 46	->	38
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>FC1003</player>
<results>
<hole number="1" par="4">4</hole>
<hole number="2" par="5">4</hole>
<hole number="3" par="3">3</hole>
<hole number="4" par="4">6</hole>
<hole number="5" par="4">6</hole>
<hole number="6" par="5">6</hole>
<hole number="7" par="3">6</hole>
<hole number="8" par="5">6</hole>
<hole number="9" par="3">5</hole>
</results>
</golfscore>');

-- MC1003 (33), FC1001 (34), FC1003 (38), MC1001 (40)

-- second from="16" to="36"
-- MC1002 handicap 20, totale buche 59 	-> 	39
-- FC1002 handicap 17, totale buche 49 	-> 	32
-- MC1004 handicap 27, totale buche 58 	-> 	31
-- FC1004 handicap 35, totale buche 71 	-> 	36

-- MC1002 handicap 20, totale buche 59 	-> 	39
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>MC1002</player>
<results>
<hole number="1" par="4">7</hole>
<hole number="2" par="5">6</hole>
<hole number="3" par="3">7</hole>
<hole number="4" par="4">7</hole>
<hole number="5" par="4">6</hole>
<hole number="6" par="5">7</hole>
<hole number="7" par="3">7</hole>
<hole number="8" par="5">6</hole>
<hole number="9" par="3">6</hole>
</results>
</golfscore>');

-- FC1002 handicap 17, totale buche 49 	-> 	32
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>FC1002</player>
<results>
<hole number="1" par="4">5</hole>
<hole number="2" par="5">6</hole>
<hole number="3" par="3">5</hole>
<hole number="4" par="4">4</hole>
<hole number="5" par="4">6</hole>
<hole number="6" par="5">5</hole>
<hole number="7" par="3">7</hole>
<hole number="8" par="5">6</hole>
<hole number="9" par="3">5</hole>
</results>
</golfscore>');

-- MC1004 handicap 27, totale buche 58 	-> 	31
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>MC1004</player>
<results>
<hole number="1" par="4">5</hole>
<hole number="2" par="5">6</hole>
<hole number="3" par="3">5</hole>
<hole number="4" par="4">7</hole>
<hole number="5" par="4">6</hole>
<hole number="6" par="5">5</hole>
<hole number="7" par="3">7</hole>
<hole number="8" par="5">9</hole>
<hole number="9" par="3">8</hole>
</results>
</golfscore>');

-- FC1004 handicap 35, totale buche 71 	-> 	36
call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del presidente</name>
<date>2009-12-25</date>
<player>FC1004</player>
<results>
<hole number="1" par="4">10</hole>
<hole number="2" par="5">6</hole>
<hole number="3" par="3">10</hole>
<hole number="4" par="4">10</hole>
<hole number="5" par="4">6</hole>
<hole number="6" par="5">5</hole>
<hole number="7" par="3">7</hole>
<hole number="8" par="5">9</hole>
<hole number="9" par="3">8</hole>
</results>
</golfscore>');


-- inserisco 4 giocatori di cui 2 ritirato (MC1001, MC1002, FC1001, FC1002)
CALL valida_gara('<?xml version="1.0" encoding="UTF-8"?>
<golfCompetition xsi:noNamespaceSchemaLocation="GolfCompetition.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<name>Coppa del mondo</name>
<date>2009-6-10</date>
<sponsor>Nike</sponsor>
<buche>
<buca par="2" />
<buca par="3" />
<buca par="4" />
<buca par="2" />
<buca par="3" />
<buca par="2" />
<buca par="2" />
<buca par="3" />
<buca par="2" />
</buche>
<category numPrize="2" from="0" to="36" type="First"/>
</golfCompetition>');


UPDATE circoli set gare = gare MULTISET UNION gare_set(
    (SELECT ref(g) FROM gare g where nome='Coppa del mondo')
) WHERE nome='Golf Club Milano';

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="23">Coppa del mondo</name>
<date>2009-6-10</date>
<player>MC1001</player>
<results>
<hole number="1" par="2">1</hole>
<hole number="2" par="3">2</hole>
<hole number="3" par="4">3</hole>
<hole number="4" par="2">4</hole>
<hole number="5" par="3">5</hole>
<hole number="6" par="2">6</hole>
<hole number="7" par="2">7</hole>
<hole number="8" par="3">8</hole>
<hole number="9" par="2">9</hole>
</results>
</golfscore>');

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="23">Coppa del mondo</name>
<date>2009-6-10</date>
<player>MC1002</player>
<results>
<hole number="1" par="2">2</hole>
<hole number="2" par="3">2</hole>
<hole number="3" par="4">2</hole>
<hole number="4" par="2">2</hole>
<hole number="5" par="3">3</hole>
<hole number="6" par="2">3</hole>
<hole number="7" par="2">3</hole>
<hole number="8" par="3">3</hole>
<hole number="9" par="2">3</hole>
</results>
</golfscore>');

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="23">Coppa del mondo</name>
<date>2009-6-10</date>
<player>FC1001</player>
<results>
<hole number="1" par="2">10</hole>
<hole number="2" par="3">10</hole>
<hole number="3" par="4">10</hole>
<hole number="4" par="2">10</hole>
<hole number="5" par="3">5</hole>
</results>
</golfscore>');

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="23">Coppa del mondo</name>
<date>2009-6-10</date>
<player>FC1002</player>
<results>
<hole number="1" par="2">10</hole>
<hole number="2" par="3">10</hole>
<hole number="3" par="4">10</hole>
<hole number="4" par="2">10</hole>
</results>
</golfscore>');

-- gare Golf Club Torino

-- gara reserved in cui c'è FC1005, che gioca solo in gare reserved del proprio club
CALL valida_gara('<?xml version="1.0" encoding="UTF-8"?>
<golfCompetition xsi:noNamespaceSchemaLocation="GolfCompetition.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<name>Coppa dei campioni</name>
<date>2012-08-26</date>
<sponsor>Nissan</sponsor>
<buche>
<buca par="6" />
<buca par="3" />
<buca par="2" />
<buca par="8" />
<buca par="2" />
<buca par="3" />
<buca par="4" />
<buca par="6" />
<buca par="7" />
</buche>
<category numPrize="2" from="0" to="36" type="Lady"/>
<reserved>true</reserved>
</golfCompetition>');


UPDATE circoli set gare = gare MULTISET UNION gare_set(
    (SELECT ref(g) FROM gare g where nome='Coppa dei campioni')
) WHERE nome='Golf Club Torino';

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="23">Coppa dei campioni</name>
<date>2012-08-26</date>
<player>FC1004</player>
<results>
<hole number="1" par="2">6</hole>
<hole number="2" par="3">6</hole>
<hole number="3" par="4">6</hole>
<hole number="4" par="2">6</hole>
<hole number="5" par="3">6</hole>
<hole number="6" par="2">6</hole>
<hole number="7" par="2">6</hole>
<hole number="8" par="3">6</hole>
<hole number="9" par="2">6</hole>
</results>
</golfscore>');

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="23">Coppa dei campioni</name>
<date>2012-08-26</date>
<player>FC1005</player>
<results>
<hole number="1" par="2">6</hole>
<hole number="2" par="3">6</hole>
<hole number="3" par="4">6</hole>
<hole number="4" par="2">6</hole>
<hole number="5" par="3">6</hole>
<hole number="6" par="2">6</hole>
<hole number="7" par="2">6</hole>
<hole number="8" par="3">6</hole>
<hole number="9" par="2">6</hole>
</results>
</golfscore>');

select c.nome as circolo, value(g).nome as giocatore, value(p).giocatore.numeroTessera as id, value(p).risultato as punti, value(p).buche_completate as buche, value(p).giocatore.handicap as handicap
from circoli c, table(c.gare) g, table(value(g).punteggi) p;