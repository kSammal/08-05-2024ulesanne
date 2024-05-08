# 08-05-2024ulesanne

Esimene osa
---------
1. Tee ülesande jaoks kaust
2. Tee sinna kausta kaks alamkausta:
	2.1 XLS
	2.2 CSV
3. Kausta XLS pane jagatud zip faili sisu
4. Skriptid tulevad kasuta mille tegid esimeses punktis


Teine osa
---------
1. NB! Originaal XLSX failid kaustas XLS peavad alles jääma!!
2. Kirjuta skript, mis muudab kaustas olevad failid alljärgnevaks:
	YYYY-MM-DD_Sinotrack-ST-903.xlsx, 
	kus YYYY on aasta neljakohalise numbrina (2024)
	MM on kuu kahekohalise numbrina (05)
	DD on päev kahekohalise numbrina (30)	
	Originaal failinimes on kuupäev failinime lõpus
	track-My-Sinotrack-ST-903-01-04-2024 => See on 01.04.2024 (esimene aprill)
3. Konverteeri (mitte ära nimeta ümber) sama skriptiga XLSX failid CSV vormingusse. Kui faili sisu vaadata Notepad/Notepad++ siis peab sisu olema loetav. 
4. CSV faili sisu veergude eraldajaks on semikoolon (;)
CSV failid peavad minema kausta CSV mis on esimeses osas tehtud.

Teise osa punktide 2 ja 3 tegemise järjekord on teie enda valida. Need mõlemad tegevuse don ühes failis

Kolmas osa (eraldi skript samas projektis)
----------
1. Loe CSV kaustas olevaid faile ja näita päevade kaupa unikaaleid aadresse (Address) millel on staatus (Status) "trip"
2. Tulemus näita konsooli.
3. Kasutajal võiks olla võimalus näidata kindlat kuupäeva infot.
