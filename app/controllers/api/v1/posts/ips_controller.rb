# frozen_string_literal: true

class Api::V1::Posts::IpsController < ApplicationController
  def index
    ips = Post
          .joins(:user)
          .group(:ip)
          .having('COUNT(DISTINCT posts.user_id) > 1')
          .pluck(:ip, Arel.sql('ARRAY_AGG(DISTINCT users.login) AS user_logins'))

    result = ips.map { |ip, logins| { ip: ip.to_s, authors_logins: logins } }

    render json: result, status: :ok
  end
end
