# frozen_string_literal: true

describe package('google-cloud-sdk') do
  it { should be_installed }
end
