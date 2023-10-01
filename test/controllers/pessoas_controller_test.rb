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

  test "should NOT create pessoa with invalid stack" do
    assert_no_difference("Pessoa.count") do
      post pessoas_url, params: {
        pessoa: {
          apelido: "NEW_APELIDO",
          nome: "Antonio Carlos de Souza",
          nascimento: "1982-08-28",
          stack: "string instead of array"
        }
      }, as: :json
    end

    assert_response :unprocessable_entity

    errors_hash = JSON.parse(response.body)

    assert_equal "must be a list: 'string instead of array'", errors_hash.dig('errors', 'stack')&.first

    assert_no_difference("Pessoa.count") do
      post pessoas_url, params: {
        pessoa: {
          apelido: "NEW_APELIDO",
          nome: "Antonio Carlos de Souza",
          nascimento: "1982-08-28",
          stack: 1
        }
      }, as: :json
    end

    assert_response :unprocessable_entity

    errors_hash = JSON.parse(response.body)

    assert_equal "must be a list: '1'", errors_hash.dig('errors', 'stack')&.first
  end

  test "should show pessoa" do
    get pessoa_url(@pessoa)
    assert_response :success

    assert_equal @pessoa.to_json, response.body
  end

  test "should require search term" do
    get pessoas_url

    assert_response :bad_request

    assert_equal "query string `t` can't be blank", response.body
  end

  test "should find pessoas by apelido" do
    get pessoas_url, params: {
      t: "jo"
    }

    assert_response :success

    expected_id_list = [pessoas(:one).id, pessoas(:three).id].sort
    actual_id_list   = JSON.parse(response.body).map {|e| e['id']}.sort

    assert_equal expected_id_list, actual_id_list
  end

  test "should find pessoas by nome" do
    get pessoas_url, params: {
      t: "barbosa"
    }

    assert_response :success

    expected_id_list = [pessoas(:two).id, pessoas(:three).id]
    actual_id_list   = JSON.parse(response.body).map {|e| e['id']}

    assert_equal expected_id_list, actual_id_list
  end

  test "should find pessoas by stack" do
    get pessoas_url, params: {
      t: "Java"
    }

    assert_response :success

    expected_id_list = [pessoas(:three).id]
    actual_id_list   = JSON.parse(response.body).map {|e| e['id']}

    assert_equal expected_id_list, actual_id_list
  end
end
