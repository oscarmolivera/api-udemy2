# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'FactoryBot Content Example' }
    association :article
    association :user
  end
end
