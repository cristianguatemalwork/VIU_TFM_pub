--=============================== JUBILADOS DE VEJEZ, DISCAPACIDAD E INVALIDEZ HISTORICOS: ESQUEMA IESS_OWNER ======================--
create table cedulas_cd656 tablespace tb_actuarial as
select sec.secuencia cedula_cod, pres.asegurado cedula, decode(rc.genper,'1','H','2','M') sexo, rc.fecnacper fecha_nacimiento, rc.fecdefper fecha_muerte
from pensiones_owner.prestaciones pres 
left join iess_owner.kspcotregciv rc on rc.cedideusu = pres.asegurado
inner join system.iden_seq sec on sec.cedula = pres.asegurado
where pres.tipo_seguro  in ('SG','ZF','TE','CE')
and pres.tipo_prestacion in ('ER','JV','MM','MP','JI','IN','DV') 
and pres.estado_prestacion not in ('X')
group by  sec.secuencia, pres.asegurado, decode(rc.genper,'1','H','2','M'), rc.fecnacper, rc.fecdefper;

select count(1) n_reg, count(distinct cedula) n_jub from cedulas_cd656;
-- 686,046	686,046

--------------------------------------------------------------------------------------------------------------
-- OBTENER APORTES SOLO DE HISTORIA LABORAL ABIERTOS POR SECTOR
create table aportes_cd656_new tablespace tb_actuarial as
select sec.secuencia cedula_cod, dt.numafi cedula, dt.aniper anio, dt.mesper mes, tpe.codsec
, case when tpe.codsec = 'P' then
       case when (dt.rucemp = dt.numafi || '001' and dt.codreltra  not in ('74','75')) then 'INDEPENDIENTES'
            when dt.codreltra in ('74','75') then 'PASANTE PUBLICO'
        else 'PUBLICO' end
       when tpe.codsec = 'R' then
       case when (dt.rucemp = dt.numafi || '001' and dt.codreltra  not in ('74','75')) then 'INDEPENDIENTES'
            when dt.codreltra in ('74','75') then 'PASANTE PRIVADO'
        else 'PRIVADO' end
       when tpe.codsec = 'V' then rt.desreltra
       end sector
, tpe.destipemp, rt.desreltra, suc.codcii
, case when suc.coddivpol is not null then pro.nomdivpol else substr(pais.dp_codigo,1,2) end provincia
, case when suc.coddivpol is not null then can.nomdivpol else substr(pais.dp_codigo,1,2) end canton
, sum(dt.valsue) salario, sum(dt.poraponor) porcentaje_ap
from iess_owner.ksrectpladet dt
inner join system.iden_seq sec on sec.cedula = dt.numafi
inner join iess_owner.ksrectplanillas pla
           on dt.rucemp = pla.rucemp and dt.codsuc = pla.codsuc and dt.codtippla = pla.codtippla and dt.tipper = pla.tipper 
           and dt.aniper = pla.aniper and dt.mesper = pla.mesper AND dt.secpla = pla.secpla
left join iess_owner.kspcotemptip tpe on tpe.codtipemp = dt.codtipemp 
left join iess_owner.kspcotreltra rt on rt.codreltra = dt.codreltra
left join iess_owner.kspcotsucursales suc on suc.rucemp = dt.rucemp and suc.codsuc = dt.codsuc
left join iess_owner.kspcotdivpol pro on pro.coddivpol = substr(suc.coddivpol,1,2)
left join iess_owner.kspcotdivpol can on can.coddivpol = substr(suc.coddivpol,1,4)
left join iess_owner.kspcotafiliados pais on pais.numafi = dt.numafi
inner join cedulas_cd656 pob on pob.cedula = dt.numafi
where dt.codtippla in ('A', 'AA', 'RA', 'EX','ATH','ATJ') and pla.esttippla <> 'ANU' and pla.valnorpla > 0
and tpe.codsec IN ('P', 'R', 'V') and dt.mesper between 1 and 12
group by sec.secuencia, dt.numafi, dt.aniper, dt.mesper, tpe.codsec
, case when tpe.codsec = 'P' then
       case when (dt.rucemp = dt.numafi || '001' and dt.codreltra  not in ('74','75')) then 'INDEPENDIENTES'
            when dt.codreltra  in ('74','75') then 'PASANTE PUBLICO'
        else 'PUBLICO' end
       when tpe.codsec = 'R' then
       case when (dt.rucemp = dt.numafi || '001' and dt.codreltra  not in ('74','75')) then 'INDEPENDIENTES'
            when dt.codreltra in ('74','75') then 'PASANTE PRIVADO'
        else 'PRIVADO' end
       when tpe.codsec = 'V' then rt.desreltra
       end
, tpe.destipemp, rt.desreltra, suc.codcii
, case when suc.coddivpol is not null then pro.nomdivpol else substr(pais.dp_codigo,1,2) end
, case when suc.coddivpol is not null then can.nomdivpol else substr(pais.dp_codigo,1,2) end;

select count(1) n_reg, count(distinct cedula) n_jub, sum(salario) masa from aportes_cd656_new;
-- 68,062,270	556,782     45,886,262,482.06  

-- VERIFICAR REPETIDOS POR AÑO Y MES
select count(1) from aportes_cd656_new where cedula in (select cedula from aportes_cd656_new group by  cedula, anio, mes having count(1)>1);
-- 19,889,751 --> Por cotizacion en diferente sector el mismo mes, por disposicion de CG dejar así

-- EXPORTAR TABLA aportes_cd656_new 