drop type circolo_t force;
drop type gara_t force;
drop type gare_set force;
drop type giocatore_t force;
drop type punteggi_set force;
drop type punteggio_t force;
drop type telefoni_set force;

drop table gare force;
drop table circoli force;
drop table giocatori force;

-- schemi

BEGIN
    dbms_xmlschema.deleteSchema(schemaURL  => 'GolfCompetition.xsd');
    dbms_xmlschema.deleteSchema(schemaURL  => 'GolfScore.xsd');    
END;

BEGIN   
   dbms_xmlschema.registerSchema(schemaURL   => 'GolfCompetition.xsd', 
                                 schemaDoc   => '<?xml version="1.0" encoding="UTF-8"?>
                                                <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified">
                                                <xs:element name="golfCompetition">
                                    
                                                <xs:complexType>
                                                <xs:sequence>
                                                <xs:element name="name">
                                                <xs:complexType>
                                                <xs:simpleContent>
                                                <xs:extension base="xs:string">
                                                <xs:attribute name="id" type="xs:string"/>
                                                </xs:extension>
                                                </xs:simpleContent>
                                                </xs:complexType>
                                                </xs:element>
                                                <xs:element name="date" type="xs:date"/>
                                                <xs:element name="sponsor" type="xs:string"/>
                                                <xs:element name="buche">
                                                <xs:complexType>
                                                <xs:sequence>
                                                <xs:element name="buca" minOccurs="9" maxOccurs="9">
                                                <xs:complexType>
                                                <xs:attribute name="par" type="parT" use="required"/>
                                                </xs:complexType>
                                                </xs:element>	
                                                </xs:sequence>
                                                </xs:complexType>
                                                </xs:element>                                                
                                                <xs:element name="category" maxOccurs="7">
                                                <xs:complexType>
                                                <xs:attribute name="from" type="HandicapT"/>
                                                <xs:attribute name="to" type="HandicapT"/>
                                                <xs:attribute name="type" type="CategoryType" use="required"/>
                                                <xs:attribute name="numPrize" type="NumPrizeT" use="required"/>
                                                <xs:attribute name="age" type="xs:integer"/>
                                                </xs:complexType>
                                                </xs:element>
                                                <xs:element name="reserved" type="xs:boolean" minOccurs="0"/>
                                                </xs:sequence>
                                                </xs:complexType>
                                                </xs:element>
                                                <xs:simpleType name="HandicapT">
                                                <xs:restriction base="xs:integer">
                                                <xs:minInclusive value="0"/>
                                                <xs:maxInclusive value="36"/>
                                                </xs:restriction>
                                                </xs:simpleType>
                                                <xs:simpleType name="CategoryType">
                                                <xs:restriction base="xs:string">
                                                <xs:enumeration value="First"/>
                                                <xs:enumeration value="Second"/>
                                                <xs:enumeration value="Third"/>
                                                <xs:enumeration value="Forth"/>
                                                <xs:enumeration value="Fifth"/>
                                                <xs:enumeration value="Lady"/>
                                                <xs:enumeration value="Over"/>
                                                </xs:restriction>
                                                </xs:simpleType>
                                                <xs:simpleType name="NumPrizeT">
                                                <xs:restriction base="xs:integer">
                                                <xs:minInclusive value="1"/>
                                                <xs:maxInclusive value="3"/>
                                                </xs:restriction>
                                                </xs:simpleType>
                                                <xs:simpleType name="parT">
                                                <xs:restriction base="xs:integer">
                                                <xs:minInclusive value="1"/>
                                                <xs:maxInclusive value="10"/>
                                                </xs:restriction>
                                                </xs:simpleType>
                                                </xs:schema>'); 

dbms_xmlschema.registerSchema(schemaURL   => 'GolfScore.xsd', 
                                 schemaDoc   => '<?xml version="1.0" encoding="UTF-8"?>
                                                <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
                                                 elementFormDefault="qualified" attributeFormDefault="unqualified">
                                                <xs:element name="golfscore">
                                                <xs:complexType>
                                                <xs:sequence>
                                                <xs:element name="name">
                                                <xs:complexType>
                                                <xs:simpleContent>
                                                <xs:extension base="xs:string">
                                                <xs:attribute name="id" type="xs:string" />
                                                <xs:attribute name="par" type="xs:integer" />
                                                </xs:extension>
                                                </xs:simpleContent>
                                                </xs:complexType>
                                                </xs:element> 
                                                <xs:element name="date" type="xs:date"/>
                                                <xs:element name="player" type="xs:string"/>
                                                <xs:element name="results">
                                                 <xs:complexType>
                                                <xs:sequence>
                                                <xs:element name="hole" type="holeT" minOccurs="0" maxOccurs="9"/>
                                                <xs:choice>
                                                <xs:element name="withdraw" minOccurs="0">
                                                <xs:complexType>
                                                </xs:complexType>
                                                </xs:element>
                                                <xs:element name="jolly" type="holeNumberT" minOccurs="0"/>
                                                </xs:choice>
                                                </xs:sequence>
                                                </xs:complexType>
                                                </xs:element>
                                                </xs:sequence>
                                                </xs:complexType>
                                                </xs:element>
                                                 <xs:complexType name= "holeT">
                                                 <xs:simpleContent>
                                                 <xs:extension base="holeResultT">
                                                 <xs:attribute name="number" type="holeNumberT" />
                                                 <xs:attribute name="par" type="holeNumberT" />
                                                 </xs:extension>
                                                 </xs:simpleContent>
                                                 </xs:complexType>
                                                <xs:simpleType name="holeNumberT">
                                                <xs:restriction base="xs:integer">
                                                <xs:minInclusive value="1"/>
                                                <xs:maxInclusive value="9"/>
                                                </xs:restriction>
                                                </xs:simpleType>
                                                <xs:simpleType name="holeResultT">
                                                <xs:restriction base="xs:integer">
                                                <xs:minInclusive value="1"/>
                                                <xs:maxInclusive value="10"/>
                                                </xs:restriction>
                                                </xs:simpleType>
                                                </xs:schema>'); 
END; 

-- creazione tipi

CREATE TYPE gara_t AS OBJECT(
    nome        VARCHAR2(50),
    data        DATE,
    sponsor     VARCHAR2(50),
    buche       XMLTYPE,
    categorie   XMLTYPE,
    privata     NUMBER(1),
     
    MEMBER FUNCTION parTotale RETURN INTEGER,
    MEMBER FUNCTION classifica RETURN XMLTYPE
);
/
CREATE TYPE telefoni_set AS TABLE OF VARCHAR(15);
/
CREATE TYPE gare_set AS TABLE OF REF gara_t;
/
CREATE TYPE circolo_t AS OBJECT(
    nome VARCHAR2(50),
    citta VARCHAR2(50),
    telefoni TELEFONI_SET,
    gare GARE_SET,
    
    MEMBER FUNCTION numeroSoci RETURN INTEGER
);
/
CREATE TYPE giocatore_t AS OBJECT(
    numeroTessera   VARCHAR2(10),
    nome            VARCHAR2(50),
    cognome         VARCHAR2(50),
    sesso           CHAR(1),
    eta             INTEGER,
    handicap        INTEGER,
    circolo         REF CIRCOLO_T
);
/
CREATE TYPE punteggio_t AS OBJECT(
    giocatore        REF GIOCATORE_T,
    risultato        INTEGER,
    buche_completate INTEGER,
    
    -- torna il punteggio col handicap applicato
    MEMBER FUNCTION punteggio RETURN INTEGER
);
/
CREATE TYPE punteggi_set AS TABLE OF punteggio_t;
/
ALTER TYPE gara_t ADD ATTRIBUTE punteggi punteggi_set CASCADE;
/
-- funzioni oggetti

CREATE OR REPLACE TYPE BODY gara_t AS
  MEMBER FUNCTION parTotale RETURN INTEGER IS
  par_totale NUMBER;
  BEGIN
    SELECT  xtab.par_tot INTO par_totale 
    FROM gare g, XMLTable(
    '<par>{sum($buche//buca/@par)}</par>'
    PASSING g.buche as "buche"
    COLUMNS
            par_tot INTEGER PATH    '/par'
    ) xtab
    where nome=self.nome;
    RETURN par_totale;
  END;
  MEMBER FUNCTION classifica RETURN XMLType IS
  BEGIN
    RETURN null;
  END;
END;
/

-- creazione tabelle
CREATE TABLE gare OF gara_t (
        nome primary key,
        privata DEFAULT 0 NOT NULL,
        CONSTRAINT testo_valido_gara CHECK (LENGTH(sponsor) > 0 AND LENGTH(nome) > 0),
        CONSTRAINT privata_valida CHECK (privata IN (0,1))
    )
    NESTED TABLE punteggi STORE AS punteggi_tab;
/
CREATE TABLE circoli OF circolo_t (
        nome primary key,
        CONSTRAINT testo_valido_circoli CHECK (LENGTH(citta) > 0 AND LENGTH(nome) > 0)
    )
    NESTED TABLE telefoni STORE AS telefoni_tab 
    NESTED TABLE gare STORE AS gare_tab;
/
CREATE TABLE giocatori OF giocatore_t(
    circolo SCOPE IS circoli,
    numeroTessera primary key,
    CONSTRAINT testo_valido_giocatori CHECK (LENGTH(cognome) > 0 AND LENGTH(nome) > 0 and LENGTH(numeroTessera) > 0),
    CONSTRAINT sesso_valido CHECK (sesso IN ('m', 'f')),
    CONSTRAINT eta_valida CHECK (eta BETWEEN 0 AND 150),
    CONSTRAINT handicap_valido CHECK (handicap BETWEEN 0 AND 36)
);

-- Valida in documento in ingresso con lo schema e lo inserisce nella tabella
CREATE OR REPLACE PROCEDURE valida_gara (doc IN VARCHAR2)
AS
    validated_doc XMLType;
BEGIN
    validated_doc := xmltype(doc, schema => 'GolfCompetition.xsd');
    XMLTYPE.schemavalidate(validated_doc);
    
    INSERT INTO gare
        SELECT xtab.nome, xtab.data, xtab.sponsor, xtab.buche, xtab.categorie, xtab.privata, punteggi_set()
        FROM XMLTABLE(
            '<result>
                    <name>{data($doc//name)}</name>
                    <date>{data($doc//date)}</date>
                    <sponsor>{data($doc//sponsor)}</sponsor>
                    <category_list>{$doc//category}</category_list>
                    <reserved>{if (exists($doc/golfCompetition/reserved) 
                                and ($doc/golfCompetition/reserved="true" or $doc/golfCompetition/reserved=1)) then(
                                    1
                                ) else(
                                    0
                                )}
                    </reserved>
                    {$doc//buche}
            </result>
            '
            PASSING validated_doc AS "doc"
            COLUMNS
            nome      VARCHAR2(50)   PATH    '/result/name',
            data      DATE          PATH    '/result/date',
            sponsor   VARCHAR2(50)   PATH    '/result/sponsor',
            buche     XMLTYPE       PATH    '/result/buche',
            categorie XMLTYPE       PATH    '/result/category_list',
            privata numeric(1)      PATH    '/result/reserved'
            ) xtab;
END;

CREATE OR REPLACE PROCEDURE valida_punteggio (doc IN VARCHAR2)
AS
    validated_doc XMLType;
    numeroTessera_locale giocatori.numeroTessera%TYPE;
    circolo_locale giocatori.circolo%TYPE;
    giocatore_locale    REF giocatore_t;
    nome_gara_locale    VARCHAR2(50);
    
    nest           gare.punteggi%TYPE;
    punt           punteggio_t;
BEGIN 
    -- validare xml
    validated_doc := xmltype(doc, schema => 'GolfScore.xsd');
    XMLTYPE.schemavalidate(validated_doc);
    -- 1 estrarre id giocatore
    
    SELECT tessera INTO numeroTessera_locale FROM XMLTABLE('.' PASSING validated_doc COLUMNS tessera VARCHAR2(10) PATH 'player');
    
    -- 2 estrarre giocatore e se ref circolo e controllare se ref circolo è diversa da nullRi
    -- provo a cercare giocatore con numeroTessera trovato in XML, se non lo trovo segnalo errore ed esco
    BEGIN
      SELECT ref(g) INTO giocatore_locale FROM giocatori g WHERE g.numeroTessera = numeroTessera_locale;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Il giocatore ' || numeroTessera_locale || ' non esiste, il suo punteggio non può essere inserito');
        RETURN;
    END;
    
    -- se il giocatore trovato non appartiene ad un circolo genero un exception
    IF circolo_locale IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Il giocatore ' || numeroTessera_locale || ' non appartiene ad un circolo, il suo punteggio non può essere inserito');
        RETURN;
    END IF;
    
    SELECT nome_gara INTO nome_gara_locale FROM XMLTable('.' PASSING validated_doc COLUMNS nome_gara  VARCHAR2(50) PATH '//name') xtab2;    
        
    SELECT punteggi INTO nest FROM gare WHERE nome = nome_gara_locale;
    
    nest.extend;
    
    SELECT punteggio_t(giocatore_locale, xtab.punteggio, xtab.buche_completate) INTO punt
            FROM XMLTABLE(
                'let $jolly := if (exists($d//jolly)) then data($d//jolly) else -1
                return 
                <risultato>
                 <punteggio>  {sum(for $h in $d//hole return <s>{if ($h/@number = $jolly) then data($h/@par) else data($h)}</s>)} </punteggio>
                 <buche_completate>{count($d//hole)}</buche_completate>
                </risultato>'
            PASSING validated_doc as "d"
            COLUMNS
                punteggio NUMBER PATH '/risultato/punteggio',
                buche_completate NUMBER PATH '/risultato/buche_completate'
            ) xtab;
    
    nest(nest.last) := punt;
    
    UPDATE gare g SET punteggi = nest WHERE g.nome = nome_gara_locale;
    
    
END;
