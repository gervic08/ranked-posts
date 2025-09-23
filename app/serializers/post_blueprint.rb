# frozen_string_literal: true

class PostBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :body, :created_at, :updated_at

  field :user_ip do |post|
    post.ip.to_s
  end

  association :user, blueprint: UserBlueprint
end
