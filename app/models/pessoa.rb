class Pessoa < ApplicationRecord
  validates :apelido,    presence: true, length: { maximum:  32 }, uniqueness: true
  validates :nome,       presence: true, length: { maximum: 100 }
  validates :nascimento, presence: true

  scope :search, ->(t) do
    unntested_stack_join = <<-UNNEST_JOIN
      LEFT JOIN (
        SELECT id, unnest(stack) AS unnest_stack
        FROM pessoas
      ) pessoas_unnested ON pessoas.id = pessoas_unnested.id
    UNNEST_JOIN

    select("pessoas.*")
      .joins(unntested_stack_join)
      .where('apelido ILIKE ? OR nome ILIKE ? OR unnest_stack ILIKE ?', "%#{t}%", "%#{t}%", "%#{t}%")
      .distinct
  end
end
