# app.rb
require 'httparty'
require 'json'

class UserClient
  include HTTParty
  base_uri 'http://localhost:3000' # URL da sua API Rails

  def initialize
    @options = { headers: { "Content-Type" => "application/json" } }
  end

  def list_users
    self.class.get('/users', @options)
  end

  def get_user(id)
    self.class.get("/users/#{id}", @options)
  end

  def create_user(name, document, role)
    body = { name: name, document: document, role: role }.to_json
    self.class.post('/users', @options.merge(body: body))
  end
end

# Exemplo de uso
client = UserClient.new

# Adicionar um novo usuário
print "Digite o nome: "
name = gets.chomp

print "Digite o documento: "
document = gets.chomp

print "Digite o Cargo ou Categoria do fucionario (Se deixa em branco será Estagiário):
0: Estagiário
1: Colaborador
2: Freelancer
3: Consultor
4: Gerente
5: Supervisor
6: Coordenador 

Escolha a opção:"

role_input = gets.chomp
role = role_input.empty? ? 1 : role_input.to_i

response = client.create_user(name, document, role)
if response.success?
  puts "Usuário criado com sucesso!"
  puts JSON.pretty_generate(response.parsed_response)
else
  puts "Falha ao criar usuário."
  puts response.body
end
