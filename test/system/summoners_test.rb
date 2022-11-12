require "application_system_test_case"

class SummonersTest < ApplicationSystemTestCase
  setup do
    @summoner = summoners(:one)
  end

  test "visiting the index" do
    visit summoners_url
    assert_selector "h1", text: "Summoners"
  end

  test "should create summoner" do
    visit summoners_url
    click_on "New summoner"

    click_on "Create Summoner"

    assert_text "Summoner was successfully created"
    click_on "Back"
  end

  test "should update Summoner" do
    visit summoner_url(@summoner)
    click_on "Edit this summoner", match: :first

    click_on "Update Summoner"

    assert_text "Summoner was successfully updated"
    click_on "Back"
  end

  test "should destroy Summoner" do
    visit summoner_url(@summoner)
    click_on "Destroy this summoner", match: :first

    assert_text "Summoner was successfully destroyed"
  end
end
