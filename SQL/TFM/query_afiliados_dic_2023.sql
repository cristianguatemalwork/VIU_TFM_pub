--========================================================================================================================================================--
--============================================================= AFILIADOS SGO DICIEMBRE 2023 =============================================================--
-- Identificador, sexo de la persona, fecha de nacimiento --> Ok.
-- Base de cálculo:  Promedio de los cinco mejores años de sueldo al 31/12/2023 --> Ok.
-- Número de imposiciones al 31/12/2023 --> Ok.

-- CREAR TABLA CON LA POBLACION DE ASEGURADOS AL SGO DESDE EL ORIGEN DE LOS TIEMPOS HASTA DICIEMBRE DE 2023
create table pob_exp_sgo tablespace tb_actuarial as
select t2.secuencia cedula_cod, dt.numafi cedula, decode(rc.genper, '1','H','2','M') sexo, rc.fecnacper fecha_nacimiento, bc.bc_22 base_calculo_2023, impo.impo_2023
from iess_owner.ksrectpladet dt
inner join iess_owner.ksrectplanillas pl on dt.rucemp = pl.rucemp and dt.codsuc = pl.codsuc and dt.codtippla = pl.codtippla and dt.tipper = pl.tipper 
                                              and dt.aniper = pl.aniper and dt.mesper = pl.mesper and dt.secpla = pl.secpla
inner join iess_owner.kspcotemptip tpe on tpe.codtipemp = dt.codtipemp 
inner join system.iden_seq t2 on t2.cedula = dt.numafi
inner join iess_owner.kspcotregciv rc on rc.cedideusu = dt.numafi
left join iess_owner.base_calculo bc on bc.cedula = dt.numafi
left join iess_owner.imposiciones_sgo impo on impo.cedula = dt.numafi
where pl.esttippla <> 'ANU' and dt.codtippla IN ('A', 'AA', 'RA', 'EX','ATH','ATJ')and PL.VALNORPLA > 0
and tpe.codsec in ('P','R','V') and dt.aniper <= 2023
group by t2.secuencia, dt.numafi, decode(rc.genper, '1','H','2','M'), rc.fecnacper, bc.bc_22, impo.impo_2023
union
select t2.secuencia cedula_cod, host.cedideusu cedula, decode(rc.genper, '1','H','2','M'), rc.fecnacper fecha_nacimiento, bc.bc_22, impo.impo_2023
from hist_iessmigra.ksmigtaportes host
inner join system.iden_seq t2 on t2.cedula = host.cedideusu
inner join iess_owner.kspcotregciv rc on rc.cedideusu = host.cedideusu
left join iess_owner.base_calculo bc on bc.cedula = host.cedideusu
left join iess_owner.imposiciones_sgo impo on impo.cedula = host.cedideusu
left join iess_owner.kspcotemptip tpe on tpe.codtipemp = host.codtipemp
where host.codmes between 1 and 12
group by t2.secuencia, host.cedideusu, decode(rc.genper, '1','H','2','M'), rc.fecnacper, bc.bc_22, impo.impo_2023;


select count(1) n_reg, count(distinct cedula) n_afi from pob_exp_sgo;
-- 8,424,149	8,424,149 (Toda la población asegurada de SGO)
-- Sal_prom_1: Promedio de salarios de toda la historia laboral
-- Sueldo: Suma de sueldos de toda la historia laboral
create table datos_salarios tablespace tb_actuarial as
select cedula, sum(sueldo) salario, avg(sueldo) sal_prom_1 from imposiciones_mes_sgo where anio <= 2023 group by cedula;

select count(1) n_reg, count(distinct cedula) n_afi from datos_salarios;
-- 8,424,149	8,424,149

-- Sal_prom_2: Promedio de salarios de toda la historia laboral desde el año 2000 en adelante
create table datos_salarios_dol tablespace tb_actuarial as
select cedula, avg(sueldo) sal_prom_2 from imposiciones_mes_sgo where anio between 2000 and 2023 group by cedula;

select count(1) n_reg, count(distinct cedula) n_afi from datos_salarios_dol;
-- 7,403,891	7,403,891

-- Q1_2: percentil 25 de los sueldos de toda la historia laboral de sueldos desde el año 2000 en adelante
-- Q3_2: percentil 75 de los sueldos de toda la historia laboral de sueldos desde el año 2000 en adelante
create table percentil_dm tablespace tb_actuarial as
select cedula, q1_2, q3_2
from percentil_dol
group by cedula, q1_2, q3_2;

select count(1) n_reg, count(cedula) n_afi from percentil_dm;
-- 7,403,891	7,403,891

-- CON LA TABLA grupo_doce_22
------------------------------------------------------------------------------
-- Fecha inicio de los mejores cinco años de sueldo
-- Fecha fin de los mejores cinco años de sueldo
-- T1_1: percentil 25 de los sueldos dentro de los cinco mejores años
-- T3_1: percentil 75 de los sueldos dentro de los cinco mejores años

-- CALCULAR SUELDO ARITMETICO DE CADA GRUPO
create table aritmetico_grupo tablespace tb_actuarial as
select cedula, avg(sueldo) sueldo_aritmetico, grupo from grupos_doce_22 group by cedula, grupo order by cedula, grupo;

create table ranking_5mej_grupos tablespace tb_actuarial as
select cedula, round(sueldo_aritmetico,4) s_aritmetico, grupo, ranking
from (select cedula, sueldo_aritmetico, grupo, rank() over (partition by cedula order by sueldo_aritmetico desc) ranking from aritmetico_grupo)
where ranking <= 5
group by cedula, sueldo_aritmetico, grupo, ranking order by cedula, ranking;

create table ranking_ord tablespace tb_actuarial as
select cedula, s_aritmetico, grupo, ranking, row_number() over(partition by cedula order by ranking asc) ranking_ord
from ranking_5mej_grupos;

create table cinco_mej_sueldos tablespace tb_actuarial as
select * from ranking_ord where ranking_ord <= 5;

create table aportes_5mej tablespace tb_actuarial as
select t1.cedula, t1.anio || '-' || t1.mes mes, t1.grupo 
from grupos_doce_22 t1
inner join cinco_mej_sueldos t2 on t2.cedula = t1.cedula and t2.grupo = t1.grupo;

create table periodo_5mejanios tablespace tb_actuarial as
select cedula, min(to_date(mes || '-' || '01','rrrr-mm-dd')) fin, max(last_day(to_date(mes || '-' || '01','rrrr-mm-dd'))) inicio from aportes_5mej
group by cedula
order by cedula;

-- Fecha inicio de los mejores cinco años de sueldo
-- Fecha fin de los mejores cinco años de sueldo
-- TABLA CON LAS VARIABLES SOLICITADAS
create table dat_5mej tablespace tb_actuarial as
select t1.cedula, t2.inicio inicio_5mej, t2.fin fin_5mej from pob_exp_sgo t1
left join periodo_5mejanios t2 on t2.cedula = t1.cedula;

-- T1_1: percentil 25 de los sueldos dentro de los cinco mejores años
-- T3_1: percentil 75 de los sueldos dentro de los cinco mejores años
create table percentil_5mej_ag tablespace tb_actuarial as
select cedula, t1_1, t3_1
from percentil_5mej
group by cedula, t1_1, t3_1;

select count(1) n_reg, count(distinct cedula) from percentil_5mej_ag;
-- 8,419,260	8,419,260

-- TABLA CON LOS DATOS SOLICITADOS
create table tab_afi_maestria tablespace tb_Actuarial as
select cedula_cod identificador, t1.cedula, sexo, t1.fecha_nacimiento, t1.base_calculo_2023, t1.impo_2023
, t2.sal_prom_1, t2.salario sueldo
, t3.sal_prom_2
, t4.q1_1, t4.q3_1
, t5.q1_2, t5.q3_2
, t6.inicio_5mej, t6.fin_5mej
, t7.t1_1, t7.t3_1
, t8.imposiciones n_pri
, t9.imposiciones n_pub
, t10.imposiciones n_ind
, t11.imposiciones n_vol_ec
, t12.imposiciones n_vol_ex
, r5mej.n_apo m_pri
, p5mej.n_apo m_pub
, i5mej.n_apo m_ind
, vec5mej.n_apo m_vol_ec
, vex5mej.n_apo m_vol_ex
from pob_exp_sgo t1
inner join (select cedula from boletin_2023.afiliados_2023_dic where sector like '%PRI%' or sector like '%PUB%' or sector like '%VOL%') dic_22 on dic_22.cedula = t1.cedula -- solo quiere diciembre 2023
left join datos_salarios t2 on t2.cedula = t1.cedula
left join datos_salarios_dol t3 on t3.cedula = t1.cedula
left join percentil_sgo t4 on t4.cedula = t1.cedula
left join percentil_dm t5 on t5.cedula = t1.cedula
left join dat_5mej t6 on t6.cedula = t1.cedula
left join percentil_5mej_ag t7 on t7.cedula = t1.cedula
left join imposiciones_priv_2023 t8 on t8.cedula = t1.cedula
left join imposiciones_pub_2023 t9 on t9.cedula = t1.cedula
left join imposiciones_ind_2023 t10 on t10.cedula = t1.cedula
left join imposiciones_volec_2023 t11 on t11.cedula = t1.cedula
left join imposiciones_volex_2023 t12 on t12.cedula = t1.cedula
left join (select cedula, relacion, n_apo from apor_rpiv_5mej where relacion = 'PRIVADO') r5mej on r5mej.cedula = t1.cedula
left join (select cedula, relacion, n_apo from apor_rpiv_5mej where relacion = 'PUBLICO') p5mej on p5mej.cedula = t1.cedula
left join (select cedula, relacion, n_apo from apor_rpiv_5mej where relacion = 'INDEPENDIENTES') i5mej on i5mej.cedula = t1.cedula
left join (select cedula, relacion, n_apo from apor_rpiv_5mej where relacion = 'VOL_ECUADOR') vec5mej on vec5mej.cedula = t1.cedula
left join (select cedula, relacion, n_apo from apor_rpiv_5mej where relacion = 'VOL_EXTERIOR') vex5mej on vex5mej.cedula = t1.cedula;

select count(1) n_reg, count(distinct cedula) n_afi from tab_afi_maestria;
-- 8,424,149	8,424,149 --> Ok.
-- 3,089,379	3,089,379 -- solo poblacion de diciembre 2023

-- EXPORTAR TABLA ---> tab_afi_maestria 
------------------------------------------------------------------------------
