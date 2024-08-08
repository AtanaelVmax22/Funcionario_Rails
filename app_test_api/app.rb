require 'httparty'
require 'json'
require 'tty-prompt'

class UserClient
  include HTTParty
  base_uri 'http://localhost:3000' # URL da sua API Rails

  def initialize
    @options = { headers: { "Content-Type" => "application/json" } }
  end

  def list_users
    self.class.get('/users', @options)
  end

  def create_user(name, document, role, password)
    body = { user: { name: name, document: document, role: role, password: password } }.to_json
    self.class.post('/users', @options.merge(body: body))
  end

  def login(name, password)
    body = { session: { name: name, password: password } }.to_json
    self.class.post('/login', @options.merge(body: body))
  end
end

# Função para limpar a tela
def clear_screen
  system("clear") || system("cls") # Tenta limpar a tela a cada iteração do loop
end

# Função para exibir o título com largura total
def display_title
  title = "Projeto Funcionário Rails"
  width = 100 # Defina a largura desejada
  padding = width - title.length
  puts "\e[48;5;235m\e[38;5;15m" # Fundo cinza e texto branco

  # Exibe o título com preenchimento de espaços à direita
  puts title + " " * padding
  
  puts "\e[0m" # Reseta as cores
end

# Inicializa o cliente da API
client = UserClient.new
prompt = TTY::Prompt.new

# Função para fazer o login
def user_login(client, prompt)
  loop do
    clear_screen  # Limpa a tela antes de solicitar os dados
    display_title # Exibe o título novamente
    subtitle = "Login"
    puts "\e[48;5;1m\e[38;5;15m" # Fundo vermelho e texto branco

    # Exibe o título
    puts subtitle 
    puts "\e[0m" # Reseta as cores
    
    name = prompt.ask("Digite seu nome:")
    password = prompt.ask("Digite sua senha:")

    response = client.login(name, password)

    if response.success?
      puts "Login bem-sucedido!"
      puts JSON.pretty_generate(response.parsed_response)
      return name # Retorna o nome do usuário se o login for bem-sucedido
    else
      puts "Falha no login."
      error_message = JSON.parse(response.body) rescue response.body
      puts "Detalhes: #{error_message}"
      puts "Pressione Enter para tentar novamente..."
      gets
    end
  end
end

# Chama a função de login e armazena o nome do usuário
user_name = user_login(client, prompt)

# Loop principal para o menu
loop do
  clear_screen  # Limpa a tela a cada iteração do loop
  display_title # Exibe o título
  nameUser = "Seja Bem-Vindo, #{user_name}!" # Agora, `user_name` contém o nome do usuário
  puts "\e[48;5;1m\e[38;5;15m" # Fundo vermelho e texto branco

  # Exibe a mensagem de boas-vindas
  puts nameUser 
  puts "\e[0m" # Reseta as cores
    
  option = prompt.select("Escolha uma opção:", [
    "Adicionar Novo Usuário",
    "Listar Usuários",
    "Sair"
  ])

  case option
  when "Adicionar Novo Usuário"
    clear_screen  # Limpa a tela antes de solicitar os dados
    display_title # Exibe o título novamente
    name = prompt.ask("Digite o nome:")
    document = prompt.ask("Digite o documento:")
    role = prompt.select("Escolha o Cargo ou Categoria do funcionário:", [
      { name: 'Estagiário', value: 0 },
      { name: 'Colaborador', value: 1 },
      { name: 'Freelancer', value: 2 },
      { name: 'Consultor', value: 3 },
      { name: 'Gerente', value: 4 },
      { name: 'Supervisor', value: 5 },
      { name: 'Coordenador', value: 6 }
    ])

    # Solicita a senha ao usuário
    password = prompt.ask("Digite a senha:")

    # Chama o método create_user com a senha
    response = client.create_user(name, document, role, password)

    if response.success?
      puts "Usuário criado com sucesso!"
      puts JSON.pretty_generate(response.parsed_response)
    else
      puts "Falha ao criar usuário."
      puts response.body
    end

  when "Listar Usuários"
    clear_screen  # Limpa a tela antes de listar usuários
    display_title # Exibe o título novamente
    response = client.list_users
    if response.success?
      puts "Lista de Usuários:"
      users = response.parsed_response
      if users.empty?
        puts "Nenhum usuário encontrado."
      else
        users.each do |user|
          puts "ID: #{user['id']}, Nome: #{user['name']}, Documento: #{user['document']}, Cargo: #{user['role']}"
        end
      end
    else
      puts "Falha ao listar usuários."
      puts response.body
    end

  when "Sair"
    puts "Saindo..."
    break
  end
  
  puts "\nPressione Enter para continuar..."  # Adiciona uma pausa para o usuário ler a saída
  gets
end
