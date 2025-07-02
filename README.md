
# 🎮 Guess Game com Docker Compose

Este projeto implementa o jogo de adivinhação [Guess Game](https://github.com/fams/guess_game), estruturado com Docker Compose, contemplando backend Flask, frontend React, banco PostgreSQL e um proxy reverso NGINX com balanceamento de carga.

---

## 🎯 Objetivo

Criar uma arquitetura em containers com:

- Backend Python Flask
- Frontend React
- Banco de Dados PostgreSQL com volume persistente
- NGINX servindo o frontend e atuando como proxy reverso entre múltiplos backends

---

## 🧱 Estrutura da Solução

| Serviço    | Descrição                                               | Porta     |
|------------|---------------------------------------------------------|-----------|
| `postgres` | Banco PostgreSQL com volume persistente                 | 5432 (int)|
| `backend1` | Primeira instância da API Flask                         | 5000 (int)|
| `backend2` | Segunda instância da API Flask                          | 5000 (int)|
| `frontend` | Frontend React (build via Dockerfile)                   | interno   |
| `nginx`    | Proxy reverso para `/api/` e servidor de arquivos React | 8080      |

---

## 📦 Requisitos Atendidos

- [x] Backend Python Flask rodando em container
- [x] Banco de dados Postgres com volume Docker
- [x] Frontend React servido via NGINX
- [x] NGINX com balanceamento de carga entre múltiplas instâncias do backend
- [x] Resiliência com `restart: on-failure` para todos os serviços
- [x] Fácil atualização de qualquer serviço
- [x] Comunicação total entre os containers
- [x] Volume persistente `postgres-data` para dados do Postgres

---

## 📁 Estrutura de Diretórios

```bash
guess_game/
├── docker-compose.yml
├── Dockerfile                  # Backend Flask
├── frontend/
│   ├── Dockerfile              # Dockerfile do frontend
│   ├── default.conf            # Configuração NGINX (proxy + frontend)
├── run.py                     # Entry point do backend
├── start-backend.sh           # Inicialização do Flask app
├── requirements.txt
```

---

## ⚙️ Instalação e Execução

### 1. Clone o repositório

```bash
git clone https://github.com/viniciusaraujo20/pucminas-guessgame-docker-compose.git
cd pucminas-guessgame-docker-compose
```

### 2. Execute o build e suba os serviços

```bash
docker compose up -d --build
```

### 3. Acesse a aplicação

🌐 http://localhost:8080

---

## ♻️ Atualização de Componentes

Atualize backend:

```bash
docker compose build backend1 backend2
docker compose up -d
```

Atualize frontend:

```bash
docker compose build frontend
docker compose up -d
```

Atualize PostgreSQL:

Troque a versão no `docker-compose.yml`, mantendo o volume `postgres-data`.

---

## 🧠 Estratégia Técnica

### 🔀 NGINX como Proxy Reverso + Servidor do Frontend

```nginx
upstream backend_servers {
    server backend1:5000;
    server backend2:5000;
}

server {
    listen 80;

    location /api/ {
        proxy_pass http://backend_servers/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri /index.html;
    }
}
```

- Requisições para `/api/` são balanceadas entre `backend1` e `backend2`
- Requisições para `/` entregam o frontend React

---

## 🗄️ Volume Persistente

```yaml
volumes:
  postgres-data:
```

Esse volume é montado em:

```yaml
- postgres-data:/var/lib/postgresql/data
```

O Docker monta esse volume automaticamente no host em:

```yaml
- /var/lib/docker/volumes/pucminas-guessgame-docker-compose_postgres-data/_data
```

---

## 🛡️ Resiliência

Todos os serviços utilizam:

```yaml
restart: on-failure
```

Garantindo que:

- Containers reiniciem automaticamente em falhas
- Continuidade da aplicação após reinicializações

---

## 🎮 Como Jogar

1. Acesse `http://localhost:8080`
2. Vá em **Maker**, defina uma senha e clique em **Create Game**
3. Copie o `game_id` gerado
4. Vá na aba **Breaker**, insira o `game_id` e tente adivinhar a senha

---

## 💡 Tecnologias Utilizadas

- 🐍 Python 3.10 + Flask
- 🐘 PostgreSQL
- ⚛️ React + TypeScript
- 🐳 Docker + Docker Compose
- 🌐 NGINX (Alpine)
