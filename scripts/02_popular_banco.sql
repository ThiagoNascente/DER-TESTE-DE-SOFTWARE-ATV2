-- Arquivo: 02_popular_banco.sql
-- Finalidade: inserir a massa de dados válida usada como base para os casos de teste.
-- Uso: executar após 01_criar_tabelas.sql; o script confirma os dados com COMMIT e exibe as contagens.

SET ECHO ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

INSERT INTO ats_cliente (cliente_id, nome, email, telefone, data_nascimento, status_cliente)
VALUES (1, 'Ana Souza', 'ana.souza@example.com', '11987654321', DATE '1994-05-12', 'A');
INSERT INTO ats_cliente (cliente_id, nome, email, telefone, data_nascimento, status_cliente)
VALUES (2, 'Bruno Lima', 'bruno.lima@example.com', '21976543210', DATE '1988-11-03', 'A');
INSERT INTO ats_cliente (cliente_id, nome, email, telefone, data_nascimento, status_cliente)
VALUES (3, 'Carla Mendes', 'carla.mendes@example.com', '31965432109', DATE '2000-02-29', 'A');
INSERT INTO ats_cliente (cliente_id, nome, email, telefone, data_nascimento, status_cliente)
VALUES (4, 'Diego Alves', 'diego.alves@example.com', NULL, DATE '1979-08-20', 'I');

INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, complemento, cep, cidade, uf)
VALUES (101, 1, 'RESIDENCIAL', 'Rua das Flores', 120, 'Apto 31', '01310100', 'Sao Paulo', 'SP');
INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, complemento, cep, cidade, uf)
VALUES (102, 2, 'RESIDENCIAL', 'Avenida Atlantica', 850, NULL, '22021001', 'Rio de Janeiro', 'RJ');
INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, complemento, cep, cidade, uf)
VALUES (103, 3, 'COMERCIAL', 'Avenida Afonso Pena', 1500, 'Sala 402', '30130005', 'Belo Horizonte', 'MG');
INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, complemento, cep, cidade, uf)
VALUES (104, 1, 'COMERCIAL', 'Rua Vergueiro', 55, NULL, '01504000', 'Sao Paulo', 'SP');
INSERT INTO ats_endereco (endereco_id, cliente_id, tipo_endereco, logradouro, numero, complemento, cep, cidade, uf)
VALUES (105, 4, 'RESIDENCIAL', 'Rua do Comercio', 9, NULL, '80010010', 'Curitiba', 'PR');

INSERT INTO ats_categoria (categoria_id, nome, descricao, ativo)
VALUES (201, 'Eletronicos', 'Equipamentos eletronicos e acessorios', 'S');
INSERT INTO ats_categoria (categoria_id, nome, descricao, ativo)
VALUES (202, 'Casa e Cozinha', 'Itens para uso domestico', 'S');
INSERT INTO ats_categoria (categoria_id, nome, descricao, ativo)
VALUES (203, 'Livros', 'Livros fisicos e materiais de leitura', 'S');
INSERT INTO ats_categoria (categoria_id, nome, descricao, ativo)
VALUES (204, 'Esportes', 'Artigos esportivos', 'S');

INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
VALUES (301, 201, 'NOTE-001', 'Notebook 15 polegadas', 3999.90, 12, 'S');
INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
VALUES (302, 201, 'CEL-001', 'Smartphone 128 GB', 2499.00, 25, 'S');
INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
VALUES (303, 202, 'CAF-001', 'Cafeteira eletrica', 189.90, 18, 'S');
INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
VALUES (304, 203, 'LIV-001', 'Livro de Banco de Dados', 89.90, 40, 'S');
INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
VALUES (305, 204, 'BOL-001', 'Bola oficial', 129.90, 30, 'S');
INSERT INTO ats_produto (produto_id, categoria_id, sku, nome, preco, estoque, ativo)
VALUES (306, 204, 'COR-001', 'Corda de pular', 45.00, 50, 'S');

INSERT INTO ats_pedido (pedido_id, cliente_id, endereco_id, data_pedido, status_pedido, valor_total)
VALUES (401, 1, 101, DATE '2026-09-20', 'ENVIADO', 4161.72);
INSERT INTO ats_pedido (pedido_id, cliente_id, endereco_id, data_pedido, status_pedido, valor_total)
VALUES (402, 2, 102, DATE '2026-09-21', 'PAGO', 2499.00);
INSERT INTO ats_pedido (pedido_id, cliente_id, endereco_id, data_pedido, status_pedido, valor_total)
VALUES (403, 3, 103, DATE '2026-09-22', 'ABERTO', 389.70);
INSERT INTO ats_pedido (pedido_id, cliente_id, endereco_id, data_pedido, status_pedido, valor_total)
VALUES (404, 1, 104, DATE '2026-09-23', 'ABERTO', 225.00);

INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
VALUES (401, 301, 1, 3999.90, 0);
INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
VALUES (401, 304, 2, 89.90, 10);
INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
VALUES (402, 302, 1, 2499.00, 0);
INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
VALUES (403, 305, 3, 129.90, 0);
INSERT INTO ats_item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_percentual)
VALUES (404, 306, 5, 45.00, 0);

INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento, data_pagamento)
VALUES (501, 401, 'CARTAO', 4161.72, 4, 'APROVADO', DATE '2026-09-20');
INSERT INTO ats_pagamento (pagamento_id, pedido_id, forma_pagamento, valor, parcelas, status_pagamento, data_pagamento)
VALUES (502, 402, 'PIX', 2499.00, 1, 'APROVADO', DATE '2026-09-21');

INSERT INTO ats_entrega (entrega_id, pedido_id, transportadora, codigo_rastreio, status_entrega, data_envio, data_prevista, data_entrega)
VALUES (601, 401, 'Entrega Rapida', 'BR2026000001', 'ENVIADO', DATE '2026-09-21', DATE '2026-09-28', NULL);
INSERT INTO ats_entrega (entrega_id, pedido_id, transportadora, codigo_rastreio, status_entrega, data_envio, data_prevista, data_entrega)
VALUES (602, 402, 'Logistica Brasil', 'BR2026000002', 'PREPARANDO', NULL, NULL, NULL);

COMMIT;

SELECT 'ATS_CLIENTE' tabela, COUNT(*) quantidade FROM ats_cliente UNION ALL
SELECT 'ATS_ENDERECO', COUNT(*) FROM ats_endereco UNION ALL
SELECT 'ATS_CATEGORIA', COUNT(*) FROM ats_categoria UNION ALL
SELECT 'ATS_PRODUTO', COUNT(*) FROM ats_produto UNION ALL
SELECT 'ATS_PEDIDO', COUNT(*) FROM ats_pedido UNION ALL
SELECT 'ATS_ITEM_PEDIDO', COUNT(*) FROM ats_item_pedido UNION ALL
SELECT 'ATS_PAGAMENTO', COUNT(*) FROM ats_pagamento UNION ALL
SELECT 'ATS_ENTREGA', COUNT(*) FROM ats_entrega;

PROMPT Povoamento concluido e confirmado com COMMIT.
