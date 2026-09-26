-- Arquivo: 03_testes_integridade_referencial.sql
-- Finalidade: executar os CT01 a CT08 para validar chaves estrangeiras e exclusões de registros referenciados.
-- Uso: cada CT cria um SAVEPOINT e desfaz a tentativa, preservando a massa de dados original.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO OFF
SET FEEDBACK OFF

PROMPT GRUPO|Integridade referencial

SAVEPOINT ct01;
BEGIN
  INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, cep, cidade, uf)
  VALUES (9901, 99999, 'RESIDENCIAL', 'Rua Teste', 10, '01001000', 'Sao Paulo', 'SP');
  DBMS_OUTPUT.PUT_LINE('CT01|ERRO|Endereco com cliente inexistente foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT01|OK|ORA-02291: cliente inexistente bloqueado pela chave estrangeira.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT01|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct01;

SAVEPOINT ct02;
BEGIN
  INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
  VALUES (9902, 99999, 'CT02-SKU', 'Produto de teste', 10, 1, 'S');
  DBMS_OUTPUT.PUT_LINE('CT02|ERRO|Produto com categoria inexistente foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT02|OK|ORA-02291: categoria inexistente bloqueada pela chave estrangeira.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT02|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct02;

SAVEPOINT ct03;
BEGIN
  INSERT INTO ats_pedido (pedido_id, cliente_id, endereco_id, status_pedido, valor_total)
  VALUES (9903, 1, 102, 'ABERTO', 10);
  DBMS_OUTPUT.PUT_LINE('CT03|ERRO|Pedido com endereco de outro cliente foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT03|OK|ORA-02291: par endereco/cliente incompatível bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT03|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct03;

SAVEPOINT ct04;
BEGIN
  DELETE FROM ats_categoria WHERE categoria_id = 201;
  DBMS_OUTPUT.PUT_LINE('CT04|ERRO|Categoria com produtos foi excluida.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2292 THEN
    DBMS_OUTPUT.PUT_LINE('CT04|OK|ORA-02292: categoria referenciada por produtos nao foi excluida.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT04|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct04;

SAVEPOINT ct05;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (99999, 301, 1, 10, 0);
  DBMS_OUTPUT.PUT_LINE('CT05|ERRO|Item com pedido inexistente foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT05|OK|ORA-02291: pedido inexistente bloqueado pela chave estrangeira.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT05|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct05;

SAVEPOINT ct06;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 99999, 1, 10, 0);
  DBMS_OUTPUT.PUT_LINE('CT06|ERRO|Item com produto inexistente foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT06|OK|ORA-02291: produto inexistente bloqueado pela chave estrangeira.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT06|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct06;

SAVEPOINT ct07;
BEGIN
  INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento)
  VALUES (9907, 99999, 'PIX', 10, 1, 'PENDENTE');
  DBMS_OUTPUT.PUT_LINE('CT07|ERRO|Pagamento com pedido inexistente foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT07|OK|ORA-02291: pagamento sem pedido foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT07|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct07;

SAVEPOINT ct08;
BEGIN
  INSERT INTO ats_entrega (entrega_id, pedido_id, transportadora, status_entrega)
  VALUES (9908, 99999, 'Transportadora Teste', 'PREPARANDO');
  DBMS_OUTPUT.PUT_LINE('CT08|ERRO|Entrega com pedido inexistente foi aceita.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2291 THEN
    DBMS_OUTPUT.PUT_LINE('CT08|OK|ORA-02291: entrega sem pedido foi bloqueada.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT08|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct08;
