-- PROJETO FINAL - LABORATÓRIO DE BANCO DE DADOS
-- Instruções e Estrutura do Arquivo .sql

-- Identificação do Grupo: 
-- Nome:Pedro Henrique Santos Lustosa / Matricula: UC24102979
-- Nome:Sofia Cutrim Cabral / Matricula: UC24101541
-- Nome:Paulo José Higa Freitas / Matricula: UC24101911

-- Alterações na Modelagem
-- Indique se houve alterações na modelagem de dados:
-- (x) Sim. O arquivo atualizado foi enviado novamente no AVA. 
-- ( ) Não.


-- 1. Criação do Banco de Dados e Estrutura
-- Criação do banco de dados.
CREATE DATABASE IF NOT EXISTS livraria_db;
USE livraria_db;

-- Criação das tabelas conforme a modelagem apresentada.
-- Tabela: autores
CREATE TABLE autores (
    id_autor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(255) NOT NULL,
    nacionalidade VARCHAR(100)
);

-- Tabela: livros
CREATE TABLE livros (
    id_livro INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    idioma VARCHAR(50),
    ano_publicacao SMALLINT,
    preco_compra DECIMAL(10,2),
    preco_venda DECIMAL(10,2) NOT NULL,
    classificacao_indicativa VARCHAR(50),
    editora VARCHAR(100),
    numero_edicao VARCHAR(50),
    impressao VARCHAR(50)
);

-- Tabela de Junção: autores_livros (relacionamento N:N entre autores e livros)
CREATE TABLE autores_livros (
    id_autor INT UNSIGNED,
    id_livro INT UNSIGNED,
    PRIMARY KEY (id_autor, id_livro), -- Chave primária composta
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela: categorias
CREATE TABLE categorias (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela de Junção: categorias_livros (relacionamento N:N entre categorias e livros)
CREATE TABLE categorias_livros (
    id_categoria INT UNSIGNED,
    id_livro INT UNSIGNED,
    PRIMARY KEY (id_categoria, id_livro), -- Chave primária composta
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela: fornecedores
CREATE TABLE fornecedores (
    id_fornecedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_empresa VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    email_contato VARCHAR(255),
    telefone_contato VARCHAR(20),
    tipo_fornecimento VARCHAR(100) -- Ex: 'Atacado', 'Distribuidor'
);

-- Tabela: fornecimento (Registra as entradas de livros por fornecedor)
CREATE TABLE fornecimento (
    id_fornecimento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_livro INT UNSIGNED NOT NULL,
    id_fornecedor INT UNSIGNED NOT NULL,
    quantidade_fornecida INT UNSIGNED NOT NULL,
    data_fornecimento DATE NOT NULL,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabela: estoque (Mantém o controle da quantidade atual de cada livro)
CREATE TABLE estoque (
    id_estoque INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_livro INT UNSIGNED UNIQUE NOT NULL, -- Garante que cada livro tenha apenas um registro de estoque
    quantidade INT UNSIGNED NOT NULL DEFAULT 0,
    ultima_entrada DATETIME,
    ultima_saida DATETIME,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela: clientes
CREATE TABLE clientes (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    telefone VARCHAR(20),
    email VARCHAR(255) UNIQUE
);

-- Tabela: vendas
CREATE TABLE vendas (
    id_venda INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(50), -- Ex: 'Cartão de Crédito', 'Boleto', 'Pix'
    status_venda VARCHAR(50), -- Ex: 'Pendente', 'Concluída', 'Cancelada', 'Em Processamento'
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabela: itens_da_venda (Detalhamento dos livros em cada venda)
CREATE TABLE itens_da_venda (
    id_item_venda INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_venda INT UNSIGNED NOT NULL,
    id_livro INT UNSIGNED NOT NULL,
    quantidade_vendida INT UNSIGNED NOT NULL,
    preco_unitario_venda DECIMAL(10,2) NOT NULL, -- Preço do livro no momento da venda (importante para histórico)
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (id_venda, id_livro) -- Garante que um livro não seja duplicado em um item da mesma venda
);

-- 2. Inserção de Dados
-- Inserção de dados em todas as tabelas. Cada tabela deve conter no mínimo 30 comandos INSERT. É permitido utilizar ferramentas auxiliares para gerar dados, como o ChatGPT ou geradores automáticos de dados fictícios.
INSERT INTO autores (nome_completo, nacionalidade) VALUES
('Clarice Lispector','Brasileira'),
('Jorge Amado','Brasileira'),
('Machado de Assis','Brasileira'),
('Paulo Coelho','Brasileira'),
('Graciliano Ramos','Brasileira'),
('Érico Veríssimo','Brasileiro'),
('José Saramago','Portuguesa'),
('Gabriel García Márquez','Colombiana'),
('Isabel Allende','Chilena'),
('Mario Vargas Llosa','Peruana'),
('William Shakespeare','Inglesa'),
('Jane Austen','Inglesa'),
('Fyodor Dostoevsky','Russkoe'),
('Victor Hugo','Francesa'),
('George Orwell','Britânica'),
('J.K. Rowling','Britânica'),
('Stephen King','Americana'),
('Agatha Christie','Britânica'),
('Haruki Murakami','Japonesa'),
('Chimamanda Ngozi Adichie','Nigeriana'),
('Mark Twain','Americana'),
('Emily Brontë','Britânica'),
('J.R.R. Tolkien','Britânico'),
('C.S. Lewis','Britânico'),
('Oscar Wilde','Irlandês'),
('Franz Kafka','Austríaco'),
('Khaled Hosseini','Afegã'),
('Toni Morrison','Americana'),
('Miguel de Cervantes','Espanhola'),
('Ernest Hemingway','Americano');

INSERT INTO livros (titulo, idioma, ano_publicacao, preco_compra, preco_venda, classificacao_indicativa, editora, numero_edicao, impressao) VALUES
('Dom Casmurro','Português',1899,10.00,25.00,'12+','Francisco','1ª','Offset'),
('O Alquimista','Português',1988,8.00,20.00,'10+','Rocco','3ª','Digital'),
('Cem Anos de Solidão','Espanhol',1967,12.00,30.00,'14+','HarperCollins','5ª','Offset'),
('O Cortiço','Português',1890,9.00,22.00,'14+','Global','2ª','Offset'),
('Memórias Póstumas de Brás Cubas','Português',1881,11.00,27.00,'12+','Nova Fronteira','4ª','Offset'),
('Harry Potter e a Pedra Filosofal','Português',1997,15.00,40.00,'10+','Rocco','7ª','Digital'),
('1984','Inglês',1949,7.00,19.00,'16+','Companhia das Letras','2ª','Offset'),
('O Senhor dos Anéis','Português',1954,18.00,50.00,'14+','Martins Fontes','8ª','Offset'),
('Crime e Castigo','Russo',1866,13.00,35.00,'16+','Penguin','3ª','Offset'),
('Orgulho e Preconceito','Inglês',1813,8.00,23.00,'14+','Martin Claret','6ª','Offset'),
('Grande Sertão: Veredas','Português',1956,14.00,37.00,'16+','José Olympio','2ª','Offset'),
('O Hobbit','Português',1937,10.00,25.00,'12+','Rocco','5ª','Offset'),
('A Revolução dos Bichos','Português',1945,6.00,16.00,'10+','Companhia das Letras','7ª','Offset'),
('Ensaio sobre a Cegueira','Português',1995,9.00,24.00,'14+','Cia das Letras','4ª','Digital'),
('O Morro dos Ventos Uivantes','Inglês',1847,8.00,22.00,'14+','Penguin','3ª','Offset'),
('O Processo','Alemão',1925,6.00,18.00,'16+','Companhia das Letras','2ª','Offset'),
('A Metamorfose','Alemão',1915,5.00,15.00,'14+','Alfaguara','4ª','Offset'),
('Os Miseráveis','Francês',1862,17.00,45.00,'16+','Martin Claret','3ª','Offset'),
('A Menina que Roubava Livros','Inglês',2005,10.00,28.00,'12+','Zahar','2ª','Offset'),
('O Apanhador no Campo de Centeio','Inglês',1951,7.00,20.00,'16+','Back Bay','4ª','Offset'),
('O Segredo','Português',2006,4.00,12.00,'10+','Sextante','10ª','Digital'),
('O Código Da Vinci','Inglês',2003,9.00,25.00,'14+','Arqueiro','5ª','Offset'),
('A Sombra do Vento','Espanhol',2001,8.00,23.00,'14+','Planeta','3ª','Offset'),
('A História Sem Fim','Alemão',1979,5.00,17.00,'10+','Rocco','6ª','Offset'),
('O Sol é Para Todos','Inglês',1960,8.00,24.00,'14+','HarperCollins','3ª','Offset'),
('A Ilha do Tesouro','Inglês',1883,6.00,19.00,'12+','Martin Claret','4ª','Offset'),
('O Pequeno Príncipe','Francês',1943,5.00,18.00,'10+','Agir','12ª','Offset'),
('O Velho e o Mar','Inglês',1952,6.00,17.00,'14+','Companhia das Letras','2ª','Offset'),
('A Divina Comédia','Italiano',1320,12.00,35.00,'16+','Bertrand','1ª','Offset'),
('Dom Quixote','Espanhol',1605,13.00,38.00,'16+','Martin Claret','3ª','Offset');

INSERT INTO autores_livros (id_autor, id_livro) VALUES
(1,1),(3,1),
(4,2),
(8,3),
(3,5),
(6,4),
(13,9),
(16,6),
(15,7),
(22,11),
(11,10),
(23,8),
(13,14),
(15,20),
(16,12),
(13,13),
(14,17),
(17,18),
(16,19),
(15,21),
(18,22),
(15,23),
(24,25),
(25,26),
(11,24),
(27,27),
(28,29),
(13,28),
(3,4),
(12,11);

INSERT INTO clientes (nome_completo, cpf, data_nascimento, telefone, email, data_cadastro) VALUES
('Marcos Vinicius da Luz', '218.722.278-48', '1995-08-15', '(37) 99183-5657', 'marcos.vinicius@exemplo.com', '2025-04-05 00:00:00'),
('Juliana Ribeiro Rocha', '867.155.220-72', '1987-12-09', '(85) 98399-3214', 'juliana.rocha@exemplo.com', '2025-05-25 00:00:00'),
('Carlos Henrique Teixeira', '127.209.146-31', '1978-03-22', '(81) 98424-8700', 'carlos.teixeira@exemplo.com', '2025-06-03 00:00:00'),
('Fernanda Souza Lima', '631.189.354-08', '2001-07-03', '(11) 98912-1745', 'fernanda.lima@exemplo.com', '2025-02-26 00:00:00'),
('Luciana Costa Martins', '936.271.199-50', '1992-11-27', '(21) 98745-6123', 'luciana.martins@exemplo.com', '2025-01-10 00:00:00'),
('Gabriel dos Santos Alves', '361.074.208-74', '1984-04-18', '(31) 99914-2234', 'gabriel.alves@exemplo.com', '2025-05-23 00:00:00'),
('Tatiane Carvalho Melo', '082.473.374-00', '1999-01-12', '(62) 98177-8822', 'tatiane.melo@exemplo.com', '2025-01-02 00:00:00'),
('Rafael Almeida Pires', '741.993.866-99', '2000-06-07', '(27) 98834-1103', 'rafael.pires@exemplo.com', '2025-03-06 00:00:00'),
('Camila Freitas Araújo', '370.644.156-37', '1991-09-30', '(71) 98555-0912', 'camila.araujo@exemplo.com', '2025-02-11 00:00:00'),
('Bruno Fernandes Lopes', '600.713.831-98', '1989-02-05', '(34) 99678-5221', 'bruno.lopes@exemplo.com', '2025-04-03 00:00:00'),
('Aline Pereira Nunes', '815.993.078-59', '1993-10-22', '(51) 98412-7749', 'aline.nunes@exemplo.com', '2025-02-23 00:00:00'),
('Diego Silva Rocha', '938.112.865-61', '1982-05-14', '(47) 98734-9882', 'diego.rocha@exemplo.com', '2025-02-15 00:00:00'),
('Beatriz Moraes Dias', '429.704.294-95', '2003-12-01', '(88) 98127-8341', 'beatriz.dias@exemplo.com', '2025-06-09 00:00:00'),
('André Luiz Cunha', '210.661.540-03', '1975-03-03', '(83) 98417-4450', 'andre.cunha@exemplo.com', '2025-05-05 00:00:00'),
('Jéssica Cristina Rocha', '503.090.138-02', '1998-11-09', '(16) 98641-9991', 'jessica.rocha@exemplo.com', '2025-02-15 00:00:00'),
('Felipe Batista Gomes', '111.384.244-19', '1986-06-25', '(67) 99811-5432', 'felipe.gomes@exemplo.com', '2025-02-07 00:00:00'),
('Isabela Moura Silva', '747.165.580-79', '1994-04-17', '(84) 98766-1298', 'isabela.silva@exemplo.com', '2025-01-06 00:00:00'),
('Rodrigo Matheus Barros', '213.774.146-22', '1980-10-11', '(92) 98213-8741', 'rodrigo.barros@exemplo.com', '2025-03-17 00:00:00'),
('Larissa Carvalho Lima', '904.801.904-72', '2002-02-19', '(61) 98873-4531', 'larissa.lima@exemplo.com', '2025-05-12 00:00:00'),
('Lucas Eduardo Moreira', '015.942.271-86', '1985-12-06', '(19) 99744-1209', 'lucas.moreira@exemplo.com', '2025-04-17 00:00:00'),
('Patrícia Ramos Almeida', '861.748.487-66', '1996-07-23', '(95) 98103-8871', 'patricia.almeida@exemplo.com', '2025-06-24 00:00:00'),
('Henrique Augusto Mendes', '723.198.914-39', '1979-11-29', '(98) 98457-6201', 'henrique.mendes@exemplo.com', '2025-01-03 00:00:00'),
('Natália Figueiredo Soares', '689.790.992-57', '1990-05-15', '(43) 98600-7766', 'natalia.soares@exemplo.com', '2025-05-07 00:00:00'),
('Eduardo Oliveira Nascimento', '113.259.547-62', '1983-09-03', '(13) 98900-1231', 'eduardo.nascimento@exemplo.com', '2025-03-25 00:00:00'),
('Amanda Cristina Lopes', '600.973.304-49', '2000-01-30', '(65) 98008-2200', 'amanda.lopes@exemplo.com', '2025-05-13 00:00:00'),
('Vinícius Ferreira Araújo', '807.504.346-10', '1997-03-18', '(55) 98177-0145', 'vinicius.araujo@exemplo.com', '2025-05-29 00:00:00'),
('Raquel de Souza Martins', '047.058.827-75', '1988-08-08', '(44) 98598-5643', 'raquel.martins@exemplo.com', '2025-05-24 00:00:00'),
('Matheus Lima Cardoso', '314.472.928-32', '1995-06-11', '(46) 98145-7783', 'matheus.cardoso@exemplo.com', '2025-01-20 00:00:00'),
('Thais Barbosa Pinto', '214.209.148-84', '2001-05-02', '(53) 98978-1132', 'thais.pinto@exemplo.com', '2025-03-21 00:00:00'),
('Jonathan Ribeiro Cunha', '710.494.082-40', '1981-09-21', '(91) 98481-3349', 'jonathan.cunha@exemplo.com', '2025-01-10 00:00:00');


INSERT INTO categorias (nome_categoria) VALUES
('Ficção'),
('Literatura Brasileira'),
('Clássicos'),
('Infantojuvenil'),
('Fantasia'),
('Suspense'),
('Romance'),
('Histórico'),
('Drama'),
('Aventura'),
('Filosofia'),
('Autoajuda'),
('Terror'),
('Biografia'),
('Poesia'),
('Humor'),
('Distopia'),
('Religião'),
('Psicologia'),
('Política'),
('Sociedade'),
('Educação'),
('Crime'),
('Tecnologia'),
('Economia'),
('Arte'),
('Culinária'),
('Viagem'),
('Esportes'),
('Ciência');

INSERT INTO categorias_livros (id_categoria, id_livro) VALUES
(2,1),(3,1),(7,2),(12,2),(3,3),(1,3),
(3,5),(7,5),(5,6),(4,6),
(1,7),(17,7),(5,8),(1,8),
(3,9),(3,11),(1,11),(5,12),
(3,13),(17,13),(3,14),(1,14),
(3,15),(1,16),(3,17),(3,18),
(4,18),(3,19),(3,20),(7,20),
(1,21),(5,21),(7,22),(3,22),
(1,23),(7,23),(3,24),(12,24),
(3,25),(3,26),(3,27),(7,27),
(3,28),(6,20),(1,29),(3,29),
(3,30),(1,30);

INSERT INTO fornecedores (nome_empresa, cnpj, email_contato, telefone_contato, tipo_fornecimento) VALUES
('Distribuidora Alpha','12.345.678/0001-01','contato@alpha.com','(61) 3000-1111','Atacado'),
('Livros & Cia','98.765.432/0001-02','vendas@livrosecia.com','(61) 3000-2222','Distribuidor'),
('Editora Beta','23.456.789/0001-03','beta@editora.com','(61) 3000-3333','Distribuidor'),
('Mega Livraria','34.567.890/0001-04','contato@mega.com','(61) 3000-4444','Atacado'),
('Cosmos Distribuições','45.678.901/0001-05','cosmos@dist.com','(61) 3000-5555','Distribuidor'),
('Alpha Beta Distribuição','56.789.012/0001-06','abdist@ab.com','(61) 3000-6666','Atacado'),
('Rochinha Fornecimentos','67.890.123/0001-07','rochinha@fornecedor.com','(61) 3000-7777','Distribuidor'),
('Livraria Central','78.901.234/0001-08','central@livraria.com','(61) 3000-8888','Atacado'),
('Distrib. Norte Sul','89.012.345/0001-09','ns@dist.com','(61) 3000-9999','Distribuidor'),
('Rainha dos Livros','90.123.456/0001-10','rainha@livros.com','(61) 3000-0001','Atacado'),
('BookSupply','11.222.333/0001-11','booksupply@bk.com','(61) 3000-0101','Distribuidor'),
('Multilivros','22.333.444/0001-12','multilivros@ml.com','(61) 3000-0202','Atacado'),
('SuperEditora','33.444.555/0001-13','super@editora.com','(61) 3000-0303','Distribuidor'),
('Literar','44.555.666/0001-14','contato@literar.com','(61) 3000-0404','Atacado'),
('Ponto Livro','55.666.777/0001-15','ponto@livro.com','(61) 3000-0505','Distribuidor'),
('AlphaBook','66.777.888/0001-16','alphabook@ab.com','(61) 3000-0606','Atacado'),
('Livraria do Centro','77.888.999/0001-17','centro@livraria.com','(61) 3000-0707','Distribuidor'),
('Distribuidor Gaúcho','88.999.000/0001-18','gaucho@dist.com','(61) 3000-0808','Atacado'),
('Beta Books','99.000.111/0001-19','beta@books.com','(61) 3000-0909','Distribuidor'),
('MegaDistrib','00.111.222/0001-20','contato@mega.com','(61) 3000-1010','Atacado'),
('Editora Universal','11.111.222/0001-21','universal@edit.com','(61) 3000-1112','Distribuidor'),
('FabEditora','22.222.333/0001-22','fab@edit.com','(61) 3000-1212','Atacado'),
('BookExpress','33.333.444/0001-23','express@book.com','(61) 3000-1313','Distribuidor'),
('AlphaDistrib','44.444.555/0001-24','alphad@dist.com','(61) 3000-1414','Atacado'),
('LivraMaster','55.555.666/0001-25','master@livra.com','(61) 3000-1515','Distribuidor'),
('DistribBeta','66.666.777/0001-26','dbeta@dist.com','(61) 3000-1616','Atacado'),
('Cultura Fornece','77.777.888/0001-27','cultura@forn.com','(61) 3000-1717','Distribuidor'),
('BooksWorld','88.888.999/0001-28','world@books.com','(61) 3000-1818','Atacado'),
('Elite Livros','99.999.000/0001-29','elite@livros.com','(61) 3000-1919','Distribuidor'),
('Distrib Master','00.000.111/0001-30','master@dist.com','(61) 3000-2020','Atacado');

INSERT INTO fornecimento (id_livro, id_fornecedor, quantidade_fornecida, data_fornecimento) VALUES
(4, 12, 54, '2025-04-25'),
(20, 9, 15, '2025-03-08'),
(24, 15, 78, '2025-03-05'),
(4, 30, 58, '2025-02-10'),
(3, 18, 47, '2025-05-17'),
(27, 21, 89, '2024-12-26'),
(29, 28, 56, '2025-03-02'),
(19, 7, 100, '2025-05-25'),
(3, 2, 94, '2025-01-05'),
(8, 25, 47, '2025-02-27'),
(3, 28, 39, '2025-02-07'),
(28, 4, 58, '2025-05-14'),
(9, 15, 91, '2025-04-29'),
(27, 12, 30, '2025-04-23'),
(12, 12, 36, '2025-01-12'),
(22, 9, 99, '2025-05-21'),
(30, 22, 92, '2025-04-14'),
(3, 20, 91, '2025-05-14'),
(6, 18, 43, '2025-06-01'),
(2, 5, 74, '2025-04-02'),
(5, 3, 57, '2025-05-02'),
(13, 24, 22, '2025-03-09'),
(17, 8, 45, '2025-05-19'),
(21, 26, 31, '2025-03-04'),
(1, 10, 90, '2025-01-22'),
(16, 29, 17, '2025-02-21'),
(10, 6, 65, '2025-05-07'),
(26, 1, 87, '2025-04-09'),
(11, 11, 40, '2025-03-27'),
(15, 19, 48, '2025-05-28');


INSERT INTO estoque (id_livro, quantidade, ultima_entrada, ultima_saida) VALUES
(1, 63, '2025-05-06 04:16:10', '2025-06-20 06:55:09'),
(2, 137, '2025-05-08 06:09:58', '2025-05-31 11:41:43'),
(3, 149, '2025-04-25 21:31:11', '2025-05-13 14:15:29'),
(4, 149, '2025-05-30 19:16:14', '2025-06-06 08:23:06'),
(5, 56, '2025-01-05 11:29:14', NULL),
(6, 35, '2025-05-12 06:25:45', '2025-06-18 22:45:23'),
(7, 23, '2025-03-23 02:21:32', '2025-03-26 16:32:14'),
(8, 28, '2025-02-19 04:57:32', '2025-03-30 08:26:27'),
(9, 40, '2025-01-01 17:34:10', '2025-06-04 08:24:20'),
(10, 108, '2025-01-31 23:00:51', '2025-05-03 01:44:53'),
(11, 18, '2025-02-12 22:25:45', '2025-06-03 14:29:33'),
(12, 148, '2025-04-03 18:43:57', '2025-04-26 16:14:15'),
(13, 40, '2025-06-13 15:32:18', '2025-06-22 03:44:31'),
(14, 10, '2025-04-30 08:33:36', '2025-06-06 08:01:40'),
(15, 38, '2025-01-24 01:35:56', NULL),
(16, 135, '2025-04-20 04:27:35', '2025-05-07 01:20:58'),
(17, 86, '2025-03-01 11:29:37', '2025-03-03 15:26:34'),
(18, 8, '2025-05-09 02:18:38', '2025-06-19 07:29:52'),
(19, 24, '2025-06-02 14:25:46', '2025-06-13 06:57:20'),
(20, 11, '2025-03-14 15:24:40', NULL),
(21, 50, '2025-02-10 20:52:24', '2025-05-04 12:43:45'),
(22, 99, '2025-04-16 10:01:16', '2025-05-28 07:32:18'),
(23, 106, '2025-03-22 14:55:45', '2025-04-15 19:17:00'),
(24, 42, '2025-03-20 06:03:33', '2025-05-20 10:41:20'),
(25, 10, '2025-01-10 02:37:39', '2025-04-17 13:33:21'),
(26, 147, '2025-02-22 18:47:30', NULL),
(27, 95, '2025-06-06 11:29:19', '2025-06-16 08:18:57'),
(28, 75, '2025-01-11 13:02:15', '2025-06-20 01:21:12'),
(29, 84, '2025-01-14 15:33:10', '2025-06-14 06:00:00'),
(30, 64, '2025-04-15 21:24:05', '2025-06-04 05:55:55');


INSERT INTO vendas (id_cliente, data_venda, valor_total, forma_pagamento, status_venda) VALUES
(29, '2025-04-30 06:08:21', 292.33, 'Cartão de Crédito', 'Pendente'),
(24, '2025-04-04 23:28:22', 253.28, 'Cartão de Crédito', 'Concluída'),
(5, '2025-05-04 11:30:47', 336.68, 'Boleto', 'Cancelada'),
(17, '2025-03-16 10:31:14', 438.77, 'Dinheiro', 'Concluída'),
(30, '2025-02-08 16:30:35', 278.86, 'Boleto', 'Cancelada'),
(13, '2025-06-13 19:57:24', 497.67, 'Pix', 'Em Processamento'),
(29, '2025-04-16 01:49:26', 268.44, 'Cartão de Crédito', 'Concluída'),
(8, '2025-02-07 23:20:19', 50.73, 'Cartão de Crédito', 'Concluída'),
(19, '2025-04-17 06:17:13', 125.70, 'Cartão de Crédito', 'Pendente'),
(8, '2025-05-20 15:08:53', 52.35, 'Cartão de Crédito', 'Cancelada'),
(3, '2025-02-27 16:30:01', 266.79, 'Pix', 'Em Processamento'),
(7, '2025-05-09 13:36:25', 278.83, 'Dinheiro', 'Concluída'),
(26, '2025-03-21 16:33:46', 247.03, 'Dinheiro', 'Concluída'),
(4, '2025-03-27 00:27:57', 66.53, 'Dinheiro', 'Cancelada'),
(14, '2025-02-12 13:39:11', 217.33, 'Cartão de Crédito', 'Pendente'),
(2, '2025-02-08 04:39:37', 213.26, 'Pix', 'Pendente'),
(8, '2025-03-28 07:43:47', 111.96, 'Dinheiro', 'Concluída'),
(14, '2025-05-31 23:37:08', 108.07, 'Dinheiro', 'Concluída'),
(28, '2025-03-22 01:17:39', 463.17, 'Dinheiro', 'Pendente'),
(2, '2025-03-24 03:53:11', 333.03, 'Cartão de Crédito', 'Pendente'),
(30, '2025-04-20 05:37:49', 381.71, 'Boleto', 'Concluída'),
(14, '2025-05-20 15:55:57', 253.11, 'Boleto', 'Em Processamento'),
(29, '2025-06-12 00:03:49', 48.14, 'Dinheiro', 'Pendente'),
(13, '2025-04-16 09:21:25', 147.30, 'Dinheiro', 'Cancelada'),
(14, '2025-02-25 00:07:59', 354.36, 'Dinheiro', 'Concluída'),
(7, '2025-06-06 14:02:57', 162.42, 'Cartão de Crédito', 'Pendente'),
(24, '2025-04-19 20:16:30', 170.53, 'Cartão de Crédito', 'Em Processamento'),
(17, '2025-04-01 21:50:23', 461.31, 'Boleto', 'Pendente'),
(17, '2025-04-20 11:17:14', 58.45, 'Boleto', 'Pendente'),
(20, '2025-01-31 20:54:05', 52.62, 'Boleto', 'Em Processamento');

INSERT INTO itens_da_venda (id_venda, id_livro, quantidade_vendida, preco_unitario_venda) VALUES
(8, 19, 5, 22.38),
(3, 14, 5, 53.91),
(11, 30, 3, 32.26),
(23, 11, 2, 35.94),
(5, 22, 3, 47.43),
(30, 25, 1, 20.56),
(20, 19, 1, 24.4),
(7, 17, 3, 27.95),
(12, 29, 1, 72.76),
(12, 10, 2, 46.29),
(18, 23, 3, 56.7),
(26, 21, 5, 20.47),
(27, 18, 3, 75.91),
(4, 29, 2, 35.87),
(29, 4, 5, 29.33),
(10, 20, 2, 63.06),
(7, 22, 3, 50.32),
(9, 29, 1, 25.54),
(14, 27, 3, 22.65),
(11, 25, 2, 58.23),
(9, 6, 4, 53.1),
(14, 18, 1, 26.71),
(29, 23, 2, 52.74),
(27, 12, 5, 53.15),
(14, 5, 1, 38.5),
(29, 30, 1, 73.94),
(8, 22, 1, 41.22),
(18, 29, 4, 78.43),
(24, 5, 2, 71.88),
(26, 26, 2, 72.88);




-- 3. Índices
-- Criação de pelo menos um índice (INDEX) em um atributo.
CREATE INDEX idx_autores_nome ON autores(nome_completo);
CREATE INDEX idx_livros_titulo ON livros(titulo);
CREATE INDEX idx_itens_venda_livro ON itens_da_venda(id_livro);
CREATE INDEX idx_clientes_cpf ON clientes(cpf);

-- Incluir justificativa para a escolha do campo indexado, explicando o benefício em termos de desempenho.

-- CREATE INDEX idx_autores_nome ON autores(nome_completo);
-- Justificativa:
-- Consultas que buscam autores pelo nome (por exemplo, em buscas alfabéticas, autocompletes ou filtros por nacionalidade + nome) 
-- se beneficiam desse índice. Ele acelera pesquisas com WHERE nome_completo LIKE 'A%' ou ORDER BY nome_completo.

-- Benefício:
-- Redução significativa no tempo de varredura da tabela autores ao procurar nomes ou ordenar resultados.

-- CREATE INDEX idx_livros_titulo ON livros(titulo);
-- Justificativa:
-- Busca por título é uma operação frequente em sistemas de livrarias, tanto para localizar livros quanto para exibir listagens ordenadas.

-- Benefício:
-- Acelera buscas por parte do título (LIKE, =) e ordenações (ORDER BY titulo), melhorando a responsividade das telas de consulta e busca de livros.

-- CREATE INDEX idx_itens_venda_livro ON itens_da_venda(id_livro);
-- Justificativa:
-- Permite identificar rapidamente em quais vendas determinado livro foi vendido.

-- Benefício:
-- Evita varreduras em toda a tabela itens_da_venda quando consultando vendas por id_livro.

-- CREATE INDEX idx_clientes_cpf ON clientes(cpf);
-- Justificativa:
-- Busca por CPF é para identificar clientes de forma única e rápida.

-- Benefício:
-- Garante consultas imediatas ao cliente por CPF, essencial para verificação de cadastro e prevenção de duplicidades.


-- 4. Scripts Adicionais (Inserir como Comentários no Arquivo)
-- Inclua os seguintes exemplos no arquivo .sql, comentados, como demonstração de domínio técnico:

-- Exclusão do banco de dados.
-- DROP DATABASE IF EXISTS livraria_db;

-- Exclusão de uma tabela.
 -- DROP TABLE IF EXISTS fornecimento;

-- Exclusão de uma coluna de uma tabela.
 -- ALTER TABLE livros DROP COLUMN impressao;

-- Adição de uma nova coluna (não prevista na modelagem inicial).
 -- ALTER TABLE clientes ADD COLUMN endereco VARCHAR(255);

-- Edição de um registro específico.
-- UPDATE livros SET preco_venda = 59.90 WHERE id_livro = 10;

-- Exclusão de um registro específico.
-- DELETE FROM clientes WHERE id_cliente = 15;

-- 5. Consultas SQL (Queries)
-- Caso sua modelagem não permita algum dos JOINs solicitados, incluir uma justificativa técnica.
-- As consultas devem utilizar, sempre que possível, os seguintes comandos SQL: WHERE e diferentes tipos de operadores; GROUP BY; HAVING e ORDER BY

-- Duas consultas simples, utilizando apenas uma tabela.
-- listar todos os livros com preço de venda acima de R$ 30,00
-- SELECT titulo, preco_venda FROM livros WHERE preco_venda > 30.00;

-- buscar todos os clientes cadastrados após 1º de março de 2025
-- SELECT nome_completo, data_cadastro FROM clientes WHERE data_cadastro > '2025-03-01';

-- Quatro consultas com duas tabelas, utilizando INNER JOIN.
-- Consulta 1: Listar os títulos dos livros e seus respectivos autores
-- SELECT l.titulo, a.nome_completo
-- FROM livros l
-- INNER JOIN autores_livros al ON l.id_livro = al.id_livro
-- INNER JOIN autores a ON al.id_autor = a.id_autor;

-- Consulta 2: Listar os nomes dos clientes e os detalhes das vendas que realizaram
-- SELECT c.nome_completo, v.data_venda, v.valor_total
-- FROM clientes c
-- INNER JOIN vendas v ON c.id_cliente = v.id_cliente;

-- Consulta 3: Listar os títulos dos livros e seus fornecedores
-- SELECT l.titulo, f.nome_empresa
-- FROM livros l
-- INNER JOIN fornecimento fo ON l.id_livro = fo.id_livro
-- INNER JOIN fornecedores f ON fo.id_fornecedor = f.id_fornecedor;

-- Consulta 4: Listar os títulos dos livros e as categorias correspondentes
-- SELECT l.titulo, c.nome_categoria
-- FROM livros l
-- INNER JOIN categorias_livros cl ON l.id_livro = cl.id_livro
-- INNER JOIN categorias c ON cl.id_categoria = c.id_categoria;


-- Uma consulta com LEFT JOIN.
-- Consulta com LEFT JOIN: Listar todos os livros e seus autores (incluindo livros sem autor cadastrado)
 -- SELECT l.titulo, a.nome_completo
 -- FROM livros l
 -- LEFT JOIN autores_livros al ON l.id_livro = al.id_livro
 -- LEFT JOIN autores a ON al.id_autor = a.id_autor;


-- Uma consulta com RIGHT JOIN.
-- Listar todos os fornecedores e os livros que forneceram (incluindo fornecedores que ainda não forneceram livros)
-- SELECT f.nome_empresa, l.titulo
-- FROM fornecimento fo
-- RIGHT JOIN fornecedores f ON fo.id_fornecedor = f.id_fornecedor
-- LEFT JOIN livros l ON fo.id_livro = l.id_livro;


-- Uma consulta com três tabelas, utilizando qualquer tipo de JOIN.
-- Listar o nome dos clientes, a data da venda e os títulos dos livros comprados
-- SELECT c.nome_completo, v.data_venda, l.titulo
-- FROM clientes c
-- INNER JOIN vendas v ON c.id_cliente = v.id_cliente
-- INNER JOIN itens_da_venda iv ON v.id_venda = iv.id_venda
-- INNER JOIN livros l ON iv.id_livro = l.id_livro;
 
-- Uma consulta com quatro tabelas, utilizando qualquer tipo de JOIN.
-- Listar o nome dos clientes, a data da venda, o título dos livros comprados e o nome do autor
-- SELECT c.nome_completo AS cliente, v.data_venda, l.titulo AS livro, a.nome_completo AS autor
-- FROM clientes c
-- INNER JOIN vendas v ON c.id_cliente = v.id_cliente
-- INNER JOIN itens_da_venda iv ON v.id_venda = iv.id_venda
-- INNER JOIN livros l ON iv.id_livro = l.id_livro
-- INNER JOIN autores_livros al ON l.id_livro = al.id_livro
-- INNER JOIN autores a ON al.id_autor = a.id_autor;

-- 6. Recursos Adicionais
-- Criação de três VIEWs.
 -- VIEW 1: Livros com seus autores Exibe título, autor e idioma dos livros
CREATE VIEW vw_livros_autores AS
SELECT l.titulo, a.nome_completo AS autor, l.idioma
FROM livros l
INNER JOIN autores_livros al ON l.id_livro = al.id_livro
INNER JOIN autores a ON al.id_autor = a.id_autor;


-- VIEW 2: Estoque atual de livros com títulos e quantidade
CREATE VIEW vw_estoque_livros AS
SELECT l.titulo, e.quantidade, e.ultima_entrada, e.ultima_saida
FROM livros l
INNER JOIN estoque e ON l.id_livro = e.id_livro;


-- VIEW 3: Vendas detalhadas (cliente, data e total)
CREATE VIEW vw_vendas_clientes AS
SELECT c.nome_completo, v.data_venda, v.valor_total, v.forma_pagamento, v.status_venda
FROM clientes c
INNER JOIN vendas v ON c.id_cliente = v.id_cliente;


-- Criação de dois TRIGGERs, sendo:
-- Um BEFORE
-- Garante que nenhum livro seja cadastrado com preco_venda menor que preco_compra
DELIMITER //
CREATE TRIGGER trg_livro_preco_check
BEFORE INSERT ON livros
FOR EACH ROW
BEGIN
    IF NEW.preco_venda < NEW.preco_compra THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O preço de venda não pode ser menor que o preço de compra';
    END IF;
END;
//
DELIMITER ;

-- Um AFTER
-- Atualiza a tabela de estoque automaticamente após uma nova entrada de fornecimento
DELIMITER //
CREATE TRIGGER trg_atualiza_estoque
AFTER INSERT ON fornecimento
FOR EACH ROW
BEGIN
    INSERT INTO estoque (id_livro, quantidade, ultima_entrada)
    VALUES (NEW.id_livro, NEW.quantidade_fornecida, NOW())
    ON DUPLICATE KEY UPDATE 
        quantidade = quantidade + NEW.quantidade_fornecida,
        ultima_entrada = NOW();
END;
//
DELIMITER ;

-- Criação de três usuários com permissões distintas.
-- Criar usuários
CREATE USER 'admin_livraria'@'localhost' IDENTIFIED BY 'Admin#123';
CREATE USER 'vendedor_livraria'@'localhost' IDENTIFIED BY 'Vend#123';
CREATE USER 'consultor_livraria'@'localhost' IDENTIFIED BY 'Cons#123';

-- Conceder permissões
-- Usuário ADMIN: todas as permissões
GRANT ALL PRIVILEGES ON livraria_db.* TO 'admin_livraria'@'localhost';

-- Usuário VENDEDOR: pode selecionar, inserir e atualizar vendas e clientes
GRANT SELECT, INSERT, UPDATE ON livraria_db.vendas TO 'vendedor_livraria'@'localhost';
GRANT SELECT, INSERT, UPDATE ON livraria_db.itens_da_venda TO 'vendedor_livraria'@'localhost';
GRANT SELECT, INSERT, UPDATE ON livraria_db.clientes TO 'vendedor_livraria'@'localhost';

-- Usuário CONSULTOR: apenas leitura (SELECT) em todas as tabelas
GRANT SELECT ON livraria_db.* TO 'consultor_livraria'@'localhost';

-- Exclusão de um dos usuários criados.
/*
 DROP USER IF EXISTS 'admin_livraria'@'localhost';
 DROP USER IF EXISTS 'vendedor_livraria'@'localhost';
 DROP USER IF EXISTS 'consultor_livraria'@'localhost'; 
*/
-- Revogação de privilégios de dois usuários

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_livraria'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'vendedor_livraria'@'localhost';
REVOKE SELECT ON livraria_db.* FROM 'consultor_livraria'@'localhost';

/*
SHOW GRANTS FOR 'admin_livraria'@'localhost';
SHOW GRANTS FOR 'vendedor_livraria'@'localhost';
SHOW GRANTS FOR 'consultor_livraria'@'localhost';
*/

-- Exemplo de uso dos comandos:
-- COMMIT

-- ROLLBACK
