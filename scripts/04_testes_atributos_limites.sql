-- Arquivo: 04_testes_atributos_limites.sql
-- Finalidade: executar os CT09 a CT24 para validar obrigatoriedade, domínios e fronteiras de atributos.
-- Uso: cada CT cria um SAVEPOINT e desfaz a tentativa, preservando a massa de dados original.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET ECHO OFF
SET FEEDBACK OFF

PROMPT GRUPO|Integridade de atributos, classes de equivalencia e valores-limite

SAVEPOINT ct09;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9909, NULL, 'ct09@example.com', DATE '1990-01-01', 'A');
  DBMS_OUTPUT.PUT_LINE('CT09|ERRO|Nome nulo foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -1400 THEN
    DBMS_OUTPUT.PUT_LINE('CT09|OK|ORA-01400: nome nulo bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT09|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct09;

SAVEPOINT ct10;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9910, 'Cliente Limite', 'ct10@example.com', DATE '1900-01-01', 'A');
  DBMS_OUTPUT.PUT_LINE('CT10|OK|Data 1900-01-01 aceita no limite inferior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT10|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct10;

SAVEPOINT ct11;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9911, 'Cliente Invalido', 'ct11@example.com', DATE '1899-12-31', 'A');
  DBMS_OUTPUT.PUT_LINE('CT11|ERRO|Data anterior a 1900 foi aceita.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT11|OK|ORA-02290: data 1899-12-31 bloqueada abaixo do limite.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT11|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct11;

SAVEPOINT ct12;
BEGIN
  INSERT INTO ats_cliente (cliente_id, nome, email, data_nascimento, status_cliente)
  VALUES (9912, 'Cliente Menor', 'ct12@example.com', DATE '2008-09-27', 'A');
  DBMS_OUTPUT.PUT_LINE('CT12|ERRO|Cliente um dia abaixo de 18 anos foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT12|OK|ORA-02290: nascimento em 2008-09-27, um dia abaixo do limite de 18 anos, foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT12|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct12;

SAVEPOINT ct13;
BEGIN
  INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, cep, cidade, uf)
  VALUES (9913, 1, 'RESIDENCIAL', 'Rua Teste', 10, '1234567', 'Sao Paulo', 'SP');
  DBMS_OUTPUT.PUT_LINE('CT13|ERRO|CEP com 7 digitos foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT13|OK|ORA-02290: CEP com 7 digitos foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT13|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct13;

SAVEPOINT ct14;
BEGIN
  INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, cep, cidade, uf)
  VALUES (9914, 1, 'RESIDENCIAL', 'Rua Teste', 1, '01001000', 'Sao Paulo', 'SP');
  DBMS_OUTPUT.PUT_LINE('CT14|OK|Numero 1 aceito no limite inferior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT14|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct14;

SAVEPOINT ct15;
BEGIN
  INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
  VALUES (9915, 201, 'CT15-SKU', 'Produto Teste', 0, 1, 'S');
  DBMS_OUTPUT.PUT_LINE('CT15|ERRO|Preco zero foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT15|OK|ORA-02290: preco zero bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT15|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct15;

SAVEPOINT ct16;
BEGIN
  INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
  VALUES (9916, 201, 'CT16-SKU', 'Produto Limite', 0.01, 0, 'S');
  DBMS_OUTPUT.PUT_LINE('CT16|OK|Preco 0,01 e estoque zero aceitos nos limites validos.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT16|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct16;

SAVEPOINT ct17;
BEGIN
  INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
  VALUES (9917, 201, 'CT17-SKU', 'Produto Invalido', 10, -1, 'S');
  DBMS_OUTPUT.PUT_LINE('CT17|ERRO|Estoque -1 foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT17|OK|ORA-02290: estoque -1 bloqueado abaixo do limite.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT17|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct17;

SAVEPOINT ct18;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 306, 0, 45, 0);
  DBMS_OUTPUT.PUT_LINE('CT18|ERRO|Quantidade zero foi aceita.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT18|OK|ORA-02290: quantidade zero bloqueada.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT18|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct18;

SAVEPOINT ct19;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 306, 1, 45, 0);
  DBMS_OUTPUT.PUT_LINE('CT19|OK|Quantidade 1 aceita no limite inferior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT19|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct19;

SAVEPOINT ct20;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 306, 1, 45, 100);
  DBMS_OUTPUT.PUT_LINE('CT20|OK|Desconto 100 por cento aceito no limite superior valido.');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CT20|ERRO|' || SQLERRM);
END;
/
ROLLBACK TO ct20;

SAVEPOINT ct21;
BEGIN
  INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
  VALUES (403, 306, 1, 45, 100.01);
  DBMS_OUTPUT.PUT_LINE('CT21|ERRO|Desconto acima de 100 foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT21|OK|ORA-02290: desconto 100,01 bloqueado acima do limite.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT21|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct21;

SAVEPOINT ct22;
BEGIN
  INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento)
  VALUES (9922, 403, 'CARTAO', 389.70, 13, 'PENDENTE');
  DBMS_OUTPUT.PUT_LINE('CT22|ERRO|Treze parcelas foram aceitas.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT22|OK|ORA-02290: 13 parcelas bloqueadas acima do limite.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT22|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct22;

SAVEPOINT ct23;
BEGIN
  INSERT INTO ats_entrega (entrega_id, pedido_id, transportadora, status_entrega, data_envio, data_prevista, data_entrega)
  VALUES (9923, 403, 'Transportadora Teste', 'ENTREGUE', DATE '2026-09-23', DATE '2026-09-25', NULL);
  DBMS_OUTPUT.PUT_LINE('CT23|ERRO|Status ENTREGUE sem data de entrega foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT23|OK|ORA-02290: status ENTREGUE sem data efetiva foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT23|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct23;

SAVEPOINT ct24;
BEGIN
  INSERT INTO ats_categoria (categoria_id, nome, descricao, ativo)
  VALUES (9924, 'Categoria Teste', 'Teste de dominio', 'X');
  DBMS_OUTPUT.PUT_LINE('CT24|ERRO|Status de categoria X foi aceito.');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -2290 THEN
    DBMS_OUTPUT.PUT_LINE('CT24|OK|ORA-02290: valor X fora do dominio S/N foi bloqueado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('CT24|ERRO|' || SQLERRM);
  END IF;
END;
/
ROLLBACK TO ct24;
