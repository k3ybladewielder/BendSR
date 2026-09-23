---
name: design
description: Este documento é a fonte de verdade para todas as decisões de design e estética do front-end. Toda nova tela, componente ou ajuste deve ser confrontado com as diretrizes aqui definidas antes de ser implementado. A identidade visual é derivada diretamente do site institucional **Academia Magia das Cores** (`magiadascores/index.html`) e adaptada para o contexto de painel operacional interno.
---

## 1. Princípios de Design

| Princípio | Descrição |
|---|---|
| **Operacional primeiro** | O sistema é usado durante o atendimento presencial. Cada tela deve responder em menos de 200 ms e permitir executar a ação principal em no máximo 3 cliques. |
| **Familiaridade de marca** | Operadores do salão já convivem com a identidade Magia das Cores. O painel deve parecer parte do mesmo universo, não um produto estranho. |
| **Escuro por padrão** | O dark theme reduz a fadiga visual em longas jornadas de trabalho e mantém coerência com o site institucional. Não haverá tema claro no MVP. |
| **Hierarquia por cor** | As três cores de marca têm papéis funcionais distintos (ver §3). Não usá-las aleatoriamente para decoração. |
| **Densidade controlada** | Interface densa o suficiente para mostrar a agenda completa da equipe em uma tela, mas com espaçamento generoso nos formulários de entrada rápida. |

---

## 2. Paleta de Cores

Extraída diretamente da configuração Tailwind do site institucional.

### 2.1 Cores de Marca

| Token | Hex | Nome | Uso principal |
|---|---|---|---|
| `brand-magenta` | `#FF007A` | Magenta | Ações primárias destrutivas ou urgentes, status "Cancelado" / "No-show", hover padrão em cards |
| `brand-cyan` | `#00F0FF` | Ciano | Ações primárias construtivas, status "Confirmado", destaque de campo focado, indicadores de "mais completo" |
| `brand-yellow` | `#FFDF00` | Amarelo | Alertas, avisos, status "Agendado" (pendente), estrelas de avaliação, badges de atenção |

### 2.2 Cores de Superfície

| Token | Hex | Uso |
|---|---|---|
| `brand-dark` | `#0B0B0F` | Background da página (body) |
| `brand-card` | `#14141B` | Background de cards, painéis e modais |
| `brand-border` | `#262636` | Bordas neutras de separação |

### 2.3 Texto

| Classe Tailwind | Uso |
|---|---|
| `text-white` | Títulos e labels de campo ativos |
| `text-gray-100` | Corpo de texto principal |
| `text-gray-300` | Texto secundário, descrições |
| `text-gray-400` | Texto de suporte, placeholders, metadados |
| `text-gray-500` | Texto desabilitado, rodapés |

### 2.4 Gradiente Fluido

O gradiente tricolor é o elemento visual mais reconhecível da marca.

```css
/* Gradiente de fundo / elementos de destaque máximo */
background: linear-gradient(135deg, #FF007A 0%, #00F0FF 50%, #FFDF00 100%);

/* Texto com gradiente */
background: linear-gradient(135deg, #FF007A, #00F0FF, #FFDF00);
-webkit-background-clip: text;
-webkit-text-fill-color: transparent;
```

**Regra de uso:** o gradiente fluido é reservado para o elemento de CTA principal de cada tela e para o logo/wordmark. Não deve aparecer em mais de 2 elementos por viewport.

### 2.5 Status dos Agendamentos

Mapeamento direto de cor para os estados do RF07:

| Status | Cor | Token |
|---|---|---|
| Agendado | Amarelo | `brand-yellow` |
| Confirmado | Ciano | `brand-cyan` |
| Concluído | Verde sutil | `#22c55e` (Tailwind `green-500`) |
| Cancelado | Magenta | `brand-magenta` |
| Faltou (No-show) | Cinza | `text-gray-500` |

---

## 3. Tipografia

Fontes idênticas ao site institucional, mantendo o vínculo de marca.

| Família | Variável CSS / Tailwind | Pesos | Uso |
|---|---|---|---|
| **Syne** | `font-display` | 700, 800 | Títulos de seção (h1–h3), nome do logo, cabeçalhos de página |
| **Plus Jakarta Sans** | `font-sans` (padrão) | 400, 600, 700, 800 | Todo o restante: labels, botões, tabelas, formulários, corpo |

```html
<!-- Google Fonts — incluir no layout raiz -->
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&family=Syne:wght@700;800&display=swap" rel="stylesheet">
```

### Escala Tipográfica

| Elemento | Tailwind | Peso | Fonte |
|---|---|---|---|
| Título de página | `text-3xl` / `text-4xl` | `font-extrabold` | `font-display` (Syne) |
| Título de seção / modal | `text-xl` / `text-2xl` | `font-bold` | `font-display` (Syne) |
| Label de card / badge | `text-[10px]` uppercase | `font-bold` | `font-sans` |
| Corpo / descrição | `text-sm` | `font-normal` | `font-sans` |
| Dado de tabela | `text-sm` | `font-normal` / `font-semibold` | `font-sans` |
| Metadado / caption | `text-xs` | `font-normal` | `font-sans` |

---

## 4. Componentes Base

### 4.1 Glass Card

O componente de superfície mais usado. Toda caixa de conteúdo — card de agendamento, painel lateral, modal — usa este padrão.

```css
/* Classe utilitária: glass-card */
background: rgba(20, 20, 27, 0.7);   /* brand-card com 70% opacidade */
backdrop-filter: blur(12px);
border: 1px solid rgba(255, 255, 255, 0.08);
border-radius: 1.5rem;               /* rounded-3xl */
```

**Estado hover padrão (cards interativos):**
```css
border-color: rgba(0, 240, 255, 0.4);           /* brand-cyan */
box-shadow: 0 0 25px rgba(255, 0, 122, 0.15);   /* brand-magenta glow */
```

Em shadcn/ui, implementar como variante de `Card` com `className="glass-card"`.

### 4.2 Botões

| Variante | Aparência | Uso |
|---|---|---|
| **Primary** | `bg-fluid-primary` (gradiente), texto preto, `font-extrabold`, `rounded-full` | CTA principal da tela: "Novo Agendamento", "Salvar" |
| **Secondary** | `glass-card` fundo, texto branco, `font-bold`, `rounded-full` | Ação secundária: "Cancelar", "Ver Detalhes" |
| **Ghost** | `bg-white/10`, hover `bg-white/20`, `rounded-xl` | Ações terciárias dentro de cards, botões de lista |
| **Destructive** | `bg-brand-magenta`, texto branco | "Cancelar Agendamento", "Remover Cliente" |
| **Status** | Fundo colorido pelo status + `rounded-full` | Badges de status na grade da agenda |

Todos os botões usam `hover:scale-105 transition-transform duration-200` para feedback visual.

### 4.3 Badges de Label

Padrão para categorias, status e indicadores:

```html
<span class="inline-block text-[10px] font-bold text-brand-cyan uppercase tracking-wider">
  Label
</span>
```

Para badges com fundo:
```html
<span class="px-3 py-0.5 rounded-full bg-brand-cyan text-black font-extrabold text-[9px] uppercase tracking-wider">
  Mais Completa
</span>
```

### 4.4 Inputs e Formulários

- Background: `bg-brand-card` (`#14141B`)
- Borda padrão: `border border-brand-border` (`#262636`)
- Borda em foco: `focus:border-brand-cyan focus:ring-1 focus:ring-brand-cyan/50`
- Texto: `text-gray-100`
- Placeholder: `text-gray-500`
- Border radius: `rounded-xl`
- Padding: `px-4 py-3`

### 4.5 Separadores e Bordas de Seção

```css
/* Separador horizontal de seção */
border-top: 1px solid rgba(255, 255, 255, 0.05);  /* border-white/5 */

/* Separador interno de card */
border-top: 1px solid rgba(255, 255, 255, 0.1);   /* border-white/10 */
```

---

## 5. Layout e Estrutura de Telas

### 5.1 Shell do Painel

```
┌──────────────────────────────────────────────────────────────┐
│  HEADER (fixo, 64px)  — logo + user menu + ações globais    │
│  backdrop-blur-md · bg-brand-dark/80 · border-b border-white/5│
├─────────────────┬────────────────────────────────────────────┤
│                 │                                            │
│  SIDEBAR        │  CONTEÚDO PRINCIPAL                        │
│  (240px fixo)   │  max-w-7xl · px-6 · py-8                  │
│  bg-brand-card  │                                            │
│  border-r       │                                            │
│  border-white/5 │                                            │
│                 │                                            │
└─────────────────┴────────────────────────────────────────────┘
```

- Header fixo com `backdrop-blur-md bg-brand-dark/80 border-b border-white/5` — idêntico ao navbar do site.
- Sidebar com navegação principal: Agenda, Clientes, Equipe, Configurações.
- Área de conteúdo com `max-w-7xl mx-auto`.

### 5.2 Grade da Agenda (tela principal)

- Colunas por profissional (visão empresa) ou linha do tempo única (autônomo).
- Slots de horário como células de `glass-card` compactas com badge de status.
- Botão de "Novo Agendamento" em destaque máximo (gradiente fluido) no canto superior direito.

### 5.3 Sheet de Agendamento Rápido

- Usa o componente `Sheet` do shadcn/ui (painel deslizante lateral).
- Largura: `max-w-md`.
- Fundo: `bg-brand-card`.
- Título em `font-display`.
- Campos: Cliente (Combobox), Serviço, Profissional, Data, Horário.
- Botão principal com gradiente fluido ocupa 100% da largura no rodapé do sheet.

### 5.4 Painel de Reengajamento

- Layout de tabela full-width com `TanStack Table`.
- Linha por cliente com: nome, último serviço, data da última visita, dias em atraso (destacado em `brand-magenta` se > 0), botão `wa.me` inline.
- Background de linha alternado: `bg-brand-dark` / `bg-brand-card/50`.

---

## 6. Efeitos Visuais e Animações

### 6.1 Glow de Fundo (Ambient Light)

Usado no hero do site para profundidade. No painel, aplicar com moderação em telas de destaque (ex.: dashboard vazio, tela de boas-vindas):

```html
<div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2
            w-[400px] h-[400px] bg-fluid-primary opacity-10
            blur-[120px] rounded-full pointer-events-none" />
```

Opacidade máxima de `0.10`–`0.15` no painel (vs. `0.20` no site) para não competir com dados operacionais.

### 6.2 Transições

```css
/* Hover em botões e cards interativos */
hover:scale-105 transition-transform duration-200

/* Hover de cor em links de nav */
transition-colors duration-150

/* Abertura de accordions / details */
transition: transform 150ms ease;   /* usado na seta ↓ do FAQ */
```

### 6.3 Selection Color

```css
::selection {
  background-color: #FF007A;   /* brand-magenta */
  color: white;
}
```

---

## 7. Iconografia

- Biblioteca: **Lucide React** (já listada na stack).
- Tamanho padrão: `16px` (`size-4`) em labels, `20px` (`size-5`) em botões, `24px` (`size-6`) em navegação sidebar.
- Cor: herda do texto pai ou usa cor de marca para ícones de status.
- Emojis são aceitáveis em títulos de seção e badges de marketing (ex.: `✨`, `🎨`), mas **não** em interfaces operacionais de tabela ou formulário.

---

## 8. Responsividade

O painel é projetado mobile-first mas otimizado para desktop de recepção (≥1280px).

| Breakpoint | Contexto | Ajuste |
|---|---|---|
| `sm` (640px) | Celular do profissional | Sidebar colapsada em menu hambúrguer; grade de agenda em coluna única |
| `md` (768px) | Tablet | Sidebar visível; grade com 2 colunas |
| `lg` (1024px) | Laptop da recepção | Layout completo; agenda com todas as colunas de profissionais |
| `xl` (1280px+) | Monitor de recepção | Densidade máxima; painel de reengajamento ao lado da agenda |

---

## 9. Acessibilidade

- Contraste mínimo de 4.5:1 para texto sobre fundos escuros (obrigatório para `text-gray-400` sobre `brand-dark`).
- Foco visível: `focus-visible:ring-2 focus-visible:ring-brand-cyan focus-visible:ring-offset-2 focus-visible:ring-offset-brand-dark`.
- Todos os campos de formulário com `<label>` associado via `htmlFor`.
- Badges de status não devem transmitir informação apenas por cor — incluir texto ou ícone.
- `aria-label` em botões que contêm apenas ícones (ex.: botão de WhatsApp).

---

## 10. Referência Rápida — Tailwind Config

Copiar este bloco no `tailwind.config.ts` do projeto para garantir paridade de tokens:

```ts
import type { Config } from 'tailwindcss'

const config: Config = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['"Plus Jakarta Sans"', 'sans-serif'],
        display: ['"Syne"', 'sans-serif'],
      },
      colors: {
        brand: {
          magenta: '#FF007A',
          cyan: '#00F0FF',
          yellow: '#FFDF00',
          dark: '#0B0B0F',
          card: '#14141B',
          border: '#262636',
        },
      },
    },
  },
}

export default config
```

E os utilitários CSS globais no `globals.css`:

```css
@layer utilities {
  .bg-fluid-primary {
    background: linear-gradient(135deg, #FF007A 0%, #00F0FF 50%, #FFDF00 100%);
  }

  .text-gradient {
    background: linear-gradient(135deg, #FF007A, #00F0FF, #FFDF00);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .glass-card {
    background: rgba(20, 20, 27, 0.7);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.08);
  }

  .glass-card-hover:hover {
    border-color: rgba(0, 240, 255, 0.4);
    box-shadow: 0 0 25px rgba(255, 0, 122, 0.15);
  }
}
```
