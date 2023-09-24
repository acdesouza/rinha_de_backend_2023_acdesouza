require "test_helper"

class ContagemPessoasControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get contagem_pessoas_url
    assert_response :success

    assert_equal 3, response.body.to_i
  end
end
