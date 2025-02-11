SELECT top 1000 'XXXXX' AS txtTaskScriptID, 
                 a.dttglawalstatus, 
                 a.txtkontakid, 
                 kk.txtkontakid txtpicid, 
                 a.txtprodukid, 
                 a.txtstatuspelangganid, 
                 kk.txtcabangid, 
                 a.txtsubmissionid, 
                 a.intsubmissionidx 
FROM dstatuspenggunaan a with(nolock)
       INNER JOIN dkontak b with(nolock)
               ON a.txtkontakid = b.txtkontakid 
               AND (b.boldeletedmerge = 0 OR b.boldeletedmerge IS NULL ) 
        INNER JOIN dkontak kk with(nolock)
               ON kk.txtkontakid = isnull(b.txtpicid,b.txtkontakid) 
               AND (kk.boldeleted = 0 OR kk.boldeleted IS NULL ) 
		INNER JOIN  (select distinct txtkontakid from dstatuspenggunaan WITH (nolock)--SUMDAT MATCHED_ALFA
				where txtsumberdataid='186722')ds ON a.txtkontakid=ds.txtkontakid
		LEFT JOIN (SELECT alias.txtkontakid 
                        FROM   (SELECT aa.txtkontakid, 
                                       Max (aa.dtstart) TGL 
                                FROM   davayakontak aa with(nolock)
                                WHERE  aa.bitvalidcalling = 1 
                                       AND aa.txtstatus IN ( 'Terhubungi', 'Bicara dgn PIC', 'Bicara dgn keluarga' )
                                GROUP  BY aa.txtkontakid 
                                HAVING Datediff (DAY, Max (aa.dtstart), GETDATE()) <= 14) alias) x1
                    ON x1.txtkontakid = isnull(b.txtpicid,b.txtkontakid) 


WHERE  1=1
and x1.txtkontakid IS NULL 
AND a.bolstatusakhir = 1 
AND a.txtstatuspelangganid in ('LC','LC OTOMATIS','NC')
AND a.txtprodukid in ('MIF-CHK-REG','MIF-CHK-PLAT','MIF-CHS-REG','MIF-CHS-PLAT')
and cast(dtTglAwalStatus as date)>='2024-01-01'
AND (a.boldeletedmerge = 0 OR a.boldeletedmerge IS NULL )