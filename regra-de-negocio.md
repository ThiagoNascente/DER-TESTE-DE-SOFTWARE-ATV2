# Regras de negócio — Sistema de Vendas Online

O modelo possui oito entidades. Os nomes físicos recebem o prefixo `ATS_` para separar a atividade de outros objetos existentes no usuário Oracle `THIAGO`.

## 1. ATS_CLIENTE

- `cliente_id` identifica unicamente o cliente.
- `nome` é obrigatório e deve conter de 3 a 100 caracteres úteis.
- `email` é obrigatório, deve possuir formato básico válido e não pode se repetir.
- `telefone`, quando informado, deve conter 10 ou 11 algarismos.
- `data_nascimento` é obrigatória e deve ficar entre 01/01/1900 e 26/09/2008. Esse limite representa 18 anos completos na data-base da execução, 26/09/2026.
- `status_cliente` aceita somente `A` (ativo) ou `I` (inativo).

## 2. ATS_ENDERECO

- Todo endereço pertence a um cliente existente.
- `tipo_endereco` aceita somente `RESIDENCIAL` ou `COMERCIAL`.
- `logradouro`, `cidade`, `cep` e `uf` são obrigatórios.
- `numero` deve ser um inteiro entre 1 e 999999.
- `cep` deve conter exatamente 8 algarismos.
- `uf` deve conter exatamente duas letras maiúsculas.
- O par (`endereco_id`, `cliente_id`) é único e permite assegurar que o endereço usado no pedido pertence ao cliente do pedido.

## 3. ATS_CATEGORIA

- `categoria_id` identifica unicamente a categoria.
- `nome` é obrigatório, deve conter de 3 a 80 caracteres e não pode se repetir.
- `ativo` aceita somente `S` ou `N`.
- Uma categoria com produtos associados não pode ser excluída.

## 4. ATS_PRODUTO

- Todo produto pertence a uma categoria existente.
- `sku` é obrigatório e não pode se repetir.
- `nome` é obrigatório e deve conter de 3 a 120 caracteres.
- `preco` deve ficar entre R$ 0,01 e R$ 999.999,99.
- `estoque` deve ser inteiro e ficar entre 0 e 99.999.999 unidades.
- `ativo` aceita somente `S` ou `N`.

## 5. ATS_PEDIDO

- Todo pedido pertence a um cliente existente e usa um endereço existente do mesmo cliente.
- `data_pedido` é obrigatória e recebe a data atual quando não informada.
- `status_pedido` aceita `ABERTO`, `PAGO`, `ENVIADO`, `ENTREGUE` ou `CANCELADO`.
- `valor_total` deve ficar entre zero e R$ 9.999.999.999,99.
- Um cliente com pedidos associados não pode ser excluído.

## 6. ATS_ITEM_PEDIDO

- O item é identificado pelo par (`pedido_id`, `produto_id`).
- Todo item referencia um pedido e um produto existentes.
- `quantidade` deve ser inteira e ficar entre 1 e 999.
- `preco_unitario` deve ficar entre R$ 0,01 e R$ 999.999,99.
- `desconto_percentual` deve ficar entre 0% e 100%.

## 7. ATS_PAGAMENTO

- Todo pagamento pertence a um pedido existente.
- Cada pedido pode ter, no máximo, um pagamento.
- `forma_pagamento` aceita `PIX`, `CARTAO`, `BOLETO` ou `DINHEIRO`.
- `valor` deve ser positivo.
- `parcelas` deve ser um inteiro entre 1 e 12.
- `status_pagamento` aceita `PENDENTE`, `APROVADO`, `RECUSADO` ou `ESTORNADO`.
- O valor do pagamento deve ser exatamente igual ao `valor_total` do pedido. A chave estrangeira composta (`pedido_id`, `valor`) aplica a regra sem depender de gatilhos.

## 8. ATS_ENTREGA

- Toda entrega pertence a um pedido existente.
- Cada pedido pode ter, no máximo, uma entrega.
- `transportadora` é obrigatória.
- `codigo_rastreio`, quando informado, não pode se repetir.
- `status_entrega` aceita `PREPARANDO`, `ENVIADO`, `ENTREGUE` ou `DEVOLVIDO`.
- A data prevista não pode ser anterior à data de envio.
- A data efetiva de entrega não pode ser anterior à data de envio.
- Uma entrega com status `ENTREGUE` deve possuir `data_entrega`.
