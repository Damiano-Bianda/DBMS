insert into circoli values('Golf Club Milano', 'Milano', telefoni_set('0293829','9238421'), gare_set());
insert into circoli values('Golf Club Torino', 'Torino', telefoni_set('2321425','5262192', '2918231'), gare_set());

insert into giocatori values('MC1001', 'Rory', 'Mcllroy', 'm', 53, 2, NULL);
insert into giocatori values('MC1002', 'Dustin', 'Johnson', 'm', 26, 10, NULL);
insert into giocatori values('MC1003', 'Tiger', 'Woods', 'm', 45, 13, NULL);
insert into giocatori values('MC1004', 'Phil', 'Mickelson', 'm', 20, 14, NULL);
insert into giocatori values('MC1005', 'Francesco', 'Molinari', 'm', 23, 24, NULL);
insert into giocatori values('MC1006', 'Sergio', 'Garcia Fernandez', 'm', 42, 32, NULL);
insert into giocatori values('MC1007', 'Henrik', 'Stenson', 'm', 33, 36, NULL);
insert into giocatori values('MC1008', 'Justin', 'Rose', 'm', 62, 5, NULL);
insert into giocatori values('MC1009', 'Phil', 'Mickelson', 'm', 41, 27, NULL);
insert into giocatori values('MC1010', 'Jordan', 'Spieth', 'm', 38, 31, NULL);

insert into giocatori values('FC1001', 'Annika', 'Sorenstam', 'f', 22, 4, NULL);
insert into giocatori values('FC1002', 'Stacy', 'Lewis', 'f', 43, 8, NULL);
insert into giocatori values('FC1003', 'Ariya', 'Jutanugarn', 'f', 36, 12, NULL);
insert into giocatori values('FC1004', 'Lydia', 'Ko', 'f', 19, 16, NULL);
insert into giocatori values('FC1005', 'Michelle', 'Wie', 'f', 44, 24, NULL);
insert into giocatori values('FC1006', 'Paula', 'Creamer', 'f', 23, 22, NULL);
insert into giocatori values('FC1007', 'Suzann', 'Pettersen', 'f', 54, 30, NULL);
insert into giocatori values('FC1008', 'Ryu', 'So-Yeon', 'f', 43, 1, NULL);
insert into giocatori values('FC1009', 'Veronica', 'Zorzi', 'f', 22, 6, NULL);
insert into giocatori values('FC1010', 'Linda', 'Wessberg', 'f', 35, 35, NULL);

update giocatori set circolo = (select ref(c) from circoli c where nome = 'Golf Club Milano') where mod(eta, 2) = 0;
update giocatori set circolo = (select ref(c) from circoli c where nome = 'Golf Club Torino') where mod(eta, 2) = 1;

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
<category numPrize="3" from="0" to="12" type="First"/>
<category numPrize="3" from="13" to="24" type="Second"/>
<category numPrize="2" from="25" to="36" type="Third"/>
<category numPrize="1" type="Lady"/>
<category numPrize="1" type="Over" age="40"/>
</golfCompetition>');


CALL valida_gara('<?xml version="1.0" encoding="UTF-8"?>
<golfCompetition xsi:noNamespaceSchemaLocation="GolfCompetition.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<name>Coppa del mondo</name>
<date>2009-12-25</date>
<sponsor>Lavazza S.p.A</sponsor>
<buche>
<buca par="5" />
<buca par="6" />
<buca par="5" />
<buca par="5" />
<buca par="5" />
<buca par="6" />
<buca par="4" />
<buca par="3" />
<buca par="1" />
</buche>
<category numPrize="3" from="0" to="12" type="First"/>
<category numPrize="3" from="13" to="24" type="Second"/>
<category numPrize="2" from="25" to="36" type="Third"/>
<category numPrize="1" type="Lady"/>
<category numPrize="1" type="Over" age="40"/>
<reserved>true</reserved>
</golfCompetition>');

call valida_punteggio('<golfscore xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GolfScore.xsd">
<name id="324" par="35">Coppa del mondo</name>
<date>2018-12-25</date>
<player>MC1001</player>
<results>
<hole number="1" par="4">4</hole>
<hole number="2" par="5">4</hole>
<hole number="3" par="3">4</hole>
<hole number="4" par="4">3</hole>
<hole number="5" par="4">5</hole>
<hole number="6" par="5">6</hole>
<hole number="7" par="3">4</hole>
<hole number="8" par="5">6</hole>
<hole number="9" par="3">4</hole>
<jolly>2</jolly>
</results>
</golfscore>');