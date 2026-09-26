-- Arquivo: 05_testes_semanticos.sql
-- Finalidade: executar os CT25 a CT32 para validar dependências entre dados, unicidade e regras cronológicas.
-- Uso: cada CT cria um SAVEPOINT e desfaz a tentativa, preservando a massa de dados original.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO OFF
SET FEEDBACK OFF

PROMPT GRUPO|Integridade semantica, unicidade e dependencia de dados

SAVEPOINT ct25;
BEGIN
  INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento)
  VALUES (9925, 403, 'PIX', 300, 1, 'APROVADO');
  DBMS_OUTPUT.PUT_LINE('CT25|ERRO|Pagamento aprovado divergente do total foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT25|OK|ORA-02291: pagamento divergente do total do pedido foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT25|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct25;

SAVEPOINT ct26;
BEGIN
  INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento)
  VALUES (9926, 403, 'PIX', 389.70, 1, 'APROVADO');
  DBMS_OUTPUT.PUT_LINE('CT26|OK|Pagamento aprovado igual ao total do pedido foi aceito.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT26|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct26;

SAVEPOINT ct27;
BEGIN
  INSERT INTO ats_entrega (entrega_id, pedido_id, transportadora, status_entrega, data_envio, data_prevista)
  VALUES (9927, 403, 'Transportadora Teste', 'ENVIADO', DATE '2026-09-25', DATE '2026-09-24');
  DBMS_OUTPUT.PUT_LINE('CT27|ERRO|Data prevista anterior ao envio foi aceita.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT27|OK|ORA-02290: data prevista anterior ao envio foi bloqueada.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT27|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct27;

SAVEPOINT ct28;
BEGIN
  INSERT INTO ats_entrega (entrega_id, pedido_id, transportadora, status_entrega, data_envio, data_prevista, data_entrega)
  VALUES (9928, 403, 'Transportadora Teste', 'ENTREGUE', DATE '2026-09-25', DATE '2026-09-28', DATE '2026-09-24');
  DBMS_OUTPUT.PUT_LINE('CT28|ERRO|Data de entrega anterior ao envio foi aceita.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT28|OK|ORA-02290: data efetiva anterior ao envio foi bloqueada.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT28|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct28;

SAVEPOINT ct29;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9929, 'Email Duplicado', 'ana.souza@example.com', DATE '1990-01-01', 'A');
  DBMS_OUTPUT.PUT_LINE('CT29|ERRO|Email duplicado foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -1 THEN
    DBMS_OUTPUT.PUT_LINE('CT29|OK|ORA-00001: email duplicado foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT29|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct29;

SAVEPOINT ct30;
BEGIN
  INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento)
  VALUES (9930, 401, 'PIX', 4161.72, 1, 'APROVADO');
  DBMS_OUTPUT.PUT_LINE('CT30|ERRO|Segundo pagamento para o mesmo pedido foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -1 THEN
    DBMS_OUTPUT.PUT_LINE('CT30|OK|ORA-00001: segundo pagamento do pedido foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT30|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct30;

SAVEPOINT ct31;
BEGIN
  DELETE FROM ats_cliente WHERE cliente_id = 1;
  DBMS_OUTPUT.PUT_LINE('CT31|ERRO|Cliente com dependencias foi excluido.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2292 THEN
    DBMS_OUTPUT.PUT_LINE('CT31|OK|ORA-02292: cliente com enderecos e pedidos nao foi excluido.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT31|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct31;

SAVEPOINT ct32;
BEGIN
  INSERT INTO ats_pedido (pedido_id, cliente_id, endereco_id, status_pedido, valor_total)
  VALUES (9932, 1, 101, 'ABERTO', -0.01);
  DBMS_OUTPUT.PUT_LINE('CT32|ERRO|Pedido com total negativo foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT32|OK|ORA-02290: total negativo do pedido foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT32|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct32;
