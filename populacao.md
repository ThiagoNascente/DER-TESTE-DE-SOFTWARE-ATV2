# Povoamento do banco de dados

## Execução

O povoamento foi executado no SQL*Plus e confirmado com `COMMIT` pelo comando:

```sql
@scripts/02_popular_banco.sql
```

O script executável completo está em [`scripts/02_popular_banco.sql`](scripts/02_popular_banco.sql), e a saída integral está em [`scripts/execucao-banco.log`](scripts/execucao-banco.log).

## Registros inseridos

| Tabela | Quantidade | Identificadores e conteúdo principal |
|---|---:|---|
| `ATS_CLIENTE` | 4 | IDs 1 a 4; Ana, Bruno, Carla e Diego |
| `ATS_ENDERECO` | 5 | IDs 101 a 105; endereços em SP, RJ, MG e PR |
| `ATS_CATEGORIA` | 4 | IDs 201 a 204; Eletrônicos, Casa e Cozinha, Livros e Esportes |
| `ATS_PRODUTO` | 6 | IDs 301 a 306; preços de R$ 45,00 a R$ 3.999,90 |
| `ATS_PEDIDO` | 4 | IDs 401 a 404; totais de R$ 225,00 a R$ 4.161,72 |
| `ATS_ITEM_PEDIDO` | 5 | Itens associados aos quatro pedidos |
| `ATS_PAGAMENTO` | 2 | IDs 501 e 502; valores iguais aos totais dos pedidos 401 e 402 |
| `ATS_ENTREGA` | 2 | IDs 601 e 602; uma entrega enviada e uma em preparação |

## Conferência executada

```sql
SELECT 'ATS_CLIENTE' tabela, COUNT(*) quantidade FROM ats_cliente UNION ALL
SELECT 'ATS_ENDERECO', COUNT(*) FROM ats_endereco UNION ALL
SELECT 'ATS_CATEGORIA', COUNT(*) FROM ats_categoria UNION ALL
SELECT 'ATS_PRODUTO', COUNT(*) FROM ats_produto UNION ALL
SELECT 'ATS_PEDIDO', COUNT(*) FROM ats_pedido UNION ALL
SELECT 'ATS_ITEM_PEDIDO', COUNT(*) FROM ats_item_pedido UNION ALL
SELECT 'ATS_PAGAMENTO', COUNT(*) FROM ats_pagamento UNION ALL
SELECT 'ATS_ENTREGA', COUNT(*) FROM ats_entrega;
```

Resultado obtido: `4, 5, 4, 6, 4, 5, 2, 2`, respectivamente. Os 40 testes usam `SAVEPOINT` e `ROLLBACK TO SAVEPOINT`; por isso, não alteram esse povoamento.
