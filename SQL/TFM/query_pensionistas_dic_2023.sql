create table apg_cd656 tablespace tb_actuarial as
select t1.cedula, anio, mes, sueldo
from imposiciones_mes_sgo t1
inner join cedulas_cd656 cd on cd.cedula = t1.cedula;
-- 277 seg
select count(1) n_reg, count(distinct cedula) n_afi from apg_cd656;
-- 220,141,666	682,458

create table rank_ap_cd656 tablespace tb_actuarial as
select cedula, anio, mes, sum(sueldo) sueldo, rank() over (partition by cedula order by anio desc, mes desc) ranking
from apg_cd656 t1
where sueldo > 0
group by cedula, anio, mes;

select count(1) n_reg, count(distinct cedula) n_afi from rank_ap_cd656;
-- 217,316,929	681,638

create table rank_desc_cd656 tablespace tb_actuarial as
select cedula, anio, mes, sueldo, ranking -1 ranking 
from rank_ap_cd656;

create table grupos_12_cd656 tablespace tb_actuarial as
select t1.*, trunc(ranking/12,0) grupo 
from rank_desc_cd656 t1;

-- CALCULAR SUELDO ARITMETICO DE CADA GRUPO
create table arit_gru_cd656 tablespace tb_actuarial as
select cedula, avg(sueldo) sueldo_aritmetico, grupo
from grupos_12_cd656 
group by cedula, grupo
order by cedula, grupo;

-- ESCOGER LOS 5 MEJORES GRUPOS DE SUELDOS ARITMETICOS DE CADA CEDULA
create table rank_5mej_grup_cd656 tablespace tb_actuarial as
select cedula, round(sueldo_aritmetico,4) s_aritmetico, grupo, ranking
from (select cedula, sueldo_aritmetico, grupo, rank() over (partition by cedula order by sueldo_aritmetico desc) ranking
      from arit_gru_cd656
      )
where ranking <= 5-- tomar los 5 mejores sueldos aritmetico de cada grupo de 12
group by cedula, sueldo_aritmetico, grupo, ranking
order by cedula, ranking;

create table rank_ord_cd656 tablespace tb_actuarial as
select cedula, s_aritmetico, grupo, ranking
, row_number() over(partition by cedula order by ranking asc) rank_ord_cd656
from rank_5mej_grup_cd656;

create table mej_5_anios tablespace tb_actuarial as
select * from rank_ord_cd656
where rank_ord_cd656 <= 5;

create table ap_5mej_cd656 tablespace tb_actuarial as
select t1.cedula, t1.anio || '-' || t1.mes mes, t1.grupo 
from grupos_12_cd656 t1
inner join mej_5_anios t2 on t2.cedula = t1.cedula and t2.grupo = t1.grupo;

select count(1) n_reg, count(distinct cedula) n_afi from ap_5mej_cd656;
-- 40,406,425	681,638

create table periodo_5mejanios tablespace tb_actuarial as
select cedula, min(to_date(mes || '-' || '01','rrrr-mm-dd')) fin, max(last_day(to_date(mes || '-' || '01','rrrr-mm-dd'))) inicio from ap_5mej_cd656
group by cedula
order by cedula;
-----------------------------------------------------------------------------------------------------------------------------------------
-- AGREGAR TODAS LAS VARIALES SOLICITADAS, POBLACION POR TIPO DE PRESTACION
-- VEJEZ
create table pob_vej_cd656_2 tablespace tb_actuarial as
select sec.secuencia cedula_cod, pres.asegurado cedula, decode(rc.genper,'1','H','2','M') sexo, rc.fecnacper fecha_nacimiento, rc.fecdefper fecha_muerte
, pres.fecha_derecho, pres.numero_imposiciones, pres.coeficiente_real, t3.coeficiente coeficiente_cal, pres.promedio_sueldo_real, bc.bc_22 promedio_cal
, ben.valor_pension, t3.coeficiente * bc.bc_22 pension_cal
, pres.secuencial_prestacion id_prestacion
, t1.inicio rango_ini_5mej
, t1.fin rango_fin_5mej
, apo.n_meses
from pensiones_owner.prestaciones pres 
inner join system.iden_seq sec on sec.cedula = pres.asegurado
left join iess_owner.kspcotregciv rc on rc.cedideusu = pres.asegurado
inner join pensiones_owner.beneficiarios ben on ben.secuencial_prestacion = pres.secuencial_prestacion and pres.asegurado = ben.identificacion_beneficiario
left join periodo_5mejanios t1 on t1.cedula = pres.asegurado
left join (select cedula, count(distinct anio || mes) n_meses from apg_cd656 group by cedula) apo on apo.cedula = pres.asegurado
left join  base_calculo bc on bc.cedula = pres.asegurado
left join ktapia.coeficientes t3 on t3.anios_impo = pres.numero_imposiciones 
where pres.estado_prestacion not in ('X') and pres.tipo_seguro in ('SG','ZF','TE','CE')
and pres.tipo_prestacion in ('ER', 'JV','MM', 'MP')
group by sec.secuencia, pres.asegurado, decode(rc.genper,'1','H','2','M'), rc.fecnacper, rc.fecdefper
, pres.fecha_derecho, pres.numero_imposiciones, pres.coeficiente_real, t3.coeficiente, pres.promedio_sueldo_real, bc.bc_22, ben.valor_pension, t3.coeficiente * bc.bc_22
, pres.secuencial_prestacion, t1.inicio, t1.fin, apo.n_meses;

select count(1) n_reg, count(distinct id_prestacion) n_pres, count(distinct cedula) n_jub, sum(promedio_cal) prom from pob_vej_cd656;
-- 681,799	681,799	627,478     431,839,066.2724

-- EXPORTAR TABLA pob_vej_cd656 
----------------------------------------- QUEDARME CON LOS DATOS DE LA PRESTACION CON MENOR FECHA DE DERECHO ---------------------------------------------
create table rank_primera_pres tablespace tb_actuarial as
select min(id) id, cedula, id_prestacion, fecha_derecho, coeficiente_real coeficiente, promedio_sueldo_real base_calculo, numero_imposiciones, valor_pension
from (select rowid id, cedula, id_prestacion, fecha_derecho, coeficiente_real, promedio_sueldo_real, numero_imposiciones, valor_pension
        , RANK() over(partition by cedula order by fecha_derecho desc) ranking 
        from pob_vej_cd656
) 
where ranking = 1 
group by cedula, id_prestacion, fecha_derecho, coeficiente_real, promedio_sueldo_real, numero_imposiciones, valor_pension;

select count(1) n_reg, count(distinct id_prestacion) n_pres, count(distinct cedula) n_jub from rank_primera_pres;
-- 673,868	673,868	627,478
--> Aún existen mas de un registro por persona debido a que las diferentes prestaciones tienen la misma fecha derecho mínima, o son prestacion "arreglo" de la naterior y comienza a pagarse por la anterior

create table rank_primer_sec tablespace tb_actuarial as
select min(id) id, cedula, id_prestacion, fecha_derecho, coeficiente coeficiente, base_calculo, numero_imposiciones, valor_pension
from (select id, cedula, id_prestacion, fecha_derecho, coeficiente, base_calculo, numero_imposiciones, valor_pension
        , RANK() over(partition by cedula order by id_prestacion desc) ranking 
        from rank_primera_pres
        where cedula in (select cedula from rank_primera_pres group by cedula having count(1)>1)
) 
where ranking = 1 
group by cedula, id_prestacion, fecha_derecho, coeficiente, base_calculo, numero_imposiciones, valor_pension;

select count(1) n_reg, count(distinct id_prestacion) n_pres, count(distinct cedula) n_jub from rank_primer_sec;
-- 45,152	45,152	45,152 --> Corecto, QUITAR ESTOS DE LA TABLA rank_primera_pres 

delete rank_primera_pres where id in (select id from rank_primer_sec);
commit;
-- 45,152 rows deleted.
-- 628,716	628,716	627,478


--=============================================================================================================
-- INVALIDEZ
create table pob_inv_cd656 tablespace tb_actuarial as
select sec.secuencia cedula_cod, pres.asegurado cedula, decode(rc.genper,'1','H','2','M') sexo, rc.fecnacper fecha_nacimiento, rc.fecdefper fecha_muerte
, pres.fecha_derecho, pres.numero_imposiciones, pres.coeficiente_real, t3.coeficiente coeficiente_cal, pres.promedio_sueldo_real, bc.bc_22 promedio_cal
, ben.valor_pension, t3.coeficiente * bc.bc_22 pension_cal
, pres.secuencial_prestacion id_prestacion
, t1.inicio rango_ini_5mej
, t1.fin rango_fin_5mej
, apo.n_meses
from pensiones_owner.prestaciones pres 
inner join system.iden_seq sec on sec.cedula = pres.asegurado
left join iess_owner.kspcotregciv rc on rc.cedideusu = pres.asegurado
inner join pensiones_owner.beneficiarios ben on ben.secuencial_prestacion = pres.secuencial_prestacion and pres.asegurado = ben.identificacion_beneficiario
left join periodo_5mejanios t1 on t1.cedula = pres.asegurado
left join (select cedula, count(distinct anio || mes) n_meses from apg_cd656 group by cedula) apo on apo.cedula = pres.asegurado
left join  base_calculo bc on bc.cedula = pres.asegurado
left join ktapia.coeficientes t3 on t3.anios_impo = pres.numero_imposiciones 
where pres.estado_prestacion not in ('X') and pres.tipo_seguro in ('SG','ZF','TE','CE')
and pres.tipo_prestacion in ('IN', 'JI')
group by sec.secuencia, pres.asegurado, decode(rc.genper,'1','H','2','M'), rc.fecnacper, rc.fecdefper
, pres.fecha_derecho, pres.numero_imposiciones, pres.coeficiente_real, t3.coeficiente, pres.promedio_sueldo_real, bc.bc_22, ben.valor_pension, t3.coeficiente * bc.bc_22
, pres.secuencial_prestacion, t1.inicio, t1.fin, apo.n_meses;

select count(1) n_reg, count(distinct cedula) n_afi from pob_inv_cd656;
-- 48,146	44,815 --> Ok.

-- EXPORTAR pob_inv_cd656

-- DISCAPACIDAD
create table pob_dis_cd656 tablespace tb_actuarial as
select sec.secuencia cedula_cod, pres.asegurado cedula, decode(rc.genper,'1','H','2','M') sexo, rc.fecnacper fecha_nacimiento, rc.fecdefper fecha_muerte
, pres.fecha_derecho, pres.numero_imposiciones, pres.coeficiente_real, t3.coeficiente coeficiente_cal, pres.promedio_sueldo_real, bc.bc_22 promedio_cal
, ben.valor_pension, t3.coeficiente * bc.bc_22 pension_cal
, pres.secuencial_prestacion id_prestacion
, t1.inicio rango_ini_5mej
, t1.fin rango_fin_5mej
, apo.n_meses
from pensiones_owner.prestaciones pres 
inner join system.iden_seq sec on sec.cedula = pres.asegurado
left join iess_owner.kspcotregciv rc on rc.cedideusu = pres.asegurado
inner join pensiones_owner.beneficiarios ben on ben.secuencial_prestacion = pres.secuencial_prestacion and pres.asegurado = ben.identificacion_beneficiario
left join periodo_5mejanios t1 on t1.cedula = pres.asegurado
left join (select cedula, count(distinct anio || mes) n_meses from apg_cd656 group by cedula) apo on apo.cedula = pres.asegurado
left join  base_calculo bc on bc.cedula = pres.asegurado
left join ktapia.coeficientes t3 on t3.anios_impo = pres.numero_imposiciones 
where pres.estado_prestacion not in ('X') and pres.tipo_seguro in ('SG','ZF','TE','CE')
and pres.tipo_prestacion in ('DV')
group by sec.secuencia, pres.asegurado, decode(rc.genper,'1','H','2','M'), rc.fecnacper, rc.fecdefper
, pres.fecha_derecho, pres.numero_imposiciones, pres.coeficiente_real, t3.coeficiente, pres.promedio_sueldo_real, bc.bc_22, ben.valor_pension, t3.coeficiente * bc.bc_22
, pres.secuencial_prestacion, t1.inicio, t1.fin, apo.n_meses;

select count(1) n_reg, count(distinct cedula) n_afi from pob_dis_cd656;
-- 14,662	14,186--> Ok.

-- EXPORTAR TABLAS DE POBLACION: pob_dis_cd656 