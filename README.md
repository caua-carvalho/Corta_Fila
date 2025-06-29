# Monorepo Corta Fila

> **Visão Geral**
> Monorepo unificado contendo:
>
> * **Backend**: API Laravel (PHP)
> * **Web**: SPA React
> * **Mobile**: App Expo (React Native)

Este repositório provê um fluxo “end‑to‑end” para **provisionamento**, **build** e **execução** em ambientes Windows 10/11, padronizado via **Chocolatey**.

---

## 🚀 Sumário

1. [Pré‑requisitos](#pré-requisitos)
2. [Instalação das Ferramentas Core](#instalação-das-ferramentas-core)
3. [Clonagem do Repositório](#clonagem-do-repositório)
4. [Provisionamento do Backend (Laravel)](#provisionamento-do-backend-laravel)
5. [Provisionamento do Front‑end Web (React)](#provisionamento-do-front-end-web-react)
6. [Provisionamento do Mobile (Expo)](#provisionamento-do-mobile-expo)
7. [Validação (Smoke Tests)](#validação-smoke-tests)
8. [Governança & CI/CD](#governança--cicd)
9. [Estrutura do Projeto](#estrutura-do-projeto)
10. [Variáveis de Ambiente](#variáveis-de-ambiente)
11. [Contribuição](#contribuição)
12. [Licença](#licença)

---

## Pré‑requisitos

* **Windows 10/11** (Admin privileges no PowerShell)
* **GitHub Desktop** instalado e autenticado
* **Acesso** ao repositório GitHub (SSH ou HTTPS)

---

## Instalação das Ferramentas Core

Abra o **PowerShell como Administrador** e execute:

```powershell
# Instalar via Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install git nodejs-lts yarn expo-cli php composer -y
```

> **Validação** (verifique se todas as ferramentas estão instaladas corretamente):
>
> ```powershell
> git --version
> node -v
> npm -v
> yarn --version
> expo --version
> php -v
> composer --version
> ```

---

## Clonagem do Repositório

1. Abra o **GitHub Desktop**
2. **File → Clone repository…**
3. Aba **URL** → cole `git@github.com:seu-org/seu-monorepo.git`
4. Escolha o **Local Path** (ex.: `C:\Projetos\seu-monorepo`)
5. Clique em **Clone**

No Windows Explorer, confirme:

```
C:\Projetos\seu-monorepo
├── backend\      # Laravel API
├── web\          # React SPA
└── mobile\       # Expo App
```

---

## Provisionamento do Backend (Laravel)

No PowerShell, dentro de `backend\`:

```powershell
cd .\backend

# 1) Instalar dependências PHP
composer install --no-interaction --optimize-autoloader

# 2) Preparar .env
copy .env.example .env
notepad .env   # ajuste DB_HOST, DB_DATABASE, DB_USERNAME, DB_PASSWORD

# 3) Gerar chave e rodar migrações
php artisan key:generate
php artisan migrate --seed

# 4) Build de assets (Laravel Mix)
yarn install      # ou npm install
yarn dev          # ou npm run dev

# 5) Iniciar servidor local
php artisan serve --host=127.0.0.1 --port=8000
```

---

## Provisionamento do Front‑end Web (React)

No PowerShell, dentro de `web\`:

```powershell
cd ..\web

# 1) Instalar dependências JS
yarn install      # ou npm install

# 2) Configurar endpoint da API
Add-Content .env.local "REACT_APP_API_URL=http://localhost:8000/api"

# 3) Iniciar em modo dev
yarn start        # ou npm start
# → Acesse: http://localhost:3000
```

---

## Provisionamento do Mobile (Expo)

No PowerShell, dentro de `mobile\`:

```powershell
cd ..\mobile

# 1) Instalar dependências Expo
yarn install      # ou npm install
expo install

# 2) Configurar endpoint da API
# Em app.json, adicione em "expo.extra":
#   "apiUrl": "http://<IP-da-máquina>:8000/api"

# 3) Iniciar Metro Bundler
expo start
# → Escaneie o QR code no Expo Go ou use um emulador
```

---

## Validação (Smoke Tests)

* **API Health Check**

  ```powershell
  curl http://127.0.0.1:8000/api/health
  ```
* **Web**: teste fluxo de login e CRUD básico
* **Mobile**: valide fetch de dados no dispositivo ou emulador

---

## Governança & CI/CD

* **Versionamento de Secrets**: mantenha apenas `.env.example` no repositório.
* **CI Pipeline** (GitHub Actions):

  * `composer install`
  * `npm ci && npm run build:web && npm run build:mobile`
  * Execução de testes automatizados (unit & integration).
* **Release Management**: use tags Git semânticas (vX.Y.Z) e GitHub Releases.

---

## Estrutura do Projeto

```
seu-monorepo/
├── backend/             # Laravel API
│   ├── app/
│   ├── database/
│   └── ...
├── web/                 # React SPA
│   ├── public/
│   ├── src/
│   └── ...
└── mobile/              # Expo App
    ├── assets/
    ├── src/
    └── app.json
```

---

## Variáveis de Ambiente

| Arquivo      | Chave                     | Descrição                        |
| ------------ | ------------------------- | -------------------------------- |
| `.env`       | `DB_HOST`, `DB_DATABASE`… | Configuração do banco Laravel    |
| `.env.local` | `REACT_APP_API_URL`       | URL base da API para a SPA React |
| `app.json`   | `expo.extra.apiUrl`       | URL base da API para o App Expo  |

---

## Contribuição

1. **Fork** do repositório
2. **Branch** de feature: `feat/minha-feature`
3. **Commit** claro e descritivo
4. **Pull Request** com revisão de código, testes e documentação atualizada

---
