require "test_helper"

class SummonersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @summoner = summoners(:one)
  end

  test "should get index" do
    get summoners_url
    assert_response :success
  end

  test "should get new" do
    get new_summoner_url
    assert_response :success
  end

  test "should create summoner" do
    assert_difference("Summoner.count") do
      post summoners_url, params: { summoner: {  } }
    end

    assert_redirected_to summoner_url(Summoner.last)
  end

  test "should show summoner" do
    get summoner_url(@summoner)
    assert_response :success
  end

  test "should get edit" do
    get edit_summoner_url(@summoner)
    assert_response :success
  end

  test "should update summoner" do
    patch summoner_url(@summoner), params: { summoner: {  } }
    assert_redirected_to summoner_url(@summoner)
  end

  test "should destroy summoner" do
    assert_difference("Summoner.count", -1) do
      delete summoner_url(@summoner)
    end

    assert_redirected_to summoners_url
  end
end
