-- Arquivo: 07_executar_todos_testes.sql
-- Finalidade: executar os 40 casos de teste em sequência e registrar o resultado consolidado.
-- Uso: executar no SQL*Plus após a criação e o povoamento; a evidência é gravada em resultados-testes.txt.

SET TERMOUT ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET PAGESIZE 0
SET LINESIZE 300
WHENEVER SQLERROR CONTINUE

SPOOL scripts/resultados-testes.txt REPLACE
PROMPT EXECUCAO|Inicio
@scripts/03_testes_integridade_referencial.sql
@scripts/04_testes_atributos_limites.sql
@scripts/05_testes_semanticos.sql
@scripts/06_testes_limites_adicionais.sql
PROMPT EXECUCAO|Fim
SPOOL OFF

SET HEADING ON
SET FEEDBACK ON
