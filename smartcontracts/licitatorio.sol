// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProcessoLicitatorio {
    struct Prazo {
        uint dataInicio;
        uint dataFim;
    }

    struct Licita {
        uint id;
        string descricao;
        uint versao;
        uint versaoAnterior;
        Prazo prazo;
    }

    struct Proposta {
        uint id;
        uint licitaId;
        address proponente;
        string descricao;
        uint valor;
        uint versao;
        uint idVersaoAnterior;
    }
    
    uint private contadorId = 0;
    uint private contadorIdProposta = 0;
    mapping(uint => Licita) public licitacoes;
    mapping(uint => Proposta) public propostas;


    /****  EVENTOS ****/
    event LicitaCriada(uint id, string descricao);
    event PropostaSubmetida(uint id, uint licitaId, address proponente);
    event PropostaAtualizada(uint id, uint licitaId, address proponente, uint versao);
    event LicitaAtualizada(uint id, string descricao, uint versao);
        function criarLicita(string memory descricao, uint dataInicio, uint dataFim) public {
        Prazo memory novoPrazo = Prazo(dataInicio, dataFim);
        Licita memory novaLicita = Licita(contadorId, descricao, 1, 0, novoPrazo);
        licitacoes[contadorId] = novaLicita;
        emit LicitaCriada(contadorId, descricao);
        contadorId++;
    }

    /****  FUNÇÕES ****/
    function atualizarLicita(uint id, string memory novaDescricao, uint novoDataInicio, uint novoDataFim) public {
        Licita storage licitaAnterior = licitacoes[id];
        Prazo memory novoPrazo = Prazo(novoDataInicio, novoDataFim);
        licitacoes[contadorId] = Licita(contadorId, novaDescricao, licitaAnterior.versao + 1, id, novoPrazo);
        emit LicitaAtualizada(contadorId, novaDescricao, licitaAnterior.versao + 1);
        contadorId++;
    }
    function submeterProposta(uint licitaId, string memory descricao, uint valor) public {
        Proposta memory novaProposta = Proposta(contadorIdProposta, licitaId, msg.sender, descricao, valor, 1, 0);
        propostas[contadorIdProposta] = novaProposta;
        emit PropostaSubmetida(contadorIdProposta, licitaId, msg.sender);
        contadorIdProposta++;
    }
    function atualizarProposta(uint propostaId, string memory novaDescricao, uint novoValor) public {
        Proposta storage propostaAnterior = propostas[propostaId];
        require(msg.sender == propostaAnterior.proponente, "Somente o proponente original pode atualizar a proposta.");
        propostas[contadorIdProposta] = Proposta(contadorIdProposta, propostaAnterior.licitaId, msg.sender, novaDescricao, novoValor, propostaAnterior.versao + 1, propostaId);
        emit PropostaAtualizada(contadorIdProposta, propostaAnterior.licitaId, msg.sender, propostaAnterior.versao + 1);
        contadorIdProposta++;
    }

}
