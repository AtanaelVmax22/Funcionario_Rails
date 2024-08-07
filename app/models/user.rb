class User < ApplicationRecord
  before_validation :set_default_role

  # Validações
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :document, presence: true, uniqueness: true, length: { is: 11 }
  :role

  # Métodos para obter a descrição do role
  def role_description
    case role
    when 0
      'Intern'
    when 1
      'Employee'
    when 2
      'Freelancer'
    when 3
      'Consultant'
    when 4
      'Manager'
    when 5
      'Supervisor'
    when 6
      'Coordinator'
    else
      'unknown'
    end
  end

  # Sobrescrever o método inspect para incluir a descrição do role
  def inspect
    "#<User id: #{id}, name: #{name}, document: #{document}, role: #{role_description}>"
  end

  private

  def set_default_role
    self.role ||= 1
  end
end
