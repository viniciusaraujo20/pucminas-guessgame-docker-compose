# 🎮 Guess Game com Docker Compose

Este projeto implementa o jogo de adivinhação [Guess Game](https://github.com/fams/guess_game), estruturado com Docker Compose, contemplando backend Flask, frontend React, banco PostgreSQL e um proxy reverso NGINX com balanceamento de carga.

## 🎯 Objetivo  
Criar uma arquitetura em containers com:  
- Backend Python Flask  
- Frontend React  
- Banco de Dados PostgreSQL com volume persistente  
- NGINX servindo o frontend e atuando como proxy reverso entre múltiplos backends  

## 🧱 Estrutura da Solução  
| Serviço    | Descrição                                               | Porta     |  
|------------|---------------------------------------------------------|-----------|  
| `db`       | Banco PostgreSQL com volume persistente                 | 5432 (int)|  
| `backend1` | Primeira instância da API Flask                         | 5000 (int)|  
| `backend2` | Segunda instância da API Flask                          | 5000 (int)|  
| `frontend` | Frontend React (construído via Dockerfile)              | interno   |  
| `nginx`    | Proxy reverso para `/api/` e servidor de arquivos React | 80        |  

## 📦 Requisitos Atendidos  
- [x] Backend Python Flask rodando em container  
- [x] Banco de dados Postgres com volume Docker  
- [x] Frontend React servido via NGINX  
- [x] NGINX com balanceamento de carga entre múltiplas instâncias do backend  
- [x] Resiliência com `restart: always` para todos os serviços  
- [x] Fácil atualização de qualquer serviço  
- [x] Comunicação total entre os containers  
- [x] Volume persistente `pgdata` para dados do Postgres  

## 📁 Estrutura de Diretórios  
\`\`\`
guess_game/
├── docker-compose.yml
├── guess/               # Backend Flask
│   └── Dockerfile
├── frontend/            # Frontend React
│   └── Dockerfile
├── nginx/               # Configuração do proxy reverso
│   └── nginx.conf
├── repository/          # Persistência em banco
├── run.py               # Entry point do backend
├── start-backend.sh     # Script de inicialização Flask
\`\`\`

## ⚙️ Instalação e Execução  
1. Clone o repositório
   
git clone https://github.com/fams/guess_game  
cd guess_game  

3. Execute o build e suba os serviços  

docker compose up -d --build  

4. Acesse a aplicação  
🌐 http://localhost  

## ♻️ Atualização de Componentes  
Atualize backend:  

docker compose build backend1 backend2  
docker compose up -d  


Atualize frontend:  

docker compose build frontend  
docker compose up -d  


Atualize PostgreSQL: troque a versão no docker-compose.yml, mantendo o volume pgdata.  

## 🧠 Estratégia Técnica  

### 🔀 NGINX como Proxy Reverso  
Configuração nginx.conf:  

upstream backend {
    server backend1:5000;
    server backend2:5000;
}
location /api/ {
    proxy_pass http://backend;
}


- /api/ é balanceado entre as instâncias do backend  
- \`/\` serve os arquivos do frontend React  

### 🗄️ Volume Persistente  
O banco PostgreSQL salva dados em:  

volumes:
  - pgdata:/var/lib/postgresql/data

Salvos no host via /var/lib/docker/volumes\.  

### 🛡️ Resiliência  
Todos os serviços usam restart: always, garantindo:  
- Autorestart em falhas
- Estabilidade contínua mesmo após reinicializações

## 🎮 Como Jogar  
1. Acesse http://localhost  
2. Clique em "Create Game" e insira uma senha  
3. Copie o game_id gerado  
4. Vá para a aba "Breaker", insira o game_id e tente adivinhar  

## 💡 Tecnologias Utilizadas  
🐍 Python 3.10 + Flask  
🐘 PostgreSQL 16  
⚛️ React + TypeScript  
🔧 Docker + Docker Compose  
🌐 NGINX (Alpine)  
