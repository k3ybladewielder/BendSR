---
name: bugfix
description: Esta skill descreve o procedimento para registro de atualizações relacionado a correções de bugs.
keywords: ["corrija", "bugfix", "bug", "erro"]
---

# Descrição
Você deve criar, se não existir, um diretório no repositório atual de trabalho (working-directory) com o nome .bugfix. Este diretório servirá para armazenar arquivos que descrevam atualizações realizadas no projeto.

Essa skill deve ser utilizada SEMPRE que o usuário solicitar a correção de um bug. Os logs registrados em .bugfix/changes.md sempre devem ser utilizados para otimizar a resolução do problema.

# Estrutura
O arquivo deve ser nomeado como changes.md e conterá todas as alterações de resolução de bugs para consultas futuras. Deve ser estruturado em bulletpoints problema, solução e mudanças realizadas. Exemplo:

# BUGFIXES
- título - timestamp:
  - description: [Descrição]
  - solution: [Descrição]