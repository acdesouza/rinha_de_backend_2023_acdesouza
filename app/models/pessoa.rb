class Pessoa < ApplicationRecord
  validates :apelido,    presence: true, length: { maximum:  32 }, uniqueness: true
  validates :nome,       presence: true, length: { maximum: 100 }
  validates :nascimento, presence: true
end
