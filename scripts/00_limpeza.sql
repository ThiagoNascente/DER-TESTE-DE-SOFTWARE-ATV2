-- Arquivo: 00_limpeza.sql
-- Finalidade: remover somente as tabelas ATS_ desta atividade, respeitando a ordem das dependências.
-- Uso: executar antes da recriação do modelo para permitir uma instalação limpa e repetível.

SET ECHO ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT SQL.SQLCODE

BEGIN
  FOR t IN (
    SELECT 'ATS_ENTREGA' table_name, 1 ordem FROM dual UNION ALL
    SELECT 'ATS_PAGAMENTO', 2 FROM dual UNION ALL
    SELECT 'ATS_ITEM_PEDIDO', 3 FROM dual UNION ALL
    SELECT 'ATS_PEDIDO', 4 FROM dual UNION ALL
    SELECT 'ATS_PRODUTO', 5 FROM dual UNION ALL
    SELECT 'ATS_CATEGORIA', 6 FROM dual UNION ALL
    SELECT 'ATS_ENDERECO', 7 FROM dual UNION ALL
    SELECT 'ATS_CLIENTE', 8 FROM dual
    ORDER BY ordem
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
          RAISE;
        END IF;
    END;
  END LOOP;
END;
/

PROMPT Limpeza concluida.
