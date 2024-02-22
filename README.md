# blockchain-tcc-licitacoes

## PROJETO DE TCC UTILIZANDO HYPERLEDGER BESU

### PASSO A PASSO DE EXECUÇÃO DO PROJETO

1. Realizar o download dos binários do besu na versão 24.1.2
```bash
    curl -o besu.zip https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/24.1.2/besu-24.1.2.zip
```
2. Descompactar o arquivo zip do besu
```bash
    unzip besu.zip -d besu
```
3. Verificar se o besu está funcionando
```bash
    .besu/bin/besu --help
```
4. Iniciar a blockchain do besu em modo de desenvolvimento
```bash
./bin/besu --network=dev --rpc-http-cors-origins="all" --host-allowlist="*" --rpc-ws-enabled --rpc-http-enabled
```


## Artefatos de Software

### Diagrama da arquitetura
```mermaid
    graph TD
    subgraph frontend
        AP[Angular App]
        AC[Controller] --> AS[Angular Services] -.->  AR[Angular Repository]
    end

    subgraph backend
    B[Java/Quarkus Backend]
    CA[Controller]
    S[Service]
    BI[Infrastructure]
    R[Repository]
    end

    subgraph blockchain
    SC[Smart Contracts]
    BC[Hyperleger Fabric]
    end

    subgraph storage
    D[(IPFS)]
    E[(PostgreSQL)]
    end

    subgraph messaging
    MQ[RabbitMQ]
    end

    AR -->|Requisições HTTP| CA
    CA -->|Lógica de Aplicação| S
    S --> BI -->|Gerenciamento de Dados| R
    BI -->|Comunicação Assíncrona| MQ
    MQ -->|Trabalhos em Background| SC
    SC -->|Interage com| BC
    R -->|Leitura/Escrita| E
    BI -->|Armazena Arquivos| D
    style frontend fill:#f9f,stroke:#333,stroke-width:2px
    style backend fill:#bbf,stroke:#333,stroke-width:4px
    style blockchain fill:#fbf,stroke:#333,stroke-width:2px
    style storage fill:#bfb,stroke:#333,stroke-width:2px
    style messaging fill:#ddf,stroke:#333,stroke-width:2px
```

### DIAGRAMAS DE SEQUENCIA
#### EDIÇÃO DE LICITAÇÃO
```mermaid
sequenceDiagram
    participant Frontend
    participant Backend
    participant IPFS
    participant Blockchain
    
    Frontend->>+Backend: Requisição de edição da licitação
    Backend->>+IPFS: Atualiza documentos
    IPFS-->>-Backend: Confirmação da atualização
    Backend->>+Blockchain: Registra transação de mudança de estado
    Blockchain-->>-Backend: Confirmação da transação
    Backend-->>-Frontend: Confirmação da edição
```