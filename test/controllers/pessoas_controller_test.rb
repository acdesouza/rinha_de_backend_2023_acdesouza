require "test_helper"

class PessoasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pessoa = pessoas(:one)
  end

  test "should create pessoa" do
    assert_difference("Pessoa.count") do
      post pessoas_url, params: {
        pessoa: {
          apelido: "acdesouza",
          nome: "Antonio Carlos de Souza",
          nascimento: "1982-08-28",
          stack: ["Ruby", "JavaScript", "PostgreSQL"]
        }
      }, as: :json
    end

    assert_response :created
    assert_equal pessoa_path(Pessoa.order(created_at: :asc).last), response.headers['Location']
  end

  test "should NOT create invalid pessoa" do
    assert_no_difference("Pessoa.count") do
      post pessoas_url, params: {
        pessoa: {
          apelido: "josé",
          nome: "Antonio Carlos de Souza"
        }
      }, as: :json
    end

    assert_response :unprocessable_entity

    errors_hash = JSON.parse(response.body)

    assert_equal "has already been taken", errors_hash.dig('errors', 'apelido')&.first
    assert_equal "can't be blank", errors_hash.dig('errors', 'nascimento')&.first
  end
end
