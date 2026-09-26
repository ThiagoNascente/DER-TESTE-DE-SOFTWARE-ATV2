-- Arquivo: 06_testes_limites_adicionais.sql
-- Finalidade: executar os CT33 a CT40, completando 40 casos com pares de valores nas fronteiras superiores e inferiores.
-- Uso: cada CT cria um SAVEPOINT e desfaz a tentativa, preservando a massa de dados original.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO OFF
SET FEEDBACK OFF

PROMPT GRUPO|Limites adicionais

-- CT33: nome com dois caracteres, imediatamente abaixo do mínimo permitido de três.
SAVEPOINT ct33;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9933, 'AB', 'ct33@example.com', DATE '1990-01-01', 'A');
  DBMS_OUTPUT.PUT_LINE('CT33|ERRO|Nome com 2 caracteres foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT33|OK|ORA-02290: nome com 2 caracteres foi bloqueado abaixo do limite.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT33|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct33;

-- CT34: data máxima válida para 18 anos completos na data-base da atividade.
SAVEPOINT ct34;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9934, 'Cliente Limite', 'ct34@example.com', DATE '2008-09-26', 'A');
  DBMS_OUTPUT.PUT_LINE('CT34|OK|Nascimento em 2008-09-26 aceito no limite superior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT34|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct34;

-- CT35: maior número de endereço aceito pela regra e pelo tipo NUMBER(6).
SAVEPOINT ct35;
BEGIN
  INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, cep, cidade, uf)
  VALUES (9935, 1, 'RESIDENCIAL', 'Rua Teste', 999999, '01001000', 'Sao Paulo', 'SP');
  DBMS_OUTPUT.PUT_LINE('CT35|OK|Numero 999999 aceito no limite superior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT35|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct35;

-- CT36: um número acima da capacidade e da regra do atributo numero.
SAVEPOINT ct36;
BEGIN
  INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, cep, cidade, uf)
  VALUES (9936, 1, 'RESIDENCIAL', 'Rua Teste', 1000000, '01001000', 'Sao Paulo', 'SP');
  DBMS_OUTPUT.PUT_LINE('CT36|ERRO|Numero 1000000 foi aceito acima do limite.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE IN (-1438, -2290) THEN
    DBMS_OUTPUT.PUT_LINE('CT36|OK|Valor 1000000 bloqueado acima do limite do numero do endereco.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT36|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct36;

-- CT37: preço exatamente igual ao maior valor permitido pela regra de negócio.
SAVEPOINT ct37;
BEGIN
  INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
  VALUES (9937, 201, 'CT37-SKU', 'Produto Limite Superior', 999999.99, 1, 'S');
  DBMS_OUTPUT.PUT_LINE('CT37|OK|Preco 999999,99 aceito no limite superior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT37|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct37;

-- CT38: um centavo acima do preço máximo permitido.
SAVEPOINT ct38;
BEGIN
  INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
  VALUES (9938, 201, 'CT38-SKU', 'Produto Acima do Limite', 1000000.00, 1, 'S');
  DBMS_OUTPUT.PUT_LINE('CT38|ERRO|Preco 1000000,00 foi aceito acima do limite.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT38|OK|ORA-02290: preco 1000000,00 bloqueado acima do limite.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT38|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct38;

-- CT39: quantidade exatamente igual ao limite superior de 999 unidades.
SAVEPOINT ct39;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 306, 999, 45, 0);
  DBMS_OUTPUT.PUT_LINE('CT39|OK|Quantidade 999 aceita no limite superior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT39|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct39;

-- CT40: uma unidade acima da quantidade máxima permitida.
SAVEPOINT ct40;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 306, 1000, 45, 0);
  DBMS_OUTPUT.PUT_LINE('CT40|ERRO|Quantidade 1000 foi aceita acima do limite.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE IN (-1438, -2290) THEN
    DBMS_OUTPUT.PUT_LINE('CT40|OK|Quantidade 1000 bloqueada acima do limite do item.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT40|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct40;
