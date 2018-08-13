require 'test_helper'

class AuthenticatableTest < ActiveSupport::TestCase
  include CandidateXYZ::Concerns::Request
  include CandidateXYZ::Concerns::Authenticatable

  attr_reader :request, :params

  setup do
    @request = Request.new({})
    @params = {}

    response = HTTParty.post("#{Rails.application.secrets.auth_api}/auth/sign_in", {
      query: { email: 'test@gmail.com', password: 'password' }
    })

    @user = response['data']
    @auth_headers = response.headers
  end

  test 'should authenticate' do
    @request = Request.new(@auth_headers)
    status = authenticate

    assert_not status == 401
    assert_not @current_user.authorized?
    assert @current_user.id == @user['id']
  end

  test 'should authenticate with params' do
    @params = @auth_headers
    status = authenticate

    assert_not status == 401
    assert_not @current_user.authorized?
    assert @current_user.id == @user['id']
  end

  test "shouldn't authenticate with no headers and no params" do
    @request = Request.new({})
    status = authenticate

    assert status == 401
  end

  test 'should authenticate admin' do
    @request = Request.new(@auth_headers)
    authenticate
    status = authenticate_admin

    assert_not status == 401
  end

  test "shouldn't authenticate superuser" do
    @request = Request.new(@auth_headers)
    authenticate
    status = authenticate_superuser

    assert status == 401
  end

  test 'should authenticate campaign id' do
    @request = Request.new(@auth_headers)
    authenticate
    status = authenticate_campaign_id

    assert_not status == 401
    assert @campaign_id == @user['campaignId']
  end

  private
  def render(args)
    return args[:status]
  end
end

class Request
  attr_reader :headers

  def initialize(headers)
    @headers = headers
  end
end
