# 🤖 Unipoke

Um bot Discord interativo para Pokémon construído em **Elixir**, que fornece informações completas sobre Pokémon, análise de fraquezas, fusão de Pokémon e muito mais!

## ✨ Funcionalidades

- 🎲 **Pokémon Aleatório** - Obtenha um Pokémon aleatório com `!randompoke`
- 📖 **Pokédex** - Consulte informações detalhadas de qualquer Pokémon com `!pokedex <pokemon>`
- ⚠️ **Análise de Fraquezas** - Veja as fraquezas de um Pokémon com `!fraqueza <pokemon>`
- 📊 **Atributos e Status** - Verifique atributos com `!status` ou `!status <pokemon> <atributo>`
- 🔗 **Fusão de Pokémon** - Combine dois Pokémon com `!fusao <pokemon1> <pokemon2>`
- 📋 **Sistema de Ajuda** - Use `!help` para ver todos os comandos disponíveis

## 🛠️ Tecnologia

- **Linguagem**: Elixir ~> 1.19
- **Discord**: [Nostrum](https://github.com/Kraigie/nostrum) ~> 0.10.4
- **HTTP Client**: [Finch](https://github.com/sneako/finch) ~> 0.16.0

## 📋 Pré-requisitos

- Elixir >= 1.19
- Erlang OTP 26+
- Token de bot do Discord
- Acesso a uma API Pokémon (ex: PokéAPI)

## 🚀 Instalação e Configuração

### 1. Clone o repositório

```bash
git clone <seu-repositorio>
cd unipoke
```

### 2. Instale as dependências

```bash
mix deps.get
```

### 3. Configure o token do Discord

Adicione uma variável de ambiente com seu token do Discord:

```bash
export DISCORD_TOKEN="seu_token_aqui"
```

Ou configure no arquivo `config/config.exs`:

```elixir
config :nostrum,
  token: System.get_env("DISCORD_TOKEN") || "seu_token"
```

### 4. Inicie o bot

```bash
mix run --no-halt
```

## 📝 Comandos Disponíveis

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `!help` | Exibe todos os comandos disponíveis | `!help` |
| `!randompoke` | Retorna um Pokémon aleatório | `!randompoke` |
| `!pokedex <pokemon>` | Busca informações de um Pokémon | `!pokedex pikachu` |
| `!fraqueza <pokemon>` | Lista as fraquezas de um Pokémon | `!fraqueza charizard` |
| `!status` | Lista todos os atributos disponíveis | `!status` |
| `!status <pokemon> <atributo>` | Consulta um atributo específico | `!status pikachu speed` |
| `!fusao <pokemon1> <pokemon2>` | Cria uma fusão entre dois Pokémon | `!fusao pikachu squirtle` |

## 🔧 Estrutura do Projeto

```
unipoke/
├── lib/
│   ├── unipoke.ex                 # Módulo principal
│   ├── unipoke/
│   │   ├── application.ex         # Configuração da aplicação
│   │   ├── consumer.ex            # Consumidor de eventos Discord
│   │   ├── commands.ex            # Roteador de comandos
│   │   └── commands/              # Implementação de cada comando
│   └── ...
├── config/
│   └── config.exs                 # Configurações
├── mix.exs                        # Dependências do projeto
└── README.md                      # Este arquivo
```

## 📄 Licença

Este projeto está sob licença MIT. Veja o arquivo LICENSE para mais detalhes.

