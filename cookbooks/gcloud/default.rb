# frozen_string_literal: true

case node['distro']
when 'ubuntu'
  %w[apt-transport-https ca-certificates gnupg].each do |pkg|
    package pkg do
      action :install
    end
  end

  execute 'Cloud SDK の配布 URI をパッケージ ソースとして追加' do
    not_if 'test -f /etc/apt/sources.list.d/google-cloud-sdk.list'
    command 'echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list' # rubocop:disable Layout/LineLength
  end

  execute 'Google Cloud の公開鍵をインポート' do
    command 'curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -' # rubocop:disable Layout/LineLength
  end

  execute 'apt update'
when 'ol8'
  execute 'Cloud SDK リポジトリ情報で DNF を更新' do
    not_if 'test -f /etc/yum.repos.d/google-cloud-sdk.repo'
    command <<~SH
      sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
      [google-cloud-sdk]
      name=Google Cloud SDK
      baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
      enabled=1
      gpgcheck=1
      repo_gpgcheck=0
      gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
            https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
      EOM
    SH
  end
end

package 'google-cloud-sdk' do
  action :install
end
