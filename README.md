# Corrida Certa

App para motoristas de aplicativo analisarem automaticamente se uma
oferta de corrida vale a pena, calculando R$/km e R$/h em tempo real.

## Estrutura

- `CorridaCerta/Modelos` — modelos de dados (oferta, configurações, veredito)
- `CorridaCerta/Servicos` — motor de cálculo, persistência de configurações, tema visual
- `CorridaCerta/Views` — telas SwiftUI
- `CorridaCertaTests` — testes unitários do motor de cálculo

## Como o projeto Xcode é gerado

Este repositório **não** versiona o arquivo `.xcodeproj`. Ele é gerado
automaticamente a partir do `project.yml` usando o
[XcodeGen](https://github.com/yonaskolb/XcodeGen). Isso permite testar
e compilar o projeto inteiramente pelo GitHub Actions, sem precisar
abrir o Xcode manualmente.

O workflow em `.github/workflows/build.yml` roda a cada push:
1. Instala o XcodeGen
2. Gera o `.xcodeproj` a partir do `project.yml`
3. Compila o app para o simulador de iPhone
4. Roda os testes unitários

Veja o resultado na aba **Actions** do repositório no GitHub.

## Rodando localmente (quando tiver acesso a um Mac)

```bash
brew install xcodegen
xcodegen generate
open CorridaCerta.xcodeproj
```
